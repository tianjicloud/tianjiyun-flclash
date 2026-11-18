package tianji

import (
	"context"
	"encoding/binary"
	"io"
	"net"
	"reflect"
	"strings"
	"sync"
	"testing"
	"time"
)

type memoryConn struct {
	mu           sync.Mutex
	read         []byte
	written      []byte
	closed       chan struct{}
	once         sync.Once
	blockOnEmpty bool
}

func newMemoryConn() *memoryConn { return &memoryConn{closed: make(chan struct{}), blockOnEmpty: true} }
func (c *memoryConn) Read(b []byte) (int, error) {
	c.mu.Lock()
	if len(c.read) == 0 {
		block := c.blockOnEmpty
		closed := c.closed
		c.mu.Unlock()
		if block {
			<-closed
		}
		return 0, io.EOF
	}
	n := copy(b, c.read)
	c.read = c.read[n:]
	c.mu.Unlock()
	return n, nil
}
func (c *memoryConn) Write(b []byte) (int, error) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.written = append(c.written, b...)
	return len(b), nil
}
func (c *memoryConn) Close() error                     { c.once.Do(func() { close(c.closed) }); return nil }
func (c *memoryConn) LocalAddr() net.Addr              { return testAddr("local") }
func (c *memoryConn) RemoteAddr() net.Addr             { return testAddr("remote") }
func (c *memoryConn) SetDeadline(time.Time) error      { return nil }
func (c *memoryConn) SetReadDeadline(time.Time) error  { return nil }
func (c *memoryConn) SetWriteDeadline(time.Time) error { return nil }

type testAddr string

func (a testAddr) Network() string { return "test" }
func (a testAddr) String() string  { return string(a) }

type memoryDatagrams struct {
	incoming chan []byte
	mu       sync.Mutex
	sent     [][]byte
}

func newMemoryDatagrams() *memoryDatagrams { return &memoryDatagrams{incoming: make(chan []byte, 128)} }
func (d *memoryDatagrams) SendDatagram(b []byte) error {
	d.mu.Lock()
	defer d.mu.Unlock()
	d.sent = append(d.sent, append([]byte(nil), b...))
	return nil
}
func (d *memoryDatagrams) ReceiveDatagram(ctx context.Context) ([]byte, error) {
	select {
	case b := <-d.incoming:
		return b, nil
	case <-ctx.Done():
		return nil, ctx.Err()
	}
}

func TestPacketConnH2LengthFramingAndAddress(t *testing.T) {
	conn := newMemoryConn()
	pc := Packets(&streamConn{reader: conn, writer: conn, closeFn: func() {}})
	payload := []byte("small data")
	n, err := pc.WriteTo(payload, testAddr("example.test:443"))
	if err != nil || n != len(payload) {
		t.Fatalf("WriteTo = %d, %v", n, err)
	}
	frame := append([]byte(nil), conn.written...)
	if got := binary.BigEndian.Uint32(frame[:4]); got != uint32(len(frame)-4) {
		t.Fatalf("frame length = %d, payload length %d", got, len(frame)-4)
	}
	conn.read = frame
	buffer := make([]byte, 64)
	n, addr, err := pc.ReadFrom(buffer)
	if err != nil {
		t.Fatal(err)
	}
	if addr.String() != "example.test:443" || !reflect.DeepEqual(buffer[:n], payload) {
		t.Fatalf("ReadFrom = %q, %q", addr, buffer[:n])
	}
	_ = pc.Close()
}

func TestPacketConnH3ReassemblesOutOfOrderAndIgnoresDuplicates(t *testing.T) {
	conn := newMemoryConn()
	d := newMemoryDatagrams()
	stream := &streamConn{reader: conn, writer: conn, datagrams: d, closeFn: func() {}}
	pc := Packets(stream)
	packet := make([]byte, 2+len("example.test:53")+2500)
	binary.BigEndian.PutUint16(packet, uint16(len("example.test:53")))
	copy(packet[2:], "example.test:53")
	for i := 2 + len("example.test:53"); i < len(packet); i++ {
		packet[i] = byte(i)
	}
	parts := splitForTest(19, packet)
	for i := len(parts) - 1; i >= 0; i-- {
		d.incoming <- parts[i]
	}
	buffer := make([]byte, 3000)
	n, addr, err := pc.ReadFrom(buffer)
	if err != nil {
		t.Fatal(err)
	}
	if addr.String() != "example.test:53" || !reflect.DeepEqual(buffer[:n], packet[2+len("example.test:53"):]) {
		t.Fatal("out-of-order datagram did not reassemble exactly")
	}
	if got := pc.(*packetConn).reassemble(parts[0]); got != nil {
		t.Fatal("one fragment completed a multi-fragment packet")
	}
	if got := pc.(*packetConn).reassemble(parts[0]); got != nil {
		t.Fatal("duplicate fragment changed assembly completion")
	}
	if got := pc.(*packetConn).reassemble(parts[1]); got != nil {
		t.Fatal("incomplete fragments produced a packet")
	}
	if got := pc.(*packetConn).reassemble(parts[2]); got == nil {
		t.Fatal("final fragment did not complete packet")
	}
	_ = pc.Close()
}

func TestPacketConnH3FragmentsLargeWritesWithinBounds(t *testing.T) {
	conn := newMemoryConn()
	datagrams := newMemoryDatagrams()
	packetConn := Packets(&streamConn{reader: conn, writer: conn, datagrams: datagrams, closeFn: func() { _ = conn.Close() }})
	payload := make([]byte, 65507)
	for i := range payload {
		payload[i] = byte(i)
	}
	written, err := packetConn.WriteTo(payload, testAddr("192.0.2.8:5353"))
	if err != nil || written != len(payload) {
		t.Fatalf("large WriteTo = %d, %v", written, err)
	}
	if len(datagrams.sent) >= (maxPacket+fragmentSize-1)/fragmentSize+1 {
		t.Fatalf("unexpected fragment count %d", len(datagrams.sent))
	}
	var reconstructed []byte
	for index, fragment := range datagrams.sent {
		if len(fragment) > fragmentSize+8 || binary.BigEndian.Uint16(fragment[4:]) != uint16(index) || binary.BigEndian.Uint16(fragment[6:]) != uint16(len(datagrams.sent)) {
			t.Fatalf("invalid fragment header at index %d", index)
		}
		reconstructed = append(reconstructed, fragment[8:]...)
	}
	addrLen := int(binary.BigEndian.Uint16(reconstructed))
	if string(reconstructed[2:2+addrLen]) != "192.0.2.8:5353" || !reflect.DeepEqual(reconstructed[2+addrLen:], payload) {
		t.Fatal("fragmented packet did not preserve destination and payload")
	}
	_ = packetConn.Close()
}

func TestPacketConnRejectsInvalidOutboundDatagrams(t *testing.T) {
	conn := newMemoryConn()
	packetConn := Packets(&streamConn{reader: conn, writer: conn, closeFn: func() { _ = conn.Close() }})
	for _, test := range []struct {
		address string
		payload []byte
	}{{"example.test:53", make([]byte, 65508)}, {strings.Repeat("a", 513) + ":53", nil}, {"example.test:no-port", nil}, {"", nil}} {
		if _, err := packetConn.WriteTo(test.payload, testAddr(test.address)); err == nil {
			t.Fatalf("accepted invalid UDP destination/length %q/%d", test.address, len(test.payload))
		}
	}
	_ = packetConn.Close()
}

func splitForTest(id uint32, payload []byte) [][]byte {
	const chunk = fragmentSize
	count := (len(payload) + chunk - 1) / chunk
	out := make([][]byte, 0, count)
	for i := 0; i < count; i++ {
		start := i * chunk
		end := min(start+chunk, len(payload))
		part := make([]byte, 8+end-start)
		binary.BigEndian.PutUint32(part, id)
		binary.BigEndian.PutUint16(part[4:], uint16(i))
		binary.BigEndian.PutUint16(part[6:], uint16(count))
		copy(part[8:], payload[start:end])
		out = append(out, part)
	}
	return out
}

func TestPacketConnH2TruncationClosesAssociation(t *testing.T) {
	conn := newMemoryConn()
	conn.blockOnEmpty = false
	conn.read = []byte{0, 0}
	pc := Packets(&streamConn{reader: conn, writer: conn, closeFn: func() { _ = conn.Close() }})
	_, _, err := pc.ReadFrom(make([]byte, 10))
	if err == nil {
		t.Fatal("expected truncated prefix failure")
	}
	select {
	case <-conn.closed:
	default:
		t.Fatal("truncated stream remained open")
	}
}
