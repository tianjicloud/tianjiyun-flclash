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

/// Never starts the sampling timers that outlive a test in a shared isolate.
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
