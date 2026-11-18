package tianji

import (
	"bytes"
	"encoding/binary"
	"errors"
	"io"
	"net"
	"sync"
	"testing"
)

func TestTCPFramesSplitLargeWritesAndRoundTrip(t *testing.T) {
	payload := make([]byte, 96<<10)
	for i := range payload {
		payload[i] = byte(i * 13)
	}
	wireOut := newMemoryConn()
	sender := newTCPConn(wireOut)
	if n, err := sender.Write(payload); err != nil || n != len(payload) {
		t.Fatalf("Write = %d, %v", n, err)
	}
	if err := sender.CloseWrite(); err != nil {
		t.Fatal(err)
	}
	if err := sender.CloseWrite(); err != nil {
		t.Fatalf("repeated CloseWrite = %v", err)
	}
	if _, err := sender.Write([]byte("after FIN")); !errors.Is(err, io.ErrClosedPipe) {
		t.Fatalf("Write after FIN = %v", err)
	}
	if got := countTCPFrames(wireOut.written); got != 4 {
		t.Fatalf("wire frame count = %d, want 3 DATA and one FIN", got)
	}
	wireIn := newMemoryConn()
	wireIn.blockOnEmpty = false
	wireIn.read = append([]byte(nil), wireOut.written...)
	receiver := newTCPConn(wireIn)
	got, err := io.ReadAll(receiver)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(got, payload) {
		t.Fatal("framed TCP payload changed")
	}
}

func TestTCPHalfClosesAreIndependentInBothDirections(t *testing.T) {
	t.Run("remote FIN leaves local write open", func(t *testing.T) {
		wire := newMemoryConn()
		wire.blockOnEmpty = false
		wire.read = appendTCPFrame(nil, tcpFINFrame, nil)
		conn := newTCPConn(wire)
		if _, err := conn.Read(make([]byte, 1)); !errors.Is(err, io.EOF) {
			t.Fatalf("Read at remote FIN = %v", err)
		}
		if _, err := conn.Write([]byte("client still writes")); err != nil {
			t.Fatalf("Write after remote FIN = %v", err)
		}
		if got := wire.written[0]; got != tcpDataFrame {
			t.Fatalf("response frame type = %d", got)
		}
	})
	t.Run("local FIN leaves remote read open", func(t *testing.T) {
		wire := newMemoryConn()
		wire.blockOnEmpty = false
		wire.read = appendTCPFrame(nil, tcpDataFrame, []byte("server reply"))
		wire.read = appendTCPFrame(wire.read, tcpFINFrame, nil)
		conn := newTCPConn(wire)
		if err := conn.CloseWrite(); err != nil {
			t.Fatal(err)
		}
		got, err := io.ReadAll(conn)
		if err != nil {
			t.Fatal(err)
		}
		if string(got) != "server reply" {
			t.Fatalf("Read after local FIN = %q", got)
		}
		if wire.written[0] != tcpFINFrame {
			t.Fatalf("client FIN frame = %d", wire.written[0])
		}
	})
	t.Run("local FIN closes underlying HTTP request body", func(t *testing.T) {
		wire := &halfCloseMemoryConn{memoryConn: newMemoryConn()}
		conn := newTCPConn(wire)
		if err := conn.CloseWrite(); err != nil {
			t.Fatal(err)
		}
		if wire.closeWrites != 1 {
			t.Fatalf("underlying CloseWrite calls = %d, want 1", wire.closeWrites)
		}
		if err := conn.CloseWrite(); err != nil || wire.closeWrites != 1 {
			t.Fatalf("repeated CloseWrite = %v, underlying calls = %d", err, wire.closeWrites)
		}
	})
}

type halfCloseMemoryConn struct {
	*memoryConn
	closeWrites int
}

func (c *halfCloseMemoryConn) CloseWrite() error {
	c.closeWrites++
	return nil
}

func TestTCPFramesSerializeConcurrentWrites(t *testing.T) {
	wire := newMemoryConn()
	conn := newTCPConn(wire)
	const writers = 12
	var workers sync.WaitGroup
	for i := 0; i < writers; i++ {
		workers.Add(1)
		go func(value byte) {
			defer workers.Done()
			payload := bytes.Repeat([]byte{value}, 4096)
			if n, err := conn.Write(payload); err != nil || n != len(payload) {
				t.Errorf("concurrent Write = %d, %v", n, err)
			}
		}(byte(i + 1))
	}
	workers.Wait()
	offset, frames := 0, 0
	for offset < len(wire.written) {
		if len(wire.written)-offset < tcpFrameHeaderSize {
			t.Fatal("truncated concurrent frame header")
		}
		header := wire.written[offset : offset+tcpFrameHeaderSize]
		size := int(binary.BigEndian.Uint32(header[1:]))
		if header[0] != tcpDataFrame || size != 4096 || offset+tcpFrameHeaderSize+size > len(wire.written) {
			t.Fatal("concurrent writes interleaved frame boundaries")
		}
		payload := wire.written[offset+tcpFrameHeaderSize : offset+tcpFrameHeaderSize+size]
		if !bytes.Equal(payload, bytes.Repeat(payload[:1], size)) {
			t.Fatal("concurrent writes interleaved payload bytes")
		}
		offset += tcpFrameHeaderSize + size
		frames++
	}
	if frames != writers {
		t.Fatalf("frame count = %d, want %d", frames, writers)
	}
}

func TestTCPFramingRejectsTruncationAndInvalidFrames(t *testing.T) {
	cases := []struct {
		name string
		wire []byte
		want error
	}{
		{"missing FIN", nil, io.ErrUnexpectedEOF},
		{"unknown type", []byte{9, 0, 0, 0, 0}, errTCPFrame},
		{"empty DATA", []byte{tcpDataFrame, 0, 0, 0, 0}, errTCPFrame},
		{"oversized DATA", frameHeader(tcpDataFrame, maxTCPFrame+1), errTCPFrame},
		{"truncated DATA", []byte{tcpDataFrame, 0, 0, 0, 2, 'x'}, io.ErrUnexpectedEOF},
		{"malformed FIN", []byte{tcpFINFrame, 0, 0, 0, 1}, errTCPFrame},
	}
	for _, test := range cases {
		t.Run(test.name, func(t *testing.T) {
			wire := newMemoryConn()
			wire.blockOnEmpty = false
			wire.read = test.wire
			conn := newTCPConn(wire)
			_, err := conn.Read(make([]byte, maxTCPFrame))
			if !errors.Is(err, test.want) {
				t.Fatalf("Read error = %v, want %v", err, test.want)
			}
			select {
			case <-wire.closed:
			default:
				t.Fatal("invalid stream remained open")
			}
		})
	}
}

func appendTCPFrame(dst []byte, frameType byte, payload []byte) []byte {
	frame := make([]byte, tcpFrameHeaderSize+len(payload))
	frame[0] = frameType
	binary.BigEndian.PutUint32(frame[1:], uint32(len(payload)))
	copy(frame[tcpFrameHeaderSize:], payload)
	return append(dst, frame...)
}
func frameHeader(frameType byte, size int) []byte {
	header := make([]byte, tcpFrameHeaderSize)
	header[0] = frameType
	binary.BigEndian.PutUint32(header[1:], uint32(size))
	return header
}
func countTCPFrames(wire []byte) int {
	count := 0
	for offset := 0; offset < len(wire); {
		if len(wire)-offset < tcpFrameHeaderSize {
			return -1
		}
		size := int(binary.BigEndian.Uint32(wire[offset+1 : offset+tcpFrameHeaderSize]))
		if offset+tcpFrameHeaderSize+size > len(wire) {
			return -1
		}
		offset += tcpFrameHeaderSize + size
		count++
	}
	return count
}

var _ net.Conn = (*tcpConn)(nil)
