from __future__ import annotations

import argparse
import hashlib
import json
import os
import socket
import ssl
import struct
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from pathlib import Path
from typing import Any

import bench


PAYLOAD = bytes(range(256)) * 256
HERE = Path(__file__).resolve()
CERT = HERE.parent / 'testdata' / 'untrusted-test.crt'
KEY = HERE.parent / 'testdata' / 'untrusted-test.key'


def receive_exact(client: socket.socket, size: int) -> bytes:
    data = bytearray()
    while len(data) < size:
        part = client.recv(size - len(data))
        if not part:
            raise ConnectionError()
        data.extend(part)
    return bytes(data)


def serve(port: int, mode: str) -> None:
    listener = socket.socket()
    listener.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    listener.bind(('127.0.0.1', port))
    listener.listen()
    while True:
        client, _ = listener.accept()
        try:
            client.settimeout(2)
            version, method_count = receive_exact(client, 2)
            methods = receive_exact(client, method_count)
            if mode == 'unadvertised_method':
                client.sendall(b'\x05\x02')
                client.close()
                continue
            if version != 5 or 0 not in methods:
                if mode != 'require_auth' or 2 not in methods:
                    client.close()
                    continue
            selected_method = 2 if mode == 'require_auth' else 0
            client.sendall(bytes((5, selected_method)))
            if selected_method == 2:
                auth_version, username_size = receive_exact(client, 2)
                username = receive_exact(client, username_size)
                password_size = receive_exact(client, 1)[0]
                password = receive_exact(client, password_size)
                auth_status = 0 if (auth_version == 1 and username == b'bench-user'
                                    and password == b'bench-password') else 1
                client.sendall(bytes((1, auth_status)))
                if auth_status:
                    client.close()
                    continue
            version, command, _, address_type = receive_exact(client, 4)
            if address_type == 3:
                address = receive_exact(client, receive_exact(client, 1)[0])
            elif address_type == 1:
                address = receive_exact(client, 4)
            elif address_type == 4:
                address = receive_exact(client, 16)
            else:
                client.close()
                continue
            port_bytes = receive_exact(client, 2)
            del address, port_bytes
            if version != 5 or command != 1:
                client.close()
                continue
            client.sendall(b'\x05\x00\x00\x01\x7f\x00\x00\x01\x00\x50')
            if mode == 'tls_certificate':
                context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
                context.load_cert_chain(CERT, KEY)
                tls_client = context.wrap_socket(client, server_side=True)
                tls_client.close()
                continue
            request = bytearray()
            while not request.endswith(b'\r\n\r\n') and len(request) < 8192:
                request.extend(client.recv(1))
            if mode == 'late_first_byte':
                time.sleep(0.4)
            status = b'HTTP/1.1 503 Unavailable\r\n' if mode == 'non_2xx' else b'HTTP/1.1 200 OK\r\n'
            body = PAYLOAD
            if mode == 'different_payload':
                body = bytes((byte ^ 0x01) for byte in PAYLOAD)
            if mode == 'truncated':
                header = b'Content-Length: 131072\r\n'
                body = PAYLOAD[:1024]
            else:
                header = f'Content-Length: {len(body)}\r\n'.encode('ascii')
            client.sendall(status[:1])
            if mode == 'slow_trickle':
                rest = status[1:] + header + b'Connection: close\r\n\r\n'
                for byte in rest:
                    client.sendall(bytes((byte,)))
                    time.sleep(0.04)
                client.sendall(body)
                continue
            if mode == 'delayed_headers':
                time.sleep(0.25)
            client.sendall(status[1:] + header + b'Connection: close\r\n\r\n')
            if mode != 'non_2xx':
                client.sendall(body)
        except (ConnectionError, OSError, socket.timeout):
            pass
        finally:
            client.close()


class Fixture:
    def __init__(self, mode: str) -> None:
        self.mode = mode
        self.port = self._free_port()
        self.name = f'tj-bench-fixture-{self.port}'
        self.env = dict(os.environ, DEVPORT_SESSION='tj-bench-luna-20261117')

    @staticmethod
    def _free_port() -> int:
        with socket.socket() as sock:
            sock.bind(('127.0.0.1', 0))
            return sock.getsockname()[1]

    def __enter__(self) -> Fixture:
        subprocess.run(['devport', 'run', self.name, '--port', str(self.port), '--', sys.executable,
                        str(HERE), '--serve', str(self.port), '--mode', self.mode],
                       check=True, capture_output=True, text=True, env=self.env, timeout=5)
        deadline = time.monotonic() + 5
        while time.monotonic() < deadline:
            try:
                with socket.create_connection(('127.0.0.1', self.port), timeout=0.1):
                    return self
            except OSError:
                time.sleep(0.025)
        self.__exit__(None, None, None)
        raise RuntimeError(f'fixture did not start: {self.name}')

    def __exit__(self, *_: Any) -> None:
        subprocess.run(['devport', 'stop', self.name], capture_output=True, text=True,
                       env=self.env, timeout=5, check=False)


def test_endpoint(port: int, name: str, role: str, protocol: str) -> dict[str, Any]:
    return {'name': name, 'role': role, 'protocol': protocol, 'version': 'fixture-1',
            'config_path': '/fixture/benign.json', 'proxy_host': '127.0.0.1', 'proxy_port': port}


def test_target(port: int, **overrides: Any) -> dict[str, Any]:
    target: dict[str, Any] = {'url': f'http://127.0.0.1:{port}/fixed', 'timeout_seconds': 2,
                              'max_body_bytes': 131072, 'min_bytes': 65536}
    target.update(overrides)
    return bench.validate_config({
        'schema_version': 1, 'target': target, 'rounds': 5,
        'endpoints': [test_endpoint(port, 'candidate', 'candidate', 'h3'),
                      test_endpoint(port, 'hysteria', 'hysteria2', 'udp')],
        'comparisons': [{'candidate': 'candidate', 'baseline': 'hysteria'}],
    })['target']


class TransportBenchTests(unittest.TestCase):
    def test_socks5_http_64k(self) -> None:
        with Fixture('normal') as fixture:
            result = bench.fetch(test_endpoint(fixture.port, 'candidate', 'candidate', 'h3'),
                                 test_target(fixture.port), None)
            self.assertTrue(result['ok'], result)
            self.assertEqual(result['bytes'], 65536)
            self.assertEqual(result['sha256'], hashlib.sha256(PAYLOAD).hexdigest())

    def test_non_2xx_hash_mismatch_and_truncation(self) -> None:
        with Fixture('non_2xx') as fixture:
            result = bench.fetch(test_endpoint(fixture.port, 'candidate', 'candidate', 'h3'),
                                 test_target(fixture.port), None)
            self.assertEqual(result['error'], 'http_status')
        with Fixture('normal') as fixture:
            result = bench.fetch(test_endpoint(fixture.port, 'candidate', 'candidate', 'h3'),
                                 test_target(fixture.port, sha256='0' * 64), None)
            self.assertEqual(result['error'], 'body_hash_mismatch')
        with Fixture('truncated') as fixture:
            result = bench.fetch(test_endpoint(fixture.port, 'candidate', 'candidate', 'h3'),
                                 test_target(fixture.port), None)
            self.assertFalse(result['ok'])
            self.assertIn(result['error'], {'body_truncated', 'connection_or_http_error', 'total_timeout'})

    def test_first_byte_is_not_header_completion_and_total_deadline(self) -> None:
        with Fixture('delayed_headers') as fixture:
            started = time.perf_counter()
            result = bench.fetch(test_endpoint(fixture.port, 'candidate', 'candidate', 'h3'),
                                 test_target(fixture.port), None)
            elapsed_ms = (time.perf_counter() - started) * 1000
            self.assertTrue(result['ok'], result)
            self.assertGreater(elapsed_ms - result['ttfb_ms'], 150)
        with Fixture('late_first_byte') as fixture:
            started = time.perf_counter()
            result = bench.fetch(test_endpoint(fixture.port, 'candidate', 'candidate', 'h3'),
                                 test_target(fixture.port, timeout_seconds=0.15), None)
            self.assertEqual(result['error'], 'total_timeout')
            self.assertLess(time.perf_counter() - started, 0.35)

    def test_report_redacts_credentials_and_requires_five_successes(self) -> None:
        with Fixture('normal') as fixture, tempfile.TemporaryDirectory() as directory:
            credentials_path = Path(directory) / 'credentials.json'
            credentials_path.write_text(json.dumps({'auth': {'username': 'secret-user',
                                                              'password': 'secret-password'}}))
            credentials_path.chmod(0o600)
            endpoint1 = test_endpoint(fixture.port, 'candidate', 'candidate', 'h3')
            endpoint2 = test_endpoint(fixture.port, 'hysteria', 'hysteria2', 'udp')
            endpoint1['credential_ref'] = 'auth'
            endpoint2['credential_ref'] = 'auth'
            raw = {'schema_version': 1, 'target': {'url': f'http://127.0.0.1:{fixture.port}/fixed?private=query-secret'},
                   'rounds': 5, 'credentials_file': str(credentials_path),
                   'endpoints': [endpoint1, endpoint2],
                   'comparisons': [{'candidate': 'candidate', 'baseline': 'hysteria'}]}
            config = bench.validate_config(raw)
            report = bench.run(config, '/fixture/config.json')
            serialized = json.dumps(report)
            self.assertNotIn('secret-user', serialized)
            self.assertNotIn('secret-password', serialized)
            self.assertNotIn(str(credentials_path), serialized)
            self.assertNotIn('query-secret', serialized)
            self.assertTrue(report['payload_consistent'])
            self.assertIn(report['comparisons'][0]['status'], {'pass', 'fail'})
            self.assertNotEqual(report['comparisons'][0]['status'], 'indeterminate')
            self.assertIsNotNone(report['results']['candidate']['summary']['ttfb_ms']['p95'])
            self.assertIsNotNone(report['results']['candidate']['summary']['goodput_mbps']['p50'])
            self.assertFalse(report['run']['endpoint_versions_verified'])
            summary = {'attempts': 5, 'successes': 1, 'success_rate': 0.2,
                       'ttfb_ms': {'p95': 10.0}, 'goodput_mbps': {'p50': 10.0}}
            self.assertEqual(bench.compare(summary, summary, 5)['status'], 'indeterminate')

    def test_socks5_auth_negotiation_and_payload_consistency_gate(self) -> None:
        with Fixture('require_auth') as fixture, tempfile.TemporaryDirectory() as directory:
            credentials_path = Path(directory) / 'credentials.json'
            credentials_path.write_text(json.dumps({'auth': {'username': 'bench-user',
                                                              'password': 'bench-password'}}))
            credentials_path.chmod(0o600)
            endpoint = test_endpoint(fixture.port, 'candidate', 'candidate', 'h3')
            endpoint['credential_ref'] = 'auth'
            credentials = bench.load_credentials(str(credentials_path))
            result = bench.fetch(endpoint, test_target(fixture.port), credentials['auth'])
            self.assertTrue(result['ok'], result)
        with Fixture('unadvertised_method') as fixture:
            result = bench.fetch(test_endpoint(fixture.port, 'candidate', 'candidate', 'h3'),
                                 test_target(fixture.port), None)
            self.assertFalse(result['ok'])
        with Fixture('normal') as first, Fixture('different_payload') as second:
            endpoint1 = test_endpoint(first.port, 'candidate', 'candidate', 'h3')
            endpoint2 = test_endpoint(second.port, 'hysteria', 'hysteria2', 'udp')
            raw = {'schema_version': 1,
                   'target': {'url': f'http://127.0.0.1:{first.port}/fixed'}, 'rounds': 5,
                   'endpoints': [endpoint1, endpoint2],
                   'comparisons': [{'candidate': 'candidate', 'baseline': 'hysteria'}]}
            report = bench.run(bench.validate_config(raw), '/fixture/config.json')
            self.assertFalse(report['payload_consistent'])
            self.assertEqual(report['comparisons'][0]['status'], 'indeterminate')

    def test_host_header_formats_ports_and_ipv6(self) -> None:
        self.assertEqual(bench.host_header('https', 'example.test', 443), 'example.test')
        self.assertEqual(bench.host_header('http', 'example.test', 8080), 'example.test:8080')
        self.assertEqual(bench.host_header('https', '2001:db8::1', 8443), '[2001:db8::1]:8443')
        with Fixture('normal') as fixture:
            endpoint = test_endpoint(fixture.port, 'candidate', 'candidate', 'h3')
            target = test_target(fixture.port)
            target.update({'host': '::1', 'port': fixture.port})
            result = bench.fetch(endpoint, target, None)
            self.assertTrue(result['ok'], result)

    def test_slow_trickle_cannot_extend_deadline_and_tls_rejects_untrusted_cert(self) -> None:
        with Fixture('slow_trickle') as fixture:
            started = time.perf_counter()
            result = bench.fetch(test_endpoint(fixture.port, 'candidate', 'candidate', 'h3'),
                                 test_target(fixture.port, timeout_seconds=0.2), None)
            self.assertEqual(result['error'], 'total_timeout')
            self.assertLess(time.perf_counter() - started, 0.4)
        with Fixture('tls_certificate') as fixture:
            target = test_target(fixture.port)
            target.update({'scheme': 'https', 'port': fixture.port})
            result = bench.fetch(test_endpoint(fixture.port, 'candidate', 'candidate', 'h3'), target, None)
            self.assertEqual(result['error'], 'tls_certificate')

    def test_noninferiority_thresholds_are_deterministic(self) -> None:
        baseline = {'attempts': 5, 'successes': 5, 'success_rate': 1.0,
                    'ttfb_ms': {'p95': 100.0}, 'goodput_mbps': {'p50': 100.0}}
        candidate = {'attempts': 5, 'successes': 5, 'success_rate': 1.0,
                     'ttfb_ms': {'p95': 110.0}, 'goodput_mbps': {'p50': 95.0}}
        self.assertEqual(bench.compare(candidate, baseline, 5)['status'], 'pass')
        candidate['ttfb_ms']['p95'] = 110.1
        self.assertEqual(bench.compare(candidate, baseline, 5)['status'], 'fail')

    def test_validation_rejects_remote_proxy_nonfinite_and_bool_timeout(self) -> None:
        base = {'schema_version': 1, 'target': {'url': 'https://example.invalid/object'}, 'rounds': 5,
                'endpoints': [test_endpoint(1081, 'candidate', 'candidate', 'h3'),
                              test_endpoint(1082, 'hysteria', 'hysteria2', 'udp')],
                'comparisons': [{'candidate': 'candidate', 'baseline': 'hysteria'}]}
        for proxy_host in ('192.0.2.1', 'proxy.example.invalid'):
            altered = json.loads(json.dumps(base))
            altered['endpoints'][0]['proxy_host'] = proxy_host
            with self.assertRaises(bench.ConfigError):
                bench.validate_config(altered)
        for timeout in (True, float('nan'), float('inf')):
            altered = json.loads(json.dumps(base))
            altered['target']['timeout_seconds'] = timeout
            with self.assertRaises(bench.ConfigError):
                bench.validate_config(altered)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--serve', type=int)
    parser.add_argument('--mode', default='normal')
    arguments, unittest_args = parser.parse_known_args()
    if arguments.serve is not None:
        serve(arguments.serve, arguments.mode)
    else:
        unittest.main(argv=[sys.argv[0], *unittest_args])
