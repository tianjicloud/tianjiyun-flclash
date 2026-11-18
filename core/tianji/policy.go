package tianji

import (
	"context"
	"errors"
	"net"
	"net/netip"
	"strconv"
	"strings"

	"golang.org/x/net/idna"
)

type Resolver interface {
	LookupIP(context.Context, string) ([]netip.Addr, error)
}

type systemResolver struct{}

func (systemResolver) LookupIP(ctx context.Context, host string) ([]netip.Addr, error) {
	return net.DefaultResolver.LookupNetIP(ctx, "ip", host)
}

var blockedTargets = []netip.Prefix{
	netip.MustParsePrefix("0.0.0.0/8"),
	netip.MustParsePrefix("10.0.0.0/8"),
	netip.MustParsePrefix("100.64.0.0/10"),
	netip.MustParsePrefix("127.0.0.0/8"),
	netip.MustParsePrefix("169.254.0.0/16"),
	netip.MustParsePrefix("172.16.0.0/12"),
	netip.MustParsePrefix("192.0.0.0/24"),
	netip.MustParsePrefix("192.0.2.0/24"),
	netip.MustParsePrefix("192.88.99.0/24"),
	netip.MustParsePrefix("192.168.0.0/16"),
	netip.MustParsePrefix("198.18.0.0/15"),
	netip.MustParsePrefix("198.51.100.0/24"),
	netip.MustParsePrefix("203.0.113.0/24"),
	netip.MustParsePrefix("224.0.0.0/4"),
	netip.MustParsePrefix("240.0.0.0/4"),
	netip.MustParsePrefix("::/128"),
	netip.MustParsePrefix("::/96"),
	netip.MustParsePrefix("::1/128"),
	netip.MustParsePrefix("::ffff:0:0/96"),
	netip.MustParsePrefix("64:ff9b::/96"),
	netip.MustParsePrefix("64:ff9b:1::/48"),
	netip.MustParsePrefix("100::/64"),
	netip.MustParsePrefix("2001::/23"),
	netip.MustParsePrefix("2001:db8::/32"),
	netip.MustParsePrefix("2002::/16"),
	netip.MustParsePrefix("fc00::/7"),
	netip.MustParsePrefix("fe80::/10"),
	netip.MustParsePrefix("ff00::/8"),
}

func normalizeTarget(ctx context.Context, raw string, resolver Resolver, deny []netip.Prefix) (string, error) {
	if len(raw) == 0 || len(raw) > maxTargetLength || strings.ContainsAny(raw, "\r\n\x00") {
		return "", errors.New("invalid target")
	}
	host, portText, err := net.SplitHostPort(raw)
	if err != nil || host == "" {
		return "", errors.New("invalid target")
	}
	port, err := strconv.Atoi(portText)
	if err != nil || port < 1 || port > 65535 {
		return "", errors.New("invalid target port")
	}
	ips := make([]netip.Addr, 0, 4)
	if ip, parseErr := netip.ParseAddr(host); parseErr == nil {
		if ip.Zone() != "" {
			return "", errors.New("invalid target zone")
		}
		ips = append(ips, ip.Unmap())
	} else {
		ascii, idnaErr := idna.Lookup.ToASCII(host)
		if idnaErr != nil || len(ascii) > 253 || strings.HasSuffix(ascii, ".") || strings.Contains(ascii, "..") {
			return "", errors.New("invalid target name")
		}
		ips, err = resolver.LookupIP(ctx, ascii)
		if err != nil || len(ips) == 0 {
			return "", errors.New("target resolution failed")
		}
	}
	for i, ip := range ips {
		if ip.Zone() != "" {
			return "", errors.New("invalid target zone")
		}
		ip = ip.Unmap()
		if !allowedPublicIP(ip, deny) {
			return "", errors.New("target denied")
		}
		ips[i] = ip
	}
	return net.JoinHostPort(ips[0].String(), strconv.Itoa(port)), nil
}

func allowedPublicIP(ip netip.Addr, deny []netip.Prefix) bool {
	if !ip.IsValid() || !ip.IsGlobalUnicast() || ip.IsPrivate() || ip.IsLoopback() || ip.IsLinkLocalUnicast() || ip.IsLinkLocalMulticast() || ip.IsMulticast() || ip.IsUnspecified() {
		return false
	}
	for _, prefix := range blockedTargets {
		if prefix.Contains(ip) {
			return false
		}
	}
	for _, prefix := range deny {
		if prefix.Contains(ip) {
			return false
		}
	}
	return true
}
