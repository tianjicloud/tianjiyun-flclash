package main

import "testing"

func TestEligibleFieldsRejectsTLSBypassesAndAliases(t *testing.T) {
	valid := map[string]any{
		"name": "node", "type": "vless", "server": "node.example", "port": 443,
		"uuid": "00000000-0000-4000-8000-000000000000", "tls": true, "udp": true,
	}
	if !eligibleFields(valid) {
		t.Fatal("strict TLS VLESS outbound was rejected")
	}
	for name, value := range map[string]any{
		"skip-cert-verify": true,
		"Skip-Cert-Verify": true,
		"skip_cert_verify": true,
		"fingerprint":      "sha256/pin",
		"reality-opts":     map[string]any{"public-key": "pin"},
		"dialer-proxy":     "DIRECT",
		"smux":             map[string]any{"enabled": true},
	} {
		t.Run(name, func(t *testing.T) {
			candidate := cloneMapping(valid)
			candidate[name] = value
			if eligibleFields(candidate) {
				t.Fatalf("accepted unsupported or insecure field %q", name)
			}
		})
	}
}

func TestEligibleFieldsRequiresUDPAndTLS(t *testing.T) {
	base := map[string]any{
		"name": "node", "type": "vless", "server": "node.example", "port": 443,
		"uuid": "00000000-0000-4000-8000-000000000000", "tls": true, "udp": true,
	}
	for _, field := range []string{"udp", "tls"} {
		t.Run(field, func(t *testing.T) {
			candidate := cloneMapping(base)
			candidate[field] = false
			if eligibleFields(candidate) {
				t.Fatalf("accepted VLESS with %s disabled", field)
			}
		})
	}
}

func cloneMapping(input map[string]any) map[string]any {
	output := make(map[string]any, len(input))
	for key, value := range input {
		output[key] = value
	}
	return output
}
