package tianji

import (
	"bytes"
	"strings"
	"testing"

	"go.yaml.in/yaml/v3"
)

func validRequest() SubscriptionRequest {
	return SubscriptionRequest{OfficialApp: true, SupportsTianji: true, OptIn: true, Transport: "auto", Nodes: map[string]SubscriptionNode{
		"node-a": {Server: "gateway-a.example", Port: 443, ServerName: "gateway-a.example", Path: "/transport/v1", Token: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", TLSValidated: true},
		"node-b": {Server: "gateway-b.example", Port: 443, ServerName: "gateway-b.example", Path: "/transport/v1", Token: "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", TLSValidated: true},
	}}
}

const sourceProfile = `mixed-port: 7890
rules:
  - MATCH,Proxy
proxy-groups:
  - name: Proxy
    type: select
    proxies: [node-a, node-b]
proxies:
  - name: node-a
    type: ss
    server: old.example
    port: 8388
    cipher: aes-128-gcm
    password: old-password
    interface-name: wlan0
    routing-mark: 42
  - name: node-b
    type: vless
    server: old-vless.example
    port: 443
    uuid: 00000000-0000-0000-0000-000000000001
`

func TestConvertSubscriptionPreservesRoutingAndReferences(t *testing.T) {
	got, converted, err := ConvertSubscriptionCandidate([]byte(sourceProfile), validRequest())
	if err != nil {
		t.Fatal(err)
	}
	if !converted {
		t.Fatal("candidate was not converted")
	}
	var doc map[string]any
	if err = yaml.Unmarshal(got, &doc); err != nil {
		t.Fatal(err)
	}
	proxies := doc["proxies"].([]any)
	first := proxies[0].(map[string]any)
	second := proxies[1].(map[string]any)
	if first["type"] != "tianji" || first["token"] != "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" || second["token"] != "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb" {
		t.Fatalf("converted nodes missing individual credentials: %#v", proxies)
	}
	if first["interface-name"] != "wlan0" || first["routing-mark"] != 42 {
		t.Fatalf("routing constraints were lost: %#v", first)
	}
	if first["password"] != nil || first["uuid"] != nil {
		t.Fatalf("source credentials were copied into candidate: %#v", proxies)
	}
	if !strings.Contains(string(got), "MATCH,Proxy") || !strings.Contains(string(got), "node-a, node-b") {
		t.Fatal("rules or group references were not preserved")
	}
}

func TestNonOptedClientsReceiveExactOriginalBytes(t *testing.T) {
	source := []byte("  legacy: [exact, bytes]\r\n")
	for _, request := range []SubscriptionRequest{{}, {OfficialApp: true}, {OfficialApp: true, SupportsTianji: true}} {
		got, converted, err := ConvertSubscriptionCandidate(source, request)
		if err != nil {
			t.Fatal(err)
		}
		if converted || !bytes.Equal(got, source) {
			t.Fatalf("non-opted request changed original: %q", got)
		}
	}
}

func TestConversionFailsClosedForAmbiguity(t *testing.T) {
	cases := []struct {
		name, source string
		mutate       func(*SubscriptionRequest)
	}{
		{"missing mapping", sourceProfile, func(r *SubscriptionRequest) { delete(r.Nodes, "node-b") }},
		{"duplicate name", strings.Replace(sourceProfile, "name: node-b\n    type: vless", "name: node-a\n    type: vless", 1), nil},
		{"proxy group name collision", strings.Replace(sourceProfile, "name: Proxy\n    type: select", "name: node-a\n    type: select", 1), nil},
		{"duplicate YAML key", strings.Replace(sourceProfile, "port: 8388", "port: 8388\n    port: 443", 1), nil},
		{"merge key", strings.Replace(sourceProfile, "proxies:\n  - name: node-a", "proxies:\n  - <<: &defaults {name: node-a}\n    name: node-a", 1), nil},
		{"unmaterialized provider", strings.Replace(sourceProfile, "proxies:\n", "proxy-providers: {main: {type: http}}\nproxies:\n", 1), nil},
		{"invalid providers", strings.Replace(sourceProfile, "proxies:\n", "proxy-providers: []\nproxies:\n", 1), nil},
		{"direct outbound", strings.Replace(sourceProfile, "type: ss", "type: direct", 1), nil},
		{"missing TLS validation", sourceProfile, func(r *SubscriptionRequest) {
			node := r.Nodes["node-a"]
			node.TLSValidated = false
			r.Nodes["node-a"] = node
		}},
		{"reused token", sourceProfile, func(r *SubscriptionRequest) {
			node := r.Nodes["node-b"]
			node.Token = r.Nodes["node-a"].Token
			r.Nodes["node-b"] = node
		}},
		{"ambiguous alias", sourceProfile + "extra: &unused {nested: value}\nalias: *unused\n", nil},
	}
	for _, test := range cases {
		t.Run(test.name, func(t *testing.T) {
			request := validRequest()
			if test.mutate != nil {
				test.mutate(&request)
			}
			if _, converted, err := ConvertSubscriptionCandidate([]byte(test.source), request); err == nil || converted {
				t.Fatalf("expected fail-closed error, converted=%t err=%v", converted, err)
			}
		})
	}
}
