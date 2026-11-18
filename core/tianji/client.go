package tianji

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net"
	"net/url"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/metacubex/http"
	"github.com/metacubex/mihomo/transport/tuic/common"
	"github.com/metacubex/quic-go"
	"github.com/metacubex/quic-go/http3"
	"github.com/metacubex/tls"
)

const Version = "1"

type ClientOptions struct {
	Address, ServerName, Path, Token, Transport string
	TLS                                         *tls.Config
	DialContext                                 func(context.Context, string, string) (net.Conn, error)
	DialPacket                                  func(context.Context) (net.PacketConn, net.Addr, error)
}

type h3Connection struct {
	quic   *quic.Conn
	packet net.PacketConn
	h3     *http3.ClientConn
}

type Client struct {
	options    ClientOptions
	tcp        *http.Transport
	ctx        context.Context
	cancel     context.CancelFunc
	mu         sync.Mutex
	conn       *h3Connection
	connecting chan struct{}
	cooldown   time.Time
	closed     bool
}

func NewClient(o ClientOptions) (*Client, error) {
	addressHost, addressPort, addressErr := net.SplitHostPort(o.Address)
	addressPortNumber, portErr := strconv.Atoi(addressPort)
	if addressErr != nil || portErr != nil || addressHost == "" || strings.ContainsAny(addressHost, "/@?#") || addressPortNumber < 1 || addressPortNumber > 65535 || len(o.Address) > 512 || hasControl(o.Address) || strings.Contains(o.Address, " ") ||
		o.ServerName == "" || len(o.ServerName) > 253 || strings.TrimSpace(o.ServerName) != o.ServerName || hasControl(o.ServerName) || strings.Contains(o.ServerName, " ") ||
		len(o.Token) < 32 || len(o.Token) > 2048 || hasControl(o.Token) || strings.Contains(o.Token, " ") || o.Path == "" || len(o.Path) > 2048 || o.Path[0] != '/' || hasControl(o.Path) || strings.ContainsAny(o.Path, " ?#") {
		return nil, errors.New("tianji: address, servername, path and high-entropy token required")
	}
	if o.Transport == "" {
		o.Transport = "auto"
	}
	if o.Transport != "auto" && o.Transport != "h2" && o.Transport != "h3" {
		return nil, errors.New("tianji: invalid transport")
	}
	if o.DialContext == nil || o.DialPacket == nil {
		return nil, errors.New("tianji: platform dialers required")
	}
	if o.TLS == nil {
		o.TLS = &tls.Config{}
	} else {
		o.TLS = o.TLS.Clone()
	}
	if o.TLS.InsecureSkipVerify {
		return nil, errors.New("tianji: certificate verification is mandatory")
	}
	o.TLS.MinVersion = tls.VersionTLS13
	o.TLS.ServerName = o.ServerName
	ctx, cancel := context.WithCancel(context.Background())
	c := &Client{options: o, ctx: ctx, cancel: cancel}
	c.tcp = &http.Transport{
		DialContext: o.DialContext, TLSClientConfig: h2TLSConfig(o.TLS), ForceAttemptHTTP2: true,
		TLSHandshakeTimeout: 5 * time.Second, ResponseHeaderTimeout: 15 * time.Second,
		IdleConnTimeout: 30 * time.Second, MaxIdleConnsPerHost: 2, MaxConnsPerHost: 4,
		DisableCompression: true,
	}
	return c, nil
}

func hasControl(value string) bool {
	for _, r := range value {
		if r < 0x20 || r == 0x7f {
			return true
		}
	}
	return false
}

func h2TLSConfig(cfg *tls.Config) *tls.Config {
	clone := cfg.Clone()
	clone.NextProtos = []string{"h2"}
	return clone
}

func QUICConfig() *quic.Config {
	return &quic.Config{EnableDatagrams: true, HandshakeIdleTimeout: 4 * time.Second,
		MaxIdleTimeout: 45 * time.Second, KeepAlivePeriod: 15 * time.Second,
		MaxIncomingStreams: 128, MaxIncomingUniStreams: 8,
		MaxStreamReceiveWindow: common.DefaultStreamReceiveWindow, MaxConnectionReceiveWindow: common.DefaultConnectionReceiveWindow}
}

func (c *Client) connection(ctx context.Context) (*http3.ClientConn, error) {
	for {
		c.mu.Lock()
		if c.closed {
			c.mu.Unlock()
			return nil, net.ErrClosed
		}
		if c.conn != nil && c.conn.quic.Context().Err() == nil {
			h3 := c.conn.h3
			c.mu.Unlock()
			return h3, nil
		}
		if wait := c.connecting; wait != nil {
			c.mu.Unlock()
			select {
			case <-wait:
				continue
			case <-ctx.Done():
				return nil, ctx.Err()
			case <-c.ctx.Done():
				return nil, net.ErrClosed
			}
		}
		wait := make(chan struct{})
		c.connecting = wait
		old := c.conn
		c.conn = nil
		c.mu.Unlock()
		if old != nil {
			_ = old.quic.CloseWithError(0, "replaced")
			_ = old.packet.Close()
		}

		dialCtx, cancel := context.WithTimeout(ctx, 1500*time.Millisecond)
		stop := context.AfterFunc(c.ctx, cancel)
		pc, addr, err := c.options.DialPacket(dialCtx)
		var next *h3Connection
		if err == nil {
			cfg := c.options.TLS.Clone()
			cfg.NextProtos = []string{http3.NextProtoH3}
			var q *quic.Conn
			q, err = quic.Dial(dialCtx, pc, addr, cfg, QUICConfig())
			if err == nil {
				common.SetCongestionController(q, "bbr", 0, "standard")
				next = &h3Connection{quic: q, packet: pc, h3: (&http3.Transport{EnableDatagrams: true, DisableCompression: true, MaxResponseHeaderBytes: 8192}).NewClientConn(q)}
			} else {
				_ = pc.Close()
			}
		}
		stop()
		cancel()
		c.mu.Lock()
		if err == nil && !c.closed && c.ctx.Err() == nil {
			c.conn = next
		} else if err == nil {
			err = net.ErrClosed
		}
		c.connecting = nil
		close(wait)
		c.mu.Unlock()
		if err != nil {
			if next != nil {
				_ = next.quic.CloseWithError(0, "closed")
				_ = next.packet.Close()
			}
			return nil, err
		}
		return next.h3, nil
	}
}

func (c *Client) request(network, target string) *http.Request {
	return &http.Request{Method: http.MethodPost, URL: &url.URL{Scheme: "https", Host: c.options.Address, Path: c.options.Path}, Host: c.options.ServerName,
		Header: http.Header{"Authorization": {"Bearer " + c.options.Token}, "Tianji-Version": {Version}, "Tianji-Network": {network}, "Tianji-Target": {target}}, Body: http.NoBody, ContentLength: -1}
}

type responseError int

func (e responseError) Error() string {
	return fmt.Sprintf("tianji: gateway rejected request (%d)", int(e))
}

func (c *Client) Dial(ctx context.Context, network, target string) (net.Conn, error) {
	if network != "tcp" && network != "udp" {
		return nil, errors.New("tianji: unsupported network")
	}
	if err := validateAuthority(target); err != nil {
		return nil, errors.New("tianji: invalid target")
	}
	c.mu.Lock()
	useH3 := c.options.Transport != "h2" && (c.options.Transport == "h3" || time.Now().After(c.cooldown))
	closed := c.closed
	c.mu.Unlock()
	if closed {
		return nil, net.ErrClosed
	}
	if useH3 {
		conn, err := c.dialH3(ctx, network, target)
		if err == nil {
			return wrapDialedNetwork(network, conn), nil
		}
		var unavailable h3Unavailable
		if c.options.Transport == "h3" || !errors.As(err, &unavailable) || ctx.Err() != nil || c.ctx.Err() != nil {
			return nil, err
		}
		c.mu.Lock()
		c.cooldown = time.Now().Add(30 * time.Second)
		c.mu.Unlock()
	}
	conn, err := c.dialH2(ctx, network, target)
	if err != nil {
		return nil, err
	}
	return wrapDialedNetwork(network, conn), nil
}

func wrapDialedNetwork(network string, conn net.Conn) net.Conn {
	if network == "tcp" {
		return newTCPConn(conn)
	}
	return conn
}

func validateAuthority(target string) error {
	if target == "" || len(target) > maxTargetLength || hasControl(target) || strings.Contains(target, " ") {
		return errors.New("invalid authority")
	}
	host, portText, err := net.SplitHostPort(target)
	if err != nil || host == "" {
		return errors.New("invalid authority")
	}
	port, err := strconv.Atoi(portText)
	if err != nil || port < 1 || port > 65535 {
		return errors.New("invalid authority")
	}
	return nil
}

func (c *Client) dialH3(ctx context.Context, network, target string) (net.Conn, error) {
	h3, err := c.connection(ctx)
	if err != nil {
		var cert *tls.CertificateVerificationError
		var networkErr net.Error
		if errors.As(err, &cert) || !errors.As(err, &networkErr) {
			return nil, err
		}
		return nil, h3Unavailable{err}
	}
	if network == "udp" {
		settingsCtx, cancel := context.WithTimeout(ctx, 1500*time.Millisecond)
		defer cancel()
		select {
		case <-h3.ReceivedSettings():
		case <-settingsCtx.Done():
			if ctx.Err() != nil {
				return nil, ctx.Err()
			}
			if c.ctx.Err() != nil {
				return nil, net.ErrClosed
			}
			return nil, h3Unavailable{settingsCtx.Err()}
		case <-c.ctx.Done():
			return nil, net.ErrClosed
		}
		if settings := h3.Settings(); settings == nil || !settings.EnableDatagrams {
			return nil, errors.New("tianji: gateway did not negotiate HTTP datagrams")
		}
	}
	s, err := h3.OpenRequestStream(ctx)
	if err != nil {
		return nil, err
	}
	stop := context.AfterFunc(ctx, func() { s.CancelRead(0); s.CancelWrite(0) })
	defer stop()
	if err = s.SendRequestHeader(c.request(network, target)); err != nil {
		s.CancelRead(0)
		s.CancelWrite(0)
		return nil, err
	}
	res, err := s.ReadResponse()
	if err != nil {
		s.CancelRead(0)
		s.CancelWrite(0)
		return nil, err
	}
	if res.StatusCode != http.StatusOK || res.Header.Get("Tianji-Version") != Version {
		_ = res.Body.Close()
		s.CancelWrite(0)
		return nil, responseError(res.StatusCode)
	}
	if !stop() {
		s.CancelRead(0)
		s.CancelWrite(0)
		return nil, ctx.Err()
	}
	return newStreamConn(s, s, s, func() { _ = res.Body.Close(); s.CancelRead(0); s.CancelWrite(0) }), nil
}

type h3Unavailable struct{ err error }

func (e h3Unavailable) Error() string { return "tianji: HTTP/3 unavailable: " + e.err.Error() }
func (e h3Unavailable) Unwrap() error { return e.err }

func (c *Client) dialH2(ctx context.Context, network, target string) (net.Conn, error) {
	life, cancel := context.WithCancel(c.ctx)
	stop := context.AfterFunc(ctx, cancel)
	defer stop()
	r, w := io.Pipe()
	req := c.request(network, target).WithContext(life)
	req.Body = r
	res, err := c.tcp.RoundTrip(req)
	if err != nil {
		cancel()
		_ = r.Close()
		_ = w.Close()
		return nil, fmt.Errorf("tianji: HTTP/2 connection failed: %w", err)
	}
	if res.ProtoMajor != 2 || res.StatusCode != http.StatusOK || res.Header.Get("Tianji-Version") != Version {
		cancel()
		_ = res.Body.Close()
		_ = r.Close()
		_ = w.Close()
		return nil, responseError(res.StatusCode)
	}
	if !stop() {
		cancel()
		_ = res.Body.Close()
		_ = r.Close()
		_ = w.Close()
		return nil, ctx.Err()
	}
	return newStreamConn(res.Body, w, nil, func() { cancel(); _ = res.Body.Close(); _ = r.Close(); _ = w.Close() }), nil
}

func (c *Client) Close() error {
	c.cancel()
	c.mu.Lock()
	c.closed = true
	old := c.conn
	c.conn = nil
	c.mu.Unlock()
	if old != nil {
		_ = old.quic.CloseWithError(0, "closed")
		_ = old.packet.Close()
	}
	c.tcp.CloseIdleConnections()
	return nil
}
