import 'dart:convert';

import 'package:fl_clash/core/traffic/auth.dart';
import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/traffic/report.dart';
import 'package:flutter_test/flutter_test.dart';

// Deterministic v1 payloads shared with the server implementation. No network
// or production identifier is involved.
const installationId = '0123456789abcdef0123456789abcdef';
const scopeKey = '0123456789abcdef01234567';
const day = '2026-11-07';
const streamId =
    'febdfe66c5a224496e51f2374948e00e3e3891dd294a9eeed8c124fca62809f6';
const sessionToken = 'synthetic-session-token';
const sessionExpiresAt = 1794053700;

const sessionRequest = {
  'version': 1,
  'installation-id': installationId,
  'scope-key': scopeKey,
};

const sessionResponse = {
  'version': 1,
  'token': sessionToken,
  'expires-at': sessionExpiresAt,
};

const reportRequest = {
  'version': 1,
  'installation-id': installationId,
  'sent-at': '2026-11-07T12:00:00.000Z',
  'streams': [
    {
      'stream-id': streamId,
      'day': day,
      'scope-key': scopeKey,
      'revision': 3,
      'mainland-direct': {'up': 100, 'down': 200},
      'proxy': {'up': 300, 'down': 400},
      'other-direct': {'up': 500, 'down': 600},
    },
  ],
};

const reportResponse = {
  'version': 1,
  'accepted': [
    {'stream-id': streamId, 'revision': 3},
  ],
  'received-at': '2026-11-07T12:00:05.000Z',
};

TrafficReportBatch _batch() {
  return TrafficReportBatch(
    installationId: installationId,
    sentAt: DateTime.utc(2026, 11, 7, 12),
    streams: const [
      TrafficReportStream(
        streamId: streamId,
        day: day,
        scopeKey: scopeKey,
        revision: 3,
        allocation: TrafficAllocation(
          mainlandDirect: TrafficBytes(up: 100, down: 200),
          proxy: TrafficBytes(up: 300, down: 400),
          otherDirect: TrafficBytes(up: 500, down: 600),
        ),
      ),
    ],
  );
}

void main() {
  test('the report payload is the shared v1 fixture', () {
    expect(trafficStreamId(installationId, day, scopeKey), streamId);
    expect(_batch().toJson(), reportRequest);
    expect(json.decode(json.encode(reportRequest)), reportRequest);
  });

  test('the session response parses into a short-lived credential', () {
    final session = parseTrafficSessionResponse(
      json.encode(sessionResponse),
      now: DateTime.utc(2026, 11, 7, 12),
    );
    expect(session.token, sessionToken);
    expect(session.expiresAt, DateTime.utc(2026, 11, 7, 12, 15));
  });

  test('the session request body is stable and contains no user id', () {
    expect(
      sessionRequest.keys,
      unorderedEquals(['version', 'installation-id', 'scope-key']),
    );
    expect(sessionRequest.toString(), isNot(contains('user')));
    expect(sessionRequest['installation-id'], hasLength(32));
    expect(sessionRequest['scope-key'], hasLength(24));
  });

  test('the acknowledgement completes the batch', () {
    final ack = parseTrafficReportAck(json.encode(reportResponse));
    expect(ack.covers(_batch()), isTrue);
    expect(ack.receivedAt, DateTime.utc(2026, 11, 7, 12, 0, 5));
  });
}
