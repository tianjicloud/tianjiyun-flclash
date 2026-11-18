package tianji

import (
	"context"
	"errors"
	"fmt"
	"net"
	"time"

	http "github.com/metacubex/http"
	tuciCommon "github.com/metacubex/mihomo/transport/tuic/common"
	"github.com/metacubex/quic-go"
	"github.com/metacubex/quic-go/http3"
	"github.com/metacubex/tls"
)

type ListenerOptions struct {
	Address  string
	CertFile string
	KeyFile  string
}

func Serve(ctx context.Context, gateway *Gateway, options ListenerOptions) error {
	if gateway == nil || options.Address == "" || options.CertFile == "" || options.KeyFile == "" {
		return errors.New("tianji: gateway, listen address and certificate files are required")
	}
	if _, err := tls.LoadX509KeyPair(options.CertFile, options.KeyFile); err != nil {
		return errors.New("tianji: initial TLS certificate is invalid")
	}
	tcpListener, err := net.Listen("tcp", options.Address)
	if err != nil {
		return fmt.Errorf("tianji: bind TCP listener: %w", err)
	}
	udpListener, err := net.ListenPacket("udp", options.Address)
	if err != nil {
		_ = tcpListener.Close()
		return fmt.Errorf("tianji: bind UDP listener: %w", err)
	}
	return serveListeners(ctx, gateway, options.CertFile, options.KeyFile, tcpListener, udpListener)
}

func serveListeners(ctx context.Context, gateway *Gateway, certFile, keyFile string, tcpListener net.Listener, udpListener net.PacketConn) error {
	defer tcpListener.Close()
	defer udpListener.Close()
	certificate := func(*tls.ClientHelloInfo) (*tls.Certificate, error) {
		cert, err := tls.LoadX509KeyPair(certFile, keyFile)
		if err != nil {
			return nil, errors.New("tianji: TLS certificate reload failed")
		}
		return &cert, nil
	}
	h2TLS := &tls.Config{MinVersion: tls.VersionTLS13, NextProtos: []string{"h2", "http/1.1"}, GetCertificate: certificate, SessionTicketsDisabled: true}
	httpServer := &http.Server{
		Handler:           gateway,
		TLSConfig:         h2TLS,
		ReadHeaderTimeout: 10 * time.Second,
		IdleTimeout:       90 * time.Second,
		MaxHeaderBytes:    16 << 10,
	}
	h3Server := &http3.Server{
		Addr:            udpListener.LocalAddr().String(),
		Handler:         gateway,
		TLSConfig:       http3.ConfigureTLSConfig(&tls.Config{MinVersion: tls.VersionTLS13, GetCertificate: certificate, SessionTicketsDisabled: true}),
		EnableDatagrams: true,
		QUICConfig: &quic.Config{
			EnableDatagrams: true, HandshakeIdleTimeout: 5 * time.Second,
			MaxIdleTimeout: 90 * time.Second, MaxIncomingStreams: 128,
			MaxIncomingUniStreams: 8, MaxStreamReceiveWindow: tuciCommon.DefaultStreamReceiveWindow,
			MaxConnectionReceiveWindow: tuciCommon.DefaultConnectionReceiveWindow,
		},
		ConnContext: func(ctx context.Context, conn *quic.Conn) context.Context {
			tuciCommon.SetCongestionController(conn, "bbr", 0, "standard")
			return ctx
		},
		MaxHeaderBytes: 16 << 10,
		IdleTimeout:    90 * time.Second,
	}
	type serveResult struct {
		name string
		err  error
	}
	results := make(chan serveResult, 2)
	go func() {
		results <- serveResult{name: "HTTP/2", err: httpServer.Serve(tls.NewListener(tcpListener, h2TLS))}
	}()
	go func() {
		results <- serveResult{name: "HTTP/3", err: h3Server.Serve(udpListener)}
	}()
	var result error
	received := 0
	select {
	case <-ctx.Done():
	case res := <-results:
		received++
		if !errors.Is(res.err, http.ErrServerClosed) {
			result = fmt.Errorf("tianji: %s listener stopped", res.name)
		}
	}
	_ = httpServer.Close()
	_ = h3Server.Close()
	_ = tcpListener.Close()
	_ = udpListener.Close()
	for i := received; i < 2; i++ {
		select {
		case <-results:
		case <-time.After(2 * time.Second):
			if result == nil {
				result = errors.New("tianji: listener shutdown timed out")
			}
		}
	}
	if ctx.Err() != nil && result == nil {
		return nil
	}
	return result
}
