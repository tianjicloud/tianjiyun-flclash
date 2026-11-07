import 'package:fl_clash/common/common.dart';

abstract interface class TrafficStatsStore {
  Future<String?> read();

  Future<void> write(String? value);
}

class PreferencesTrafficStatsStore implements TrafficStatsStore {
  const PreferencesTrafficStatsStore();

  @override
  Future<String?> read() => preferences.getTrafficAccounting();

  @override
  Future<void> write(String? value) => preferences.saveTrafficAccounting(value);
}
