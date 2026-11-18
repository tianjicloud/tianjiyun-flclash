# Tianji Gateway candidate

This command is a local candidate gateway. It is not a production panel or quota integration, and a successful local test is not deployment approval.

The gateway JSON contains only token digests. Store it in a regular file with mode `0600` or stricter. The mihomo file is also required to have restrictive permissions because it contains upstream credentials. Both inputs are size bounded. The mihomo YAML is deliberately limited to a single `proxies:` list; rules, groups, providers, and listeners are not loaded. The current upstream allowlist is VLESS with TLS, Trojan, Hysteria2, and AnyTLS. `skip-cert-verify`, certificate fingerprint overrides, Reality, direct and reject adapters, groups, nested dialer proxies, and unknown fields are rejected. UDP must be enabled for VLESS, Trojan, and AnyTLS. Add a custom `deny_cidrs` list for the deployment's management, gateway, and upstream networks before considering a real host.

Example gateway file:

```json
{
  "path": "/tianji/v1",
  "max_connections": 128,
  "deny_cidrs": ["203.0.113.0/24"],
  "authorizations": [
    {
      "token_sha256": "REPLACE_WITH_64_HEX_SHA256_CHARACTERS",
      "outbound": "authorized-user-egress",
      "expires": "2035-01-01T00:00:00Z",
      "max_connections": 4
    }
  ]
}
```

The corresponding upstream YAML must contain only the named, concrete mihomo proxy:

```yaml
proxies:
  - name: authorized-user-egress
    type: vless
    server: upstream.example.net
    port: 443
    uuid: REPLACE_WITH_UPSTREAM_UUID
    tls: true
    servername: upstream.example.net
    udp: true
```

The gateway listens on TCP and UDP at the same numeric address. The TLS certificate and key are read for the initial validation and again for each new full handshake; session tickets are disabled so resumed handshakes cannot bypass reload. Renew them by atomically replacing both files. Established sessions retain their current certificate. The listener enforces TLS 1.3 and uses H2 over TCP and H3 over UDP; HTTP/1.1 is available only for the ordinary fallback response and is never proxied. H3 uses mihomo's `bbr` congestion controller with the `standard` profile and 15 MiB stream / 64 MiB connection receive windows on each side. These settings have not been shown to outperform a baseline.

Run it with:

```sh
go run ./cmd/tianji-gateway \
  -config /etc/tianji/gateway.json \
  -mihomo-config /etc/tianji/upstreams.yaml \
  -listen :8443 \
  -cert /etc/tianji/fullchain.pem \
  -key /etc/tianji/private-key.pem
```

The per-request admission limits cover gateway business sessions, not unauthenticated TLS/QUIC handshakes. Place the listener behind host/network connection-rate controls appropriate to the deployment. Existing mihomo accounting behavior through each selected outbound has not been verified against a production panel, existing sessions are not proven to be revoked when panel authorization changes, and production network inventories, certificate renewal, and real-line tests remain outstanding.
