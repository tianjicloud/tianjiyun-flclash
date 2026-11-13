package core

import (
	"strings"

	"github.com/metacubex/mihomo/component/resolver"
	C "github.com/metacubex/mihomo/constant"
	"github.com/metacubex/mihomo/dns"
	"github.com/metacubex/mihomo/tunnel"
	"github.com/metacubex/mihomo/tunnel/statistic"
)

// A rule usually targets a group such as a direct group, so the verdict follows
// each group's current pick down to the adapter that carries the traffic.
func resolveRoute(target string, metadata *C.Metadata) string {
	proxies := tunnel.Proxies()
	proxy := proxies[target]
	for depth := 0; proxy != nil && depth < 16; depth++ {
		switch proxy.Type() {
		case C.Direct:
			return "direct"
		case C.Reject, C.RejectDrop:
			return "reject"
		}
		next := proxy.Unwrap(metadata, false)
		if next == nil {
			break
		}
		proxy = next
	}
	switch strings.ToUpper(target) {
	case "DIRECT":
		return "direct"
	case "REJECT", "REJECT-DROP":
		return "reject"
	}
	return "proxy"
}

func handleDnsRoute(params DomainParams) DnsRoute {
	configMu.Lock()
	defer configMu.Unlock()
	metadata := &C.Metadata{Host: strings.TrimSuffix(params.Domain, ".")}
	for _, rule := range tunnel.Rules() {
		if matched, target := rule.Match(metadata, C.RuleMatchHelper{}); matched {
			return DnsRoute{Route: resolveRoute(target, metadata), Target: target, Rule: rule.RuleType().String() + "," + rule.Payload()}
		}
	}
	return DnsRoute{Route: "proxy", Target: "MATCH", Rule: "MATCH"}
}

func handleGetTraffic(params TrafficParams) Traffic {
	up, down := statistic.DefaultManager.NowTraffic(params.OnlyProxy)
	return Traffic{Up: up, Down: down}
}

func handleGetTotalTraffic(params TrafficParams) Traffic {
	up, down := statistic.DefaultManager.TotalTraffic(params.OnlyProxy)
	return Traffic{Up: up, Down: down}
}

func handleGetTrafficStats() TrafficStats {
	return currentTrafficAccounting.snapshot()
}

// traffic.reset clears the UI's speed and request totals only. The client
// accounting snapshot stays cumulative for the Core process, so stopping and
// starting a run cannot discard savings the host has not persisted yet.
func handleResetTraffic() {
	statistic.DefaultManager.ResetStatistic()
}

func handleGetConnections() *statistic.Snapshot {
	return statistic.DefaultManager.Snapshot()
}

func handleGetConnectionCount() int {
	count := 0
	statistic.DefaultManager.Range(func(statistic.Tracker) bool {
		count++
		return true
	})
	return count
}

func handleCloseConnections() {
	statistic.DefaultManager.Range(func(c statistic.Tracker) bool {
		_ = c.Close()
		return true
	})
}

func handleResetConnections() {
	resolver.ResetConnection()
}

// A network change clears rather than waits out the TTLs: mihomo serves an
// expired entry once more before it refreshes it.
func handleClearDnsCache() {
	configMu.Lock()
	defer configMu.Unlock()
	dns.ClearAll()
}

// handleNetworkChanged is how the desktop host reports a new network, which
// Android's NetworkObserver reports through handleResetNetwork.
func handleNetworkChanged() {
	handleClearDnsCache()
}

// A connection that went out over a network the device has left hangs until
// TCP gives up on it, and so do the DNS clients' pooled connections.
func handleResetNetwork() {
	handleCloseConnections()
	handleNetworkChanged()
}

// A connection that is already gone is closed as far as the host is concerned.
func handleCloseConnection(params IDParams) error {
	if c := statistic.DefaultManager.Get(params.ID); c != nil {
		_ = c.Close()
	}
	return nil
}
