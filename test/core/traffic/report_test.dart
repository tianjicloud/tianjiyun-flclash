import 'dart:async';

import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/traffic/report.dart';
import 'package:fl_clash/core/traffic/service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/traffic_stats_store.dart';

const _endpoint = 'https://report.example/v1';
const _identity = 'profile-1|fingerprint-1';

TrafficSnapshot _snapshot({int epoch = 1, int proxyUp = 0}) {
  return TrafficSnapshot(
    version: 1,
    epoch: epoch,
    mainlandDirect: TrafficBytes.zero,
    proxy: TrafficBytes(up: proxyUp),
    otherDirect: TrafficBytes.zero,
  );
}

class _Clock {
  _Clock(this.now);

  DateTime now;

  DateTime call() => now;

  void advance(Duration duration) {
    now = now.add(duration);
  }
}

class _Source {
  _Source(this.snapshot);

  TrafficSnapshot snapshot;
  Completer<void>? gate;

  Future<TrafficSnapshot> read() async {
    final gate = this.gate;
    if (gate != null) await gate.future;
    return snapshot;
  }
}

class _Auth implements TrafficReportAuthenticator {
  _Auth([this.token = 'Bearer scoped-token']);

  String? token;
  Exception? error;
  Completer<void>? gate;
  Completer<void>? started;
  final scopes = <String>[];
  final installations = <String>[];
  final invalidations =
      <({String endpoint, String installationId, String scopeKey})>[];
  var calls = 0;

  @override
  Future<String?> authorizationFor(
    Uri endpoint, {
    required String installationId,
    required String scopeKey,
  }) async {
    calls++;
    scopes.add(scopeKey);
    installations.add(installationId);
    final started = this.started;
    if (started != null && !started.isCompleted) started.complete();
    final gate = this.gate;
    if (gate != null) await gate.future;
    final error = this.error;
    if (error != null) throw error;
    return token;
  }

  @override
  void invalidate({
    required Uri endpoint,
    required String installationId,
    required String scopeKey,
  }) {
    invalidations.add((
      endpoint: endpoint.toString(),
      installationId: installationId,
      scopeKey: scopeKey,
    ));
  }
}

TrafficReportAck _ackFor(TrafficReportBatch batch) {
  return TrafficReportAck(
    version: TrafficReportAck.protocolVersion,
    accepted: [
      for (final stream in batch.streams)
        TrafficReportAccepted(
          streamId: stream.streamId,
          revision: stream.revision,
        ),
    ],
    receivedAt: DateTime.utc(2026, 11, 7, 12),
  );
}

class _RecordingTransport implements TrafficReportTransport {
  final attempts = <TrafficReportBatch>[];
  final authorizations = <String>[];
  bool fail = false;
  TrafficReportException? error;
  TrafficReportAck Function(TrafficReportBatch batch)? ack;
  Completer<void>? gate;
  Completer<void>? started;

  @override
  Future<TrafficReportAck> send(
    TrafficReportBatch batch, {
    required Uri endpoint,
    required String authorization,
    required Duration timeout,
  }) async {
    final started = this.started;
    if (started != null && !started.isCompleted) started.complete();
    final gate = this.gate;
    if (gate != null) await gate.future;
    attempts.add(batch);
    authorizations.add(authorization);
    final error = this.error;
    if (error != null) throw error;
    if (fail) {
      throw const TrafficReportException('failed');
    }
    return ack?.call(batch) ?? _ackFor(batch);
  }
}

Future<TrafficAccountingService> _service(
  MemoryTrafficStatsStore store,
  _Clock clock,
  _Source source,
) async {
  final service = TrafficAccountingService(
    store: store,
    readSnapshot: source.read,
    clock: clock.call,
    sampleInterval: const Duration(hours: 1),
    flushInterval: const Duration(hours: 1),
  );
  await service.start();
  return service;
}

TrafficReportOptions _options(
  _Auth auth, {
  Duration timeout = const Duration(seconds: 5),
  String identityKey = _identity,
}) {
  return TrafficReportOptions(
    endpoint: Uri.parse(_endpoint),
    authenticator: auth,
    identityKey: identityKey,
    interval: const Duration(minutes: 5),
    timeout: timeout,
  );
}

void main() {
  test('only a clean HTTPS origin is accepted', () {
    expect(
      validTrafficReportEndpoint(Uri.parse('https://report.example/v1')),
      isTrue,
    );
    expect(
      validTrafficReportEndpoint(Uri.parse('http://report.example/v1')),
      isFalse,
    );
    expect(
      validTrafficReportEndpoint(Uri.parse('https://user@report.example/v1')),
      isFalse,
    );
    expect(
      validTrafficReportEndpoint(
        Uri.parse('https://report.example/v1?token=1'),
      ),
      isFalse,
    );
    expect(
      validTrafficReportEndpoint(Uri.parse('https://report.example/v1#x')),
      isFalse,
    );
    expect(validTrafficReportEndpoint(Uri.parse('https:///v1')), isFalse);
  });

  test('an incomplete acknowledgement is retried unchanged', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final transport = _RecordingTransport()
      ..ack = ((batch) => TrafficReportAck(
        version: TrafficReportAck.protocolVersion,
        accepted: const [],
        receivedAt: DateTime.utc(2026, 11, 7, 12),
      ));
    service.configureReporting(
      options: _options(_Auth()),
      transport: transport,
    );

    await service.upload();
    expect(transport.attempts.single.streams.single.revision, 1);

    await service.upload();
    expect(transport.attempts.length, 1, reason: 'backoff must hold the retry');

    clock.advance(const Duration(minutes: 11));
    transport.ack = null;
    await service.upload();
    expect(transport.attempts.length, 2);
    expect(transport.attempts.last.streams.single.revision, 1);
  });

  test('the acknowledgement must match every sent stream', () {
    final batch = TrafficReportBatch(
      installationId: 'a' * 32,
      sentAt: DateTime.utc(2026, 11, 7),
      streams: const [
        TrafficReportStream(
          streamId: 'one',
          day: '2026-11-07',
          scopeKey: 'bbbbbbbbbbbbbbbbbbbbbbbb',
          revision: 2,
          allocation: TrafficAllocation.zero,
        ),
        TrafficReportStream(
          streamId: 'two',
          day: '2026-11-07',
          scopeKey: 'bbbbbbbbbbbbbbbbbbbbbbbb',
          revision: 3,
          allocation: TrafficAllocation.zero,
        ),
      ],
    );
    TrafficReportAck ack(List<TrafficReportAccepted> accepted) {
      return TrafficReportAck(
        version: 1,
        accepted: accepted,
        receivedAt: DateTime.utc(2026, 11, 7),
      );
    }

    expect(
      ack(const [
        TrafficReportAccepted(streamId: 'one', revision: 2),
        TrafficReportAccepted(streamId: 'two', revision: 3),
      ]).covers(batch),
      isTrue,
    );
    expect(
      ack(const [
        TrafficReportAccepted(streamId: 'one', revision: 2),
      ]).covers(batch),
      isFalse,
    );
    expect(
      ack(const [
        TrafficReportAccepted(streamId: 'one', revision: 2),
        TrafficReportAccepted(streamId: 'one', revision: 2),
      ]).covers(batch),
      isFalse,
    );
    expect(
      ack(const [
        TrafficReportAccepted(streamId: 'one', revision: 1),
        TrafficReportAccepted(streamId: 'two', revision: 3),
      ]).covers(batch),
      isFalse,
    );
    expect(
      ack(const [
        TrafficReportAccepted(streamId: 'one', revision: 2),
        TrafficReportAccepted(streamId: 'two', revision: 4),
      ]).covers(batch),
      isTrue,
    );
  });

  test('a malformed or unsuccessful acknowledgement is rejected', () {
    expect(
      () => parseTrafficReportAck('not json'),
      throwsA(isA<TrafficReportException>()),
    );
    expect(
      () => parseTrafficReportAck(
        '{"version":2,"accepted":[],"received-at":"2026-11-07T12:00:00Z"}',
      ),
      throwsA(isA<TrafficReportException>()),
    );
    expect(
      () => parseTrafficReportAck(
        '{"version":1,"accepted":[{"stream-id":"one","revision":0}],'
        '"received-at":"2026-11-07T12:00:00Z"}',
      ),
      throwsA(isA<TrafficReportException>()),
    );
    expect(
      () => parseTrafficReportAck(
        '{"version":1,"accepted":[{"stream-id":"one","revision":1}]}',
      ),
      throwsA(isA<TrafficReportException>()),
    );
  });

  test('fractional protocol fields cannot acknowledge a report', () {
    for (final body in [
      '{"version":1.5,"accepted":[],"received-at":"2026-11-07T12:00:00Z"}',
      '{"version":1,"accepted":[{"stream-id":"one","revision":1.5}],"received-at":"2026-11-07T12:00:00Z"}',
    ]) {
      expect(
        () => parseTrafficReportAck(body),
        throwsA(isA<TrafficReportException>()),
      );
    }
  });

  test('an invalid endpoint never records', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);
    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final transport = _RecordingTransport();
    service.configureReporting(
      options: TrafficReportOptions(
        endpoint: Uri.parse('http://report.example/v1'),
        authenticator: _Auth(),
        identityKey: _identity,
      ),
      transport: transport,
    );
    await service.upload();

    expect(transport.attempts, isEmpty);
  });

  test('a disabled reporter sends nothing', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);
    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final transport = _RecordingTransport();
    service.configureReporting(
      options: _options(_Auth(null)),
      transport: transport,
    );
    await service.upload();

    expect(transport.attempts, isEmpty);
  });

  test('a failed revision retries unchanged after backoff', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final transport = _RecordingTransport()..fail = true;
    service.configureReporting(
      options: _options(_Auth()),
      transport: transport,
    );

    await service.upload();
    expect(transport.attempts.single.streams.single.revision, 1);

    await service.upload();
    expect(transport.attempts.length, 1, reason: 'backoff must hold the retry');

    clock.advance(const Duration(minutes: 11));
    transport.fail = false;
    await service.upload();
    expect(transport.attempts.length, 2);
    expect(transport.attempts.last.streams.single.revision, 1);

    await service.upload();
    expect(
      transport.attempts.length,
      2,
      reason: 'acknowledged revision is done',
    );
  });

  test('a 401 drops the cached credential for the next attempt', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final auth = _Auth();
    final transport = _RecordingTransport()
      ..error = const TrafficReportUnauthorizedException();
    service.configureReporting(options: _options(auth), transport: transport);

    await service.upload();
    expect(auth.invalidations, hasLength(1));
    expect(auth.invalidations.single.installationId, isNotEmpty);
    expect(auth.invalidations.single.scopeKey, isNotEmpty);
  });

  test(
    'an acknowledgement does not drop bytes collected while in flight',
    () async {
      final store = MemoryTrafficStatsStore();
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final source = _Source(_snapshot());
      final service = await _service(store, clock, source);
      addTearDown(service.dispose);

      await service.sample();
      source.snapshot = _snapshot(proxyUp: 10);
      await service.sample();
      source.snapshot = _snapshot(proxyUp: 15);
      await service.sample();

      final transport = _RecordingTransport()
        ..gate = Completer<void>()
        ..started = Completer<void>();
      service.configureReporting(
        options: _options(_Auth()),
        transport: transport,
      );

      final upload = service.upload();
      await transport.started!.future;

      source.snapshot = _snapshot(proxyUp: 25);
      await service.sample();

      transport.gate!.complete();
      await upload;
      expect(transport.attempts.single.streams.single.revision, 2);

      await service.upload();
      expect(transport.attempts.length, 2);
      expect(transport.attempts.last.streams.single.revision, 3);
    },
  );

  test('concurrent uploads run one authenticator and one send', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final auth = _Auth()..gate = Completer<void>();
    auth.started = Completer<void>();
    final transport = _RecordingTransport();
    service.configureReporting(options: _options(auth), transport: transport);

    final first = service.upload();
    final second = service.upload();
    await auth.started!.future;
    await second;
    auth.gate!.complete();
    await first;

    expect(auth.calls, 1);
    expect(transport.attempts.length, 1);
  });

  test('an authenticator failure is caught and not sent', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final auth = _Auth()..error = Exception('auth unavailable');
    final transport = _RecordingTransport();
    service.configureReporting(options: _options(auth), transport: transport);

    await service.upload();
    expect(transport.attempts, isEmpty);
    await service.upload();
    expect(auth.calls, 1, reason: 'failure is backed off');
  });

  test('an injected transport cannot outlive the service timeout', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final transport = _RecordingTransport()..gate = Completer<void>();
    service.configureReporting(
      options: _options(_Auth(), timeout: const Duration(milliseconds: 20)),
      transport: transport,
    );

    await service.upload();
    expect(transport.attempts, isEmpty);
  });

  test('dispose during authenticator work sends nothing', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final auth = _Auth()..gate = Completer<void>();
    auth.started = Completer<void>();
    final transport = _RecordingTransport();
    service.configureReporting(options: _options(auth), transport: transport);

    final upload = service.upload();
    await auth.started!.future;
    service.dispose();
    auth.gate!.complete();
    await upload;

    expect(transport.attempts, isEmpty);
  });

  test('pending records from another local scope are not uploaded', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);

    await service.setScope('a');
    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    await service.setScope('b');
    source.snapshot = _snapshot(proxyUp: 15);
    await service.sample();

    final auth = _Auth();
    final transport = _RecordingTransport();
    service.configureReporting(options: _options(auth), transport: transport);

    await service.upload();
    expect(transport.attempts.single.streams.single.allocation.proxy.up, 5);
    final scopeB = auth.scopes.single;

    await service.setScope('a');
    await service.sample();
    await service.upload();

    expect(transport.attempts.length, 2);
    expect(transport.attempts.last.streams.single.allocation.proxy.up, 10);
    expect(auth.scopes.last, isNot(scopeB));
  });

  test(
    'a scope switch during a delayed authenticator aborts the send',
    () async {
      final store = MemoryTrafficStatsStore();
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final source = _Source(_snapshot());
      final service = await _service(store, clock, source);
      addTearDown(service.dispose);

      await service.setScope('a');
      await service.sample();
      source.snapshot = _snapshot(proxyUp: 10);
      await service.sample();

      final auth = _Auth()..gate = Completer<void>();
      auth.started = Completer<void>();
      final transport = _RecordingTransport();
      service.configureReporting(options: _options(auth), transport: transport);

      final upload = service.upload();
      await auth.started!.future;
      await service.setScope('b');
      source.snapshot = _snapshot(proxyUp: 15);
      await service.sample();
      auth.gate!.complete();
      await upload;

      expect(transport.attempts, isEmpty);
    },
  );

  test(
    'a same-profile credential change during auth aborts the send',
    () async {
      final store = MemoryTrafficStatsStore();
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final source = _Source(_snapshot());
      final service = await _service(store, clock, source);
      addTearDown(service.dispose);

      await service.setScope('profile-1');
      await service.sample();
      source.snapshot = _snapshot(proxyUp: 10);
      await service.sample();

      final auth = _Auth()..gate = Completer<void>();
      auth.started = Completer<void>();
      final transport = _RecordingTransport();
      service.configureReporting(
        options: _options(auth, identityKey: 'profile-1|old'),
        transport: transport,
      );

      final upload = service.upload();
      await auth.started!.future;
      service.configureReporting(
        options: _options(_Auth(), identityKey: 'profile-1|rotated'),
        transport: transport,
      );
      auth.gate!.complete();
      await upload;

      expect(transport.attempts, isEmpty);
    },
  );

  test('stopping reporting aborts an upload waiting on auth', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final auth = _Auth()..gate = Completer<void>();
    auth.started = Completer<void>();
    final transport = _RecordingTransport();
    service.configureReporting(options: _options(auth), transport: transport);

    final upload = service.upload();
    await auth.started!.future;
    service.stopReporting();
    auth.gate!.complete();
    await upload;

    expect(transport.attempts, isEmpty);
  });

  test(
    'an upload waits for a slow sample before it captures a batch',
    () async {
      final store = MemoryTrafficStatsStore();
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final source = _Source(_snapshot());
      final service = await _service(store, clock, source);
      addTearDown(service.dispose);

      await service.sample();
      source.snapshot = _snapshot(proxyUp: 10);
      source.gate = Completer<void>();
      final sample = service.sample();

      final auth = _Auth();
      final transport = _RecordingTransport();
      service.configureReporting(options: _options(auth), transport: transport);
      final upload = service.upload();
      await Future<void>.delayed(Duration.zero);
      expect(transport.attempts, isEmpty);

      source.gate!.complete();
      await sample;
      await upload;
      source.gate = null;

      expect(transport.attempts.single.streams.single.allocation.proxy.up, 10);
    },
  );

  test('the request carries no domains or history', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_snapshot());
    final service = await _service(store, clock, source);
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    final transport = _RecordingTransport();
    service.configureReporting(
      options: _options(_Auth()),
      transport: transport,
    );
    await service.upload();

    final json = transport.attempts.single.toJson();
    expect(
      json.keys,
      containsAll(['version', 'installation-id', 'sent-at', 'streams']),
    );
    final stream = (json['streams'] as List).single as Map<String, Object?>;
    expect(
      stream.keys,
      containsAll([
        'stream-id',
        'day',
        'scope-key',
        'revision',
        'mainland-direct',
        'proxy',
        'other-direct',
      ]),
    );
    expect(json.toString(), isNot(contains('example.com')));
  });
}
