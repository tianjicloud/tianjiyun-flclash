import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/core/traffic/service.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/business.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/preferences.dart';
import '../../helpers/test_app.dart';
import '../../helpers/test_profiles.dart';
import '../../helpers/traffic_stats_store.dart';

class _IdleIpProbe extends OutboundIpProbe {
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState({});

  @override
  void watch(String target) {}

  @override
  void unwatch(String target) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late TrafficAccountingService stats;

  setUp(() async {
    await mockPreferences();
    stats = TrafficAccountingService(
      store: MemoryTrafficStatsStore(),
      readSnapshot: () async => const TrafficSnapshot(
        version: 1,
        epoch: 1,
        mainlandDirect: TrafficBytes.zero,
        proxy: TrafficBytes.zero,
        otherDirect: TrafficBytes.zero,
      ),
    );
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(
          () => TestProfiles(const [
            Profile(
              id: 1,
              type: ProfileType.url,
              label: 'Tianji',
              url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
              autoUpdateDuration: Duration(days: 1),
            ),
          ]),
        ),
        outboundIpProbeProvider.overrideWith(_IdleIpProbe.new),
        trafficStatsProvider.overrideWithValue(stats),
      ],
    );
    globalState.container = container;
    container.read(currentProfileIdProvider.notifier).value = 1;
    final profile = container.read(currentProfileProvider)!;
    container
        .read(profilesProvider.notifier)
        .put(
          profile.copyWith(
            overrides: ProfileOverrides(
              residentialExit: '🇯🇵 东京家宽 · 01',
              residentialSubscriptionFingerprint: resolveTianjiProfile(
                profile,
              )!.fingerprint,
            ),
          ),
        );
    container.read(groupsProvider.notifier).value = const [
      Group(
        name: tianjiResidentialRootName,
        type: GroupType.Selector,
        all: [Proxy(name: '🇯🇵 东京家宽 · 01', type: 'URLTest')],
      ),
      Group(
        name: '🇯🇵 东京家宽 · 01',
        type: GroupType.URLTest,
        all: [Proxy(name: 'home-a', type: 'ss')],
      ),
    ];
    container
        .read(groupsSourceProfileProvider.notifier)
        .set(profileId: profile.id, url: profile.url);
  });

  tearDown(() {
    container.dispose();
    stats.dispose();
  });

  for (final (width, scale, captureOff, residential) in [
    (1200.0, 1.0, false, true),
    (800.0, 1.0, false, true),
    (800.0, 2.0, false, true),
    (390.0, 1.6, false, true),
    (1200.0, 1.0, true, true),
    (1200.0, 1.0, false, false),
    (800.0, 2.0, false, false),
    (390.0, 1.6, false, false),
  ]) {
    testWidgets(
      'business home fits $width at scale $scale, capture off $captureOff, residential $residential',
      (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        container.read(viewSizeProvider.notifier).value = Size(width, 900);
        if (!residential) {
          final profile = container.read(currentProfileProvider)!;
          container
              .read(profilesProvider.notifier)
              .put(profile.copyWith(overrides: const ProfileOverrides()));
          container.read(groupsProvider.notifier).value = const [
            Group(
              name: '天机云',
              type: GroupType.Selector,
              all: [Proxy(name: '⚡ 自动选择', type: 'URLTest')],
            ),
          ];
        }
        if (captureOff) {
          container.read(runTimeProvider.notifier).value = 1;
          container
              .read(networkSettingProvider.notifier)
              .update((state) => state.copyWith(systemProxy: false));
          container
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.tun(enable: false));
        }

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const TestApp(
              locale: Locale('zh', 'CN'),
              child: BusinessDashboardView(platform: SupportPlatform.Windows),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byType(ResidentialExitCard),
          residential ? findsOneWidget : findsNothing,
        );
        if (!residential) expect(find.text('连接线路'), findsOneWidget);
        expect(
          find.text('尚未接管电脑流量，请开启下方的系统代理或 TUN 模式。'),
          captureOff ? findsOneWidget : findsNothing,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 5));
      },
    );
  }
}
