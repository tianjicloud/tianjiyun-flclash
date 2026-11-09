import 'package:prism_ui/prism_ui.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/app_update.dart';
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
import 'package:fl_clash/views/dashboard/widgets/network_takeover.dart';
import 'package:fl_clash/views/dashboard/widgets/outbound_mode.dart';
import 'package:fl_clash/views/dashboard/widgets/profiles.dart';
import 'package:fl_clash/views/dashboard/widgets/traffic_savings.dart';
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
          expect(find.byType(OutboundModeInline), findsOneWidget);
          final mobile = width / scale < 640;
          if (mobile) {
            expect(find.byType(MobileUsageCard), findsOneWidget);
            expect(find.byType(BusinessAIStatusCard), findsOneWidget);
          } else {
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
