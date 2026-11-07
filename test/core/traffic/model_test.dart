import 'package:fl_clash/core/traffic/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a snapshot reads all three categories', () {
    final snapshot = TrafficSnapshot.fromJson({
      'version': 1,
      'epoch': 42,
      'mainland-direct': {'up': 100, 'down': 200},
      'proxy': {'up': 30, 'down': 40},
      'other-direct': {'up': 5, 'down': 6},
    });

    expect(snapshot.version, 1);
    expect(snapshot.epoch, 42);
    expect(snapshot.mainlandDirect.total, 300);
    expect(snapshot.proxy.total, 70);
    expect(snapshot.otherDirect.total, 11);
    expect(snapshot.countersBelow(snapshot), isFalse);
  });

  test('a counter decrease is visible', () {
    const previous = TrafficSnapshot(
      version: 1,
      epoch: 1,
      mainlandDirect: TrafficBytes(up: 10),
      proxy: TrafficBytes.zero,
      otherDirect: TrafficBytes.zero,
    );
    const next = TrafficSnapshot(
      version: 1,
      epoch: 1,
      mainlandDirect: TrafficBytes(up: 9),
      proxy: TrafficBytes.zero,
      otherDirect: TrafficBytes.zero,
    );

    expect(next.countersBelow(previous), isTrue);
  });

  test(
    'revision moves only when bytes move and acknowledgement is monotonic',
    () {
      const record = TrafficDayRecord(
        day: '2026-11-07',
        scopeKey: 'a',
        allocation: TrafficAllocation.zero,
      );

      final unchanged = record.accumulate(TrafficAllocation.zero);
      expect(unchanged.revision, 0);

      final first = unchanged.accumulate(
        const TrafficAllocation(mainlandDirect: TrafficBytes(up: 5)),
      );
      expect(first.revision, 1);
      expect(first.pending, isTrue);

      final acknowledged = first.acknowledge(1);
      expect(acknowledged.pending, isFalse);
      expect(acknowledged.acknowledge(0).acknowledgedRevision, 1);
      expect(acknowledged.acknowledge(3).acknowledgedRevision, 3);
    },
  );

  test('accounting state survives a JSON round trip', () {
    final state = TrafficAccountingState.empty('install-id').copyWith(
      scopeId: 'local-profile',
      scopeKey: 'scope-key',
      hasBaseline: true,
      baseline: const TrafficAllocation(proxy: TrafficBytes(up: 1, down: 2)),
      epoch: 7,
      days: {
        '2026-11-07|scope-key': const TrafficDayRecord(
          day: '2026-11-07',
          scopeKey: 'scope-key',
          allocation: TrafficAllocation(
            mainlandDirect: TrafficBytes(up: 3, down: 4),
          ),
          revision: 2,
          acknowledgedRevision: 1,
        ),
      },
    );

    final decoded = TrafficAccountingState.fromJson(
      state.toJson(),
      fallbackInstallationId: 'fallback',
    );

    expect(decoded.installationId, 'install-id');
    expect(decoded.scopeId, 'local-profile');
    expect(decoded.scopeKey, 'scope-key');
    expect(decoded.hasBaseline, isTrue);
    expect(decoded.epoch, 7);
    expect(decoded.baseline.proxy, const TrafficBytes(up: 1, down: 2));
    final record = decoded.days['2026-11-07|scope-key']!;
    expect(
      record.allocation.mainlandDirect,
      const TrafficBytes(up: 3, down: 4),
    );
    expect(record.revision, 2);
    expect(record.acknowledgedRevision, 1);
  });

  test('day keys are UTC days', () {
    expect(utcDayKey(DateTime.utc(2026, 11, 7, 23, 59)), '2026-11-07');
    expect(
      utcDayKey(DateTime.parse('2026-11-08T00:00:00+09:00')),
      '2026-11-07',
    );
  });

  test('stream ids are stable and opaque', () {
    final first = trafficStreamId('install', '2026-11-07', 'scope');
    final second = trafficStreamId('install', '2026-11-07', 'scope');
    final other = trafficStreamId('install', '2026-11-07', 'other');

    expect(first, second);
    expect(first, isNot(other));
    expect(first, hasLength(64));
  });
}
