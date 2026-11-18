package core

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"math"
	"net"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/metacubex/mihomo/adapter/outbound"
	"github.com/metacubex/mihomo/adapter/outboundgroup"
	"github.com/metacubex/mihomo/common/utils"
	C "github.com/metacubex/mihomo/constant"
	P "github.com/metacubex/mihomo/constant/provider"
)

const entryPoolProbeURL = "http://probe.invalid/"

type entryPoolFakeProxy struct {
	C.Proxy
	mu        sync.Mutex
	name      string
	proxyType C.AdapterType
	delay     uint16
	alive     bool
	dialErr   error
	dials     int
	conns     []*entryPoolFakeConn
}

func newEntryPoolFakeProxy(name string, delay uint16, alive bool) *entryPoolFakeProxy {
	return &entryPoolFakeProxy{name: name, proxyType: C.Shadowsocks, delay: delay, alive: alive}
}

func (p *entryPoolFakeProxy) Adapter() C.ProxyAdapter          { return p }
func (p *entryPoolFakeProxy) Name() string                     { return p.name }
func (p *entryPoolFakeProxy) Type() C.AdapterType              { return p.proxyType }
func (p *entryPoolFakeProxy) Addr() string                     { return p.name + ".invalid:443" }
func (p *entryPoolFakeProxy) SupportUDP() bool                 { return true }
func (p *entryPoolFakeProxy) SupportUOT() bool                 { return false }
func (p *entryPoolFakeProxy) ProxyInfo() C.ProxyInfo           { return C.ProxyInfo{} }
func (p *entryPoolFakeProxy) IsL3Protocol(*C.Metadata) bool    { return false }
func (p *entryPoolFakeProxy) Unwrap(*C.Metadata, bool) C.Proxy { return p }
func (p *entryPoolFakeProxy) Close() error                     { return nil }
func (p *entryPoolFakeProxy) MarshalJSON() ([]byte, error) {
	return json.Marshal(map[string]string{"name": p.name})
}
func (p *entryPoolFakeProxy) ListenPacketContext(context.Context, *C.Metadata) (C.PacketConn, error) {
	return nil, C.ErrNotSupport
}
func (p *entryPoolFakeProxy) AliveForTestUrl(string) bool {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.alive
}
func (p *entryPoolFakeProxy) DelayHistory() []C.DelayHistory               { return nil }
func (p *entryPoolFakeProxy) ExtraDelayHistories() map[string]C.ProxyState { return nil }
func (p *entryPoolFakeProxy) LastDelayForTestUrl(string) uint16 {
	p.mu.Lock()
	defer p.mu.Unlock()
	if !p.alive {
		return math.MaxUint16
	}
	return p.delay
}
func (p *entryPoolFakeProxy) URLTest(context.Context, string, utils.IntRanges[uint16]) (uint16, error) {
	p.mu.Lock()
	defer p.mu.Unlock()
	if p.dialErr != nil {
		p.alive = false
		return 0, p.dialErr
	}
	if !p.alive {
		return 0, errors.New("candidate is unhealthy")
	}
	return p.delay, nil
}
func (p *entryPoolFakeProxy) DialContext(_ context.Context, _ *C.Metadata) (C.Conn, error) {
	p.mu.Lock()
	defer p.mu.Unlock()
	p.dials++
	if !p.alive {
		return nil, errors.New("candidate is unhealthy")
	}
	if p.dialErr != nil {
		return nil, p.dialErr
	}
	conn := &entryPoolFakeConn{closed: make(chan struct{})}
	p.conns = append(p.conns, conn)
	return outbound.NewConn(conn, p), nil
}
func (p *entryPoolFakeProxy) setState(alive bool, delay uint16) {
	p.mu.Lock()
	p.alive = alive
	p.delay = delay
	p.mu.Unlock()
}
func (p *entryPoolFakeProxy) setDialError(err error) {
	p.mu.Lock()
	p.dialErr = err
	p.mu.Unlock()
}
func (p *entryPoolFakeProxy) setType(proxyType C.AdapterType) { p.proxyType = proxyType }
func (p *entryPoolFakeProxy) dialCount() int {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.dials
}
func (p *entryPoolFakeProxy) lastConn() *entryPoolFakeConn {
	p.mu.Lock()
	defer p.mu.Unlock()
	return p.conns[len(p.conns)-1]
}

type entryPoolFakeConn struct {
	closed chan struct{}
	once   sync.Once
	closes atomic.Int32
}

func (c *entryPoolFakeConn) Read([]byte) (int, error) {
	<-c.closed
	return 0, io.EOF
}
func (c *entryPoolFakeConn) Write(p []byte) (int, error) { return len(p), nil }
func (c *entryPoolFakeConn) Close() error {
	c.once.Do(func() {
		c.closes.Add(1)
		close(c.closed)
	})
	return nil
}
func (*entryPoolFakeConn) LocalAddr() net.Addr              { return entryPoolAddr("local") }
func (*entryPoolFakeConn) RemoteAddr() net.Addr             { return entryPoolAddr("remote") }
func (*entryPoolFakeConn) SetDeadline(time.Time) error      { return nil }
func (*entryPoolFakeConn) SetReadDeadline(time.Time) error  { return nil }
func (*entryPoolFakeConn) SetWriteDeadline(time.Time) error { return nil }
func (c *entryPoolFakeConn) closeCount() int32              { return c.closes.Load() }

type entryPoolAddr string

func (a entryPoolAddr) Network() string { return "entry-pool-test" }
func (a entryPoolAddr) String() string  { return string(a) }

type entryPoolFakeProvider struct {
	P.ProxyProvider
	name          string
	proxies       []C.Proxy
	healthChecked chan struct{}
}

func newEntryPoolFakeProvider(name string, proxies ...C.Proxy) *entryPoolFakeProvider {
	return &entryPoolFakeProvider{name: name, proxies: proxies, healthChecked: make(chan struct{}, 8)}
}
func (p *entryPoolFakeProvider) Name() string               { return p.name }
func (p *entryPoolFakeProvider) VehicleType() P.VehicleType { return P.File }
func (p *entryPoolFakeProvider) Type() P.ProviderType       { return P.Proxy }
func (p *entryPoolFakeProvider) Proxies() []C.Proxy         { return p.proxies }
func (p *entryPoolFakeProvider) Count() int                 { return len(p.proxies) }
func (p *entryPoolFakeProvider) Version() uint32            { return 1 }
func (p *entryPoolFakeProvider) Touch()                     {}
func (p *entryPoolFakeProvider) HealthCheck() {
	for _, proxy := range p.proxies {
		_, _ = proxy.URLTest(context.Background(), entryPoolProbeURL, nil)
	}
	p.healthChecked <- struct{}{}
}
func (p *entryPoolFakeProvider) RegisterHealthCheckTask(string, utils.IntRanges[uint16], string, uint) {
}
func (p *entryPoolFakeProvider) HealthCheckURL() string { return entryPoolProbeURL }
func (*entryPoolFakeProvider) Initial() error           { return nil }
func (*entryPoolFakeProvider) Update() error            { return nil }

func newEntryPoolURLTest(t *testing.T, tolerance uint16, fallback C.Proxy, proxies ...C.Proxy) (*outboundgroup.URLTest, *entryPoolFakeProvider) {
	t.Helper()
	provider := newEntryPoolFakeProvider("entry-candidates", proxies...)
	group, err := outboundgroup.NewURLTest(
		outboundgroup.GroupCommonOption{Name: "entry", URL: entryPoolProbeURL},
		outboundgroup.URLTestOption{Tolerance: tolerance},
		fallback,
		[]P.ProxyProvider{provider},
	)
	if err != nil {
		t.Fatal(err)
	}
	return group, provider
}

func TestEntryPoolURLTestChoosesLowestMeasuredLatency(t *testing.T) {
	first := newEntryPoolFakeProxy("candidate-a", 60, true)
	second := newEntryPoolFakeProxy("candidate-b", 18, true)
	group, _ := newEntryPoolURLTest(t, 0, newEntryPoolFakeProxy("REJECT", 0, false), first, second)

	if got := group.Now(); got != second.Name() {
		t.Fatalf("URLTest selected %q, want lowest-delay candidate %q", got, second.Name())
	}
}

func TestEntryPoolURLTestToleranceKeepsFirstMemberOnSmallImprovement(t *testing.T) {
	first := newEntryPoolFakeProxy("candidate-a", 30, true)
	second := newEntryPoolFakeProxy("candidate-b", 80, true)
	group, _ := newEntryPoolURLTest(t, 10, newEntryPoolFakeProxy("REJECT", 0, false), first, second)
	if got := group.Now(); got != first.Name() {
		t.Fatalf("initial URLTest selection = %q, want %q", got, first.Name())
	}

	first.setState(true, 30)
	second.setState(true, 25)
	group.ForceSet("")
	if got := group.Now(); got != first.Name() {
		t.Fatalf("URLTest switched to %q for a %d ms improvement within tolerance", got, 5)
	}
}

func TestEntryPoolURLTestToleranceKeepsLaterMemberOnSmallImprovement(t *testing.T) {
	first := newEntryPoolFakeProxy("candidate-a", 90, true)
	second := newEntryPoolFakeProxy("candidate-b", 25, true)
	group, _ := newEntryPoolURLTest(t, 10, newEntryPoolFakeProxy("REJECT", 0, false), first, second)
	if got := group.Now(); got != second.Name() {
		t.Fatalf("initial URLTest selection = %q, want %q", got, second.Name())
	}

	first.setState(true, 20)
	second.setState(true, 25)
	group.ForceSet("")
	if got := group.Now(); got != second.Name() {
		t.Fatalf("URLTest switched to %q for a %d ms improvement within tolerance", got, 5)
	}
}

func TestEntryPoolURLTestToleranceDoesNotOverflowUint16(t *testing.T) {
	first := newEntryPoolFakeProxy("candidate-a", 65000, false)
	second := newEntryPoolFakeProxy("candidate-b", 65500, true)
	group, _ := newEntryPoolURLTest(t, 1000, newEntryPoolFakeProxy("REJECT", 0, false), first, second)
	if got := group.Now(); got != second.Name() {
		t.Fatalf("initial URLTest selection = %q, want live member %q", got, second.Name())
	}

	first.setState(true, 65000)
	group.ForceSet("")
	if got := group.Now(); got != second.Name() {
		t.Fatalf("URLTest switched to %q after uint16 tolerance overflow", got)
	}
}

func TestEntryPoolDialFailureHealthChecksAndMovesOnlyNewConnections(t *testing.T) {
	first := newEntryPoolFakeProxy("candidate-a", 15, true)
	second := newEntryPoolFakeProxy("candidate-b", 40, true)
	fallback := newEntryPoolFakeProxy("REJECT", 0, false)
	group, provider := newEntryPoolURLTest(t, 0, fallback, first, second)
	if got := group.Now(); got != first.Name() {
		t.Fatalf("initial URLTest selection = %q, want %q", got, first.Name())
	}

	oldConn, err := group.DialContext(context.Background(), &C.Metadata{})
	if err != nil {
		t.Fatalf("initial DialContext: %v", err)
	}
	defer oldConn.Close()
	oldRaw := first.lastConn()

	first.setDialError(errors.New("connection refused"))
	if _, err = group.DialContext(context.Background(), &C.Metadata{}); err == nil {
		t.Fatal("failed candidate unexpectedly established a connection")
	}
	select {
	case <-provider.healthChecked:
	case <-time.After(time.Second):
		t.Fatal("connection refusal did not trigger a provider health check")
	}

	newConn := waitEntryPoolDial(t, group, second)
	defer newConn.Close()
	if got := second.dialCount(); got != 1 {
		t.Fatalf("healthy candidate dial count = %d, want 1", got)
	}
	if got := oldRaw.closeCount(); got != 0 {
		t.Fatalf("switching candidates closed an existing connection %d times", got)
	}
	if fallback.dialCount() != 0 {
		t.Fatal("candidate failover dialed the empty fallback")
	}
}

func TestEntryPoolAllUnhealthyCandidatesNeverDialDirectFallback(t *testing.T) {
	first := newEntryPoolFakeProxy("candidate-a", 0, false)
	second := newEntryPoolFakeProxy("candidate-b", 0, false)
	direct := newEntryPoolFakeProxy("DIRECT", 0, true)
	direct.setType(C.Direct)
	group, _ := newEntryPoolURLTest(t, 0, direct, first, second)
	if _, err := group.DialContext(context.Background(), &C.Metadata{}); err == nil {
		t.Fatal("all-unhealthy URLTest candidates unexpectedly connected")
	}
	if direct.dialCount() != 0 {
		t.Fatal("all-unhealthy candidate selection reached the direct fallback")
	}
}

func TestEntryPoolEmptyGroupUsesRejectFallback(t *testing.T) {
	reject := newEntryPoolFakeProxy("REJECT", 0, false)
	reject.setType(C.Reject)
	reject.setDialError(errors.New("rejected"))
	group, _ := newEntryPoolURLTest(t, 0, reject)
	if _, err := group.DialContext(context.Background(), &C.Metadata{}); err == nil {
		t.Fatal("empty URLTest group unexpectedly connected")
	}
	if reject.dialCount() != 1 {
		t.Fatalf("reject fallback dial count = %d, want 1", reject.dialCount())
	}
}

func waitEntryPoolDial(t *testing.T, group *outboundgroup.URLTest, want *entryPoolFakeProxy) C.Conn {
	t.Helper()
	deadline := time.Now().Add(time.Second)
	for time.Now().Before(deadline) {
		conn, err := group.DialContext(context.Background(), &C.Metadata{})
		if err == nil {
			if want.dialCount() > 0 {
				return conn
			}
			_ = conn.Close()
		}
		time.Sleep(time.Millisecond)
	}
	t.Fatalf("URLTest did not start dialing %q after health check", want.Name())
	return nil
}

var _ C.Proxy = (*entryPoolFakeProxy)(nil)
var _ P.ProxyProvider = (*entryPoolFakeProvider)(nil)
var _ net.Conn = (*entryPoolFakeConn)(nil)
