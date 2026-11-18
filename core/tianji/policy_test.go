package tianji

import (
	"context"
	"net/netip"
	"testing"
)

type fixedResolver []netip.Addr

func (r fixedResolver) LookupIP(context.Context, string) ([]netip.Addr, error) { return r, nil }

func TestNormalizeTargetBlocksSpecialAddresses(t *testing.T) {
	blocked := []string{
		"127.0.0.1:443",
		"10.2.3.4:443",
		"100.64.1.2:443",
		"169.254.169.254:80",
		"[::1]:443",
		"[fe80::1]:443",
		"[fc00::1]:443",
		"[64:ff9b::7f00:1]:443",
		"[::7f00:1]:443",
		"[fe80::1%eth0]:443",
	}
	for _, target := range blocked {
		t.Run(target, func(t *testing.T) {
			if got, err := normalizeTarget(context.Background(), target, fixedResolver{}, nil); err == nil {
				t.Fatalf("normalizeTarget(%q) = %q, want denied", target, got)
			}
		})
	}
}

func TestNormalizeTargetRejectsMixedDNSAnswers(t *testing.T) {
	resolver := fixedResolver{netip.MustParseAddr("8.8.8.8"), netip.MustParseAddr("127.0.0.1")}
	if _, err := normalizeTarget(context.Background(), "mixed.example:443", resolver, nil); err == nil {
		t.Fatal("mixed public and loopback answers were accepted")
	}
}

func TestNormalizeTargetPinsCheckedAddressAndDenyCIDR(t *testing.T) {
	resolver := fixedResolver{netip.MustParseAddr("8.8.8.8")}
	got, err := normalizeTarget(context.Background(), "gateway.example:443", resolver, []netip.Prefix{netip.MustParsePrefix("8.8.8.0/24")})
	if err == nil || got != "" {
		t.Fatalf("custom deny list was not applied: got %q, err %v", got, err)
	}
	got, err = normalizeTarget(context.Background(), "gateway.example:443", resolver, nil)
	if err != nil || got != "8.8.8.8:443" {
		t.Fatalf("resolved target = %q, err %v", got, err)
	}
}
