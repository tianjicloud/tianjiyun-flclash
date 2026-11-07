package core

import (
	"context"
	"io"
	"net"
	"net/netip"
	"testing"
	"time"

	"github.com/metacubex/mihomo/adapter/outbound"
	N "github.com/metacubex/mihomo/common/net"
	C "github.com/metacubex/mihomo/constant"
	"github.com/metacubex/mihomo/tunnel/statistic"
)

type accountingTestRule struct {
	ruleType C.RuleType
	payload  string
}

func (r accountingTestRule) RuleType() C.RuleType { return r.ruleType }

func (r accountingTestRule) Match(*C.Metadata, C.RuleMatchHelper) (bool, string) {
	return false, ""
}

func (r accountingTestRule) Adapter() string         { return "" }
func (r accountingTestRule) Payload() string         { return r.payload }
func (r accountingTestRule) ProviderNames() []string { return nil }

func accountingMetadata(dst string) *C.Metadata {
	return &C.Metadata{DstIP: netip.MustParseAddr(dst)}
}

func TestTrafficAccountingClassification(t *testing.T) {
	direct := C.Chain{"DIRECT"}
	proxy := C.Chain{"hk-node"}
	mainlandIP := accountingMetadata("202.96.134.133")
	publicIP := accountingMetadata("8.8.8.8")

	tests := []struct {
		name     string
		metadata *C.Metadata
		rule     C.Rule
		chain    C.Chain
		want     trafficCategory
	}{
		{"geoip cn direct", mainlandIP, accountingTestRule{C.GEOIP, "CN"}, direct, trafficCategoryMainlandDirect},
		{"geosite cn direct", mainlandIP, accountingTestRule{C.GEOSITE, "cn@ads"}, direct, trafficCategoryMainlandDirect},
		{"destination geoip evidence", &C.Metadata{
			DstIP:    netip.MustParseAddr("202.96.134.133"),
			DstGeoIP: []string{"CN"},
		}, accountingTestRule{C.DomainSuffix, "example.com"}, direct, trafficCategoryMainlandDirect},
		{"source geoip is not destination evidence", mainlandIP, accountingTestRule{C.SrcGEOIP, "CN"}, direct, trafficCategoryOtherDirect},
		{"unknown direct stays other", publicIP, accountingTestRule{C.DomainSuffix, "example.com"}, direct, trafficCategoryOtherDirect},
		{"rule set name is not trusted", publicIP, accountingTestRule{C.RuleSet, "cn"}, direct, trafficCategoryOtherDirect},
		{"proxy wins over cn rule", mainlandIP, accountingTestRule{C.GEOIP, "CN"}, proxy, trafficCategoryProxy},
		{"inner probe", &C.Metadata{
			Type:  C.INNER,
			DstIP: netip.MustParseAddr("202.96.134.133"),
		}, accountingTestRule{C.GEOIP, "CN"}, direct, trafficCategoryNone},
		{"private", accountingMetadata("192.168.1.10"), nil, direct, trafficCategoryNone},
		{"ipv4 mapped private", accountingMetadata("::ffff:192.168.1.10"), nil, direct, trafficCategoryNone},
		{"loopback", accountingMetadata("127.0.0.1"), nil, direct, trafficCategoryNone},
		{"link local", accountingMetadata("169.254.1.1"), nil, direct, trafficCategoryNone},
		{"multicast", accountingMetadata("224.0.0.1"), nil, direct, trafficCategoryNone},
		{"unspecified", accountingMetadata("0.0.0.0"), nil, direct, trafficCategoryNone},
		{"cgnat", accountingMetadata("100.64.0.1"), nil, direct, trafficCategoryNone},
		{"documentation 1", accountingMetadata("192.0.2.1"), nil, direct, trafficCategoryNone},
		{"documentation 2", accountingMetadata("198.51.100.1"), nil, direct, trafficCategoryNone},
		{"documentation 3", accountingMetadata("203.0.113.1"), nil, direct, trafficCategoryNone},
		{"benchmark", accountingMetadata("198.18.0.1"), nil, direct, trafficCategoryNone},
		{"reserved", accountingMetadata("240.0.0.1"), nil, direct, trafficCategoryNone},
		{"ipv6 documentation", accountingMetadata("2001:db8::1"), nil, direct, trafficCategoryNone},
		{"localhost host", &C.Metadata{Host: "localhost"}, nil, direct, trafficCategoryNone},
		{"mdns host", &C.Metadata{Host: "printer.local"}, nil, direct, trafficCategoryNone},
		{"public fixture", publicIP, nil, direct, trafficCategoryOtherDirect},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if got := classifyTrafficRequest(test.metadata, test.rule, test.chain); got != test.want {
				t.Fatalf("got %v, want %v", got, test.want)
			}
		})
	}
}

type accountingAddr struct{}

func (accountingAddr) Network() string { return "udp" }
func (accountingAddr) String() string  { return "in-memory" }

type accountingPacketConn struct {
	readData []byte
	written  []byte
	closed   bool
}

func (c *accountingPacketConn) Chains() C.Chain                               { return C.Chain{"DIRECT"} }
func (c *accountingPacketConn) ProviderChains() C.Chain                       { return nil }
func (c *accountingPacketConn) AppendToChains(C.ProxyAdapter)                 {}
func (c *accountingPacketConn) RemoteDestination() string                     { return "" }
func (c *accountingPacketConn) ResolveUDP(context.Context, *C.Metadata) error { return nil }

func (c *accountingPacketConn) ReadFrom(b []byte) (int, net.Addr, error) {
	n := copy(b, c.readData)
	return n, accountingAddr{}, nil
}

func (c *accountingPacketConn) WaitReadFrom() (data []byte, put func(), addr net.Addr, err error) {
	data = c.readData
	put = func() {}
	addr = accountingAddr{}
	return
}

func (c *accountingPacketConn) WriteTo(b []byte, _ net.Addr) (int, error) {
	c.written = append(c.written, b...)
	return len(b), nil
}

func (c *accountingPacketConn) Close() error                     { c.closed = true; return nil }
func (c *accountingPacketConn) LocalAddr() net.Addr              { return accountingAddr{} }
func (c *accountingPacketConn) SetDeadline(time.Time) error      { return nil }
func (c *accountingPacketConn) SetReadDeadline(time.Time) error  { return nil }
func (c *accountingPacketConn) SetWriteDeadline(time.Time) error { return nil }

func accountingSnapshot(t *testing.T) TrafficStats {
	t.Helper()
	return currentTrafficAccounting.snapshot()
}

func resetAccounting(t *testing.T) {
	t.Helper()
	currentTrafficAccounting.reset()
}

type accountingTCPTracker interface {
	statistic.Tracker
	io.Reader
	io.Writer
	UnwrapReader() (io.Reader, []N.CountFunc)
}

type accountingUDPTracker interface {
	statistic.Tracker
	ReadFrom([]byte) (int, net.Addr, error)
	WriteTo([]byte, net.Addr) (int, error)
}

func newAccountingTCPTracker(
	t *testing.T,
	metadata *C.Metadata,
	upload, download int64,
	push bool,
) (tracker accountingTCPTracker, remote net.Conn) {
	t.Helper()
	local, remote := net.Pipe()
	go func() { _, _ = io.Copy(io.Discard, remote) }()
	direct := outbound.NewDirectWithOption(outbound.DirectOption{Name: "DIRECT"})
	tracker = statistic.NewTCPTracker(
		outbound.NewConn(local, direct),
		statistic.DefaultManager,
		metadata,
		nil,
		upload,
		download,
		push,
	)
	t.Cleanup(func() {
		_ = tracker.Close()
		_ = remote.Close()
	})
	return tracker, remote
}

func newAccountingUDPTracker(t *testing.T, push bool) (accountingUDPTracker, *accountingPacketConn) {
	t.Helper()
	conn := &accountingPacketConn{readData: []byte("ping")}
	tracker := statistic.NewUDPTracker(
		conn,
		statistic.DefaultManager,
		accountingMetadata("202.96.134.133"),
		nil,
		0,
		0,
		push,
	)
	t.Cleanup(func() { _ = tracker.Close() })
	return tracker, conn
}

func TestTrafficAccountingCountsInitialAndOpenBytesOnce(t *testing.T) {
	resetAccounting(t)
	tracker, _ := newAccountingTCPTracker(t, accountingMetadata("8.8.8.8"), 3, 4, true)

	initial := accountingSnapshot(t)
	if initial.OtherDirect.Up != 3 || initial.OtherDirect.Down != 4 {
		t.Fatalf("initial totals: %+v", initial)
	}

	if _, err := tracker.Write([]byte("hello")); err != nil {
		t.Fatalf("write: %v", err)
	}
	afterWrite := accountingSnapshot(t)
	if afterWrite.OtherDirect.Up != 8 || afterWrite.OtherDirect.Down != 4 {
		t.Fatalf("after write: %+v", afterWrite)
	}
	if again := accountingSnapshot(t); again != afterWrite {
		t.Fatalf("bytes counted twice: %+v then %+v", afterWrite, again)
	}
}

func TestTrafficAccountingCountsBytesAfterClose(t *testing.T) {
	resetAccounting(t)
	tracker, _ := newAccountingTCPTracker(t, accountingMetadata("8.8.8.8"), 0, 0, true)
	_, readers := tracker.UnwrapReader()

	if err := tracker.Close(); err != nil {
		t.Fatalf("close: %v", err)
	}
	readers[0](7)

	snapshot := accountingSnapshot(t)
	if snapshot.OtherDirect.Down != 7 {
		t.Fatalf("late bytes after close: %+v", snapshot)
	}
}

func TestTrafficAccountingCountsShortUDP(t *testing.T) {
	resetAccounting(t)
	tracker, conn := newAccountingUDPTracker(t, true)
	buffer := make([]byte, 16)
	if _, _, err := tracker.ReadFrom(buffer); err != nil {
		t.Fatalf("read: %v", err)
	}
	if _, err := tracker.WriteTo([]byte("pong"), accountingAddr{}); err != nil {
		t.Fatalf("write: %v", err)
	}
	if err := tracker.Close(); err != nil {
		t.Fatalf("close: %v", err)
	}
	if string(conn.written) != "pong" {
		t.Fatalf("udp write not forwarded: %q", conn.written)
	}
	snapshot := accountingSnapshot(t)
	if snapshot.OtherDirect.Up != 4 || snapshot.OtherDirect.Down != 4 {
		t.Fatalf("udp totals: %+v", snapshot)
	}
}

func TestTrafficAccountingIgnoresADisabledPush(t *testing.T) {
	resetAccounting(t)
	tracker, _ := newAccountingTCPTracker(t, accountingMetadata("8.8.8.8"), 3, 4, false)
	if _, err := tracker.Write([]byte("hello")); err != nil {
		t.Fatalf("write: %v", err)
	}
	snapshot := accountingSnapshot(t)
	if snapshot.OtherDirect.Up != 0 || snapshot.OtherDirect.Down != 0 {
		t.Fatalf("pushToManager false was accounted: %+v", snapshot)
	}
}

func TestTrafficAccountingKeepsEpochAndNeverCountsNegative(t *testing.T) {
	resetAccounting(t)
	tracker, _ := newAccountingTCPTracker(t, accountingMetadata("8.8.8.8"), 0, 0, true)
	if _, err := tracker.Write([]byte("hello")); err != nil {
		t.Fatalf("write: %v", err)
	}
	before := accountingSnapshot(t)
	currentTrafficAccounting.reset()
	after := accountingSnapshot(t)
	if after.Epoch == before.Epoch {
		t.Fatal("reset kept the epoch")
	}
	if after.OtherDirect.Up != 0 || after.OtherDirect.Down != 0 {
		t.Fatalf("reset kept counters: %+v", after)
	}
}
