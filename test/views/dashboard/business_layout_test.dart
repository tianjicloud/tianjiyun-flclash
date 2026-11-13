import 'dart:async';

import 'package:prism_ui/prism_ui.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/business_exit_warning_banner.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/app_update.dart';
import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/common/service_probe.dart' show routedOutbound;
import 'package:fl_clash/core/traffic/service.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/ip_quality.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/business.dart';
import 'package:fl_clash/views/dashboard/edit.dart';
import 'package:fl_clash/views/config/advanced.dart';
import 'package:fl_clash/views/dashboard/widgets/network_takeover.dart';
import 'package:fl_clash/views/dashboard/widgets/outbound_mode.dart';
import 'package:fl_clash/views/dashboard/widgets/profiles.dart';
import 'package:fl_clash/views/dashboard/widgets/traffic_savings.dart';
import 'package:fl_clash/views/dashboard/widgets/traffic.dart';
import 'package:fl_clash/views/dashboard/widgets/quick_lines.dart';
import 'package:fl_clash/views/about.dart';
import 'package:fl_clash/views/dashboard/widgets/update_status.dart';
import 'package:fl_clash/views/dashboard/widgets/scene_bar.dart';
import 'package:fl_clash/views/dashboard/widgets/service_status.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

class _VerifiedIpProbe extends OutboundIpProbe {
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState({
    routedOutbound: ProbeEntry(
      phase: ProbePhase.fresh,
      value: IpInfo(ip: '203.0.113.42', countryCode: 'JP'),
      stamp: RouteStamp(
        coreEpoch: 1,
        routeVersion: 1,
        hostEpoch: 1,
        proxied: true,
        hits: [RouteHit(host: 'example.com', proxy: 'Tokyo', exit: 'Tokyo')],
        chains: ['Tokyo'],
      ),
    ),
  });

  @override
  void watch(String target) {}

  @override
  void unwatch(String target) {}
}

class _FailedIpProbe extends OutboundIpProbe {
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState({
    routedOutbound: ProbeEntry(phase: ProbePhase.failed),
  });

  @override
  void watch(String target) {}

  @override
  void unwatch(String target) {}
}

class _UpdateAction extends CommonAction {
  int installs = 0;

  @override
  Future<void> installUpdate() async {
    installs++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late TrafficAccountingService stats;
  late _UpdateAction updateAction;

  setUp(() async {
    await mockPreferences();
    globalState.packageInfo = PackageInfo(
      appName: 'TianjiCloud',
      packageName: 'org.tianjiyun.app',
      version: '0.9.10',
      buildNumber: '1',
    );
    updateAction = _UpdateAction();
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
        tianjiApiEnabledProvider.overrideWithValue(false),
        commonActionProvider.overrideWith(() => updateAction),
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

  testWidgets('verified dashboard pill keeps the connected label', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final verifiedContainer = ProviderContainer(
      parent: container,
      overrides: [
        runTimeProvider.overrideWithBuild((_, _) => 1),
        isStartProvider.overrideWithValue(true),
        networkSettingProvider.overrideWithBuild(
          (_, _) => const NetworkProps(systemProxy: true),
        ),
        routeTrackerProvider.overrideWithBuild(
          (_, _) => const RouteState(
            coreEpoch: 1,
            routeVersion: 1,
            hostEpoch: 1,
            proxied: true,
            synced: true,
            live: true,
          ),
        ),
        selectionCheckProvider.overrideWithBuild(
          (_, _) => SelectionVerdict.consistent,
        ),
        outboundIpProbeProvider.overrideWith(_VerifiedIpProbe.new),
        ipQualityProvider.overrideWith((_, _) => Completer<IpQuality>().future),
      ],
    );
    addTearDown(verifiedContainer.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: verifiedContainer,
        child: const TestApp(
          locale: Locale('zh', 'CN'),
          child: BusinessDashboardView(platform: SupportPlatform.Windows),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('已连接 · 出口已校验'), findsOneWidget);
    expect(find.text('出口校验通过'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('macOS disconnected home keeps quick lines and settings cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final macContainer = ProviderContainer(
      parent: container,
      overrides: [
        isStartProvider.overrideWithValue(false),
        coreStatusProvider.overrideWithBuild((_, _) => CoreStatus.disconnected),
      ],
    );
    addTearDown(macContainer.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: macContainer,
        child: TestApp(
          locale: const Locale('zh', 'CN'),
          theme: ThemeData(platform: TargetPlatform.macOS),
          child: const BusinessDashboardView(platform: SupportPlatform.MacOS),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('未连接'), findsOneWidget);
    expect(find.byType(QuickLines), findsOneWidget);
    expect(find.text('URLTEST'), findsNothing);
    expect(find.byType(BusinessExitWarningBanner), findsNothing);
    expect(find.byType(TrafficSavingsCard), findsOneWidget);
    expect(find.byType(ProfilesCard), findsOneWidget);
    expect(find.byType(NetworkTakeoverBlock), findsWidgets);
    expect(find.text('下载'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final scenario in [
    (
      name: 'connecting',
      started: true,
      status: CoreStatus.connecting,
      probe: _IdleIpProbe.new,
      title: '连接中…',
      action: '连接中…',
      subtitle: '正在启动服务…',
    ),
    (
      name: 'connected',
      started: true,
      status: CoreStatus.connected,
      probe: _VerifiedIpProbe.new,
      title: '已连接',
      action: '断开连接',
      subtitle: '203.0.113.42',
    ),
    (
      name: 'abnormal',
      started: true,
      status: CoreStatus.connected,
      probe: _FailedIpProbe.new,
      title: '暂时无法确认出口',
      action: '重新检测',
      subtitle: '出口检测没有返回结果，代理可能仍在工作。可以重新检测，或运行诊断查看原因。',
    ),
  ]) {
    testWidgets('macOS ${scenario.name} home shows its state and action', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final stateContainer = ProviderContainer(
        parent: container,
        overrides: [
          isStartProvider.overrideWithValue(scenario.started),
          coreStatusProvider.overrideWithBuild((_, _) => scenario.status),
          runTimeProvider.overrideWithBuild((_, _) => 3600000),
          outboundIpProbeProvider.overrideWith(scenario.probe),
          ipQualityProvider('203.0.113.42').overrideWith(
            (_) async => const IpQuality(
              ip: '203.0.113.42',
              source: IpQualitySource.ipApiCom,
              type: IpType.residential,
              organization: 'SoftBank',
            ),
          ),
        ],
      );
      addTearDown(stateContainer.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: stateContainer,
          child: TestApp(
            locale: const Locale('zh', 'CN'),
            theme: ThemeData(platform: TargetPlatform.macOS),
            child: const BusinessDashboardView(platform: SupportPlatform.MacOS),
          ),
        ),
      );
      await tester.pump();
      expect(
        find.text(scenario.title),
        scenario.name == 'connecting' ? findsWidgets : findsOneWidget,
      );
      expect(find.text(scenario.action), findsWidgets);
      expect(find.text(scenario.subtitle), findsWidgets);
      expect(find.byType(BusinessExitWarningBanner), findsNothing);
      expect(find.text('URLTEST'), findsNothing);
      if (scenario.name == 'connected') {
        expect(find.text('203.0.113.42'), findsOneWidget);
        expect(find.text('下载'), findsOneWidget);
        expect(find.text('上传'), findsOneWidget);
        expect(find.text('本月流量'), findsWidgets);
        expect(find.text('运行时长'), findsOneWidget);
      } else {
        expect(find.text('下载'), findsNothing);
      }
      if (scenario.name == 'abnormal') {
        expect(find.text('暂时无法确认出口'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('business dashboard uses saved card visibility and order', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
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
      container.read(appSettingProvider).businessDashboardCards,
      defaultBusinessDashboardCards,
    );
    expect(find.byType(BusinessLineCard), findsOneWidget);
    expect(find.byType(TrafficSavingsCard), findsOneWidget);
    expect(find.byType(ProfilesCard), findsOneWidget);

    container
        .read(appSettingProvider.notifier)
        .update(
          (state) => state.copyWith(
            businessDashboardCards: const [
              BusinessDashboardCard.networkSpeed,
              BusinessDashboardCard.subscription,
            ],
          ),
        );
    await tester.pump();
    expect(find.byType(BusinessLineCard), findsNothing);
    expect(find.byType(TrafficSavingsCard), findsNothing);
    expect(find.byType(NetworkSpeedCard), findsOneWidget);
    expect(find.byType(ProfilesCard), findsOneWidget);
    expect(
      tester.getTopLeft(find.byType(NetworkSpeedCard)).dx,
      lessThan(tester.getTopLeft(find.byType(ProfilesCard)).dx),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('business dashboard editor adds, removes, reorders, and resets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    container
        .read(appSettingProvider.notifier)
        .update(
          (state) => state.copyWith(
            businessDashboardCards: const [
              BusinessDashboardCard.monthlyTraffic,
            ],
          ),
        );
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
    await tester.tap(find.byTooltip('编辑仪表盘'));
    await tester.pump();
    expect(find.byType(BusinessDashboardEditor), findsOneWidget);
    await tester.tap(find.byTooltip('移除').first);
    await tester.pump();
    expect(container.read(appSettingProvider).businessDashboardCards, isEmpty);
    await tester.tap(find.byTooltip('添加').first);
    await tester.pump();
    expect(container.read(appSettingProvider).businessDashboardCards, [
      BusinessDashboardCard.residentialLines,
    ]);
    await tester.tap(find.text('重置'));
    await tester.pump();
    expect(
      container.read(appSettingProvider).businessDashboardCards,
      defaultBusinessDashboardCards,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('business dashboard editor persists drag order', (tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    const initial = [
      BusinessDashboardCard.monthlyTraffic,
      BusinessDashboardCard.subscription,
    ];
    container
        .read(appSettingProvider.notifier)
        .update((state) => state.copyWith(businessDashboardCards: initial));
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
    await tester.tap(find.byTooltip('编辑仪表盘'));
    await tester.pump();
    final handle = find.byType(ReorderableDragStartListener).first;
    await tester.timedDragFrom(
      tester.getCenter(handle),
      const Offset(0, 130),
      const Duration(milliseconds: 500),
    );
    await tester.pumpAndSettle();
    expect(container.read(appSettingProvider).businessDashboardCards, const [
      BusinessDashboardCard.subscription,
      BusinessDashboardCard.monthlyTraffic,
    ]);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('unsafe outbound warning restores rule mode', (tester) async {
    container
        .read(patchClashConfigProvider.notifier)
        .update((state) => state.copyWith(mode: Mode.global));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(
          locale: Locale('en'),
          child: BusinessOutboundModeWarning(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Global mode is active'), findsOneWidget);
    await tester.tap(find.text('Restore Rule'));
    await tester.pump();
    expect(container.read(patchClashConfigProvider).mode, Mode.rule);
    expect(find.text('Global mode is active'), findsNothing);
  });

  testWidgets('Android advanced settings can change outbound mode', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(
          locale: Locale('en'),
          child: AdvancedConfigView(isAndroid: true),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(OutboundModeInline), findsOneWidget);
    await tester.tap(find.text('Global'));
    await tester.pump();
    expect(container.read(patchClashConfigProvider).mode, Mode.global);
  });

  for (final brightness in Brightness.values) {
    for (final (width, scale) in [
      (1000.0, 1.0),
      (1200.0, 1.2),
      (390.0, 1.0),
      (390.0, 1.6),
    ]) {
      testWidgets(
        'subscribed English home fits $brightness $width at scale $scale',
        (tester) async {
          tester.view.physicalSize = Size(width, 900);
          tester.view.devicePixelRatio = 1;
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.reset);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          container.read(viewSizeProvider.notifier).value = Size(width, 900);
          final profile = container.read(currentProfileProvider)!;
          container
              .read(profilesProvider.notifier)
              .put(
                profile.copyWith(
                  subscriptionInfo: SubscriptionInfo(
                    upload: 0,
                    download: 50 * 1024 * 1024 * 1024,
                    total: 100 * 1024 * 1024 * 1024,
                    expire:
                        DateTime.now()
                            .add(const Duration(days: 30))
                            .millisecondsSinceEpoch ~/
                        1000,
                  ),
                ),
              );
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: TestApp(
                theme: ThemeData(
                  colorScheme: seededColorScheme(
                    seedColor: BusinessPalette.blue,
                    brightness: brightness,
                  ),
                ),
                locale: const Locale('en'),
                child: const BusinessDashboardView(
                  platform: SupportPlatform.Windows,
                ),
              ),
            ),
          );
          await tester.pump();
          final mobile = width / scale < 640;
          if (mobile) {
            expect(find.byType(OutboundModeInline), findsNothing);
            expect(find.byType(OutboundModeCard), findsNothing);
            expect(find.byType(MobileUsageCard), findsOneWidget);
            expect(find.byType(BusinessAIStatusCard), findsOneWidget);
          } else {
            expect(find.byType(OutboundModeInline), findsOneWidget);
            expect(find.byType(TrafficSavingsCard), findsOneWidget);
          }
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump(const Duration(seconds: 5));
        },
      );
    }
  }

  testWidgets(
    'desktop keeps outbound mode when scene controls are unavailable',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      container.read(viewSizeProvider.notifier).value = const Size(1200, 900);
      final sceneUnavailableContainer = ProviderContainer(
        parent: container,
        overrides: [
          scenePolicyProvider.overrideWithValue(
            const ScenePolicy(
              available: false,
              current: null,
              suspended: false,
            ),
          ),
        ],
      );
      addTearDown(sceneUnavailableContainer.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: sceneUnavailableContainer,
          child: const TestApp(
            locale: Locale('en'),
            child: BusinessDashboardView(platform: SupportPlatform.Windows),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SceneBar), findsNothing);
      expect(find.byType(OutboundModeInline), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );

  for (final about in [false, true]) {
    testWidgets(
      'update stays visible on ${about ? 'about' : 'business home'}',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        container.read(viewSizeProvider.notifier).value = const Size(1200, 900);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: TestApp(
              locale: const Locale('en'),
              child: about
                  ? const AboutView()
                  : const BusinessDashboardView(
                      platform: SupportPlatform.Windows,
                    ),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('Update ready'), findsNothing);
        final download = container.read(updateDownloadStateProvider.notifier);
        download.value = const UpdateDownloading(
          'v0.9.10',
          received: 1,
          total: 4,
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('25%'), findsOneWidget);
        download.value = const UpdateReady('v0.9.10', '/test/update.exe');
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Update ready'), findsWidgets);
        if (!about) {
          await tester.tap(
            find.descendant(
              of: find.byType(UpdateStatusSlot),
              matching: find.text('Update ready'),
            ),
          );
          expect(updateAction.installs, 1);
        }
        download.value = null;
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Update ready'), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      },
    );
  }

  for (final brightness in Brightness.values) {
    for (final (width, scale, captureOff, residential) in [
      (1200.0, 1.0, false, true),
      (1024.0, 1.25, false, true),
      (800.0, 1.0, false, true),
      (800.0, 2.0, false, true),
      (390.0, 1.6, false, true),
      (1200.0, 1.0, true, true),
      (1200.0, 1.0, false, false),
      (800.0, 2.0, false, false),
      (390.0, 1.6, false, false),
    ]) {
      testWidgets(
        'business home fits $brightness $width at scale $scale, capture off $captureOff, residential $residential',
        (tester) async {
          tester.view.physicalSize = Size(width, 700);
          tester.view.devicePixelRatio = 1;
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          container.read(viewSizeProvider.notifier).value = Size(width, 700);
          if (!residential) {
            final profile = container.read(currentProfileProvider)!;
            container
                .read(profilesProvider.notifier)
                .put(profile.copyWith(overrides: const ProfileOverrides()));
            container.read(groupsProvider.notifier).value = const [
              Group(
                name: '天机云',
                type: GroupType.Selector,
                now: '⚡ 自动选择',
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
              child: TestApp(
                theme: ThemeData(
                  colorScheme: seededColorScheme(
                    seedColor: BusinessPalette.blue,
                    brightness: brightness,
                  ),
                ),
                locale: const Locale('zh', 'CN'),
                child: const BusinessDashboardView(
                  platform: SupportPlatform.Windows,
                ),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.byType(ResidentialExitCard),
            residential && width / scale >= 640 ? findsOneWidget : findsNothing,
          );
          if (width == 1024 && scale == 1.25 && residential) {
            expect(
              tester.getSize(find.byType(BusinessLineCard)).width,
              lessThan(tester.getSize(find.byType(ProfilesCard)).width),
            );
            expect(find.text('🇯🇵 东京家宽 · 01'), findsOneWidget);
          }
          if (width >= 1200 && scale == 1 && !captureOff) {
            await tester.scrollUntilVisible(
              find.byType(NetworkTakeoverBlock).last,
              200,
            );
            expect(
              tester.getBottomRight(find.byType(NetworkTakeoverBlock).last).dy,
              lessThanOrEqualTo(700),
            );
          }
          if (!residential && width / scale >= 640) {
            expect(find.byType(BusinessLineCard), findsOneWidget);
          }
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
}
