import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/traffic/service.dart';
import 'package:fl_clash/core/traffic/store.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:riverpod/misc.dart' show Override;

class MemoryTrafficStatsStore implements TrafficStatsStore {
  MemoryTrafficStatsStore([this.value]);

  String? value;
  var writes = 0;
  Exception? readError;
  Exception? writeError;

  @override
  Future<String?> read() async {
    final error = readError;
    if (error != null) throw error;
    return value;
  }

  @override
  Future<void> write(String? value) async {
    final error = writeError;
    if (error != null) throw error;
    this.value = value;
    writes++;
  }
}

/// The real provider starts sampling timers as soon as preferences load, which
/// another file in the same test isolate may already have done; a test that
/// does not look at traffic overrides it with a service that never starts.
Override idleTrafficStatsOverride() => trafficStatsProvider.overrideWithValue(
  TrafficAccountingService(
    store: MemoryTrafficStatsStore(),
    readSnapshot: () async => const TrafficSnapshot(
      version: 1,
      epoch: 1,
      mainlandDirect: TrafficBytes.zero,
      proxy: TrafficBytes.zero,
      otherDirect: TrafficBytes.zero,
    ),
  ),
);
