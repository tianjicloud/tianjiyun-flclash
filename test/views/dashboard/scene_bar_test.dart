import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prism_ui/prism_ui.dart';

import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/traffic/service.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/app_background.dart';
import 'package:fl_clash/views/dashboard/business.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/outbound_mode.dart';
import 'package:fl_clash/views/dashboard/widgets/quick_lines.dart';
import 'package:fl_clash/views/dashboard/widgets/scene_bar.dart';

import '../../helpers/preferences.dart';
import '../../helpers/test_app.dart';
import '../../helpers/test_profiles.dart';
import '../../helpers/traffic_stats_store.dart';

class _IdleProbe extends OutboundIpProbe {
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState({});

  @override
  void watch(String target) {}

  @override
  void unwatch(String target) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('scene bar renders on a phone width with scenes available', (
    tester,
  ) async {
    await mockPreferences();
    globalState.packageInfo = PackageInfo(
      appName: 'TianjiCloud',
      packageName: 'org.tianjiyun.app',
      version: '0.9.11',
      buildNumber: '1',
    );
    final stats = TrafficAccountingService(
      store: MemoryTrafficStatsStore(),
      readSnapshot: () async => const TrafficSnapshot(
        version: 1,
        epoch: 1,
        mainlandDirect: TrafficBytes.zero,
        proxy: TrafficBytes.zero,
        otherDirect: TrafficBytes.zero,
      ),
    );
    final container = ProviderContainer(
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
        outboundIpProbeProvider.overrideWith(_IdleProbe.new),
        trafficStatsProvider.overrideWithValue(stats),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(stats.dispose);
    globalState.container = container;
    container.read(currentProfileIdProvider.notifier).value = 1;
    final profile = container.read(currentProfileProvider)!;
    container
        .read(profilesProvider.notifier)
        .put(
          profile.copyWith(
            selectedMap: const {'总出口': '场景模式', '场景模式': '日常', '日常': '香港01'},
            subscriptionInfo: SubscriptionInfo(
              upload: 1000000000,
              download: 3000000000,
              total: 850 * 1024 * 1024 * 1024,
              expire:
                  DateTime.now()
                      .add(const Duration(days: 303))
                      .millisecondsSinceEpoch ~/
                  1000,
            ),
            overrides: ProfileOverrides(
              residentialExit: '🇯🇵 东京家宽 · 01',
              residentialSubscriptionFingerprint: resolveTianjiProfile(
                profile,
              )!.fingerprint,
              scene: '日常',
            ),
          ),
        );
    container.read(groupsProvider.notifier).value = const [
      Group(
        name: '总出口',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: '场景模式', type: 'select'),
          Proxy(name: '节点选择', type: 'select'),
        ],
      ),
      Group(
        name: '场景模式',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: '日常', type: 'url-test'),
          Proxy(name: 'AI模式', type: 'select'),
          Proxy(name: '观影模式', type: 'select'),
        ],
      ),
      Group(
        name: '日常',
        type: GroupType.Selector,
        hidden: false,
        now: '香港01',
        all: [
          Proxy(name: '香港01', type: 'anytls'),
          Proxy(name: '日本01', type: 'anytls'),
          Proxy(name: '美国01', type: 'anytls'),
        ],
      ),
      Group(
        name: 'AI模式',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: 'AI住宅-东京', type: 'anytls'),
          Proxy(name: 'AI住宅-洛杉矶', type: 'anytls'),
        ],
      ),
      Group(
        name: '观影模式',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: '观影-日本', type: 'anytls'),
          Proxy(name: '观影-美国', type: 'anytls'),
        ],
      ),
      Group(
        name: '节点选择',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: '香港01', type: 'anytls'),
          Proxy(name: '日本01', type: 'anytls'),
          Proxy(name: '美国01', type: 'anytls'),
        ],
      ),
      Group(
        name: 'AI服务',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: 'AI住宅-东京', type: 'anytls'),
          Proxy(name: 'AI住宅-洛杉矶', type: 'anytls'),
        ],
      ),
      Group(
        name: '流媒体',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: '观影-日本', type: 'anytls'),
          Proxy(name: '观影-美国', type: 'anytls'),
        ],
      ),
      Group(
        name: '🏠 家宽',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: '🇯🇵 东京家宽 · 01', type: 'URLTest'),
          Proxy(name: '🇯🇵 东京家宽 · 02', type: 'anytls'),
        ],
      ),
      Group(
        name: '🇯🇵 东京家宽 · 01',
        type: GroupType.URLTest,
        hidden: false,
        all: [Proxy(name: 'home-a', type: 'ss')],
      ),
    ];
    container
        .read(groupsSourceProfileProvider.notifier)
        .set(profileId: profile.id, url: profile.url);
    container
        .read(themeSettingProvider.notifier)
        .update(
          (state) => state.copyWith(
            themeMode: ThemeMode.dark,
            background: 'planet',
            primaryColor: BusinessPalette.blue.toARGB32(),
          ),
        );

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    container.read(viewSizeProvider.notifier).value = const Size(390, 844);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(
          themeMode: ThemeMode.dark,
          locale: Locale('zh', 'CN'),
          child: AppBackgroundScope(
            preset: 'planet',
            child: AppBackground(
              child: BusinessDashboardView(platform: SupportPlatform.Android),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
    expect(find.byType(SceneBar), findsOneWidget);
    expect(find.byType(OutboundModeInline), findsNothing);
    expect(find.byType(QuickLines), findsOneWidget);
    expect(find.text('常用线路'), findsOneWidget);
    expect(find.textContaining('东京家宽', findRichText: true), findsWidgets);
  });
}
