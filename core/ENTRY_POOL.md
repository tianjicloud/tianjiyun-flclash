# Client entry IP selection

A proxy can opt into a pool of owned numeric entry IPs by adding
`x-tianji-entry-pool`. The Core expands each entry into a copy of that proxy,
keeps its credentials and TLS settings, and adds a lazy `url-test` group under
the original proxy name. Existing rules and explicit group members keep using
that original name. The extension is removed from the expanded config, which is
persisted so an Android service start or Mihomo controller reload can parse it
without this wrapper.

```yaml
proxies:
  - name: Tokyo
    type: vless
    server: entry.example.net
    port: 443
    uuid: 2a70e3a9-b4ce-4f20-908d-e99950a0a611
    tls: true
    network: tcp
    x-tianji-entry-pool:
      entries:
        - id: east
          server: 192.0.2.10
        - id: west
          server: 2001:db8::10
          port: 8443
      url: https://probe.example/generate_204
      interval: 300
      timeout: 5000
      tolerance: 50
```

`url` is required and must be HTTPS without user information or a fragment.
`entries` must contain 2–8 unique numeric IP and port pairs. An omitted entry
port inherits the original proxy port. Entry IDs are unique short ASCII names
using letters, digits, underscores or hyphens. `interval`, `timeout` and
`tolerance` default to 300 seconds, 5000 milliseconds and 50 milliseconds;
their accepted ranges are 60–3600 seconds, 1000–15000 milliseconds and
10–1000 milliseconds. The total candidate count across the full config is
limited to 64.

When any pool is configured, YAML aliases, anchors and merge keys are rejected
so copied credentials and fields cannot inherit ambiguous or shared values.

The first version accepts VLESS over TLS with TCP or the default network
(including REALITY), Trojan over TCP or the default network, Hysteria 2, and
AnyTLS. It keeps the original TLS server name; when it is absent, the original
server hostname becomes the identity. An original server that is already an IP
must provide an explicit non-empty `servername` (VLESS) or `sni` (the other
protocols). Certificate verification stays enabled; `skip-cert-verify: true`,
certificate pins or custom certificate material, unsupported transport modes,
pooled `dialer-proxy`, provider-defined pools, and configs with
`include-all` or `include-all-proxies` groups are rejected when a pool is
configured. Proxy-provider configs cannot be combined with entry pools in this
version.

Each entry must reach the same logical exit and accept the copied
authentication. The service owner must verify that property, strict TLS identity
and certificate validity, and certificate renewal for every entry before
publishing a subscription. A successful local conversion does not establish
those deployment facts.

The generated group measures response delay through the full proxy path; it
does not measure throughput or isolate entry-IP latency. This first version
does not add telemetry, push recovery, throughput scoring or seamless
connection migration. Lazy checks avoid continuous probing while unused. With
a 300-second default interval and a two-failure threshold, unhealthy entries
are not guaranteed to be removed immediately. `empty-fallback: REJECT` only
applies when the group has no members; it does not force REJECT as soon as all
existing members fail health checks.

This client-side implementation has not been deployed to production.
This extension is consumed by FlClash's Core wrapper. Third-party Mihomo
clients may not accept the unknown extension; distribute it only to compatible
clients or verify compatibility separately.

