# Tianji transport benchmark

This small standard-library harness makes sequential HTTP GET requests through preconfigured local SOCKS5 endpoints. It does not start production proxies or configure them. It never follows redirects and it requires normal TLS certificate and hostname verification for HTTPS targets. Proxy addresses must be literal loopback IPs; remote SOCKS endpoints are rejected.

## Configure and run

Copy `config.example.json` outside the repository and replace its placeholder target, endpoint versions, and configuration paths. The target must return the same finite payload to every endpoint; use a stable test object, at least 64 KiB by default, and preferably pin its SHA-256 digest. Without a pinned digest, the harness compares hashes of all successful samples and makes every pair `indeterminate` if any payload differs. Choose an endpoint on each client that exposes a local SOCKS5 listener. The H3 candidate is compared with Hysteria 2; the H2 candidate is compared with VLESS REALITY+Vision.

If an endpoint requires SOCKS5 username/password, put references in a separate restricted JSON file and set its path in `credentials_file`:

```json
{
  "tianji-h3": {"username": "replace-me", "password": "replace-me"},
  "tianji-h2": {"username": "replace-me", "password": "replace-me"}
}
```

On POSIX, that file must be owned/protected so group and other users have no access (for example mode `0600`). If credentials are supplied, SOCKS5 may select either advertised no-auth or username/password; selecting an unadvertised method is rejected. The output omits the credential file path and all credentials. Keep endpoint names, metadata, and configuration paths free of secrets. The HTTP target URL query is sent to the target but omitted from report metadata; avoid putting credentials in it.

Run only after the user has configured the endpoints and target:

```bash
python3 tool/transport-bench/bench.py --config /path/to/bench.json --output /path/to/result.json
```

Each round shuffles endpoint order from the fixed seed, reducing fixed-order bias while keeping a reproducible order. There is no warm-up request; every attempt is counted. The report includes successful requests, categorized failures, TTFB p50/p95/p99, body goodput p50/p95/p99, raw per-attempt timings, versions, optional build/congestion/MTU/path labels, and config paths. Fill those labels from the exact binaries and test setup; labels are not independently verified. TTFB ends when the first response byte arrives, so delayed remaining headers do not inflate it. It includes SOCKS connect, target connect/TLS, and request time. One hard deadline covers connect, SOCKS negotiation, TLS, headers, and body. Throughput measures received body bytes over body-read time, excluding connect and response-header time. Target response must fit `max_body_bytes`; non-2xx, timeout, TLS, truncated/oversized/undersized body, or optional digest mismatch count as failures. At least five successful samples per endpoint are required before a pair can pass or fail the non-inferiority thresholds; otherwise it is `indeterminate`.

The proposed gate is intentionally conservative: candidate success rate must be at least baseline, candidate p95 TTFB at most 110% of baseline, and candidate median goodput at least 95% of baseline. A missing usable metric makes the comparison `indeterminate`; a measured threshold miss is `fail`. Five rounds and five successful samples per endpoint are minimums for this preliminary engineering gate, not statistical proof. Endpoint version labels are supplied by the operator and are not verified by the harness; the report marks them unverified. Do not tune these thresholds after seeing results.

## Self-tests and limits

`python3 tool/transport-bench/bench.py --self-test` checks local pure functions. `python3 tool/transport-bench/test_bench.py -v` runs isolated loopback SOCKS5/HTTP(S) fixtures for successful 64 KiB transfer, auth negotiation, unadvertised auth rejection, non-2xx, digest mismatch, truncated response, delayed and slow-trickle total timeouts, untrusted TLS certificate rejection, true first-byte timing, credential redaction, payload mismatch, and host formatting. The test runner starts every listener with `devport run` and stops it after each fixture. Its checked-in self-signed key is test-only and must never be used as a service identity.

The current harness does not measure CPU/RSS, online protocol overhead, long-duration stability, UDP latency/jitter/loss, reconnect time, or censorship resistance. It cannot establish performance across carriers or real networks. Loopback results, if collected separately, are local correctness/overhead observations only and cannot be called cross-border non-inferiority or anti-blocking evidence. Network impairment matrices (RTT 20/80/180 ms; random loss 0/0.5/2/5%; burst loss; asymmetric rates; UDP drop; 20/100/500 Mbps) must run in an isolated network namespace or designated lab host with recorded `tc netem` settings; never modify the host default network or production routes for this tool.

The JSON records endpoint config paths and user-supplied safe metadata, but does not read proxy configuration files. It cannot verify that the named config matches the running process; include immutable version/build identifiers and retain configurations separately with restricted permissions. Do not treat `pass` as release approval, production readiness, real-network superiority, or evidence that a protocol is harder to block.
