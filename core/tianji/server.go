package tianji

import (
	"context"
	"crypto/sha256"
	"encoding/binary"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net"
	"net/netip"
	"strings"
	"sync"
	"time"

	http "github.com/metacubex/http"
	"github.com/metacubex/mihomo/constant"
	"github.com/metacubex/quic-go/http3"
)

const (
	maxTargetLength       = 512
	maxGatewayConnections = 4096
	maxUDPPayload         = 65507
	defaultUDPIdle        = 60 * time.Second
	defaultUDPFirstPacket = 10 * time.Second
	defaultSetupTimeout   = 10 * time.Second
)

type Egress interface {
	DialContext(context.Context, string, string) (net.Conn, error)
	ListenPacket(context.Context, string) (net.PacketConn, error)
}

type Authorization struct {
	TokenSHA256    string    `json:"token_sha256"`
	Outbound       string    `json:"outbound"`
	Expires        time.Time `json:"expires"`
	MaxConnections int       `json:"max_connections"`
}

type gatewayConfig struct {
	Path           string          `json:"path"`
	Authorizations []Authorization `json:"authorizations"`
	MaxConnections int             `json:"max_connections"`
	DenyCIDRs      []string        `json:"deny_cidrs,omitempty"`
}

type authorization struct {
	outbound Egress
	expires  time.Time
	limit    chan struct{}
}

type Gateway struct {
	path         string
	auth         map[[sha256.Size]byte]*authorization
	global       chan struct{}
	resolver     Resolver
	deny         []netip.Prefix
	fallback     http.Handler
	udpIdle      time.Duration
	udpFirst     time.Duration
	setupTimeout time.Duration
}

type GatewayOptions struct {
	Resolver              Resolver
	Fallback              http.Handler
	UDPIdleTimeout        time.Duration
	UDPFirstPacketTimeout time.Duration
	SetupTimeout          time.Duration
}

func LoadGateway(data []byte, egresses map[string]Egress, options GatewayOptions) (*Gateway, error) {
	decoder := json.NewDecoder(strings.NewReader(string(data)))
	decoder.DisallowUnknownFields()
	var cfg gatewayConfig
	if err := decoder.Decode(&cfg); err != nil {
		return nil, fmt.Errorf("tianji: invalid gateway config: %w", err)
	}
	if err := decoder.Decode(new(any)); err != io.EOF {
		return nil, errors.New("tianji: gateway config must contain one JSON value")
	}
	if cfg.Path == "" || cfg.Path[0] != '/' || len(cfg.Path) > 128 || strings.ContainsAny(cfg.Path, "?#\r\n") {
		return nil, errors.New("tianji: invalid gateway path")
	}
	if cfg.MaxConnections < 1 || cfg.MaxConnections > maxGatewayConnections {
		return nil, errors.New("tianji: invalid global connection limit")
	}
	if options.Resolver == nil {
		options.Resolver = systemResolver{}
	}
	if options.Fallback == nil {
		options.Fallback = http.NotFoundHandler()
	}
	if options.UDPIdleTimeout <= 0 {
		options.UDPIdleTimeout = defaultUDPIdle
	}
	if options.UDPFirstPacketTimeout <= 0 {
		options.UDPFirstPacketTimeout = defaultUDPFirstPacket
	}
	if options.SetupTimeout <= 0 {
		options.SetupTimeout = defaultSetupTimeout
	}
	g := &Gateway{path: cfg.Path, auth: make(map[[sha256.Size]byte]*authorization), global: make(chan struct{}, cfg.MaxConnections), resolver: options.Resolver, fallback: options.Fallback, udpIdle: options.UDPIdleTimeout, udpFirst: options.UDPFirstPacketTimeout, setupTimeout: options.SetupTimeout}
	for _, raw := range cfg.DenyCIDRs {
		prefix, err := netip.ParsePrefix(raw)
		if err != nil {
			return nil, errors.New("tianji: invalid deny CIDR")
		}
		g.deny = append(g.deny, prefix.Masked())
	}
	for _, entry := range cfg.Authorizations {
		encoded, err := hex.DecodeString(entry.TokenSHA256)
		if err != nil || len(encoded) != sha256.Size || entry.Outbound == "" || entry.Expires.IsZero() || !entry.Expires.After(time.Now()) || entry.MaxConnections < 1 || entry.MaxConnections > cfg.MaxConnections {
			return nil, errors.New("tianji: invalid authorization entry")
		}
		outbound := egresses[entry.Outbound]
		if outbound == nil {
			return nil, errors.New("tianji: authorization references unavailable outbound")
		}
		var digest [sha256.Size]byte
		copy(digest[:], encoded)
		if _, duplicate := g.auth[digest]; duplicate {
			return nil, errors.New("tianji: duplicate token digest")
		}
		g.auth[digest] = &authorization{outbound: outbound, expires: entry.Expires, limit: make(chan struct{}, entry.MaxConnections)}
	}
	if len(g.auth) == 0 {
		return nil, errors.New("tianji: no authorizations configured")
	}
	return g, nil
}

func (g *Gateway) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost || r.URL.Path != g.path || r.Header.Get("Tianji-Version") != Version {
		g.fallback.ServeHTTP(w, r)
		return
	}
	if r.ProtoMajor != 2 && r.ProtoMajor != 3 {
		g.fallback.ServeHTTP(w, r)
		return
	}
	network := r.Header.Get("Tianji-Network")
	if network != "tcp" && network != "udp" {
		g.fallback.ServeHTTP(w, r)
		return
	}
	var h3stream http3.HTTPStreamer
	if network == "udp" && r.ProtoMajor == 3 {
		var ok bool
		h3stream, ok = w.(http3.HTTPStreamer)
		if !ok {
			g.fallback.ServeHTTP(w, r)
			return
		}
	}
	entry, ok := g.authenticate(r.Header.Get("Authorization"))
	if !ok || !entry.expires.After(time.Now()) {
		g.fallback.ServeHTTP(w, r)
		return
	}
	select {
	case g.global <- struct{}{}:
	default:
		http.Error(w, "unavailable", http.StatusServiceUnavailable)
		return
	}
	defer func() { <-g.global }()
	select {
	case entry.limit <- struct{}{}:
	default:
		http.Error(w, "unavailable", http.StatusServiceUnavailable)
		return
	}
	defer func() { <-entry.limit }()

	sessionCtx, sessionCancel := context.WithDeadline(r.Context(), entry.expires)
	defer sessionCancel()
	setupCtx, setupCancel := context.WithTimeout(sessionCtx, g.setupTimeout)
	target, err := normalizeTarget(setupCtx, r.Header.Get("Tianji-Target"), g.resolver, g.deny)
	if err != nil {
		setupCancel()
		http.Error(w, "unavailable", http.StatusServiceUnavailable)
		return
	}
	var conn net.Conn
	var packet net.PacketConn
	if network == "tcp" {
		conn, err = entry.outbound.DialContext(setupCtx, "tcp", target)
	} else {
		packet, err = entry.outbound.ListenPacket(setupCtx, target)
	}
	setupCancel()
	if err != nil {
		http.Error(w, "unavailable", http.StatusServiceUnavailable)
		return
	}
	if conn != nil {
		defer conn.Close()
	}
	if packet != nil {
		defer packet.Close()
	}
	r = r.WithContext(sessionCtx)
	w.Header().Set("Tianji-Version", Version)
	if network == "tcp" {
		g.serveTCP(w, r, conn)
		return
	}
	switch r.ProtoMajor {
	case 2:
		g.serveH2UDP(w, r, packet)
	case 3:
		g.serveH3UDP(w, r, packet, h3stream)
	default:
		http.Error(w, "unavailable", http.StatusServiceUnavailable)
	}
}

func (g *Gateway) authenticate(header string) (*authorization, bool) {
	if !strings.HasPrefix(header, "Bearer ") {
		return nil, false
	}
	token := strings.TrimPrefix(header, "Bearer ")
	if token == "" || strings.ContainsAny(token, " \t\r\n") {
		return nil, false
	}
	digest := sha256.Sum256([]byte(token))
	entry, ok := g.auth[digest]
	return entry, ok
}

func (g *Gateway) serveTCP(w http.ResponseWriter, r *http.Request, upstream net.Conn) {
	if controller := http.NewResponseController(w); controller != nil {
		_ = controller.EnableFullDuplex()
	}
	w.WriteHeader(http.StatusOK)
	if flusher, ok := w.(http.Flusher); ok {
		flusher.Flush()
	}
	closeRaw := func() {
		if r.Context().Err() != nil {
			_ = r.Body.Close()
			setResponseWriteDeadline(w)
		}
	}
	contextCallbackDone := make(chan struct{})
	stopContext := context.AfterFunc(r.Context(), func() {
		defer close(contextCallbackDone)
		_ = upstream.Close()
		_ = r.Body.Close()
		setResponseWriteDeadline(w)
	})
	defer func() {
		if !stopContext() {
			<-contextCallbackDone
		}
	}()
	raw := newStreamConn(r.Body, flushingWriter{writer: w}, nil, closeRaw)
	transport := newTCPConn(raw)
	relay(r.Context(), transport, upstream)
	if r.Context().Err() == nil {
		_, _ = io.Copy(io.Discard, r.Body)
	}
}

func setResponseWriteDeadline(w http.ResponseWriter) {
	if controller := http.NewResponseController(w); controller != nil {
		_ = controller.SetWriteDeadline(time.Now())
	}
}

type flushingWriter struct{ writer http.ResponseWriter }

func (w flushingWriter) Write(p []byte) (int, error) {
	n, err := w.writer.Write(p)
	if n > 0 {
		if flusher, ok := w.writer.(http.Flusher); ok {
			flusher.Flush()
		}
	}
	return n, err
}

func (g *Gateway) serveH2UDP(w http.ResponseWriter, r *http.Request, upstream net.PacketConn) {
	if controller := http.NewResponseController(w); controller != nil {
		_ = controller.EnableFullDuplex()
	}
	w.WriteHeader(http.StatusOK)
	if flusher, ok := w.(http.Flusher); ok {
		flusher.Flush()
	}
	ctx, cancel := context.WithCancel(r.Context())
	defer cancel()
	activity := newUDPActivity(g.udpFirst, g.udpIdle)
	var workers sync.WaitGroup
	workers.Add(2)
	done := make(chan struct{}, 2)
	go func() {
		defer workers.Done()
		defer func() { done <- struct{}{} }()
		buf := make([]byte, maxUDPPayload+1)
		for {
			n, addr, err := upstream.ReadFrom(buf)
			if err != nil {
				return
			}
			activity.touch()
			frame, err := encodePacket(addr.String(), buf[:n])
			if err != nil || len(frame) > maxUDPPayload+maxTargetLength+2 {
				return
			}
			var size [4]byte
			binary.BigEndian.PutUint32(size[:], uint32(len(frame)))
			if writeAll(w, size[:]) != nil || writeAll(w, frame) != nil {
				return
			}
			if flusher, ok := w.(http.Flusher); ok {
				flusher.Flush()
			}
		}
	}()
	go func() {
		defer workers.Done()
		defer func() { done <- struct{}{} }()
		for {
			var size [4]byte
			if _, err := io.ReadFull(r.Body, size[:]); err != nil {
				return
			}
			n := binary.BigEndian.Uint32(size[:])
			if n < 3 || n > maxUDPPayload+maxTargetLength+2 {
				return
			}
			frame := make([]byte, n)
			if _, err := io.ReadFull(r.Body, frame); err != nil {
				return
			}
			addr, payload, err := decodePacket(frame)
			if err != nil {
				return
			}
			resolved, err := normalizeTarget(ctx, addr, g.resolver, g.deny)
			if err != nil {
				return
			}
			if _, err := upstream.WriteTo(payload, packetAddr(resolved)); err != nil {
				return
			}
			activity.touch()
		}
	}()
	select {
	case <-done:
	case <-activity.expired:
	case <-ctx.Done():
	}
	cancel()
	_ = r.Body.Close()
	_ = upstream.Close()
	workers.Wait()
	activity.stop()
}

func (g *Gateway) serveH3UDP(w http.ResponseWriter, r *http.Request, upstream net.PacketConn, streamer http3.HTTPStreamer) {
	w.WriteHeader(http.StatusOK)
	stream := streamer.HTTPStream()
	ctx, cancel := context.WithCancel(r.Context())
	defer cancel()
	activity := newUDPActivity(g.udpFirst, g.udpIdle)
	var workers sync.WaitGroup
	workers.Add(3)
	done := make(chan struct{}, 2)
	assembler := newServerAssembler()
	go func() {
		defer workers.Done()
		defer func() { done <- struct{}{} }()
		for {
			frame, err := stream.ReceiveDatagram(ctx)
			if err != nil {
				return
			}
			packet := assembler.add(frame)
			if packet == nil {
				continue
			}
			addr, payload, err := decodePacket(packet)
			if err != nil {
				return
			}
			resolved, err := normalizeTarget(ctx, addr, g.resolver, g.deny)
			if err != nil {
				return
			}
			if _, err := upstream.WriteTo(payload, packetAddr(resolved)); err != nil {
				return
			}
			activity.touch()
		}
	}()
	go func() {
		defer workers.Done()
		defer func() { done <- struct{}{} }()
		buf := make([]byte, maxUDPPayload+1)
		var sequence uint32
		for {
			n, addr, err := upstream.ReadFrom(buf)
			if err != nil {
				return
			}
			activity.touch()
			packet, err := encodePacket(addr.String(), buf[:n])
			if err != nil {
				return
			}
			sequence++
			for _, fragment := range fragment(sequence, packet) {
				if err := stream.SendDatagram(fragment); err != nil {
					return
				}
			}
		}
	}()
	go func() {
		defer workers.Done()
		_, _ = io.Copy(io.Discard, r.Body)
		cancel()
	}()
	select {
	case <-done:
	case <-activity.expired:
	case <-ctx.Done():
	}
	cancel()
	_ = upstream.Close()
	_ = r.Body.Close()
	stream.CancelRead(0)
	stream.CancelWrite(0)
	_ = stream.Close()
	workers.Wait()
	activity.stop()
}

type udpActivity struct {
	expired    chan struct{}
	mu         sync.Mutex
	timer      *time.Timer
	first      time.Duration
	idle       time.Duration
	seen       bool
	closed     bool
	generation uint64
}

func newUDPActivity(first, idle time.Duration) *udpActivity {
	a := &udpActivity{expired: make(chan struct{}), first: first, idle: idle}
	a.reset(first)
	return a
}

func (a *udpActivity) touch() {
	a.mu.Lock()
	defer a.mu.Unlock()
	if a.closed {
		return
	}
	a.seen = true
	a.resetLocked(a.idle)
}

func (a *udpActivity) reset(d time.Duration) {
	a.mu.Lock()
	defer a.mu.Unlock()
	a.resetLocked(d)
}

func (a *udpActivity) resetLocked(d time.Duration) {
	a.generation++
	generation := a.generation
	if a.timer != nil {
		a.timer.Stop()
	}
	a.timer = time.AfterFunc(d, func() {
		a.mu.Lock()
		if !a.closed && generation == a.generation {
			a.closed = true
			close(a.expired)
		}
		a.mu.Unlock()
	})
}

func (a *udpActivity) stop() {
	a.mu.Lock()
	a.closed = true
	if a.timer != nil {
		a.timer.Stop()
	}
	a.mu.Unlock()
}

type fragmentSet struct {
	parts   [][]byte
	bytes   int
	created time.Time
}

type serverAssembler struct {
	mu        sync.Mutex
	fragments map[uint32]*fragmentSet
}

func newServerAssembler() *serverAssembler {
	return &serverAssembler{fragments: make(map[uint32]*fragmentSet)}
}

func (a *serverAssembler) add(frame []byte) []byte {
	if len(frame) <= 8 || len(frame) > fragmentSize+8 {
		return nil
	}
	id := binary.BigEndian.Uint32(frame)
	index := int(binary.BigEndian.Uint16(frame[4:]))
	total := int(binary.BigEndian.Uint16(frame[6:]))
	if total < 1 || total > (maxUDPPayload+maxTargetLength+2+fragmentSize-1)/fragmentSize || index >= total || (index < total-1 && len(frame) != fragmentSize+8) {
		return nil
	}
	a.mu.Lock()
	defer a.mu.Unlock()
	now := time.Now()
	for key, value := range a.fragments {
		if now.Sub(value.created) >= 5*time.Second {
			delete(a.fragments, key)
		}
	}
	set := a.fragments[id]
	if set == nil {
		if len(a.fragments) >= 32 {
			return nil
		}
		set = &fragmentSet{parts: make([][]byte, total), created: now}
		a.fragments[id] = set
	} else if len(set.parts) != total {
		delete(a.fragments, id)
		return nil
	}
	if set.parts[index] == nil {
		set.parts[index] = append([]byte(nil), frame[8:]...)
		set.bytes += len(frame) - 8
	}
	if set.bytes > maxUDPPayload+maxTargetLength+2 {
		delete(a.fragments, id)
		return nil
	}
	for _, part := range set.parts {
		if part == nil {
			return nil
		}
	}
	delete(a.fragments, id)
	packet := make([]byte, 0, set.bytes)
	for _, part := range set.parts {
		packet = append(packet, part...)
	}
	return packet
}

func decodePacket(buf []byte) (string, []byte, error) {
	if len(buf) < 3 {
		return "", nil, errors.New("short datagram")
	}
	n := int(binary.BigEndian.Uint16(buf))
	if n < 1 || n > maxTargetLength || 2+n > len(buf) || len(buf)-2-n > maxUDPPayload {
		return "", nil, errors.New("invalid datagram")
	}
	addr := string(buf[2 : 2+n])
	if _, _, err := net.SplitHostPort(addr); err != nil {
		return "", nil, errors.New("invalid datagram address")
	}
	return addr, buf[2+n:], nil
}

func encodePacket(addr string, data []byte) ([]byte, error) {
	if len(addr) == 0 || len(addr) > maxTargetLength || len(data) > maxUDPPayload {
		return nil, errors.New("oversized datagram")
	}
	if _, _, err := net.SplitHostPort(addr); err != nil {
		return nil, errors.New("invalid datagram address")
	}
	buf := make([]byte, 2+len(addr)+len(data))
	binary.BigEndian.PutUint16(buf, uint16(len(addr)))
	copy(buf[2:], addr)
	copy(buf[2+len(addr):], data)
	return buf, nil
}

func fragment(id uint32, packet []byte) [][]byte {
	count := (len(packet) + fragmentSize - 1) / fragmentSize
	fragments := make([][]byte, 0, count)
	for index := 0; index < count; index++ {
		start := index * fragmentSize
		end := min(start+fragmentSize, len(packet))
		frame := make([]byte, 8+end-start)
		binary.BigEndian.PutUint32(frame, id)
		binary.BigEndian.PutUint16(frame[4:], uint16(index))
		binary.BigEndian.PutUint16(frame[6:], uint16(count))
		copy(frame[8:], packet[start:end])
		fragments = append(fragments, frame)
	}
	return fragments
}

type ProxyEgress struct {
	Proxy constant.Proxy
}

func NewProxyEgress(proxy constant.Proxy) (Egress, error) {
	if proxy == nil || !proxy.SupportUDP() {
		return nil, errors.New("tianji: unavailable or UDP-disabled mihomo outbound")
	}
	switch proxy.Type() {
	case constant.Vless, constant.Trojan, constant.Hysteria2, constant.AnyTLS:
		return &ProxyEgress{Proxy: proxy}, nil
	default:
		return nil, errors.New("tianji: gateway outbound must be a supported concrete mihomo proxy")
	}
}

func (e *ProxyEgress) DialContext(ctx context.Context, network, address string) (net.Conn, error) {
	if network != "tcp" {
		return nil, errors.New("tianji: invalid TCP network")
	}
	metadata, err := e.metadata(constant.TCP, address)
	if err != nil {
		return nil, err
	}
	return e.Proxy.DialContext(ctx, metadata)
}

func (e *ProxyEgress) ListenPacket(ctx context.Context, address string) (net.PacketConn, error) {
	metadata, err := e.metadata(constant.UDP, address)
	if err != nil {
		return nil, err
	}
	return e.Proxy.ListenPacketContext(ctx, metadata)
}

func (e *ProxyEgress) metadata(network constant.NetWork, address string) (*constant.Metadata, error) {
	metadata := &constant.Metadata{NetWork: network, Type: constant.INNER}
	if err := metadata.SetRemoteAddress(address); err != nil || !metadata.DstIP.IsValid() {
		return nil, errors.New("tianji: target was not pinned to an IP")
	}
	return metadata, nil
}

var _ http.Handler = (*Gateway)(nil)
