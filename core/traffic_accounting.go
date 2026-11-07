package core

import (
	"net/netip"
	"strings"
	"sync"
	"time"

	C "github.com/metacubex/mihomo/constant"
	"github.com/metacubex/mihomo/tunnel/statistic"
)

const trafficStatsVersion = 1

type trafficCategory uint8

const (
	trafficCategoryNone trafficCategory = iota
	trafficCategoryMainlandDirect
	trafficCategoryProxy
	trafficCategoryOtherDirect
)

type trafficBytes struct {
	up   int64
	down int64
}

type trafficTotals struct {
	mainlandDirect trafficBytes
	proxy          trafficBytes
	otherDirect    trafficBytes
}

func (t *trafficTotals) add(category trafficCategory, up, down int64) {
	var target *trafficBytes
	switch category {
	case trafficCategoryMainlandDirect:
		target = &t.mainlandDirect
	case trafficCategoryProxy:
		target = &t.proxy
	case trafficCategoryOtherDirect:
		target = &t.otherDirect
	default:
		return
	}
	if up > 0 {
		target.up += up
	}
	if down > 0 {
		target.down += down
	}
}

// The byte paths call one accumulator under a short lock, so a snapshot is a
// consistent set of six counters rather than six independent atomics.
type trafficAccumulator struct {
	mu     sync.Mutex
	totals trafficTotals
	epoch  int64
}

func newTrafficAccumulator() *trafficAccumulator {
	return &trafficAccumulator{epoch: time.Now().UnixNano()}
}

var currentTrafficAccounting = newTrafficAccumulator()

func (a *trafficAccumulator) add(category trafficCategory, up, down int64) {
	a.mu.Lock()
	defer a.mu.Unlock()
	a.totals.add(category, up, down)
}

func (a *trafficAccumulator) snapshot() TrafficStats {
	a.mu.Lock()
	defer a.mu.Unlock()
	return TrafficStats{
		Version:        trafficStatsVersion,
		Epoch:          a.epoch,
		MainlandDirect: Traffic{Up: a.totals.mainlandDirect.up, Down: a.totals.mainlandDirect.down},
		Proxy:          Traffic{Up: a.totals.proxy.up, Down: a.totals.proxy.down},
		OtherDirect:    Traffic{Up: a.totals.otherDirect.up, Down: a.totals.otherDirect.down},
	}
}

func (a *trafficAccumulator) reset() {
	a.mu.Lock()
	defer a.mu.Unlock()
	a.totals = trafficTotals{}
	a.epoch = nextTrafficAccountingEpoch(a.epoch)
}

func nextTrafficAccountingEpoch(previous int64) int64 {
	epoch := time.Now().UnixNano()
	if epoch <= previous {
		epoch = previous + 1
	}
	return epoch
}

// newTrafficAccount runs once per tracker, after its metadata and rule are
// known and before the manager publishes it. The returned closure keeps only
// the category and the accumulator, so late bytes from a closed connection
// still land exactly once and nothing has to be swept afterwards.
func newTrafficAccount(metadata *C.Metadata, rule C.Rule, chain C.Chain) statistic.TrafficAccount {
	category := classifyTrafficRequest(metadata, rule, chain)
	if category == trafficCategoryNone {
		return nil
	}
	accumulator := currentTrafficAccounting
	return func(upload, download int64) {
		accumulator.add(category, upload, download)
	}
}

func classifyTrafficRequest(metadata *C.Metadata, rule C.Rule, chain C.Chain) trafficCategory {
	if metadata != nil && metadata.Type == C.INNER {
		return trafficCategoryNone
	}
	if excludedTrafficDestination(metadata) {
		return trafficCategoryNone
	}
	if !chainIsDirect(chain) {
		return trafficCategoryProxy
	}
	if hasMainlandDestinationEvidence(metadata, rule) {
		return trafficCategoryMainlandDirect
	}
	return trafficCategoryOtherDirect
}

func chainIsDirect(chain C.Chain) bool {
	name := chain.Last()
	return strings.EqualFold(name, "DIRECT") || statistic.IsDirect(name)
}

func excludedTrafficDestination(metadata *C.Metadata) bool {
	if metadata == nil {
		return false
	}
	if metadata.DstIP.IsValid() && nonPublicAddress(metadata.DstIP) {
		return true
	}
	host := strings.ToLower(strings.TrimSuffix(metadata.Host, "."))
	switch {
	case host == "localhost":
		return true
	case strings.HasSuffix(host, ".localhost"),
		strings.HasSuffix(host, ".local"),
		strings.HasSuffix(host, ".lan"):
		return true
	}
	return false
}

var nonPublicPrefixes = []netip.Prefix{
	netip.MustParsePrefix("0.0.0.0/8"),
	netip.MustParsePrefix("100.64.0.0/10"),
	netip.MustParsePrefix("192.0.0.0/24"),
	netip.MustParsePrefix("192.0.2.0/24"),
	netip.MustParsePrefix("198.18.0.0/15"),
	netip.MustParsePrefix("198.51.100.0/24"),
	netip.MustParsePrefix("203.0.113.0/24"),
	netip.MustParsePrefix("240.0.0.0/4"),
	netip.MustParsePrefix("2001:db8::/32"),
	netip.MustParsePrefix("2001:2::/48"),
	netip.MustParsePrefix("3fff::/20"),
}

func nonPublicAddress(address netip.Addr) bool {
	address = address.Unmap()
	if address.IsPrivate() ||
		address.IsLoopback() ||
		address.IsLinkLocalUnicast() ||
		address.IsLinkLocalMulticast() ||
		address.IsInterfaceLocalMulticast() ||
		address.IsMulticast() ||
		address.IsUnspecified() {
		return true
	}
	for _, prefix := range nonPublicPrefixes {
		if prefix.Contains(address) {
			return true
		}
	}
	return false
}

func hasMainlandDestinationEvidence(metadata *C.Metadata, rule C.Rule) bool {
	if metadata != nil {
		// mihomo fills DstGeoIP from the loaded database when a GEOIP rule
		// evaluates the destination. It is actual destination evidence, not a
		// guess from the domain or the selected rule.
		for _, code := range metadata.DstGeoIP {
			if strings.EqualFold(code, "CN") {
				return true
			}
		}
	}
	if rule == nil {
		return false
	}
	switch rule.RuleType() {
	case C.GEOIP:
		return strings.EqualFold(strings.TrimSpace(rule.Payload()), "CN")
	case C.GEOSITE:
		return geoSiteIsMainland(rule.Payload())
	}
	return false
}

func geoSiteIsMainland(payload string) bool {
	payload = strings.TrimSpace(payload)
	if strings.HasPrefix(payload, "!") {
		return false
	}
	list := strings.ToLower(strings.SplitN(payload, "@", 2)[0])
	return list == "cn" || list == "china" || list == "geolocation-cn"
}
