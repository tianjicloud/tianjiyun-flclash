package tianji

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"io"
	"net"
	"net/netip"
	"net/url"
	"sync"
	"testing"
	"time"

	http "github.com/metacubex/http"
)

const serverTestToken = "server-test-token-0123456789abcdef0123456789"

func TestGatewayBoundsSetupButKeepsSessionContext(t *testing.T) {
	egress := &contextEgress{connections: make(chan net.Conn, 1), contexts: make(chan context.Context, 1)}
	gateway := newServerTestGateway(t, egress, 20*time.Millisecond)
	requestContext, cancelRequest := context.WithCancel(context.Background())
	bodyReader, bodyWriter := io.Pipe()
	defer bodyWriter.Close()
	request := &http.Request{Method: http.MethodPost, URL: &url.URL{Scheme: "https", Host: "gateway.test", Path: "/tianji/v1"}, Header: make(http.Header), Body: bodyReader, ProtoMajor: 2}
	request = request.WithContext(requestContext)
	setServerTestHeaders(request)
	writer := &serverTestResponseWriter{header: make(http.Header)}
	done := make(chan struct{})
	go func() { gateway.ServeHTTP(writer, request); close(done) }()
	var sessionPeer net.Conn
	select {
	case sessionPeer = <-egress.connections:
	case <-time.After(time.Second):
		t.Fatal("gateway did not establish upstream")
	}
	defer sessionPeer.Close()
	setupContext := <-egress.contexts
	select {
	case <-setupContext.Done():
	case <-time.After(time.Second):
		t.Fatal("setup context was not canceled after successful dial")
	}
	if requestContext.Err() != nil {
		t.Fatal("setup timeout canceled the live request context")
	}
	cancelRequest()
	select {
	case <-done:
	case <-time.After(time.Second):
		t.Fatal("session did not close after request cancellation")
	}
}

func TestGatewaySetupTimeoutReturnsUnavailable(t *testing.T) {
	egress := timeoutEgress{}
	gateway := newServerTestGateway(t, egress, 20*time.Millisecond)
	request := &http.Request{Method: http.MethodPost, URL: &url.URL{Scheme: "https", Host: "gateway.test", Path: "/tianji/v1"}, Header: make(http.Header), Body: io.NopCloser(&emptyReader{}), ProtoMajor: 2}
	setServerTestHeaders(request)
	writer := &serverTestResponseWriter{header: make(http.Header)}
	started := time.Now()
	gateway.ServeHTTP(writer, request)
	if writer.status != http.StatusServiceUnavailable {
		t.Fatalf("slow upstream status = %d, want 503", writer.status)
	}
	if time.Since(started) > time.Second {
		t.Fatal("setup timeout did not bound upstream dialing")
	}
}

func newServerTestGateway(t *testing.T, egress Egress, setupTimeout time.Duration) *Gateway {
	t.Helper()
	digest := sha256.Sum256([]byte(serverTestToken))
	config := []byte(`{"path":"/tianji/v1","max_connections":2,"authorizations":[{"token_sha256":"` + hex.EncodeToString(digest[:]) + `","outbound":"test","expires":"2035-01-01T00:00:00Z","max_connections":1}]}`)
	gateway, err := LoadGateway(config, map[string]Egress{"test": egress}, GatewayOptions{
		Resolver: fixedResolver{netip.MustParseAddr("8.8.8.8")}, SetupTimeout: setupTimeout,
	})
	if err != nil {
		t.Fatal(err)
	}
	return gateway
}

func setServerTestHeaders(request *http.Request) {
	request.Header.Set("Authorization", "Bearer "+serverTestToken)
	request.Header.Set("Tianji-Version", "1")
	request.Header.Set("Tianji-Network", "tcp")
	request.Header.Set("Tianji-Target", "public.example:443")
}

type contextEgress struct {
	connections chan net.Conn
	contexts    chan context.Context
}

func (e *contextEgress) DialContext(ctx context.Context, _, _ string) (net.Conn, error) {
	server, peer := net.Pipe()
	e.connections <- peer
	e.contexts <- ctx
	return server, nil
}

func (e *contextEgress) ListenPacket(context.Context, string) (net.PacketConn, error) {
	return nil, net.ErrClosed
}

type timeoutEgress struct{}

func (timeoutEgress) DialContext(ctx context.Context, _, _ string) (net.Conn, error) {
	<-ctx.Done()
	return nil, ctx.Err()
}

func (timeoutEgress) ListenPacket(context.Context, string) (net.PacketConn, error) {
	return nil, net.ErrClosed
}

type serverTestResponseWriter struct {
	header http.Header
	status int
	mu     sync.Mutex
}

func (w *serverTestResponseWriter) Header() http.Header { return w.header }
func (w *serverTestResponseWriter) WriteHeader(status int) {
	w.mu.Lock()
	w.status = status
	w.mu.Unlock()
}
func (w *serverTestResponseWriter) Write(data []byte) (int, error) {
	return len(data), nil
}

type emptyReader struct{}

func (*emptyReader) Read([]byte) (int, error) { return 0, io.EOF }
