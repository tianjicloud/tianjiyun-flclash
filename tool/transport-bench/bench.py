#!/usr/bin/env python3
"""Compare preconfigured local SOCKS5 transports against a fixed HTTP target."""

from __future__ import annotations

import argparse
import hashlib
import http.client
import ipaddress
import json
import math
import os
import random
import socket
import ssl
import stat
import struct
import sys
import threading
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable
from urllib.parse import quote, urlsplit


class ConfigError(ValueError):
    pass


@dataclass(frozen=True)
class Credential:
    username: str
    password: str


def percentile(values: list[float], pct: float) -> float | None:
    if not values:
        return None
    ordered = sorted(values)
    position = (len(ordered) - 1) * pct / 100
    lower = math.floor(position)
    upper = math.ceil(position)
    if lower == upper:
        return ordered[lower]
    return ordered[lower] + (ordered[upper] - ordered[lower]) * (position - lower)


def safe_url_parts(url: str) -> tuple[str, str, int, str]:
    if not isinstance(url, str):
        raise ConfigError('target.url must be a string')
    parsed = urlsplit(url)
    if parsed.scheme not in {'http', 'https'} or not parsed.hostname:
        raise ConfigError('target.url must be an http or https URL with a hostname')
    if parsed.username or parsed.password:
        raise ConfigError('target.url must not contain user information')
    try:
        port = parsed.port or (443 if parsed.scheme == 'https' else 80)
    except ValueError as exc:
        raise ConfigError('target.url has an invalid port') from exc
    if not 1 <= port <= 65535:
        raise ConfigError('target.url port must be between 1 and 65535')
    if parsed.fragment:
        raise ConfigError('target.url must not contain a fragment')
    path = quote(parsed.path or '/', safe='/%:@&=+$,;')
    if parsed.query:
        path += '?' + quote(parsed.query, safe='/%?:@&=+$,;')
    return parsed.scheme, parsed.hostname, port, path


def host_header(scheme: str, host: str, port: int) -> str:
    formatted_host = f'[{host}]' if ':' in host else host.encode('idna').decode('ascii')
    default_port = 443 if scheme == 'https' else 80
    return formatted_host if port == default_port else f'{formatted_host}:{port}'


class PrefixedReader:
    def __init__(self, prefix: bytes, source: Any) -> None:
        self.prefix = prefix
        self.source = source

    def readline(self, size: int = -1) -> bytes:
        if not self.prefix:
            return self.source.readline(size)
        prefix, self.prefix = self.prefix, b''
        if b'\n' in prefix or size == 1:
            return prefix[:size] if size >= 0 else prefix
        remaining = size - len(prefix) if size >= 0 else -1
        return prefix + self.source.readline(remaining)

    def read(self, size: int = -1) -> bytes:
        if not self.prefix:
            return self.source.read(size)
        prefix, self.prefix = self.prefix, b''
        if size < 0:
            return prefix + self.source.read()
        if len(prefix) >= size:
            self.prefix = prefix[size:]
            return prefix[:size]
        return prefix + self.source.read(size - len(prefix))

    def readinto(self, buffer: Any) -> int:
        if self.prefix:
            count = min(len(buffer), len(self.prefix))
            buffer[:count] = self.prefix[:count]
            self.prefix = self.prefix[count:]
            return count
        return self.source.readinto(buffer)

    def close(self) -> None:
        self.source.close()

    def flush(self) -> None:
        self.source.flush()


class PrefixedSocket:
    def __init__(self, sock: socket.socket, first_byte: bytes) -> None:
        self.sock = sock
        self.first_byte = first_byte

    def makefile(self, mode: str = 'rb', buffering: int | None = None) -> PrefixedReader:
        return PrefixedReader(self.first_byte, self.sock.makefile(mode, buffering))


def load_credentials(path: str | None) -> dict[str, Credential]:
    if path is None:
        return {}
    file_path = Path(path)
    try:
        info = file_path.stat()
    except OSError as exc:
        raise ConfigError('credentials file cannot be read') from exc
    if not stat.S_ISREG(info.st_mode):
        raise ConfigError('credentials file must be a regular file')
    if os.name == 'posix' and info.st_mode & 0o077:
        raise ConfigError('credentials file permissions must exclude group and other access')
    try:
        raw = json.loads(file_path.read_text(encoding='utf-8'))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        raise ConfigError('credentials file is not valid JSON') from exc
    if not isinstance(raw, dict):
        raise ConfigError('credentials file must be a JSON object')
    result: dict[str, Credential] = {}
    for ref, pair in raw.items():
        if not isinstance(ref, str) or not isinstance(pair, dict):
            raise ConfigError('credentials entries must map names to objects')
        username, password = pair.get('username'), pair.get('password')
        if not isinstance(username, str) or not isinstance(password, str):
            raise ConfigError('credential entries require string username and password')
        result[ref] = Credential(username, password)
    return result


def validate_config(raw: Any) -> dict[str, Any]:
    if not isinstance(raw, dict) or raw.get('schema_version') != 1:
        raise ConfigError('schema_version must be 1')
    target = raw.get('target')
    if not isinstance(target, dict):
        raise ConfigError('target must be an object')
    scheme, host, port, path = safe_url_parts(target.get('url', ''))
    timeout = target.get('timeout_seconds', 15)
    if (not isinstance(timeout, (int, float)) or isinstance(timeout, bool)
            or not math.isfinite(timeout) or timeout <= 0):
        raise ConfigError('target.timeout_seconds must be a finite positive number')
    max_body = target.get('max_body_bytes', 8 * 1024 * 1024)
    min_body = target.get('min_bytes', 64 * 1024)
    if not isinstance(max_body, int) or isinstance(max_body, bool) or max_body <= 0:
        raise ConfigError('target.max_body_bytes must be a positive integer')
    if not isinstance(min_body, int) or isinstance(min_body, bool) or min_body < 64 * 1024:
        raise ConfigError('target.min_bytes must be an integer of at least 65536')
    if min_body > max_body:
        raise ConfigError('target.min_bytes cannot exceed max_body_bytes')
    rounds = raw.get('rounds', 5)
    if not isinstance(rounds, int) or isinstance(rounds, bool) or rounds < 5:
        raise ConfigError('rounds must be at least 5')
    seed = raw.get('seed', 20261117)
    if not isinstance(seed, int) or isinstance(seed, bool):
        raise ConfigError('seed must be an integer')
    endpoints = raw.get('endpoints')
    if not isinstance(endpoints, list) or len(endpoints) < 2:
        raise ConfigError('endpoints must contain at least two entries')
    names: set[str] = set()
    normalized = []
    for endpoint in endpoints:
        if not isinstance(endpoint, dict):
            raise ConfigError('each endpoint must be an object')
        name = endpoint.get('name')
        if not isinstance(name, str) or not name or name in names:
            raise ConfigError('endpoint names must be unique non-empty strings')
        names.add(name)
        if endpoint.get('role') not in {'candidate', 'hysteria2', 'reality_vision'}:
            raise ConfigError(f'{name}: invalid role')
        if endpoint.get('protocol') not in {'h3', 'h2', 'udp', 'tcp'}:
            raise ConfigError(f'{name}: protocol must identify the measured transport')
        if not isinstance(endpoint.get('version'), str) or not endpoint['version']:
            raise ConfigError(f'{name}: version is required')
        if not isinstance(endpoint.get('config_path'), str) or not endpoint['config_path']:
            raise ConfigError(f'{name}: config_path is required')
        for field in ('build_label', 'congestion_control', 'path_label'):
            if field in endpoint and not isinstance(endpoint[field], str):
                raise ConfigError(f'{name}: {field} must be a string')
        if 'mtu' in endpoint and (not isinstance(endpoint['mtu'], int) or isinstance(endpoint['mtu'], bool)
                                  or not 256 <= endpoint['mtu'] <= 65535):
            raise ConfigError(f'{name}: mtu must be an integer between 256 and 65535')
        proxy_host = endpoint.get('proxy_host', '127.0.0.1')
        proxy_port = endpoint.get('proxy_port')
        try:
            proxy_address = ipaddress.ip_address(proxy_host)
        except (ValueError, TypeError) as exc:
            raise ConfigError(f'{name}: proxy_host must be a loopback IP address') from exc
        if not proxy_address.is_loopback:
            raise ConfigError(f'{name}: proxy_host must be loopback')
        if not isinstance(proxy_port, int) or isinstance(proxy_port, bool) or not 1 <= proxy_port <= 65535:
            raise ConfigError(f'{name}: proxy_port must be between 1 and 65535')
        normalized.append({**endpoint, 'proxy_host': proxy_host})
    comparisons = raw.get('comparisons')
    if not isinstance(comparisons, list) or not comparisons:
        raise ConfigError('comparisons must list candidate-to-baseline pairs')
    for pair in comparisons:
        if not isinstance(pair, dict) or pair.get('candidate') not in names or pair.get('baseline') not in names:
            raise ConfigError('each comparison must reference configured endpoint names')
        candidate = next(item for item in normalized if item['name'] == pair['candidate'])
        baseline = next(item for item in normalized if item['name'] == pair['baseline'])
        if candidate['role'] != 'candidate' or baseline['role'] == 'candidate':
            raise ConfigError('comparisons must pair a candidate with a baseline')
        expected_role = {'h3': 'hysteria2', 'h2': 'reality_vision'}.get(candidate['protocol'])
        if expected_role is None or baseline['role'] != expected_role:
            raise ConfigError('h3 candidates compare with Hysteria 2; h2 candidates compare with REALITY+Vision')
    credentials_file = raw.get('credentials_file')
    if credentials_file is not None and not isinstance(credentials_file, str):
        raise ConfigError('credentials_file must be a path string')
    metadata = raw.get('metadata', {})
    if not isinstance(metadata, dict) or any(key not in {'host_label', 'cpu_quota', 'egress_label', 'network_profile'}
                                              for key in metadata):
        raise ConfigError('metadata may contain only host_label, cpu_quota, egress_label, network_profile')
    digest = target.get('sha256')
    if digest is not None and (not isinstance(digest, str) or len(digest) != 64
                               or any(char not in '0123456789abcdefABCDEF' for char in digest)):
        raise ConfigError('target.sha256 must be a 64-character hexadecimal SHA-256 digest')
    return {
        'target': {'url': target['url'], 'scheme': scheme, 'host': host, 'port': port, 'path': path,
                   'timeout_seconds': float(timeout), 'max_body_bytes': max_body,
                   'min_bytes': min_body, 'sha256': digest},
        'rounds': rounds,
        'seed': seed,
        'endpoints': normalized,
        'comparisons': comparisons,
        'credentials_file': credentials_file,
        'metadata': metadata,
    }


def _recv_exact(sock: socket.socket, length: int) -> bytes:
    chunks = bytearray()
    while len(chunks) < length:
        data = sock.recv(length - len(chunks))
        if not data:
            raise OSError('SOCKS5 handshake ended early')
        chunks.extend(data)
    return bytes(chunks)


def socks5_connect(endpoint: dict[str, Any], target_host: str, target_port: int,
                   deadline: float, credential: Credential | None,
                   on_socket: Callable[[socket.socket], None]) -> socket.socket:
    timeout = max(deadline - time.perf_counter(), 1e-6)
    sock = socket.create_connection((endpoint['proxy_host'], endpoint['proxy_port']), timeout)
    on_socket(sock)
    timeout = deadline - time.perf_counter()
    if timeout <= 0:
        sock.close()
        raise TimeoutError()
    sock.settimeout(timeout)
    try:
        methods = b'\x00\x02' if credential else b'\x00'
        sock.sendall(b'\x05' + bytes([len(methods)]) + methods)
        version, method = _recv_exact(sock, 2)
        if version != 5 or method == 0xff:
            raise OSError('SOCKS5 authentication method rejected')
        if method == 2:
            if credential is None:
                raise OSError('SOCKS5 credentials required')
            user = credential.username.encode('utf-8')
            password = credential.password.encode('utf-8')
            if len(user) > 255 or len(password) > 255:
                raise OSError('SOCKS5 credential length invalid')
            sock.sendall(b'\x01' + bytes([len(user)]) + user + bytes([len(password)]) + password)
            auth_version, auth_status = _recv_exact(sock, 2)
            if auth_version != 1 or auth_status != 0:
                raise OSError('SOCKS5 authentication failed')
        elif method != 0:
            raise OSError('SOCKS5 selected unsupported authentication')
        try:
            address = ipaddress.ip_address(target_host)
        except ValueError:
            host = target_host.encode('idna')
            if len(host) > 255:
                raise OSError('target hostname is too long')
            target_address = b'\x03' + bytes([len(host)]) + host
        else:
            target_address = (b'\x01' if address.version == 4 else b'\x04') + address.packed
        sock.sendall(b'\x05\x01\x00' + target_address + struct.pack('!H', target_port))
        version, reply, _, address_type = _recv_exact(sock, 4)
        if version != 5 or reply != 0:
            raise OSError('SOCKS5 connect failed')
        address_length = {1: 4, 4: 16}.get(address_type)
        if address_type == 3:
            address_length = _recv_exact(sock, 1)[0]
        if address_length is None:
            raise OSError('SOCKS5 returned invalid address')
        _recv_exact(sock, address_length + 2)
        return sock
    except Exception:
        sock.close()
        raise


def fetch(endpoint: dict[str, Any], target: dict[str, Any], credential: Credential | None) -> dict[str, Any]:
    started = time.perf_counter()
    sock: socket.socket | None = None
    watchdog: threading.Timer | None = None
    timeout_fired = threading.Event()
    active_socket: list[socket.socket | None] = [None]

    def abort_sample() -> None:
        timeout_fired.set()
        active = active_socket[0]
        if active is not None:
            try:
                active.shutdown(socket.SHUT_RDWR)
            except OSError:
                pass
            try:
                active.close()
            except OSError:
                pass

    def register_active_socket(active: socket.socket) -> None:
        active_socket[0] = active
        if timeout_fired.is_set():
            abort_sample()

    try:
        deadline = started + target['timeout_seconds']
        watchdog = threading.Timer(target['timeout_seconds'], abort_sample)
        watchdog.daemon = True
        watchdog.start()
        sock = socks5_connect(endpoint, target['host'], target['port'], deadline, credential,
                              register_active_socket)
        if timeout_fired.is_set():
            raise TimeoutError()
        if target['scheme'] == 'https':
            context = ssl.create_default_context()
            sock = context.wrap_socket(sock, server_hostname=target['host'], do_handshake_on_connect=False)
            active_socket[0] = sock
            sock.settimeout(max(deadline - time.perf_counter(), 1e-6))
            sock.do_handshake()
        target_host_header = host_header(target['scheme'], target['host'], target['port'])
        request = (f"GET {target['path']} HTTP/1.1\r\nHost: {target_host_header}\r\n"
                   'User-Agent: tianji-transport-bench/1\r\nAccept: */*\r\nConnection: close\r\n\r\n')
        sock.sendall(request.encode('ascii'))
        first_byte = sock.recv(1)
        if not first_byte:
            raise OSError('target closed before response')
        ttfb_ms = (time.perf_counter() - started) * 1000
        response = http.client.HTTPResponse(PrefixedSocket(sock, first_byte))
        response.begin()
        if not 200 <= response.status < 300:
            return {'ok': False, 'error': 'http_status', 'status_code': response.status,
                    'ttfb_ms': ttfb_ms, 'bytes': 0, 'sha256': None, 'goodput_mbps': None}
        body_started = time.perf_counter()
        body_hash = hashlib.sha256()
        body_size = 0
        while True:
            remaining = deadline - time.perf_counter()
            if remaining <= 0:
                raise TimeoutError()
            sock.settimeout(remaining)
            chunk = response.read(min(65536, target['max_body_bytes'] + 1 - body_size))
            if not chunk:
                break
            body_size += len(chunk)
            if body_size > target['max_body_bytes']:
                return {'ok': False, 'error': 'body_limit', 'status_code': response.status,
                        'ttfb_ms': ttfb_ms, 'bytes': body_size, 'sha256': None, 'goodput_mbps': None}
            body_hash.update(chunk)
        if response.length is not None and response.length > 0:
            return {'ok': False, 'error': 'body_truncated', 'status_code': response.status,
                    'ttfb_ms': ttfb_ms, 'bytes': body_size, 'sha256': None, 'goodput_mbps': None}
        elapsed = max(time.perf_counter() - body_started, 1e-9)
        digest = body_hash.hexdigest()
        digest_expected = target.get('sha256')
        if digest_expected and digest.lower() != digest_expected.lower():
            return {'ok': False, 'error': 'body_hash_mismatch', 'status_code': response.status,
                    'ttfb_ms': ttfb_ms, 'bytes': body_size, 'sha256': digest, 'goodput_mbps': None}
        if body_size < target['min_bytes']:
            return {'ok': False, 'error': 'body_too_small', 'status_code': response.status,
                    'ttfb_ms': ttfb_ms, 'bytes': body_size, 'sha256': digest, 'goodput_mbps': None}
        return {'ok': True, 'error': None, 'status_code': response.status, 'ttfb_ms': ttfb_ms,
                'bytes': body_size, 'sha256': digest,
                'goodput_mbps': body_size * 8 / elapsed / 1_000_000 if body_size else None}
    except (socket.timeout, TimeoutError):
        error = 'total_timeout'
        return {'ok': False, 'error': error, 'status_code': None, 'ttfb_ms': None,
                'bytes': 0, 'sha256': None, 'goodput_mbps': None}
    except ssl.SSLCertVerificationError:
        error = 'total_timeout' if timeout_fired.is_set() else 'tls_certificate'
        return {'ok': False, 'error': error, 'status_code': None, 'ttfb_ms': None,
                'bytes': 0, 'goodput_mbps': None}
    except ssl.SSLError:
        error = 'total_timeout' if timeout_fired.is_set() else 'tls_error'
        return {'ok': False, 'error': error, 'status_code': None, 'ttfb_ms': None,
                'bytes': 0, 'goodput_mbps': None}
    except (OSError, http.client.HTTPException, UnicodeError, ValueError):
        error = 'total_timeout' if timeout_fired.is_set() else 'connection_or_http_error'
        return {'ok': False, 'error': error, 'status_code': None,
                'ttfb_ms': None, 'bytes': 0, 'sha256': None, 'goodput_mbps': None}
    finally:
        if watchdog is not None:
            watchdog.cancel()
        if sock is not None:
            sock.close()


def summarize(samples: list[dict[str, Any]]) -> dict[str, Any]:
    successful = [sample for sample in samples if sample['ok']]
    ttfb = [sample['ttfb_ms'] for sample in successful if sample['ttfb_ms'] is not None]
    goodput = [sample['goodput_mbps'] for sample in successful if sample['goodput_mbps'] is not None]
    failures: dict[str, int] = {}
    for sample in samples:
        if not sample['ok']:
            failures[sample['error']] = failures.get(sample['error'], 0) + 1
    return {
        'attempts': len(samples), 'successes': len(successful),
        'success_rate': len(successful) / len(samples) if samples else None,
        'failures_by_class': failures,
        'ttfb_ms': {key: percentile(ttfb, pct) for key, pct in [('p50', 50), ('p95', 95), ('p99', 99)]},
        'goodput_mbps': {key: percentile(goodput, pct) for key, pct in [('p50', 50), ('p95', 95), ('p99', 99)]},
    }


def compare(summary_candidate: dict[str, Any], summary_baseline: dict[str, Any], rounds: int) -> dict[str, Any]:
    if (summary_candidate['attempts'] < rounds or summary_baseline['attempts'] < rounds
            or summary_candidate['successes'] < 5 or summary_baseline['successes'] < 5
            or summary_candidate['ttfb_ms']['p95'] is None or summary_baseline['ttfb_ms']['p95'] is None
            or summary_candidate['goodput_mbps']['p50'] is None or summary_baseline['goodput_mbps']['p50'] is None):
        return {'status': 'indeterminate', 'reason': 'at least five successful samples per endpoint are required'}
    success_ok = summary_candidate['success_rate'] >= summary_baseline['success_rate']
    ttfb_ratio = summary_candidate['ttfb_ms']['p95'] / max(summary_baseline['ttfb_ms']['p95'], 1e-9)
    throughput_ratio = summary_candidate['goodput_mbps']['p50'] / max(summary_baseline['goodput_mbps']['p50'], 1e-9)
    passed = success_ok and ttfb_ratio <= 1.10 and throughput_ratio >= 0.95
    return {
        'status': 'pass' if passed else 'fail',
        'checks': {'success_rate_at_least_baseline': success_ok,
                   'ttfb_p95_ratio': ttfb_ratio, 'ttfb_p95_limit': 1.10,
                   'goodput_p50_ratio': throughput_ratio, 'goodput_p50_minimum': 0.95},
    }


def run(config: dict[str, Any], config_path: str) -> dict[str, Any]:
    started_utc = time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
    credentials = load_credentials(config['credentials_file'])
    for endpoint in config['endpoints']:
        ref = endpoint.get('credential_ref')
        if ref and ref not in credentials:
            raise ConfigError(f"{endpoint['name']}: credential_ref is missing from credentials file")
    samples = {endpoint['name']: [] for endpoint in config['endpoints']}
    order_rng = random.Random(config['seed'])
    endpoints = list(config['endpoints'])
    for round_index in range(config['rounds']):
        order_rng.shuffle(endpoints)
        for endpoint in endpoints:
            sample = fetch(endpoint, config['target'], credentials.get(endpoint.get('credential_ref')))
            sample['round'] = round_index + 1
            samples[endpoint['name']].append(sample)
    summaries = {name: summarize(items) for name, items in samples.items()}
    endpoint_metadata = []
    for endpoint in config['endpoints']:
        keys = ('name', 'role', 'protocol', 'version', 'config_path', 'build_label',
                'congestion_control', 'mtu', 'path_label')
        endpoint_metadata.append({key: endpoint[key] for key in keys if key in endpoint})
    comparisons = []
    for pair in config['comparisons']:
        comparisons.append({**pair, **compare(summaries[pair['candidate']], summaries[pair['baseline']], config['rounds'])})
    body_hashes = {sample['sha256'] for items in samples.values() for sample in items
                   if sample['ok'] and sample.get('sha256')}
    payload_consistent = len(body_hashes) == 1
    for item in comparisons:
        item['payload_consistent'] = payload_consistent
        if not payload_consistent:
            item['status'] = 'indeterminate'
            item['reason'] = 'successful samples did not all return the same payload digest'
    target = config['target']
    display_host = f"[{target['host']}]" if ':' in target['host'] else target['host']
    target_display = f"{target['scheme']}://{display_host}:{target['port']}{target['path'].split('?', 1)[0]}"
    return {
        'schema_version': 1,
        'run': {'config_path': str(Path(config_path).resolve()), 'started_utc': started_utc,
                'rounds': config['rounds'], 'seed': config['seed'], 'target': target_display,
                'metadata': config['metadata'],
                'endpoint_versions_verified': False,
                'version_note': 'Version labels are user-supplied and are not queried or verified.'},
        'thresholds': {'success_rate': 'candidate >= baseline', 'ttfb_p95_ratio_max': 1.10,
                       'goodput_p50_ratio_min': 0.95, 'minimum_successful_samples': 5,
                       'minimum_payload_bytes': target['min_bytes']},
        'payload_consistent': payload_consistent,
        'endpoints': endpoint_metadata,
        'results': {name: {'summary': summaries[name], 'samples': items} for name, items in samples.items()},
        'comparisons': comparisons,
        'not_covered': ['CPU and RSS', 'online protocol overhead', 'long-duration stability',
                        'UDP latency, jitter and loss', 'real-network carrier performance',
                        'censorship resistance', 'statistical significance'],
        'interpretation': 'Local SOCKS5-to-fixed-target comparison only; a pass is not evidence of production readiness or anti-blocking performance.',
    }


def self_test() -> None:
    assert percentile([], 95) is None
    assert percentile([1.0, 3.0], 50) == 2.0
    assert percentile([1.0, 2.0, 3.0], 99) == 2.98
    stats = summarize([{'ok': True, 'ttfb_ms': 10.0, 'goodput_mbps': 5.0, 'error': None},
                       {'ok': False, 'ttfb_ms': None, 'goodput_mbps': None, 'error': 'timeout'}])
    assert stats['success_rate'] == 0.5 and stats['failures_by_class'] == {'timeout': 1}
    assert compare(stats, stats, 5)['status'] == 'indeterminate'
    base = {'attempts': 5, 'successes': 5, 'success_rate': 1.0, 'ttfb_ms': {'p95': 100.0},
            'goodput_mbps': {'p50': 100.0}}
    candidate = {'attempts': 5, 'successes': 5, 'success_rate': 1.0, 'ttfb_ms': {'p95': 110.0},
                 'goodput_mbps': {'p50': 95.0}}
    assert compare(candidate, base, 5)['status'] == 'pass'
    candidate['ttfb_ms']['p95'] = 111.0
    assert compare(candidate, base, 5)['status'] == 'fail'
    for invalid in ('ftp://example.com/file', 'https://user:secret@example.com/', 'https://example.com/#frag'):
        try:
            safe_url_parts(invalid)
        except ConfigError:
            pass
        else:
            raise AssertionError('invalid target accepted')
    print('selftests: passed')


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--config', help='JSON benchmark configuration')
    parser.add_argument('--output', help='write machine-readable JSON here (default: stdout)')
    parser.add_argument('--self-test', action='store_true', help='run local pure-function checks only')
    args = parser.parse_args()
    if args.self_test:
        self_test()
        return 0
    if not args.config:
        parser.error('--config is required unless --self-test is used')
    try:
        raw = json.loads(Path(args.config).read_text(encoding='utf-8'))
        config = validate_config(raw)
        result = run(config, args.config)
    except (OSError, UnicodeError, json.JSONDecodeError, ConfigError) as exc:
        print(f'configuration/run error: {exc}', file=sys.stderr)
        return 2
    output = json.dumps(result, indent=2, ensure_ascii=False, allow_nan=False) + '\n'
    if args.output:
        Path(args.output).write_text(output, encoding='utf-8')
    else:
        sys.stdout.write(output)
    for comparison in result['comparisons']:
        print(f"{comparison['candidate']} vs {comparison['baseline']}: {comparison['status']}", file=sys.stderr)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
