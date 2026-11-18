package core

import (
	"context"
	"crypto/x509"
	"fmt"
	"net"
	"net/netip"
	"strconv"

	"github.com/metacubex/mihomo/adapter"
	"github.com/metacubex/mihomo/adapter/outbound"
	N "github.com/metacubex/mihomo/common/net"
	"github.com/metacubex/mihomo/common/structure"
	"github.com/metacubex/mihomo/component/resolver"
	C "github.com/metacubex/mihomo/constant"
	"github.com/metacubex/tls"

	"core/tianji"
)

type tianjiAdapter struct {
	*outbound.Base
	option tianjiOption
	client *tianji.Client
}

type tianjiConn struct {
	C.Conn
	tcp interface{ CloseWrite() error }
}

func (c *tianjiConn) CloseWrite() error { return c.tcp.CloseWrite() }
func (c *tianjiConn) AddRef(ref any)    { c.Conn.(outbound.AddRef).AddRef(ref) }

type tianjiOption struct {
	Name       string `proxy:"name"`
	Server     string `proxy:"server"`
	Port       int    `proxy:"port"`
	ServerName string `proxy:"servername"`
	Path       string `proxy:"path"`
	Token      string `proxy:"token"`
	Transport  string `proxy:"transport,omitempty"`
	CACert     string `proxy:"ca-cert,omitempty"`
	outbound.BasicOption
}

func init() { adapter.CustomProxyFactory = createTianjiProxy }

func createTianjiProxy(mapping map[string]any, basic outbound.BasicOption) (outbound.ProxyAdapter, error) {
	proxyType, _ := mapping["type"].(string)
	if proxyType != "tianji" {
		return nil, fmt.Errorf("unsupported proxy type: %s", proxyType)
	}
	var option tianjiOption
	option.BasicOption = basic
	if value, exists := mapping["port"]; exists {
		switch v := value.(type) {
		case int:
			option.Port = v
		case int64:
			if int64(int(v)) != v {
				return nil, fmt.Errorf("tianji: port out of range")
			}
			option.Port = int(v)
		case uint64:
			if v > 65535 {
				return nil, fmt.Errorf("tianji: port out of range")
			}
			option.Port = int(v)
		case float64:
			if v != float64(int(v)) {
				return nil, fmt.Errorf("tianji: port must be an integer")
			}
			option.Port = int(v)
		default:
			return nil, fmt.Errorf("tianji: port must be an integer")
		}
	}
	decoder := structure.NewDecoder(structure.Option{TagName: "proxy", WeaklyTypedInput: true, KeyReplacer: structure.DefaultKeyReplacer})
	if err := decoder.Decode(mapping, &option); err != nil {
		return nil, fmt.Errorf("tianji: decode proxy options: %w", err)
	}
	for key := range mapping {
		if key != "name" && key != "server" && key != "port" && key != "servername" && key != "path" && key != "token" && key != "transport" && key != "ca-cert" && key != "type" && key != "interface-name" && key != "routing-mark" && key != "ip-version" && key != "tfo" && key != "mptcp" && key != "dialer-proxy" {
			return nil, fmt.Errorf("tianji: unsupported field %q", key)
		}
	}
	if option.Name == "" || option.Server == "" || option.ServerName == "" || option.Port < 1 || option.Port > 65535 || option.Path == "" || option.Path[0] != '/' || len(option.Token) < 32 {
		return nil, fmt.Errorf("tianji: name, server, port, servername, path and high-entropy token required")
	}
	if option.Transport == "" {
		option.Transport = "auto"
	}
	if option.Transport != "auto" && option.Transport != "h2" && option.Transport != "h3" {
		return nil, fmt.Errorf("tianji: invalid transport")
	}
	addr := net.JoinHostPort(option.Server, strconv.Itoa(option.Port))
	base := outbound.NewBase(outbound.BaseOption{Name: option.Name, Addr: addr, Type: C.Tianji, ProviderName: option.ProviderName, UDP: true, TFO: option.TFO, MPTCP: option.MPTCP, Interface: option.Interface, RoutingMark: option.RoutingMark, Prefer: option.IPVersion})
	d := option.NewDialer(base.DialOptions())
	tlsConfig := &tls.Config{MinVersion: tls.VersionTLS13, ServerName: option.ServerName}
	if option.CACert != "" {
		pool, err := x509.SystemCertPool()
		if err != nil || pool == nil {
			pool = x509.NewCertPool()
		}
		if !pool.AppendCertsFromPEM([]byte(option.CACert)) {
			return nil, fmt.Errorf("tianji: ca-cert contains no PEM certificates")
		}
		tlsConfig.RootCAs = pool
	}
	dialAddress := func(ctx context.Context) (string, error) {
		host, port, err := net.SplitHostPort(addr)
		if err != nil {
			return "", err
		}
		if ip, err := netip.ParseAddr(host); err == nil {
			return net.JoinHostPort(ip.String(), port), nil
		}
		var ip netip.Addr
		switch option.IPVersion {
		case C.IPv4Only:
			ip, err = resolver.ResolveIPv4(ctx, host)
		case C.IPv6Only:
			ip, err = resolver.ResolveIPv6(ctx, host)
		case C.IPv6Prefer:
			ip, err = resolver.ResolveIPPrefer6(ctx, host)
		default:
			ip, err = resolver.ResolveIP(ctx, host)
		}
		if err != nil {
			return "", err
		}
		return net.JoinHostPort(ip.String(), port), nil
	}
	client, err := tianji.NewClient(tianji.ClientOptions{Address: addr, ServerName: option.ServerName, Path: option.Path, Token: option.Token, Transport: option.Transport, TLS: tlsConfig,
		DialContext: func(ctx context.Context, network, _ string) (net.Conn, error) {
			resolved, err := dialAddress(ctx)
			if err != nil {
				return nil, err
			}
			return d.DialContext(ctx, network, resolved)
		},
		DialPacket: func(ctx context.Context) (net.PacketConn, net.Addr, error) {
			resolved, err := dialAddress(ctx)
			if err != nil {
				return nil, nil, err
			}
			raddr, err := net.ResolveUDPAddr("udp", resolved)
			if err != nil {
				return nil, nil, err
			}
			pc, err := d.ListenPacket(ctx, "udp", "", raddr.AddrPort())
			if err != nil {
				return nil, nil, err
			}
			return pc, raddr, nil
		},
	})
	if err != nil {
		return nil, err
	}
	return &tianjiAdapter{Base: base, option: option, client: client}, nil
}

func (a *tianjiAdapter) DialContext(ctx context.Context, metadata *C.Metadata) (C.Conn, error) {
	conn, err := a.client.Dial(ctx, "tcp", metadata.RemoteAddress())
	if err != nil {
		return nil, err
	}
	wrapped := outbound.NewConn(conn, a)
	return &tianjiConn{Conn: wrapped, tcp: conn.(interface{ CloseWrite() error })}, nil
}
func (a *tianjiAdapter) ListenPacketContext(ctx context.Context, metadata *C.Metadata) (C.PacketConn, error) {
	if err := a.ResolveUDP(ctx, metadata); err != nil {
		return nil, err
	}
	conn, err := a.client.Dial(ctx, "udp", metadata.RemoteAddress())
	if err != nil {
		return nil, err
	}
	return outbound.NewPacketConn(N.NewThreadSafePacketConn(tianji.Packets(conn)), a), nil
}
func (a *tianjiAdapter) SupportUOT() bool { return true }
func (a *tianjiAdapter) Close() error     { return a.client.Close() }
func (a *tianjiAdapter) ProxyInfo() C.ProxyInfo {
	info := a.Base.ProxyInfo()
	info.DialerProxy = a.option.DialerProxy
	return info
}

var _ outbound.ProxyAdapter = (*tianjiAdapter)(nil)
