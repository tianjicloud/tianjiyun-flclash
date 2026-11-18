package tianji

import (
	"context"
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	stdtls "crypto/tls"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/json"
	"encoding/pem"
	"fmt"
	"io"
	"math/big"
	"net"
	"net/http"
	"net/netip"
	"os"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"syscall"
	"testing"
	"time"

	mtls "github.com/metacubex/tls"
)

const integrationToken = "test-token-0123456789abcdef0123456789abcdef"
const integrationLimitedToken = "limit-token-0123456789abcdef0123456789abcdef"
const integrationSoonToken = "soon-token-0123456789abcdef0123456789abcdef"

func TestGatewayTLSIntegration(t *testing.T) {
	portText := os.Getenv("TIANJI_TEST_PORT")
	if portText == "" {
		t.Skip("run under devport with TIANJI_TEST_PORT to exercise live TLS listeners")
	}
	port, err := strconv.Atoi(portText)
	if err != nil || port < 1 || port > 65535 {
		t.Fatalf("invalid test port %q", portText)
	}
	certFile, keyFile, roots := integrationCertificate(t)
	egress := newIntegrationEgress(t)
	resolver := integrationResolver{}
	config := integrationGatewayConfig(time.Now().Add(time.Hour), time.Now().Add(2*time.Second), 1, 2)
	gateway, err := LoadGateway(config, map[string]Egress{"test-egress": egress}, GatewayOptions{Resolver: resolver, UDPIdleTimeout: 3 * time.Second, UDPFirstPacketTimeout: 500 * time.Millisecond})
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithCancel(context.Background())
	serverDone := make(chan error, 1)
	go func() {
		serverDone <- Serve(ctx, gateway, ListenerOptions{Address: net.JoinHostPort("127.0.0.1", portText), CertFile: certFile, KeyFile: keyFile})
	}()
	waitTCPListener(t, port)
	defer func() {
		cancel()
		select {
		case err := <-serverDone:
			if err != nil {
				t.Errorf("gateway shutdown: %v", err)
			}
		case <-time.After(5 * time.Second):
			t.Error("gateway did not stop")
		}
	}()

	t.Run("H3 bidirectional TCP half-close", func(t *testing.T) {
		client := integrationClient(t, port, roots, "gateway.test", "h3", nil)
		payload := make([]byte, 96<<10)
		for i := range payload {
			payload[i] = byte(i * 31)
		}
		verifyTCPHalfClose(t, client, payload)
	})
	t.Run("authorization expiry closes an active session", func(t *testing.T) {
		client := integrationClientWithToken(t, port, roots, "gateway.test", "h3", integrationSoonToken, nil)
		conn, err := client.Dial(context.Background(), "tcp", "public.example:443")
		if err != nil {
			t.Fatal(err)
		}
		defer conn.Close()
		_ = conn.SetReadDeadline(time.Now().Add(4 * time.Second))
		if _, err := conn.Read(make([]byte, 1)); err == nil {
			t.Fatal("session survived its authorization expiry")
		}
	})
	t.Run("H2 bidirectional TCP half-close", func(t *testing.T) {
		client := integrationClient(t, port, roots, "gateway.test", "h2", nil)
		payload := []byte(strings.Repeat("tianji-h2", 8192))
		verifyTCPHalfClose(t, client, payload)
	})
	t.Run("server-first FIN keeps client upload direction open", func(t *testing.T) {
		client := integrationClient(t, port, roots, "gateway.test", "h3", nil)
		conn, err := client.Dial(context.Background(), "tcp", "server-first.example:443")
		if err != nil {
			t.Fatal(err)
		}
		defer conn.Close()
		greeting := make([]byte, len("upstream-fin"))
		_ = conn.SetReadDeadline(time.Now().Add(3 * time.Second))
		if _, err := io.ReadFull(conn, greeting); err != nil || string(greeting) != "upstream-fin" {
			t.Fatalf("server greeting = %q, err=%v", greeting, err)
		}
		if _, err := conn.Read(make([]byte, 1)); err != io.EOF {
			t.Fatalf("server half-close read = %v, want EOF", err)
		}
		payload := []byte(strings.Repeat("client-after-server-fin", 2048))
		if _, err := conn.Write(payload); err != nil {
			t.Fatalf("client upload after server FIN: %v", err)
		}
		if err := conn.(interface{ CloseWrite() error }).CloseWrite(); err != nil {
			t.Fatal(err)
		}
		select {
		case got := <-egress.serverFirstData:
			if !equalBytes(got, payload) {
				t.Fatalf("server received %d bytes after its FIN, want %d", len(got), len(payload))
			}
		case <-time.After(4 * time.Second):
			t.Fatal("upstream did not receive client data after its FIN")
		}
	})
	t.Run("H3 UDP empty small and fragmented large packets", func(t *testing.T) {
		client := integrationClient(t, port, roots, "gateway.test", "h3", nil)
		verifyUDPRoundTrip(t, egress, client, [][]byte{{}, []byte("small"), make([]byte, 48<<10)})
	})
	t.Run("H2 UDP empty small and large packets", func(t *testing.T) {
		client := integrationClient(t, port, roots, "gateway.test", "h2", nil)
		verifyUDPRoundTrip(t, egress, client, [][]byte{{}, []byte("small-h2"), make([]byte, 8<<10)})
	})
	t.Run("auto falls back after H3 transport is unreachable", func(t *testing.T) {
		var h2Dials atomic.Int32
		packetDial := func(context.Context) (net.PacketConn, net.Addr, error) {
			return nil, nil, &net.OpError{Op: "dial", Net: "udp", Err: syscall.ECONNREFUSED}
		}
		client := integrationClient(t, port, roots, "gateway.test", "auto", &h2Dials)
		client.options.DialPacket = packetDial
		conn, err := client.Dial(context.Background(), "tcp", "public.example:443")
		if err != nil {
			t.Fatalf("auto H2 fallback failed: %v", err)
		}
		_ = conn.Close()
		if h2Dials.Load() == 0 {
			t.Fatal("H2 fallback dialer was not called")
		}
	})
	t.Run("wrong SNI and untrusted certificate do not downgrade", func(t *testing.T) {
		for _, tc := range []struct {
			name  string
			sni   string
			roots *x509.CertPool
		}{{name: "wrong SNI", sni: "wrong.test", roots: roots}, {name: "untrusted", sni: "gateway.test", roots: x509.NewCertPool()}} {
			t.Run(tc.name, func(t *testing.T) {
				var h2Dials atomic.Int32
				client := integrationClient(t, port, tc.roots, tc.sni, "auto", &h2Dials)
				if conn, err := client.Dial(context.Background(), "tcp", "public.example:443"); err == nil {
					_ = conn.Close()
					t.Fatal("invalid gateway identity was accepted")
				}
				if h2Dials.Load() != 0 {
					t.Fatal("certificate failure caused an H2 downgrade")
				}
			})
		}
	})
	t.Run("wrong token version and denied target never dial", func(t *testing.T) {
		before := egress.tcpDials.Load()
		client := integrationClientWithToken(t, port, roots, "gateway.test", "h3", "wrong-token-0123456789abcdef0123456789abcdef", nil)
		if _, err := client.Dial(context.Background(), "tcp", "public.example:443"); err == nil {
			t.Fatal("wrong token was accepted")
		}
		_ = client.Close()
		if egress.tcpDials.Load() != before {
			t.Fatal("wrong token dialed an outbound")
		}
		if status := rawH2Status(t, port, roots, integrationToken, "invalid", "127.0.0.1:443"); status == http.StatusOK {
			t.Fatal("wrong version was accepted")
		}
		if status := rawH2Status(t, port, roots, integrationToken, "1", "private.example:443"); status == http.StatusOK {
			t.Fatal("private target was accepted")
		}
		if egress.tcpDials.Load() != before {
			t.Fatal("invalid version or target dialed an outbound")
		}
	})
	t.Run("per-token cap releases after session close", func(t *testing.T) {
		first := integrationClient(t, port, roots, "gateway.test", "h2", nil)
		second := integrationClient(t, port, roots, "gateway.test", "h2", nil)
		conn, err := first.Dial(context.Background(), "tcp", "public.example:443")
		if err != nil {
			t.Fatal(err)
		}
		if _, err := second.Dial(context.Background(), "tcp", "public.example:443"); err == nil {
			t.Fatal("second session exceeded per-token limit")
		}
		_ = conn.Close()
		waitForAdmission(t, second, "tcp")
	})
	t.Run("global cap applies across tokens", func(t *testing.T) {
		first := integrationClient(t, port, roots, "gateway.test", "h2", nil)
		second := integrationClientWithToken(t, port, roots, "gateway.test", "h2", integrationLimitedToken, nil)
		third := integrationClientWithToken(t, port, roots, "gateway.test", "h2", integrationLimitedToken, nil)
		connA, err := first.Dial(context.Background(), "tcp", "public.example:443")
		if err != nil {
			t.Fatal(err)
		}
		defer connA.Close()
		connB, err := second.Dial(context.Background(), "tcp", "public.example:443")
		if err != nil {
			t.Fatal(err)
		}
		if _, err := third.Dial(context.Background(), "tcp", "public.example:443"); err == nil {
			t.Fatal("third session exceeded global limit")
		}
		_ = connB.Close()
	})
	t.Run("UDP session first-packet, malformed-fragment, idle and disconnect cleanup", func(t *testing.T) {
		client := integrationClient(t, port, roots, "gateway.test", "h3", nil)
		conn, err := client.Dial(context.Background(), "udp", "public.example:53")
		if err != nil {
			t.Fatal(err)
		}
		pc := egress.nextPacket(t)
		waitPacketClosed(t, pc, time.Second)
		_ = conn.Close()

		streamClient := integrationClient(t, port, roots, "gateway.test", "h3", nil)
		stream, err := streamClient.connection(context.Background())
		if err != nil {
			t.Fatal(err)
		}
		request := streamClient.request("udp", "public.example:53")
		reqStream, err := stream.OpenRequestStream(context.Background())
		if err != nil {
			t.Fatal(err)
		}
		if err := reqStream.SendRequestHeader(request); err != nil {
			t.Fatal(err)
		}
		if res, err := reqStream.ReadResponse(); err != nil || res.StatusCode != http.StatusOK {
			t.Fatalf("open malformed-fragment test stream: response=%v err=%v", res, err)
		}
		malformedPC := egress.nextPacket(t)
		for i := 0; i < 16; i++ {
			if err := reqStream.SendDatagram([]byte{0, 0, 0, byte(i), 0, 1, 0, 2}); err != nil {
				break
			}
			time.Sleep(40 * time.Millisecond)
		}
		waitPacketClosed(t, malformedPC, time.Second)
		streamClient.Close()

		activeClient := integrationClient(t, port, roots, "gateway.test", "h3", nil)
		active, err := activeClient.Dial(context.Background(), "udp", "public.example:53")
		if err != nil {
			t.Fatal(err)
		}
		activePC := egress.nextPacket(t)
		packets := Packets(active)
		if _, err := packets.WriteTo([]byte("activity"), &net.UDPAddr{IP: net.ParseIP("8.8.8.8"), Port: 53}); err != nil {
			t.Fatal(err)
		}
		buf := make([]byte, 32)
		_ = packets.SetReadDeadline(time.Now().Add(time.Second))
		if _, _, err := packets.ReadFrom(buf); err != nil {
			t.Fatal(err)
		}
		select {
		case <-activePC.closed:
			t.Fatal("active UDP association closed before its idle timeout")
		case <-time.After(time.Second):
		}
		waitPacketClosed(t, activePC, 3*time.Second)
		_ = packets.Close()

		disconnectClient := integrationClient(t, port, roots, "gateway.test", "h3", nil)
		disconnected, err := disconnectClient.Dial(context.Background(), "udp", "public.example:53")
		if err != nil {
			t.Fatal(err)
		}
		disconnectedPC := egress.nextPacket(t)
		_ = disconnected.Close()
		waitPacketClosed(t, disconnectedPC, time.Second)
	})
	t.Run("HTTP/1 probe receives fallback and does not dial", func(t *testing.T) {
		before := egress.tcpDials.Load()
		transport := &http.Transport{TLSClientConfig: &stdtls.Config{ServerName: "gateway.test", RootCAs: roots}}
		defer transport.CloseIdleConnections()
		req, err := http.NewRequest(http.MethodPost, "https://"+net.JoinHostPort("127.0.0.1", portText)+"/tianji/v1", strings.NewReader(""))
		if err != nil {
			t.Fatal(err)
		}
		req.Host = "gateway.test"
		req.Header.Set("Authorization", "Bearer "+integrationToken)
		req.Header.Set("Tianji-Version", Version)
		req.Header.Set("Tianji-Network", "tcp")
		req.Header.Set("Tianji-Target", "public.example:443")
		res, err := transport.RoundTrip(req)
		if err != nil {
			t.Fatalf("HTTP/1 fallback request: %v", err)
		}
		_ = res.Body.Close()
		if res.ProtoMajor != 1 || res.StatusCode == http.StatusOK {
			t.Fatalf("HTTP/1 response = %s %d", res.Proto, res.StatusCode)
		}
		if egress.tcpDials.Load() != before {
			t.Fatal("HTTP/1 request dialed an outbound")
		}
	})
}

func verifyTCPHalfClose(t *testing.T, client *Client, payload []byte) {
	t.Helper()
	conn, err := client.Dial(context.Background(), "tcp", "public.example:443")
	if err != nil {
		t.Fatal(err)
	}
	defer conn.Close()
	if _, err := conn.Write(payload); err != nil {
		t.Fatal(err)
	}
	if err := conn.(interface{ CloseWrite() error }).CloseWrite(); err != nil {
		t.Fatal(err)
	}
	_ = conn.SetReadDeadline(time.Now().Add(5 * time.Second))
	got, err := io.ReadAll(conn)
	if err != nil {
		t.Fatal(err)
	}
	if !equalBytes(got, payload) {
		t.Fatalf("TCP echo length=%d, want %d", len(got), len(payload))
	}
}

func verifyUDPRoundTrip(t *testing.T, egress *integrationEgress, client *Client, payloads [][]byte) {
	t.Helper()
	conn, err := client.Dial(context.Background(), "udp", "public.example:53")
	if err != nil {
		t.Fatal(err)
	}
	defer conn.Close()
	_ = egress.nextPacket(t)
	packets := Packets(conn)
	defer packets.Close()
	for i, payload := range payloads {
		for j := range payload {
			payload[j] = byte(i + j*17)
		}
		if n, err := packets.WriteTo(payload, &net.UDPAddr{IP: net.ParseIP("8.8.8.8"), Port: 53}); err != nil || n != len(payload) {
			t.Fatalf("UDP write %d: n=%d err=%v", i, n, err)
		}
		buf := make([]byte, 65507)
		_ = packets.SetReadDeadline(time.Now().Add(5 * time.Second))
		n, addr, err := packets.ReadFrom(buf)
		if err != nil {
			t.Fatalf("UDP read %d: %v", i, err)
		}
		if addr.String() != "8.8.8.8:53" || !equalBytes(buf[:n], payload) {
			t.Fatalf("UDP reply %d mismatch: n=%d addr=%v", i, n, addr)
		}
	}
}

func waitForAdmission(t *testing.T, client *Client, network string) {
	t.Helper()
	deadline := time.Now().Add(3 * time.Second)
	for time.Now().Before(deadline) {
		conn, err := client.Dial(context.Background(), network, "public.example:443")
		if err == nil {
			_ = conn.Close()
			return
		}
		time.Sleep(40 * time.Millisecond)
	}
	t.Fatal("gateway did not release its connection slot")
}

func integrationClient(t *testing.T, port int, roots *x509.CertPool, serverName, transport string, h2Calls *atomic.Int32) *Client {
	return integrationClientWithToken(t, port, roots, serverName, transport, integrationToken, h2Calls)
}

func integrationClientWithToken(t *testing.T, port int, roots *x509.CertPool, serverName, transport, token string, h2Calls *atomic.Int32) *Client {
	t.Helper()
	var dialer = &net.Dialer{Timeout: 3 * time.Second}
	client, err := NewClient(ClientOptions{
		Address: net.JoinHostPort("127.0.0.1", strconv.Itoa(port)), ServerName: serverName,
		Path: "/tianji/v1", Token: token, Transport: transport,
		TLS: &mtls.Config{RootCAs: roots},
		DialContext: func(ctx context.Context, network, address string) (net.Conn, error) {
			if h2Calls != nil {
				h2Calls.Add(1)
			}
			return dialer.DialContext(ctx, network, address)
		},
		DialPacket: func(ctx context.Context) (net.PacketConn, net.Addr, error) {
			packet, err := net.ListenPacket("udp", "127.0.0.1:0")
			if err != nil {
				return nil, nil, err
			}
			return packet, &net.UDPAddr{IP: net.ParseIP("127.0.0.1"), Port: port}, nil
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = client.Close() })
	return client
}

func integrationGatewayConfig(expiry, soonExpiry time.Time, tokenLimit, globalLimit int) []byte {
	entries := []Authorization{
		integrationAuthorization(integrationToken, expiry, tokenLimit),
		integrationAuthorization(integrationLimitedToken, expiry, globalLimit),
		integrationAuthorization(integrationSoonToken, soonExpiry, 1),
	}
	data, err := json.Marshal(gatewayConfig{Path: "/tianji/v1", MaxConnections: globalLimit, Authorizations: entries})
	if err != nil {
		panic(err)
	}
	return data
}

func integrationAuthorization(token string, expiry time.Time, limit int) Authorization {
	digest := sha256.Sum256([]byte(token))
	return Authorization{TokenSHA256: fmt.Sprintf("%x", digest), Outbound: "test-egress", Expires: expiry, MaxConnections: limit}
}

type integrationResolver struct{}

func (integrationResolver) LookupIP(_ context.Context, host string) ([]netip.Addr, error) {
	switch host {
	case "public.example":
		return []netip.Addr{netip.MustParseAddr("8.8.8.8")}, nil
	case "private.example":
		return []netip.Addr{netip.MustParseAddr("127.0.0.1")}, nil
	case "server-first.example":
		return []netip.Addr{netip.MustParseAddr("8.8.4.4")}, nil
	default:
		return nil, fmt.Errorf("unknown test host")
	}
}

type integrationEgress struct {
	address         string
	serverFirstAddr string
	tcpDials        atomic.Int32
	packets         chan *echoPacketConn
	serverFirstData chan []byte
}

func newIntegrationEgress(t *testing.T) *integrationEgress {
	t.Helper()
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = listener.Close() })
	firstListener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = firstListener.Close() })
	go func() {
		for {
			conn, err := listener.Accept()
			if err != nil {
				return
			}
			go func(conn net.Conn) { _, _ = io.Copy(conn, conn); _ = conn.Close() }(conn)
		}
	}()
	firstData := make(chan []byte, 8)
	go func() {
		for {
			conn, err := firstListener.Accept()
			if err != nil {
				return
			}
			go func(conn net.Conn) {
				_, _ = conn.Write([]byte("upstream-fin"))
				if tcp, ok := conn.(*net.TCPConn); ok {
					_ = tcp.CloseWrite()
				}
				data, _ := io.ReadAll(conn)
				firstData <- data
				_ = conn.Close()
			}(conn)
		}
	}()
	return &integrationEgress{address: listener.Addr().String(), serverFirstAddr: firstListener.Addr().String(), packets: make(chan *echoPacketConn, 32), serverFirstData: firstData}
}

func (e *integrationEgress) DialContext(ctx context.Context, network, address string) (net.Conn, error) {
	e.tcpDials.Add(1)
	return e.dial(ctx, network, address)
}

func (e *integrationEgress) dial(ctx context.Context, network, address string) (net.Conn, error) {
	if address == "8.8.4.4:443" {
		return (&net.Dialer{}).DialContext(ctx, network, e.serverFirstAddr)
	}
	return (&net.Dialer{}).DialContext(ctx, network, e.address)
}

func (e *integrationEgress) ListenPacket(context.Context, string) (net.PacketConn, error) {
	packet := newEchoPacketConn()
	e.packets <- packet
	return packet, nil
}

func (e *integrationEgress) nextPacket(t *testing.T) *echoPacketConn {
	t.Helper()
	select {
	case packet := <-e.packets:
		return packet
	case <-time.After(3 * time.Second):
		t.Fatal("gateway did not create an upstream UDP association")
		return nil
	}
}

type echoDatagram struct {
	data []byte
	addr net.Addr
}

type echoPacketConn struct {
	mu       sync.Mutex
	queue    chan echoDatagram
	closed   chan struct{}
	closeOne sync.Once
}

func newEchoPacketConn() *echoPacketConn {
	return &echoPacketConn{queue: make(chan echoDatagram, 64), closed: make(chan struct{})}
}

func (c *echoPacketConn) ReadFrom(buf []byte) (int, net.Addr, error) {
	select {
	case packet := <-c.queue:
		if len(buf) < len(packet.data) {
			return 0, nil, io.ErrShortBuffer
		}
		return copy(buf, packet.data), packet.addr, nil
	case <-c.closed:
		return 0, nil, net.ErrClosed
	}
}

func (c *echoPacketConn) WriteTo(buf []byte, addr net.Addr) (int, error) {
	packet := echoDatagram{data: append([]byte(nil), buf...), addr: addr}
	select {
	case c.queue <- packet:
		return len(buf), nil
	case <-c.closed:
		return 0, net.ErrClosed
	}
}

func (c *echoPacketConn) Close() error                     { c.closeOne.Do(func() { close(c.closed) }); return nil }
func (c *echoPacketConn) LocalAddr() net.Addr              { return packetAddr("gateway-test") }
func (c *echoPacketConn) SetDeadline(time.Time) error      { return nil }
func (c *echoPacketConn) SetReadDeadline(time.Time) error  { return nil }
func (c *echoPacketConn) SetWriteDeadline(time.Time) error { return nil }

func waitPacketClosed(t *testing.T, packet *echoPacketConn, timeout time.Duration) {
	t.Helper()
	select {
	case <-packet.closed:
	case <-time.After(timeout):
		t.Fatal("upstream UDP association was not reclaimed")
	}
}

type captureResponseWriter struct {
	header http.Header
	status int
}

func (w *captureResponseWriter) Header() http.Header    { return w.header }
func (w *captureResponseWriter) WriteHeader(status int) { w.status = status }
func (w *captureResponseWriter) Write(data []byte) (int, error) {
	if w.status == 0 {
		w.status = http.StatusOK
	}
	return len(data), nil
}

func rawRequest(token, version, network, target string) *http.Request {
	request, _ := http.NewRequest(http.MethodPost, "https://gateway.test/tianji/v1", strings.NewReader(""))
	request.ProtoMajor = 1
	request.Header.Set("Authorization", "Bearer "+token)
	request.Header.Set("Tianji-Version", version)
	request.Header.Set("Tianji-Network", network)
	request.Header.Set("Tianji-Target", target)
	return request
}

func rawH2Status(t *testing.T, port int, roots *x509.CertPool, token, version, target string) int {
	t.Helper()
	tr := &http.Transport{TLSClientConfig: &stdtls.Config{ServerName: "gateway.test", RootCAs: roots}, ForceAttemptHTTP2: true}
	defer tr.CloseIdleConnections()
	req, err := http.NewRequest(http.MethodPost, "https://"+net.JoinHostPort("127.0.0.1", strconv.Itoa(port))+"/tianji/v1", strings.NewReader(""))
	if err != nil {
		t.Fatal(err)
	}
	req.Host = "gateway.test"
	req.Header.Set("Authorization", "Bearer "+token)
	req.Header.Set("Tianji-Version", version)
	req.Header.Set("Tianji-Network", "tcp")
	req.Header.Set("Tianji-Target", target)
	res, err := tr.RoundTrip(req)
	if err != nil {
		t.Fatal(err)
	}
	defer res.Body.Close()
	return res.StatusCode
}

func integrationCertificate(t *testing.T) (string, string, *x509.CertPool) {
	t.Helper()
	key, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		t.Fatal(err)
	}
	serial, err := rand.Int(rand.Reader, new(big.Int).Lsh(big.NewInt(1), 120))
	if err != nil {
		t.Fatal(err)
	}
	now := time.Now()
	template := &x509.Certificate{SerialNumber: serial, Subject: pkix.Name{CommonName: "gateway.test"}, DNSNames: []string{"gateway.test"}, NotBefore: now.Add(-time.Minute), NotAfter: now.Add(time.Hour), KeyUsage: x509.KeyUsageDigitalSignature | x509.KeyUsageCertSign, ExtKeyUsage: []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth}, BasicConstraintsValid: true, IsCA: true}
	der, err := x509.CreateCertificate(rand.Reader, template, template, &key.PublicKey, key)
	if err != nil {
		t.Fatal(err)
	}
	keyDER, err := x509.MarshalPKCS8PrivateKey(key)
	if err != nil {
		t.Fatal(err)
	}
	dir := t.TempDir()
	certPath := dir + "/cert.pem"
	keyPath := dir + "/key.pem"
	if err := os.WriteFile(certPath, pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE", Bytes: der}), 0o600); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(keyPath, pem.EncodeToMemory(&pem.Block{Type: "PRIVATE KEY", Bytes: keyDER}), 0o600); err != nil {
		t.Fatal(err)
	}
	roots := x509.NewCertPool()
	if !roots.AppendCertsFromPEM(mustRead(t, certPath)) {
		t.Fatal("could not add generated test certificate")
	}
	return certPath, keyPath, roots
}

func mustRead(t *testing.T, path string) []byte {
	t.Helper()
	data, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	return data
}

func waitTCPListener(t *testing.T, port int) {
	t.Helper()
	deadline := time.Now().Add(5 * time.Second)
	for time.Now().Before(deadline) {
		conn, err := net.DialTimeout("tcp", net.JoinHostPort("127.0.0.1", strconv.Itoa(port)), 100*time.Millisecond)
		if err == nil {
			_ = conn.Close()
			return
		}
		time.Sleep(20 * time.Millisecond)
	}
	t.Fatal("gateway TCP listener did not start")
}

func equalBytes(a, b []byte) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}
