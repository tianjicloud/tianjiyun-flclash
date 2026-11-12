import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/service_probe.dart' show routedOutbound;
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/manager/app_manager.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/preferences.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

const _subscriptionUrl = 'https://sub1.tianjiyun.org/s/test_subscription_001';

class _RecordingApp extends App {
  _RecordingApp({this.initialRoute}) : super.forTesting();

  final String? initialRoute;
  final notices = <({String kind, String title, String body, String route})>[];
  final routes = <String>[];

  @override
  Future<String?> takeInitialRoute() async => initialRoute;

  @override
  Future<bool> sendEventNotification({
    required String kind,
    required String title,
    required String body,
    required String channelName,
    required String route,
    String? changeText,
    String? retryText,
  }) async {
    notices.add((kind: kind, title: title, body: body, route: route));
    return true;
  }

  void dispatchRoute(String route) {
    routes.add(route);
    onRoute?.call(route);
  }
}

class _RecordingOutboundIpProbe extends OutboundIpProbe {
  final rechecks = <String>[];

  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState();

  @override
  Future<Map<String, ProbeAnswer<IpInfo>>> probe(
    String target,
    RouteState route,
  ) async => {};

  @override
  void recheck(String target) => rechecks.add(target);

  void emit(ProbePhase phase) {
    state = RoutedProbeState({
      ...state.entries,
      routedOutbound: ProbeEntry(phase: phase),
    });
  }
}

class _RecordingProxiesAction extends ProxiesAction {
  @override
  void updateGroupsDebounce([Duration? duration]) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUpAll(() async {
    await AppLocalizations.load(const Locale('en'));
  });

  tearDown(() => container.dispose());

  Profile businessProfile({String exit = 'Tokyo', int? expiry}) {
    final profile = Profile(
      id: 1,
      type: ProfileType.url,
      label: 'Tianji Plan',
      url: _subscriptionUrl,
      autoUpdateDuration: Duration.zero,
      subscriptionInfo: expiry == null
          ? null
          : SubscriptionInfo(expire: expiry),
    );
    return profile.copyWith(
      overrides: profile.overrides.copyWith(
        residentialExit: exit,
        residentialSubscriptionFingerprint: resolveTianjiProfile(
          profile,
        )!.fingerprint,
      ),
    );
  }

  Future<void> setUpManager({
    required WidgetTester tester,
    required _RecordingApp fakeApp,
    required Profile profile,
    bool business = true,
    DateTime Function()? clock,
  }) async {
    await mockPreferences();
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
        outboundIpProbeProvider.overrideWith(_RecordingOutboundIpProbe.new),
        proxiesActionProvider.overrideWith(_RecordingProxiesAction.new),
      ],
    );
    globalState.container = container;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          child: AppStateManager(
            appPlugin: fakeApp,
            isAndroid: true,
            clock: clock,
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    container.read(appVisibleProvider.notifier).value = true;
    if (!business) {
      container
          .read(profilesProvider.notifier)
          .put(profile.copyWith(url: 'https://example.com/subscription'));
    }
  }

  void finishCheck(WidgetTester tester, ProbePhase result) {
    final probe =
        container.read(outboundIpProbeProvider.notifier)
            as _RecordingOutboundIpProbe;
    container.read(coreStatusProvider.notifier).value = CoreStatus.connected;
    container.read(appVisibleProvider.notifier).value = false;
    probe.emit(ProbePhase.probing);
    probe.emit(result);
  }

  testWidgets('three failed routed residential checks notify once', (
    tester,
  ) async {
    final fakeApp = _RecordingApp();
    await setUpManager(
      tester: tester,
      fakeApp: fakeApp,
      profile: businessProfile(),
    );

    finishCheck(tester, ProbePhase.failed);
    finishCheck(tester, ProbePhase.failed);
    finishCheck(tester, ProbePhase.failed);
    await tester.pumpAndSettle();

    expect(fakeApp.notices.map((notice) => notice.kind), [
      'residentialFailure',
    ]);
    expect(fakeApp.notices.single.body, contains('Tokyo'));
  });

  testWidgets('same exit is deduplicated for thirty minutes', (tester) async {
    final fakeApp = _RecordingApp();
    var now = DateTime(2026, 11, 12, 12);
    await setUpManager(
      tester: tester,
      fakeApp: fakeApp,
      profile: businessProfile(),
      clock: () => now,
    );
    for (var i = 0; i < 3; i++) {
      finishCheck(tester, ProbePhase.failed);
    }
    await tester.pumpAndSettle();
    expect(fakeApp.notices, hasLength(1));

    for (var i = 0; i < 3; i++) {
      finishCheck(tester, ProbePhase.failed);
    }
    now = now.add(const Duration(minutes: 29));
    for (var i = 0; i < 3; i++) {
      finishCheck(tester, ProbePhase.failed);
    }
    await tester.pumpAndSettle();
    expect(fakeApp.notices, hasLength(1));

    now = now.add(const Duration(minutes: 1));
    for (var i = 0; i < 3; i++) {
      finishCheck(tester, ProbePhase.failed);
    }
    await tester.pumpAndSettle();
    expect(fakeApp.notices, hasLength(2));
  });

  testWidgets('a successful check and an exit change reset the failure count', (
    tester,
  ) async {
    final fakeApp = _RecordingApp();
    final profile = businessProfile();
    await setUpManager(tester: tester, fakeApp: fakeApp, profile: profile);
    finishCheck(tester, ProbePhase.failed);
    finishCheck(tester, ProbePhase.failed);
    finishCheck(tester, ProbePhase.fresh);
    finishCheck(tester, ProbePhase.failed);
    expect(fakeApp.notices, isEmpty);

    container
        .read(profilesProvider.notifier)
        .put(businessProfile(exit: 'Osaka'));
    await tester.pump();
    finishCheck(tester, ProbePhase.failed);
    finishCheck(tester, ProbePhase.failed);
    expect(fakeApp.notices, isEmpty);
  });

  testWidgets('foreground failures do not notify and non-business is ignored', (
    tester,
  ) async {
    final fakeApp = _RecordingApp();
    await setUpManager(
      tester: tester,
      fakeApp: fakeApp,
      profile: businessProfile(),
    );
    container.read(coreStatusProvider.notifier).value = CoreStatus.connected;
    final probe =
        container.read(outboundIpProbeProvider.notifier)
            as _RecordingOutboundIpProbe;
    for (var i = 0; i < 3; i++) {
      probe.emit(ProbePhase.probing);
      probe.emit(ProbePhase.failed);
    }
    await tester.pumpAndSettle();
    expect(fakeApp.notices, isEmpty);

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    await setUpManager(
      tester: tester,
      fakeApp: fakeApp,
      profile: businessProfile(),
      business: false,
    );
    for (var i = 0; i < 3; i++) {
      finishCheck(tester, ProbePhase.failed);
    }
    await tester.pumpAndSettle();
    expect(fakeApp.notices, isEmpty);
  });

  testWidgets(
    'route requests navigate and residential retry rechecks routed outbound',
    (tester) async {
      final fakeApp = _RecordingApp();
      await setUpManager(
        tester: tester,
        fakeApp: fakeApp,
        profile: businessProfile(),
      );
      final routes = {
        'lines': PageLabel.proxies,
        'outboundMode': PageLabel.tools,
        'subscription': PageLabel.profiles,
        'residential': PageLabel.dashboard,
        'residentialRetry': PageLabel.dashboard,
      };
      for (final entry in routes.entries) {
        fakeApp.dispatchRoute(entry.key);
        await tester.pump(Duration.zero);
        await tester.pump();
        expect(container.read(currentPageLabelProvider), entry.value);
        if (entry.key == 'residentialRetry') {
          expect(
            (container.read(outboundIpProbeProvider.notifier)
                    as _RecordingOutboundIpProbe)
                .rechecks,
            [routedOutbound],
          );
        }
      }
      expect(fakeApp.routes, routes.keys);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('cold-start route uses the same route handler', (tester) async {
    final fakeApp = _RecordingApp(initialRoute: 'subscription');
    await setUpManager(
      tester: tester,
      fakeApp: fakeApp,
      profile: businessProfile(),
    );
    expect(container.read(currentPageLabelProvider), PageLabel.profiles);
  });

  testWidgets('expiry notification uses seven-day bounds and daily dedupe', (
    tester,
  ) async {
    final now = DateTime.now();
    final fakeApp = _RecordingApp();
    await setUpManager(
      tester: tester,
      fakeApp: fakeApp,
      profile: businessProfile(
        expiry:
            now
                .add(const Duration(days: 7, minutes: 1))
                .millisecondsSinceEpoch ~/
            1000,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      fakeApp.notices.where((notice) => notice.kind == 'subscriptionExpiry'),
      hasLength(1),
    );

    final day = now.year * 10000 + now.month * 100 + now.day;
    await preferences.setEventDate('subscriptionExpiry', day);
    container
        .read(profilesProvider.notifier)
        .put(
          businessProfile(
            expiry:
                now
                    .add(const Duration(days: 7, minutes: 1))
                    .millisecondsSinceEpoch ~/
                1000,
          ).copyWith(label: 'Updated plan'),
        );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(
      fakeApp.notices.where((notice) => notice.kind == 'subscriptionExpiry'),
      hasLength(1),
    );
  });

  testWidgets('expiry does not notify with eight days remaining', (
    tester,
  ) async {
    final now = DateTime.now();
    final fakeApp = _RecordingApp();
    await setUpManager(
      tester: tester,
      fakeApp: fakeApp,
      profile: businessProfile(
        expiry:
            now
                .add(const Duration(days: 8, minutes: 1))
                .millisecondsSinceEpoch ~/
            1000,
      ),
    );
    expect(fakeApp.notices, isEmpty);
  });
}
