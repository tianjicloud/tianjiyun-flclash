import 'package:fl_clash/enum/enum.dart';

PageLabel? notificationRoutePage(String route) => switch (route) {
  'lines' => PageLabel.proxies,
  'residential' || 'residentialRetry' => PageLabel.dashboard,
  'outboundMode' => PageLabel.tools,
  'subscription' => PageLabel.profiles,
  _ => null,
};

PageLabel? businessNotificationRoutePage(
  String route, {
  required bool business,
}) => business ? notificationRoutePage(route) : null;

class ResidentialFailureTracker {
  String? _exit;
  int _failures = 0;
  DateTime? _lastSent;

  int get failures => _failures;

  bool observe({
    required String exit,
    required bool failed,
    required bool appVisible,
    required DateTime now,
  }) {
    if (exit != _exit) {
      _exit = exit;
      _failures = 0;
      _lastSent = null;
    }
    if (!failed) {
      _failures = 0;
      return false;
    }
    _failures += 1;
    if (_failures < 3 || appVisible) return false;
    if (_lastSent != null &&
        now.difference(_lastSent!) < const Duration(minutes: 30)) {
      return false;
    }
    _lastSent = now;
    return true;
  }

  bool get shouldSendOnBackground => _failures >= 3;
}

bool shouldSendSubscriptionExpiry({
  required int daysLeft,
  required int? lastSentDay,
  required int today,
}) => daysLeft > 0 && daysLeft <= 7 && lastSentDay != today;
