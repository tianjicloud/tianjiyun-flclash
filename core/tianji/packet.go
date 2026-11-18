package tianji

import (
	"context"
	"encoding/binary"
	"errors"
	"io"
	"net"
	"sync"
	"time"
)

const maxPacket = 65507 + 514
const fragmentSize = 1024

type datagramStream interface {
	SendDatagram([]byte) error
	ReceiveDatagram(context.Context) ([]byte, error)
}

type packetConn struct {
	net.Conn
	d               datagramStream
	ctx             context.Context
	cancel          context.CancelFunc
	readMu, writeMu sync.Mutex
	sequence        uint32
	fragments       map[uint32]*assembly
}
type assembly struct {
	parts        [][]byte
	count, bytes int
	created      time.Time
}
type packetAddr string

func (a packetAddr) Network() string { return "udp" }
func (a packetAddr) String() string  { return string(a) }

func Packets(conn net.Conn) net.PacketConn {
	ctx, cancel := context.WithCancel(context.Background())
	p := &packetConn{Conn: conn, ctx: ctx, cancel: cancel, fragments: make(map[uint32]*assembly)}
	if s, ok := conn.(*streamConn); ok {
		p.d = s.datagrams
	}
	if p.d != nil {
		go func() { var b [1]byte; _, _ = conn.Read(b[:]); _ = p.Close() }()
	}
	return p
}
func (p *packetConn) Close() error { p.cancel(); return p.Conn.Close() }

func (p *packetConn) WriteTo(b []byte, addr net.Addr) (int, error) {
	if addr == nil {
		return 0, errors.New("tianji: missing packet destination")
	}
	a := addr.String()
	if validateAuthority(a) != nil || len(b) > 65507 {
		return 0, errors.New("tianji: oversized or invalid packet")
	}
	buf := make([]byte, 2+len(a)+len(b))
	binary.BigEndian.PutUint16(buf, uint16(len(a)))
	copy(buf[2:], a)
	copy(buf[2+len(a):], b)
	p.writeMu.Lock()
	defer p.writeMu.Unlock()
	if p.ctx.Err() != nil {
		return 0, net.ErrClosed
	}
	if p.d == nil {
		frame := make([]byte, 4+len(buf))
		binary.BigEndian.PutUint32(frame, uint32(len(buf)))
		copy(frame[4:], buf)
		if err := writeAll(p.Conn, frame); err != nil {
			_ = p.Close()
			return 0, err
		}
	} else {
		p.sequence++
		total := (len(buf) + fragmentSize - 1) / fragmentSize
		for i := 0; i < total; i++ {
			end := min((i+1)*fragmentSize, len(buf))
			frame := make([]byte, 8+end-i*fragmentSize)
			binary.BigEndian.PutUint32(frame, p.sequence)
			binary.BigEndian.PutUint16(frame[4:], uint16(i))
			binary.BigEndian.PutUint16(frame[6:], uint16(total))
			copy(frame[8:], buf[i*fragmentSize:end])
			if err := p.d.SendDatagram(frame); err != nil {
				return 0, err
			}
		}
	}
	return len(b), nil
}

func (p *packetConn) ReadFrom(b []byte) (int, net.Addr, error) {
	p.readMu.Lock()
	defer p.readMu.Unlock()
	for {
		var buf []byte
		if p.d == nil {
			var size [4]byte
			if _, err := io.ReadFull(p.Conn, size[:]); err != nil {
				_ = p.Close()
				return 0, nil, err
			}
			n := binary.BigEndian.Uint32(size[:])
			if n < 3 || n > maxPacket {
				_ = p.Close()
				return 0, nil, errors.New("tianji: invalid packet length")
			}
			buf = make([]byte, n)
			if _, err := io.ReadFull(p.Conn, buf); err != nil {
				_ = p.Close()
				return 0, nil, err
			}
		} else {
			frame, err := p.d.ReceiveDatagram(p.ctx)
			if err != nil {
				return 0, nil, err
			}
			buf = p.reassemble(frame)
			if buf == nil {
				continue
			}
		}
		if len(buf) < 3 {
			continue
		}
		n := int(binary.BigEndian.Uint16(buf))
		if n == 0 || n > 512 || 2+n > len(buf) {
			continue
		}
		a := string(buf[2 : 2+n])
		if validateAuthority(a) != nil {
			continue
		}
		if len(buf)-2-n > len(b) {
			return 0, nil, io.ErrShortBuffer
		}
		return copy(b, buf[2+n:]), packetAddr(a), nil
	}
}

func (p *packetConn) reassemble(frame []byte) []byte {
	if len(frame) <= 8 || len(frame) > fragmentSize+8 {
		return nil
	}
	id := binary.BigEndian.Uint32(frame)
	i, total := int(binary.BigEndian.Uint16(frame[4:])), int(binary.BigEndian.Uint16(frame[6:]))
	if total == 0 || total > (maxPacket+fragmentSize-1)/fragmentSize || i >= total {
		return nil
	}
	if i < total-1 && len(frame) != fragmentSize+8 {
		return nil
	}
	if total == 1 {
		return frame[8:]
	}
	now := time.Now()
	for key, value := range p.fragments {
		if now.Sub(value.created) > 5*time.Second {
			delete(p.fragments, key)
		}
	}
	a := p.fragments[id]
	if a == nil {
		if len(p.fragments) >= 32 {
			return nil
		}
		a = &assembly{parts: make([][]byte, total), created: now}
		p.fragments[id] = a
	}
	if len(a.parts) != total {
		delete(p.fragments, id)
		return nil
	}
	if a.parts[i] == nil {
		a.parts[i] = append([]byte(nil), frame[8:]...)
		a.count++
		a.bytes += len(frame) - 8
	}
	if a.bytes > maxPacket {
		delete(p.fragments, id)
		return nil
	}
	if a.count != total {
		return nil
	}
	delete(p.fragments, id)
	buf := make([]byte, 0, a.bytes)
	for _, part := range a.parts {
		buf = append(buf, part...)
	}
	return buf
}

func writeAll(w io.Writer, b []byte) error {
	for len(b) > 0 {
		n, err := w.Write(b)
		if err != nil {
			return err
		}
		if n == 0 {
			return io.ErrShortWrite
		}
		b = b[n:]
	}
	return nil
}
