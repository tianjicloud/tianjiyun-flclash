package tianji

import (
	"encoding/binary"
	"errors"
	"io"
	"net"
	"sync"
)

const (
	tcpDataFrame       byte = 1
	tcpFINFrame        byte = 0
	maxTCPFrame             = 32 << 10
	tcpFrameHeaderSize      = 5
)

var errTCPFrame = errors.New("tianji: invalid TCP application frame")

type tcpConn struct {
	net.Conn
	readMu      sync.Mutex
	writeMu     sync.Mutex
	closeOnce   sync.Once
	readBuffer  []byte
	readOffset  int
	readEOF     bool
	writeClosed bool
	writeErr    error
	closeErr    error
}

func newTCPConn(conn net.Conn) *tcpConn { return &tcpConn{Conn: conn} }

func (c *tcpConn) Read(p []byte) (int, error) {
	if len(p) == 0 {
		return 0, nil
	}
	c.readMu.Lock()
	defer c.readMu.Unlock()
	if c.readOffset < len(c.readBuffer) {
		n := copy(p, c.readBuffer[c.readOffset:])
		c.readOffset += n
		if c.readOffset == len(c.readBuffer) {
			c.readBuffer = nil
			c.readOffset = 0
		}
		return n, nil
	}
	if c.readEOF {
		return 0, io.EOF
	}
	var header [tcpFrameHeaderSize]byte
	if _, err := io.ReadFull(c.Conn, header[:]); err != nil {
		_ = c.Close()
		if errors.Is(err, io.EOF) {
			return 0, io.ErrUnexpectedEOF
		}
		return 0, err
	}
	length := binary.BigEndian.Uint32(header[1:])
	switch header[0] {
	case tcpFINFrame:
		if length != 0 {
			_ = c.Close()
			return 0, errTCPFrame
		}
		c.readEOF = true
		return 0, io.EOF
	case tcpDataFrame:
		if length == 0 || length > maxTCPFrame {
			_ = c.Close()
			return 0, errTCPFrame
		}
	default:
		_ = c.Close()
		return 0, errTCPFrame
	}
	c.readBuffer = make([]byte, int(length))
	if _, err := io.ReadFull(c.Conn, c.readBuffer); err != nil {
		c.readBuffer = nil
		_ = c.Close()
		if errors.Is(err, io.EOF) {
			return 0, io.ErrUnexpectedEOF
		}
		return 0, err
	}
	n := copy(p, c.readBuffer)
	c.readOffset = n
	if c.readOffset == len(c.readBuffer) {
		c.readBuffer = nil
		c.readOffset = 0
	}
	return n, nil
}

func (c *tcpConn) Write(p []byte) (int, error) {
	c.writeMu.Lock()
	defer c.writeMu.Unlock()
	if c.writeClosed {
		return 0, io.ErrClosedPipe
	}
	written := 0
	for len(p) > 0 {
		n := min(len(p), maxTCPFrame)
		frame := make([]byte, tcpFrameHeaderSize+n)
		frame[0] = tcpDataFrame
		binary.BigEndian.PutUint32(frame[1:tcpFrameHeaderSize], uint32(n))
		copy(frame[tcpFrameHeaderSize:], p[:n])
		if err := writeAll(c.Conn, frame); err != nil {
			_ = c.Close()
			return written, err
		}
		written += n
		p = p[n:]
	}
	return written, nil
}

func (c *tcpConn) CloseWrite() error {
	c.writeMu.Lock()
	defer c.writeMu.Unlock()
	if c.writeClosed {
		return c.writeErr
	}
	c.writeClosed = true
	var frame [tcpFrameHeaderSize]byte
	frame[0] = tcpFINFrame
	if err := writeAll(c.Conn, frame[:]); err != nil {
		c.writeErr = err
		_ = c.Close()
		return c.writeErr
	}
	if halfCloser, ok := c.Conn.(interface{ CloseWrite() error }); ok {
		if err := halfCloser.CloseWrite(); err != nil {
			c.writeErr = err
			_ = c.Close()
		}
	}
	return c.writeErr
}

func (c *tcpConn) Close() error {
	c.closeOnce.Do(func() { c.closeErr = c.Conn.Close() })
	return c.closeErr
}

var _ net.Conn = (*tcpConn)(nil)
var _ interface{ CloseWrite() error } = (*tcpConn)(nil)
