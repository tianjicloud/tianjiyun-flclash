package core

import (
	"context"
	"errors"
	"net"
	"net/netip"
	"strings"
	"testing"

	"core/tianji"
	"github.com/metacubex/mihomo/adapter"
	"github.com/metacubex/mihomo/adapter/outbound"
	"github.com/metacubex/mihomo/config"
	C "github.com/metacubex/mihomo/constant"
)

type recordingDialer struct{ packetCalls, streamCalls int }

func (d *recordingDialer) DialContext(context.Context, string, string) (net.Conn, error) {
	d.streamCalls++
	return nil, errors.New("recording dialer")
}
func (d *recordingDialer) ListenPacket(context.Context, string, string, netip.AddrPort) (net.PacketConn, error) {
	d.packetCalls++
	return nil, errors.New("recording dialer")
}

func TestTianjiProxyRegistrationKeepsBasicOptionAndAPIPath(t *testing.T) {
	dialer := &recordingDialer{}
	proxy, err := createTianjiProxy(map[string]any{
		"type": "tianji", "name": "candidate", "server": "127.0.0.1", "port": 443,
		"servername": "gateway.example", "path": "/transport/v1", "token": "01234567890123456789012345678901", "transport": "h3",
		"interface-name": "test0", "routing-mark": 19, "ip-version": "ipv6", "tfo": true, "mptcp": true, "dialer-proxy": "upstream",
	}, outbound.BasicOption{DialerForAPI: dialer})
	if err != nil {
		t.Fatal(err)
	}
	actual := proxy
	tianjiProxy := actual.(*tianjiAdapter)
	if actual.Type() != C.Tianji {
		t.Fatalf("proxy type = %v", actual.Type())
	}
	info := actual.ProxyInfo()
	if info.Interface != "test0" || info.RoutingMark != 19 || !info.TFO || !info.MPTCP || info.DialerProxy != "upstream" || tianjiProxy.option.IPVersion != C.IPv6Only {
		t.Fatalf("BasicOption not preserved: %+v", info)
	}
	metadata := &C.Metadata{Host: "203.0.113.9", DstPort: 443}
	_, err = actual.DialContext(context.Background(), metadata)
	if err == nil {
		t.Fatal("expected injected dialer failure")
	}
	if dialer.packetCalls != 1 || dialer.streamCalls != 0 {
		t.Fatalf("API dialer calls: packet=%d stream=%d", dialer.packetCalls, dialer.streamCalls)
	}
}

func TestCustomFactoryDoesNotCaptureUnknownOutboundTypes(t *testing.T) {
	_, err := adapter.ParseProxy(map[string]any{"type": "made-up", "name": "x"})
	if err == nil || !strings.Contains(err.Error(), "unsupported") {
		t.Fatalf("unknown type error = %v", err)
	}
}

func TestConvertedTianjiProfileParsesAndKeepsGroupReferences(t *testing.T) {
	request := tianji.SubscriptionRequest{OfficialApp: true, SupportsTianji: true, OptIn: true, Transport: "h3", Nodes: map[string]tianji.SubscriptionNode{
		"edge": {Server: "gateway.example", Port: 443, ServerName: "gateway.example", Path: "/transport/v1", Token: "01234567890123456789012345678901", TLSValidated: true},
	}}
	source := []byte("proxies:\n  - name: edge\n    type: ss\n    server: old.example\n    port: 443\n    cipher: aes-128-gcm\n    password: old-secret\nproxy-groups:\n  - name: Gateway\n    type: select\n    proxies: [edge]\nrules:\n  - MATCH,Gateway\n")
	candidate, converted, err := tianji.ConvertSubscriptionCandidate(source, request)
	if err != nil {
		t.Fatal(err)
	}
	if !converted {
		t.Fatal("expected candidate conversion")
	}
	parsed, err := config.Parse(candidate)
	if err != nil {
		t.Fatalf("parse converted profile: %v", err)
	}
	edge, ok := parsed.Proxies["edge"]
	if !ok || edge.Type() != C.Tianji {
		t.Fatalf("candidate outbound not retained: %#v", edge)
	}
	if _, ok := parsed.Proxies["Gateway"]; !ok {
		t.Fatal("group reference was lost during core profile build")
	}
}
