package tianji

import (
	"context"
	"errors"
	"github.com/metacubex/tls"
	"net"
	"os"
	"sync"
	"testing"
	"time"
)

func TestStreamDeadlineResetMakesOlderTimerInert(t *testing.T) {
	underlying := newMemoryConn()
	closed := make(chan struct{})
	conn := newStreamConn(underlying, underlying, nil, func() { close(closed); _ = underlying.Close() })
	if err := conn.SetReadDeadline(time.Now().Add(20 * time.Millisecond)); err != nil {
		t.Fatal(err)
	}
	if err := conn.SetReadDeadline(time.Time{}); err != nil {
		t.Fatal(err)
	}
	time.Sleep(50 * time.Millisecond)
	select {
	case <-closed:
		t.Fatal("stale read deadline closed the stream")
	default:
	}
	_ = conn.Close()
}

func TestStreamDeadlineReturnsNetTimeout(t *testing.T) {
	underlying := newMemoryConn()
	conn := newStreamConn(underlying, underlying, nil, func() { _ = underlying.Close() })
	if err := conn.SetReadDeadline(time.Now().Add(20 * time.Millisecond)); err != nil {
		t.Fatal(err)
	}
	result := make(chan error, 1)
	go func() { _, err := conn.Read(make([]byte, 1)); result <- err }()
	select {
	case err := <-result:
		if !errors.Is(err, os.ErrDeadlineExceeded) {
			t.Fatalf("Read error = %v, want deadline exceeded", err)
		}
		var netErr net.Error
		if !errors.As(err, &netErr) || !netErr.Timeout() {
			t.Fatalf("deadline error %T does not implement net.Error timeout", err)
		}
	case <-time.After(time.Second):
		t.Fatal("Read did not unblock after its deadline")
	}
	_ = conn.Close()
}

func TestClientRejectsTLSVerificationBypass(t *testing.T) {
	options := ClientOptions{Address: "127.0.0.1:443", ServerName: "gateway.example", Path: "/transport/v1", Token: "01234567890123456789012345678901", DialContext: func(context.Context, string, string) (net.Conn, error) { return nil, nil }, DialPacket: func(context.Context) (net.PacketConn, net.Addr, error) { return nil, nil, nil }}
	options.TLS = &tls.Config{InsecureSkipVerify: true}
	if _, err := NewClient(options); err == nil {
		t.Fatal("TLS verification bypass was accepted")
	}
}

func TestNewClientRejectsMalformedTransportAuthority(t *testing.T) {
	base := ClientOptions{Address: "127.0.0.1:443", ServerName: "gateway.example", Path: "/transport/v1", Token: "01234567890123456789012345678901", DialContext: func(context.Context, string, string) (net.Conn, error) { return nil, nil }, DialPacket: func(context.Context) (net.PacketConn, net.Addr, error) { return nil, nil, nil }}
	for _, mutate := range []func(*ClientOptions){
		func(o *ClientOptions) { o.Address = "127.0.0.1:notaport" },
		func(o *ClientOptions) { o.ServerName = "gateway.example\r\nHost: forged" },
		func(o *ClientOptions) { o.Path = "/transport/v1\n" },
		func(o *ClientOptions) { o.Token = "too short" },
		func(o *ClientOptions) { o.Token = "0123456789012345678901234567890 token" },
	} {
		options := base
		mutate(&options)
		if _, err := NewClient(options); err == nil {
			t.Fatal("accepted malformed Tianji client configuration")
		}
	}
}

func TestClientCloseIsConcurrentAndIdempotent(t *testing.T) {
	options := ClientOptions{Address: "127.0.0.1:443", ServerName: "gateway.example", Path: "/transport/v1", Token: "01234567890123456789012345678901", DialContext: func(context.Context, string, string) (net.Conn, error) { return nil, nil }, DialPacket: func(context.Context) (net.PacketConn, net.Addr, error) { return nil, nil, nil }}
	client, err := NewClient(options)
	if err != nil {
		t.Fatal(err)
	}
	var workers sync.WaitGroup
	for i := 0; i < 8; i++ {
		workers.Add(1)
		go func() {
			defer workers.Done()
			if err := client.Close(); err != nil {
				t.Error(err)
			}
		}()
	}
	workers.Wait()
	if _, err = client.Dial(context.Background(), "tcp", "example.test:443"); !errors.Is(err, net.ErrClosed) {
		t.Fatalf("Dial after Close = %v", err)
	}
}
