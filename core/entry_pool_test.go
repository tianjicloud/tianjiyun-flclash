package core

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"reflect"
	"strings"
	"testing"

	"github.com/metacubex/mihomo/component/age"
	"go.yaml.in/yaml/v3"
)

const entryPoolProfile = "proxies:\n" +
	"  - name: edge\n" +
	"    type: vless\n" +
	"    server: gateway.example\n" +
	"    port: 443\n" +
	"    uuid: 2a70e3a9-b4ce-4f20-908d-e99950a0a611\n" +
	"    tls: true\n" +
	"    x-tianji-entry-pool:\n" +
	"      entries:\n" +
	"        - {id: east, server: 192.0.2.10}\n" +
	"        - {id: west, server: 2001:db8::10, port: 8443}\n" +
	"      url: https://probe.example/generate_204\n" +
	"proxy-groups:\n" +
	"  - {name: Select, type: select, proxies: [edge]}\n" +
	"rules:\n" +
	"  - MATCH,edge\n"

func TestExpandTianjiEntryPoolsPreservesLogicalProxyAndRules(t *testing.T) {
	got, changed, err := expandTianjiEntryPools([]byte(entryPoolProfile))
	if err != nil || !changed {
		t.Fatalf("expansion changed=%t err=%v", changed, err)
	}
	var document map[string]any
	if err := yaml.Unmarshal(got, &document); err != nil {
		t.Fatal(err)
	}
	proxies := document["proxies"].([]any)
	if len(proxies) != 2 {
		t.Fatalf("proxy count = %d, want 2", len(proxies))
	}
	first, second := proxies[0].(map[string]any), proxies[1].(map[string]any)
	if first["name"] != "edge / east" || first["server"] != "192.0.2.10" || first["port"] != 443 {
		t.Errorf("first candidate = %#v", first)
	}
	if second["name"] != "edge / west" || second["server"] != "2001:db8::10" || second["port"] != 8443 {
		t.Errorf("second candidate = %#v", second)
	}
	for _, proxy := range proxies {
		candidate := proxy.(map[string]any)
		if candidate["servername"] != "gateway.example" ||
			candidate["uuid"] != "2a70e3a9-b4ce-4f20-908d-e99950a0a611" ||
			candidate["tls"] != true {
			t.Errorf("candidate lost TLS identity or authentication: %#v", candidate)
		}
		if _, exists := candidate[entryPoolKey]; exists {
			t.Error("expanded candidate retained the extension field")
		}
	}
	groups := document["proxy-groups"].([]any)
	if groups[0].(map[string]any)["proxies"].([]any)[0] != "edge" {
		t.Errorf("existing proxy group changed: %#v", groups[0])
	}
	automatic := groups[1].(map[string]any)
	if automatic["name"] != "edge" || automatic["type"] != "url-test" ||
		automatic["lazy"] != true || automatic["max-failed-times"] != 2 ||
		automatic["empty-fallback"] != "REJECT" || automatic["expected-status"] != "204" {
		t.Errorf("automatic group = %#v", automatic)
	}
	if automatic["url"] != "https://probe.example/generate_204" ||
		automatic["interval"] != 300 || automatic["timeout"] != 5000 ||
		automatic["tolerance"] != 50 {
		t.Errorf("automatic group defaults = %#v", automatic)
	}
	if got, want := document["rules"], []any{"MATCH,edge"}; !reflect.DeepEqual(got, want) {
		t.Errorf("rules = %#v, want %#v", got, want)
	}
}

func TestExpandTianjiEntryPoolsIsIdempotentAndKeepsTheNoPoolFastPath(t *testing.T) {
	first, changed, err := expandTianjiEntryPools([]byte(entryPoolProfile))
	if err != nil || !changed {
		t.Fatalf("first expansion changed=%t err=%v", changed, err)
	}
	second, changed, err := expandTianjiEntryPools(first)
	if err != nil || changed || !bytes.Equal(second, first) {
		t.Fatalf("second expansion changed=%t err=%v", changed, err)
	}
	plain := []byte("# x-tianji-entry-pool is documented here\nmixed-port: 7890\n")
	got, changed, err := expandTianjiEntryPools(plain)
	if err != nil || changed || !bytes.Equal(got, plain) {
		t.Fatalf("non-pool config changed=%t err=%v", changed, err)
	}
}

func TestExpandTianjiEntryPoolsPreservesExplicitTLSIdentity(t *testing.T) {
	input := strings.Replace(entryPoolProfile, "    tls: true", "    tls: true\n    servername: cert.example", 1)
	got, changed, err := expandTianjiEntryPools([]byte(input))
	if err != nil || !changed {
		t.Fatalf("expansion changed=%t err=%v", changed, err)
	}
	var document map[string]any
	if err := yaml.Unmarshal(got, &document); err != nil {
		t.Fatal(err)
	}
	for _, proxy := range document["proxies"].([]any) {
		if proxy.(map[string]any)["servername"] != "cert.example" {
			t.Errorf("explicit TLS identity changed: %#v", proxy)
		}
	}
	ipServer := strings.Replace(entryPoolProfile, "server: gateway.example", "server: 198.51.100.20", 1)
	if _, _, err := expandTianjiEntryPools([]byte(ipServer)); err == nil ||
		!strings.Contains(err.Error(), "explicit TLS identity") {
		t.Errorf("IP endpoint without TLS identity error = %v", err)
	}
	ipWithName := strings.Replace(ipServer, "    tls: true", "    tls: true\n    servername: cert.example", 1)
	if _, changed, err := expandTianjiEntryPools([]byte(ipWithName)); err != nil || !changed {
		t.Errorf("IP endpoint with TLS identity changed=%t err=%v", changed, err)
	}
}

func TestExpandTianjiEntryPoolsPreservesSupportedProtocolAuthAndSNI(t *testing.T) {
	cases := map[string]struct {
		input      string
		credential string
		identity   string
	}{
		"trojan": {
			input: strings.Replace(
				strings.Replace(entryPoolProfile, "type: vless", "type: trojan", 1),
				"    uuid: 2a70e3a9-b4ce-4f20-908d-e99950a0a611\n    tls: true\n", "    password: trojan-secret\n    sni: cert.example\n", 1,
			),
			credential: "password", identity: "sni",
		},
		"hysteria2": {
			input: strings.Replace(
				strings.Replace(entryPoolProfile, "type: vless", "type: hysteria2", 1),
				"    uuid: 2a70e3a9-b4ce-4f20-908d-e99950a0a611\n    tls: true\n", "    password: hysteria-secret\n    sni: cert.example\n", 1,
			),
			credential: "password", identity: "sni",
		},
		"anytls": {
			input: strings.Replace(
				strings.Replace(entryPoolProfile, "type: vless", "type: anytls", 1),
				"    uuid: 2a70e3a9-b4ce-4f20-908d-e99950a0a611\n    tls: true\n", "    password: anytls-secret\n    sni: cert.example\n", 1,
			),
			credential: "password", identity: "sni",
		},
	}
	for protocol, test := range cases {
		t.Run(protocol, func(t *testing.T) {
			got, changed, err := expandTianjiEntryPools([]byte(test.input))
			if err != nil || !changed {
				t.Fatalf("expansion changed=%t err=%v", changed, err)
			}
			var document map[string]any
			if err := yaml.Unmarshal(got, &document); err != nil {
				t.Fatal(err)
			}
			for _, item := range document["proxies"].([]any) {
				proxy := item.(map[string]any)
				if proxy["type"] != protocol || proxy[test.identity] != "cert.example" || proxy[test.credential] == "" {
					t.Errorf("conversion lost protocol identity or authentication: type=%v identity=%v credential-preserved=%t", proxy["type"], proxy[test.identity], proxy[test.credential] != "")
				}
			}
		})
	}
}

func TestExpandTianjiEntryPoolsRejectsBoundsAndNameCollisions(t *testing.T) {
	cases := map[string]string{
		"missing source port":      strings.Replace(entryPoolProfile, "    port: 443\n", "", 1),
		"interval too small":       strings.Replace(entryPoolProfile, "      url:", "      interval: 59\n      url:", 1),
		"timeout too small":        strings.Replace(entryPoolProfile, "      url:", "      timeout: 999\n      url:", 1),
		"tolerance too large":      strings.Replace(entryPoolProfile, "      url:", "      tolerance: 1001\n      url:", 1),
		"generated name collision": strings.Replace(entryPoolProfile, "proxy-groups:", "  - {name: edge / east, type: socks5, server: 127.0.0.1, port: 1}\nproxy-groups:", 1),
	}
	for name, input := range cases {
		t.Run(name, func(t *testing.T) {
			if _, _, err := expandTianjiEntryPools([]byte(input)); err == nil {
				t.Fatal("invalid bounds or colliding name were accepted")
			}
		})
	}
	if _, changed, err := expandTianjiEntryPools([]byte(manyEntryPoolProfile(8))); err != nil || !changed {
		t.Errorf("64 candidates changed=%t err=%v, want accepted", changed, err)
	}
	if _, _, err := expandTianjiEntryPools([]byte(manyEntryPoolProfile(9))); err == nil {
		t.Error("more than 64 candidates were accepted")
	}
}

func manyEntryPoolProfile(poolCount int) string {
	var builder strings.Builder
	builder.WriteString("proxies:\n")
	for pool := range poolCount {
		fmt.Fprintf(&builder, "  - name: edge-%d\n    type: vless\n    server: gateway.example\n    port: 443\n    uuid: 2a70e3a9-b4ce-4f20-908d-e99950a0a611\n    tls: true\n    x-tianji-entry-pool:\n      entries:\n", pool)
		for entry := range 8 {
			fmt.Fprintf(&builder, "        - {id: e%d, server: 192.0.2.%d}\n", entry, 10+pool*8+entry)
		}
		builder.WriteString("      url: https://probe.example/\n")
	}
	return builder.String() + "proxy-groups: []\nrules: []\n"
}

func TestExpandTianjiEntryPoolsRejectsUnsafeOrAmbiguousInputs(t *testing.T) {
	cases := map[string]string{
		"non-HTTPS probe":        strings.Replace(entryPoolProfile, "https://probe.example/generate_204", "http://probe.example/", 1),
		"probe credentials":      strings.Replace(entryPoolProfile, "https://probe.example", "https://user:secret@probe.example", 1),
		"invalid endpoint host":  strings.Replace(entryPoolProfile, "server: 192.0.2.10", "server: gateway.example", 1),
		"duplicate id":           strings.Replace(entryPoolProfile, "id: west", "id: east", 1),
		"skip certificate check": strings.Replace(entryPoolProfile, "tls: true", "tls: true\n    skip-cert-verify: true", 1),
		"certificate pin":        strings.Replace(entryPoolProfile, "tls: true", "tls: true\n    fingerprint: deadbeef", 1),
		"complex transport":      strings.Replace(entryPoolProfile, "tls: true", "tls: true\n    network: xhttp", 1),
		"include all":            strings.Replace(entryPoolProfile, "proxies: [edge]", "proxies: [edge], include-all-proxies: \"true\"", 1),
		"provider config":        strings.Replace(entryPoolProfile, "proxy-groups:", "proxy-providers: {remote: {type: file, path: remote.yaml}}\nproxy-groups:", 1),
		"provider pool field":    strings.Replace(entryPoolProfile, "proxy-groups:", "proxy-providers: {remote: {x-tianji-entry-pool: {entries: []}}}\nproxy-groups:", 1),
		"duplicate mapping key":  strings.Replace(entryPoolProfile, "    port: 443", "    port: 443\n    port: 443", 1),
		"YAML alias":             strings.Replace(entryPoolProfile, "proxies:\n", "defaults: &edge {type: vless}\nproxies:\n", 1),
		"pool outside proxy":     strings.Replace(entryPoolProfile, "proxy-groups:", "x-tianji-entry-pool: {}\nproxy-groups:", 1),
		"mapped IPv4 duplicate":  strings.Replace(entryPoolProfile, "server: 2001:db8::10, port: 8443", "server: ::ffff:192.0.2.10", 1),
	}
	for name, input := range cases {
		t.Run(name, func(t *testing.T) {
			if _, _, err := expandTianjiEntryPools([]byte(input)); err == nil {
				t.Fatal("unsafe input was accepted")
			}
		})
	}
}

func TestUnmarshalAndLoadConfigExpandEntryPoolsForReload(t *testing.T) {
	secretKey, publicKey, err := age.GenX25519KeyPair()
	if err != nil {
		t.Fatal(err)
	}
	age.SetGlobalSecretKeys(secretKey)
	t.Cleanup(func() { age.SetGlobalSecretKeys() })
	encrypted, err := age.EncryptBytes([]byte(entryPoolProfile), publicKey)
	if err != nil {
		t.Fatal(err)
	}
	path := filepath.Join(t.TempDir(), "runtime-config.yaml")
	if err := os.WriteFile(path, encrypted, 0o600); err != nil {
		t.Fatal(err)
	}
	raw, err := unmarshalRawConfig([]byte(entryPoolProfile))
	if err != nil {
		t.Fatal(err)
	}
	if len(raw.Proxy) != 2 || raw.Proxy[0]["name"] != "edge / east" {
		t.Fatalf("unmarshaled proxies = %#v", raw.Proxy)
	}
	cfg, err := loadConfig(path)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { closeUnappliedConfig(cfg) })
	if cfg.Proxies["edge"] == nil || cfg.Proxies["edge"].Type().String() != "URLTest" {
		t.Fatalf("logical proxy group = %#v", cfg.Proxies["edge"])
	}
	if got := cfg.Proxies["edge / east"]; got == nil || got.Addr() != "192.0.2.10:443" {
		t.Errorf("first entry proxy = %#v", got)
	}
	persisted, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.HasPrefix(persisted, []byte(ageEncryptedHeader)) {
		t.Fatal("age-encrypted runtime config was replaced by plaintext")
	}
	reloaded, err := loadConfig(path)
	if err != nil {
		t.Fatalf("external reload parse = %v", err)
	}
	t.Cleanup(func() { closeUnappliedConfig(reloaded) })
	if reloaded.Proxies["edge"] == nil || reloaded.Proxies["edge"].Type().String() != "URLTest" {
		t.Fatal("encrypted config did not retain the expanded URL-test group in memory")
	}
	if !bytes.HasPrefix(persisted, []byte(ageEncryptedHeader)) {
		t.Fatal("age-encrypted runtime config lost its armor header")
	}
	if bytes.Contains(persisted, []byte(entryPoolKey)) {
		t.Fatal("persisted encrypted config contains plaintext extension")
	}
}

func TestProfileBaseKeepsEncryptedConfigEncryptedWhileExpanding(t *testing.T) {
	secretKey, publicKey, err := age.GenX25519KeyPair()
	if err != nil {
		t.Fatal(err)
	}
	age.SetGlobalSecretKeys(secretKey)
	t.Cleanup(func() { age.SetGlobalSecretKeys() })
	encrypted, err := age.EncryptBytes([]byte(entryPoolProfile), publicKey)
	if err != nil {
		t.Fatal(err)
	}
	path := filepath.Join(t.TempDir(), "profile.yaml")
	if err := os.WriteFile(path, encrypted, 0o600); err != nil {
		t.Fatal(err)
	}
	original, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	base, err := handleGetProfileBase(PathParams{Path: path})
	if err != nil {
		t.Fatal(err)
	}
	data, err := json.Marshal(base.Config)
	if err != nil {
		t.Fatal(err)
	}
	var overlay map[string]any
	if err := json.Unmarshal(data, &overlay); err != nil {
		t.Fatal(err)
	}
	delete(overlay, "rule")
	overlay["rules"] = []string{"MATCH,edge"}
	encoded, err := json.Marshal(overlay)
	if err != nil {
		t.Fatal(err)
	}
	configPath := filepath.Join(t.TempDir(), "config.yaml")
	cfg, err := loadConfigWithBase(&SetupBase{Path: path, Overlay: string(encoded)}, configPath)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { closeUnappliedConfig(cfg) })
	if cfg.Proxies["edge"] == nil || cfg.Proxies["edge / west"] == nil {
		t.Fatalf("profile base omitted entry candidates: %#v", cfg.Proxies)
	}
	standalone, err := os.ReadFile(configPath)
	if err != nil {
		t.Fatal(err)
	}
	if bytes.Contains(standalone, []byte(entryPoolKey)) {
		t.Fatal("profile-base config.yaml retained the extension field")
	}
	reloaded, err := loadConfig(configPath)
	if err != nil {
		t.Fatalf("standalone config reload = %v", err)
	}
	t.Cleanup(func() { closeUnappliedConfig(reloaded) })
	after, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(after, original) {
		t.Fatal("profile source was modified")
	}
}

func TestUnmarshalRawConfigRetagsShortIDWhenExpanding(t *testing.T) {
	input := strings.Replace(entryPoolProfile, "    tls: true", "    tls: true\n    reality-opts: {public-key: SbVKOEMjK0sIlbwg4akyBg5mL5KZwwB-ed4eEE7YnRc, short-id: 0123}", 1)
	raw, err := unmarshalRawConfig([]byte(input))
	if err != nil {
		t.Fatal(err)
	}
	reality := raw.Proxy[0]["reality-opts"].(map[string]any)
	if reality["short-id"] != "0123" {
		t.Errorf("short-id = %#v, want literal 0123", reality["short-id"])
	}
}
