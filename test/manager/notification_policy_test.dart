import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/manager/notification_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('notificationRoutePage', () {
    test('maps every supported business route', () {
      expect(notificationRoutePage('lines'), PageLabel.proxies);
      expect(notificationRoutePage('residential'), PageLabel.dashboard);
      expect(notificationRoutePage('residentialRetry'), PageLabel.dashboard);
      expect(notificationRoutePage('outboundMode'), PageLabel.tools);
      expect(notificationRoutePage('subscription'), PageLabel.profiles);
      expect(notificationRoutePage('unknown'), isNull);
      expect(businessNotificationRoutePage('lines', business: false), isNull);
      expect(
        businessNotificationRoutePage('lines', business: true),
        PageLabel.proxies,
      );
    });
  });

  group('ResidentialFailureTracker', () {
    final start = DateTime(2026, 11, 12);

    test('notifies on the third consecutive failure', () {
      final tracker = ResidentialFailureTracker();
      expect(_observe(tracker, start), isFalse);
      expect(_observe(tracker, start), isFalse);
      expect(_observe(tracker, start), isTrue);
    });

    test('success and exit changes clear failures', () {
      final tracker = ResidentialFailureTracker();
      _observe(tracker, start);
      _observe(tracker, start);
      tracker.observe(
        exit: 'Tokyo',
        failed: false,
        appVisible: false,
        now: start,
      );
      expect(_observe(tracker, start), isFalse);
      tracker.observe(
        exit: 'Osaka',
        failed: true,
        appVisible: false,
        now: start,
      );
      expect(tracker.failures, 1);
    });

    test('deduplicates for thirty minutes and suppresses while visible', () {
      final tracker = ResidentialFailureTracker();
      expect(_observe(tracker, start), isFalse);
      expect(_observe(tracker, start), isFalse);
      expect(_observe(tracker, start), isTrue);
      expect(
        _observe(tracker, start.add(const Duration(minutes: 29))),
        isFalse,
      );
      expect(_observe(tracker, start.add(const Duration(minutes: 30))), isTrue);
      final foreground = ResidentialFailureTracker();
      for (var i = 0; i < 3; i++) {
        expect(
          foreground.observe(
            exit: 'Tokyo',
            failed: true,
            appVisible: true,
            now: start,
          ),
          isFalse,
        );
      }
    });
  });

  group('subscription expiry notice', () {
    test('sends only for one through seven days and once each day', () {
      for (final days in [7, 1]) {
        expect(
          shouldSendSubscriptionExpiry(
            daysLeft: days,
            lastSentDay: null,
            today: 20261112,
          ),
          isTrue,
        );
      }
      for (final days in [0, -1]) {
        expect(
          shouldSendSubscriptionExpiry(
            daysLeft: days,
            lastSentDay: null,
            today: 20261112,
          ),
          isFalse,
        );
      }
      expect(
        shouldSendSubscriptionExpiry(
          daysLeft: 1,
          lastSentDay: 20261112,
          today: 20261112,
        ),
        isFalse,
      );
      expect(
        shouldSendSubscriptionExpiry(
          daysLeft: 1,
          lastSentDay: 20261112,
          today: 20261113,
        ),
        isTrue,
      );
    });
  });
}

bool _observe(ResidentialFailureTracker tracker, DateTime now) =>
    tracker.observe(exit: 'Tokyo', failed: true, appVisible: false, now: now);
