import 'package:fl_clash/common/preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerUpdateFailuresProvider =
    FutureProvider<Map<String, Map<String, Object?>>>((ref) {
      return preferences.getProviderUpdateFailures();
    });
