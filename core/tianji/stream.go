package tianji

import (
	"context"
	"io"
	"net"
	"os"
	"sync"
	"time"
)

type streamConn struct {
	reader                          io.Reader
	writer                          io.WriteCloser
	closeFn                         func()
	datagrams                       datagramStream
	once                            sync.Once
	writeOnce                       sync.Once
	writeErr                        error
	mu                              sync.Mutex
	closed                          bool
	readTimer, writeTimer           *time.Timer
	readGeneration, writeGeneration uint64
	readExpired, writeExpired       bool
}

func newStreamConn(reader io.Reader, writer io.Writer, datagrams datagramStream, closeFn func()) *streamConn {
	w, ok := writer.(io.WriteCloser)
	if !ok {
		w = nopWriteCloser{Writer: writer}
	}
	return &streamConn{reader: reader, writer: w, datagrams: datagrams, closeFn: closeFn}
}

type nopWriteCloser struct{ io.Writer }

func (nopWriteCloser) Close() error { return nil }

func (c *streamConn) Read(p []byte) (int, error) {
	n, err := c.reader.Read(p)
	if err != nil && c.timedOut(true) {
		return n, os.ErrDeadlineExceeded
	}
	return n, err
}
func (c *streamConn) Write(p []byte) (int, error) {
	n, err := c.writer.Write(p)
	if err != nil && c.timedOut(false) {
		return n, os.ErrDeadlineExceeded
	}
	return n, err
}
func (c *streamConn) timedOut(read bool) bool {
	c.mu.Lock()
	defer c.mu.Unlock()
	if read {
		return c.readExpired
	}
	return c.writeExpired
}
func (c *streamConn) Close() error {
	c.once.Do(func() {
		c.mu.Lock()
		c.closed = true
		if c.readTimer != nil {
			c.readTimer.Stop()
		}
		if c.writeTimer != nil {
			c.writeTimer.Stop()
		}
		c.mu.Unlock()
		c.closeFn()
	})
	return nil
}
func (c *streamConn) CloseWrite() error {
	c.writeOnce.Do(func() { c.writeErr = c.writer.Close() })
	return c.writeErr
}
func (c *streamConn) LocalAddr() net.Addr  { return streamAddr("local") }
func (c *streamConn) RemoteAddr() net.Addr { return streamAddr("gateway") }
func (c *streamConn) SetDeadline(t time.Time) error {
	if err := c.SetReadDeadline(t); err != nil {
		return err
	}
	return c.SetWriteDeadline(t)
}
func (c *streamConn) SetReadDeadline(t time.Time) error  { return c.setDeadline(true, t) }
func (c *streamConn) SetWriteDeadline(t time.Time) error { return c.setDeadline(false, t) }
func (c *streamConn) setDeadline(read bool, deadline time.Time) error {
	c.mu.Lock()
	defer c.mu.Unlock()
	if c.closed {
		return net.ErrClosed
	}
	var timer **time.Timer
	var generation *uint64
	var expired *bool
	if read {
		timer = &c.readTimer
		generation = &c.readGeneration
		expired = &c.readExpired
	} else {
		timer = &c.writeTimer
		generation = &c.writeGeneration
		expired = &c.writeExpired
	}
	if *timer != nil {
		(*timer).Stop()
		*timer = nil
	}
	*generation++
	*expired = false
	if deadline.IsZero() {
		return nil
	}
	gen := *generation
	*timer = time.AfterFunc(time.Until(deadline), func() {
		c.mu.Lock()
		if c.closed || *generation != gen {
			c.mu.Unlock()
			return
		}
		*expired = true
		c.closed = true
		if c.readTimer != nil {
			c.readTimer.Stop()
		}
		if c.writeTimer != nil {
			c.writeTimer.Stop()
		}
		c.mu.Unlock()
		c.once.Do(c.closeFn)
	})
	return nil
}

type streamAddr string

func (a streamAddr) Network() string { return "tianji" }
func (a streamAddr) String() string  { return string(a) }

func relay(ctx context.Context, a, b net.Conn) {
	canceled := make(chan struct{})
	stop := context.AfterFunc(ctx, func() {
		_ = a.Close()
		_ = b.Close()
		close(canceled)
	})
	defer func() {
		if !stop() {
			<-canceled
		}
	}()
	defer a.Close()
	defer b.Close()
	done := make(chan struct{})
	copyHalf := func(dst, src net.Conn) {
		_, err := io.Copy(dst, src)
		if err == nil {
			if w, ok := dst.(interface{ CloseWrite() error }); ok {
				_ = w.CloseWrite()
				return
			}
		}
		_ = dst.Close()
	}
	go func() { copyHalf(a, b); close(done) }()
	copyHalf(b, a)
	<-done
}

var _ net.Conn = (*streamConn)(nil)
