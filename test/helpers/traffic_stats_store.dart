import 'package:fl_clash/core/traffic/store.dart';

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
