# Tianji transport v1 candidate

This package is a development candidate. It does not represent a production
panel integration, a deployed gateway, a measured performance win, or a claim
of stronger blocking resistance. The configured gateway authorization digest
must map to one already authorized user egress. It must not create billing,
quota accounting, or an unrestricted direct route. Existing subscription text
for old official clients and third party clients is passed through unchanged.

The client uses TLS 1.3 with certificate verification enabled and an explicit
`servername`. Every TCP and UDP socket is created through the supplied
`BasicOption.NewDialer`, including the QUIC packet socket, so mihomo's platform
socket hooks remain in effect. HTTP/3 auto fallback is limited to connection
bootstrap network failures. A server response, certificate verification
failure, and HTTP/3 request failure do not trigger a second HTTP/2 request.
HTTP/3 uses mihomo's existing BBR standard profile and its 15 MiB per-stream
and 64 MiB per-connection receive-window ceilings. These are configuration
choices, not evidence of a performance advantage.

An outbound candidate uses `type: tianji` and these fields:

```yaml
name: example
type: tianji
server: gateway.example
port: 443
servername: gateway.example
path: /transport/v1
token: replace-with-a-random-secret-of-at-least-32-bytes
transport: auto
```

`ca-cert` is an optional inline PEM trust root for isolated development only.
It adds a trust anchor; it never disables certificate or name verification.
Do not distribute a self-signed test CA or use this field to bypass normal
public certificate identity checks for subscriptions. Production candidates
must validate against the intended trust store and certificate name. Keeping
the PEM inline also avoids profile-driven filesystem reads.

## Offline subscription candidate

Build and run the converter from `core/`:

```sh
go run ./cmd/tianji-subscription-candidate \
  -source old-subscription.yaml \
  -approval approved-mapping.json \
  -output candidate.yaml
```

The approval JSON contains `official_app`, `supports_tianji`, `opt_in`,
`transport`, and a `nodes` object keyed by the original proxy names. Each node
contains `server`, `port`, `server_name`, `path`, its own `token`, and
`tls_validated`. Tokens must be unique for this candidate. The latter records the operator's external certificate
validation; the offline converter cannot establish a live TLS identity itself.
Runtime certificate validation remains mandatory. Keep this file and the
candidate output private because both contain a bearer credential. The tool
uses mode `0600` for its output and writes no candidate if any node mapping is
missing, duplicated, or ambiguous. Profiles with unmaterialized proxy
providers, aliases, YAML merge keys, duplicate YAML keys, non-outbound entries,
or unsupported per-proxy routing fields fail closed. It carries the recognized
`interface-name`, `routing-mark`, `ip-version`, `tfo`, `mptcp`, and
`dialer-proxy` values forward. It preserves non-proxy top-level data and names
referenced by groups and rules.

The converter only builds a candidate. Production selection, token digest
provisioning, revocation, quota exhaustion behavior, existing-connection
revocation, renewal, and old-client regressions remain external release gates.
The server-to-existing-egress compatibility bridge adds encryption and copy
work; comparisons must include that bridge end to end. Place it on the same
host or site as the existing authorized egress where practical. Removing the
bridge to improve a benchmark requires replacing its authorization and usage
accounting boundary first.
