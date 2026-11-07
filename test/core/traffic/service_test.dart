import 'dart:async';
import 'dart:convert';

import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/traffic/service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/traffic_stats_store.dart';

const _zero = TrafficSnapshot(
  version: 1,
  epoch: 1,
  mainlandDirect: TrafficBytes.zero,
  proxy: TrafficBytes.zero,
  otherDirect: TrafficBytes.zero,
);

TrafficSnapshot _snapshot({
  int epoch = 1,
  int mainlandUp = 0,
  int mainlandDown = 0,
  int proxyUp = 0,
  int proxyDown = 0,
  int otherUp = 0,
  int otherDown = 0,
}) {
  return TrafficSnapshot(
    version: 1,
    epoch: epoch,
    mainlandDirect: TrafficBytes(up: mainlandUp, down: mainlandDown),
    proxy: TrafficBytes(up: proxyUp, down: proxyDown),
    otherDirect: TrafficBytes(up: otherUp, down: otherDown),
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
  Exception? error;
  Completer<void>? gate;
  Completer<void>? started;

  Future<TrafficSnapshot> read() async {
    final started = this.started;
    if (started != null && !started.isCompleted) started.complete();
    final gate = this.gate;
    if (gate != null) await gate.future;
    final error = this.error;
    if (error != null) throw error;
    return snapshot;
  }
}

Future<TrafficAccountingService> _startService({
  required MemoryTrafficStatsStore store,
  required _Source source,
  required _Clock clock,
}) async {
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

void main() {
  test('the first snapshot and later deltas are counted once', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_zero);
    final service = await _startService(
      store: store,
      source: source,
      clock: clock,
    );
    addTearDown(service.dispose);

    await service.sample();
    expect(service.summary.value.todayMainlandDirect, 0);

    source.snapshot = _snapshot(
      mainlandUp: 100,
      mainlandDown: 20,
      proxyUp: 10,
      proxyDown: 5,
    );
    await service.sample();
    await service.sample();

    expect(service.summary.value.todayMainlandDirect, 120);
    expect(service.summary.value.todayProxy, 15);
  });

  test(
    'a new epoch or a counter decrease adds the new snapshot only',
    () async {
      final store = MemoryTrafficStatsStore();
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final source = _Source(_zero);
      final service = await _startService(
        store: store,
        source: source,
        clock: clock,
      );
      addTearDown(service.dispose);

      await service.sample();
      source.snapshot = _snapshot(mainlandUp: 100);
      await service.sample();
      expect(service.summary.value.todayMainlandDirect, 100);

      source.snapshot = _snapshot(epoch: 2, mainlandUp: 7);
      await service.sample();
      expect(service.summary.value.todayMainlandDirect, 107);

      source.snapshot = _snapshot(epoch: 2, mainlandUp: 10);
      await service.sample();
      expect(service.summary.value.todayMainlandDirect, 110);
    },
  );

  test('an invalid or negative snapshot is ignored', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_zero);
    final service = await _startService(
      store: store,
      source: source,
      clock: clock,
    );
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = const TrafficSnapshot(
      version: 99,
      epoch: 1,
      mainlandDirect: TrafficBytes(up: 5),
      proxy: TrafficBytes.zero,
      otherDirect: TrafficBytes.zero,
    );
    await service.sample();
    expect(service.summary.value.todayMainlandDirect, 0);

    source.snapshot = const TrafficSnapshot(
      version: 1,
      epoch: 1,
      mainlandDirect: TrafficBytes(up: -5),
      proxy: TrafficBytes.zero,
      otherDirect: TrafficBytes.zero,
    );
    await service.sample();
    expect(service.summary.value.todayMainlandDirect, 0);
  });

  test('a restart in the same epoch does not double count', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_zero);
    final first = await _startService(
      store: store,
      source: source,
      clock: clock,
    );

    await first.sample();
    source.snapshot = _snapshot(mainlandUp: 10);
    await first.sample();
    await first.flush();
    first.dispose();

    final second = await _startService(
      store: store,
      source: source,
      clock: clock,
    );
    addTearDown(second.dispose);
    await second.sample();

    expect(second.summary.value.todayMainlandDirect, 10);
  });

  test('a UTC day change attributes the new delta to the new day', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 23, 59, 55));
    final source = _Source(_zero);
    final service = await _startService(
      store: store,
      source: source,
      clock: clock,
    );
    addTearDown(service.dispose);

    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();
    expect(service.summary.value.todayProxy, 10);

    clock.advance(const Duration(seconds: 10));
    source.snapshot = _snapshot(proxyUp: 15);
    await service.sample();

    expect(service.summary.value.todayProxy, 5);
    expect(service.summary.value.monthProxy, 15);
  });

  test('the dashboard month aggregates local scopes', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_zero);
    final service = await _startService(
      store: store,
      source: source,
      clock: clock,
    );
    addTearDown(service.dispose);

    await service.setScope('a');
    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    await service.setScope('b');
    source.snapshot = _snapshot(proxyUp: 15);
    await service.sample();

    expect(service.summary.value.monthProxy, 15);
  });

  test('a failed snapshot during a scope switch keeps the old scope', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_zero);
    final service = await _startService(
      store: store,
      source: source,
      clock: clock,
    );
    addTearDown(service.dispose);

    await service.setScope('a');
    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    source.error = Exception('core unavailable');
    await service.setScope('b');
    expect(service.summary.value.monthProxy, 10);

    source.error = null;
    source.snapshot = _snapshot(proxyUp: 15);
    await service.sample();
    expect(service.summary.value.monthProxy, 10);

    source.snapshot = _snapshot(proxyUp: 20);
    await service.sample();
    expect(service.summary.value.monthProxy, 15);
  });

  test(
    'an unavailable snapshot does not invent bytes or reset the baseline',
    () async {
      final store = MemoryTrafficStatsStore();
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final source = _Source(_zero);
      final service = await _startService(
        store: store,
        source: source,
        clock: clock,
      );
      addTearDown(service.dispose);

      await service.sample();
      source.snapshot = _snapshot(mainlandUp: 10);
      await service.sample();
      source.error = Exception('core unavailable');
      await service.sample();
      source.error = null;
      await service.sample();
      expect(service.summary.value.todayMainlandDirect, 10);
    },
  );

  for (final returnToOriginal in [false, true]) {
    test(
      'scope changes during sampling discard ambiguity (return: $returnToOriginal)',
      () async {
        final store = MemoryTrafficStatsStore();
        final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
        final source = _Source(_zero);
        final service = await _startService(
          store: store,
          source: source,
          clock: clock,
        );
        addTearDown(service.dispose);

        await service.setScope('a');
        await service.sample();
        source.snapshot = _snapshot(proxyUp: 10);
        await service.sample();

        source.gate = Completer<void>();
        source.started = Completer<void>();
        final pendingSample = service.sample();
        await source.started!.future;

        final switched = service.setScope('b');
        final switchedBack = returnToOriginal ? service.setScope('a') : null;
        source.snapshot = _snapshot(proxyUp: 20);
        source.gate!.complete();
        await pendingSample;
        await switched;
        await switchedBack;

        source.snapshot = _snapshot(proxyUp: 25);
        await service.sample();
        await service.flush();

        final decoded = json.decode(store.value!) as Map<String, Object?>;
        final totals =
            (decoded['days'] as List).cast<Map<String, Object?>>().map((
              record,
            ) {
              final allocation = record['allocation'] as Map<String, Object?>;
              final proxy = allocation['proxy'] as Map<String, Object?>;
              return (proxy['up'] as num).toInt();
            }).toList()..sort();
        expect(totals, returnToOriginal ? [15] : [5, 10]);
      },
    );
  }

  test('a delayed store read does not race the first scope switch', () async {
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_zero);
    final readGate = Completer<void>();
    final store = _GatedStore(readGate.future);
    final service = TrafficAccountingService(
      store: store,
      readSnapshot: source.read,
      clock: clock.call,
      sampleInterval: const Duration(hours: 1),
      flushInterval: const Duration(hours: 1),
    );
    addTearDown(service.dispose);

    final start = service.start();
    final switchScope = service.setScope('b');
    readGate.complete();
    await start;
    await switchScope;
    await service.sample();
    source.snapshot = _snapshot(proxyUp: 10);
    await service.sample();

    expect(service.summary.value.monthProxy, 10);
  });

  test(
    'dispose during a sample does not notify the disposed summary',
    () async {
      final store = MemoryTrafficStatsStore();
      final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
      final source = _Source(_zero);
      final service = TrafficAccountingService(
        store: store,
        readSnapshot: source.read,
        clock: clock.call,
        sampleInterval: const Duration(hours: 1),
        flushInterval: const Duration(hours: 1),
      );
      await service.start();
      var notifications = 0;
      service.summary.addListener(() => notifications++);
      source.gate = Completer<void>();
      final pending = service.sample();
      service.dispose();
      final before = notifications;
      source.gate!.complete();
      await pending;
      expect(notifications, before);
    },
  );

  test('dispose cancels the timers', () async {
    final store = MemoryTrafficStatsStore();
    final clock = _Clock(DateTime.utc(2026, 11, 7, 12));
    final source = _Source(_zero);
    final service = TrafficAccountingService(
      store: store,
      readSnapshot: source.read,
      clock: clock.call,
      sampleInterval: const Duration(milliseconds: 20),
      flushInterval: const Duration(milliseconds: 20),
    );
    await service.start();
    await Future<void>.delayed(const Duration(milliseconds: 80));
    final writesBeforeDispose = store.writes;
    service.dispose();
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(store.writes, writesBeforeDispose);
  });
}

class _GatedStore extends MemoryTrafficStatsStore {
  _GatedStore(this.gate);

  final Future<void> gate;

  @override
  Future<String?> read() async {
    await gate;
    return super.read();
  }
}
