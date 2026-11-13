import 'package:flutter_riverpod/flutter_riverpod.dart';

final coreStartupErrorProvider =
    NotifierProvider<CoreStartupErrorNotifier, String?>(
      CoreStartupErrorNotifier.new,
    );

class CoreStartupErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void record(Object error) {
    state = error.toString();
  }

  void clear() {
    state = null;
  }
}
