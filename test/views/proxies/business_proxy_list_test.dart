import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/proxies/card.dart';
import 'package:fl_clash/views/proxies/business_list.dart';
import 'package:fl_clash/views/proxies/proxies.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';

import '../../helpers/host_scaffold.dart';
import '../../helpers/test_app.dart';
import '../../helpers/test_profiles.dart';

void main() {
  for (final platform in [
    TargetPlatform.windows,
    TargetPlatform.macOS,
    TargetPlatform.android,
  ]) {
    testWidgets('business delay keeps its row rect on $platform', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final profile =
          Profile.normal(
            url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
          ).copyWith(
            currentGroupName: 'Japan',
            selectedMap: const {'Japan': 'Tokyo'},
          );
      const proxy = Proxy(name: 'Tokyo', type: 'ss');
      const groups = [
        Group(
          name: 'Japan',
          type: GroupType.Selector,
          hidden: false,
          now: 'Tokyo',
          all: [proxy],
        ),
      ];
      final container = ProviderContainer(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([profile])),
          currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
          currentGroupsStateProvider.overrideWithValue(
            const GroupsState(value: groups),
          ),
          groupsProvider.overrideWithValue(groups),
          proxiesTabStateProvider.overrideWithValue(
            const ProxiesTabState(
              groups: groups,
              currentGroupName: 'Japan',
              proxyCardType: ProxyCardType.compact,
            ),
          ),
          patchClashConfigProvider.overrideWithBuild(
            (_, _) => const PatchClashConfig(testUrl: ''),
          ),
          tianjiNodeProvider(
            'Tokyo',
          ).overrideWithValue(const TianjiNode(name: 'Tokyo', multiplier: 0.5)),
        ],
      );
      addTearDown(container.dispose);
      globalState.container = container;
      container.read(viewSizeProvider.notifier).value = const Size(1280, 900);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            theme: ThemeData(platform: platform),
            homeBuilder: _host,
            child: const BusinessProxyList(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('—'), findsOneWidget);
      final card = find.byType(ProxyCard);
      expect(card, findsOneWidget);
      final rowRect = tester.getRect(card);
      expect(find.text('Rate 0.5×'), findsOneWidget);
      container
          .read(delayDataSourceProvider.notifier)
          .setDelay(const Delay(name: 'Tokyo', url: '', value: 85));
      await tester.pump();
      expect(find.text('85 ms'), findsOneWidget);
      expect(tester.getRect(card), rowRect);
      expect(find.text('Rate 0.5×'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('localized timeout delay fits at text scale 1.6', (tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final profile = Profile.normal(
      url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
    ).copyWith(currentGroupName: 'Japan');
    const proxy = Proxy(name: 'Tokyo', type: 'ss');
    const groups = [
      Group(
        name: 'Japan',
        type: GroupType.Selector,
        hidden: false,
        all: [proxy],
      ),
    ];
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
        currentGroupsStateProvider.overrideWithValue(
          const GroupsState(value: groups),
        ),
        groupsProvider.overrideWithValue(groups),
        proxiesTabStateProvider.overrideWithValue(
          const ProxiesTabState(
            groups: groups,
            currentGroupName: 'Japan',
            proxyCardType: ProxyCardType.compact,
          ),
        ),
        patchClashConfigProvider.overrideWithBuild(
          (_, _) => const PatchClashConfig(testUrl: ''),
        ),
        tianjiNodeProvider(
          'Tokyo',
        ).overrideWithValue(const TianjiNode(name: 'Tokyo')),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(viewSizeProvider.notifier).value = const Size(1280, 900);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: TestApp(
            locale: Locale('ru'),
            homeBuilder: _host,
            child: BusinessProxyList(),
          ),
        ),
      ),
    );
    await tester.pump();
    container
        .read(delayDataSourceProvider.notifier)
        .setDelay(const Delay(name: 'Tokyo', url: '', value: -1));
    await tester.pump();
    expect(find.byType(ProxyCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('business view preference switches and persists list mode', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final profile =
        Profile.normal(
          url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
        ).copyWith(
          currentGroupName: 'AI',
          selectedMap: const {'AI': '🇺🇸 Los Angeles'},
        );
    const groups = [
      Group(
        name: 'AI',
        type: GroupType.Selector,
        hidden: false,
        now: '🇺🇸 Los Angeles',
        all: [
          Proxy(name: '🇺🇸 Los Angeles', type: 'ss'),
          Proxy(name: '🇯🇵 Tokyo', type: 'vmess'),
        ],
      ),
      Group(
        name: 'Auto',
        type: GroupType.URLTest,
        hidden: false,
        now: '🇯🇵 Tokyo',
        all: [Proxy(name: '🇯🇵 Tokyo', type: 'ss')],
      ),
      Group(name: '场景模式', type: GroupType.Selector, hidden: false),
      Group(
        name: '⚡ 自动选择',
        type: GroupType.URLTest,
        hidden: false,
        all: [Proxy(name: '🇯🇵 Tokyo', type: 'ss')],
      ),
      Group(
        name: '🇯🇵 Tokyo 1.5x',
        type: GroupType.URLTest,
        hidden: false,
        all: [Proxy(name: '🇯🇵 Tokyo 1.5x', type: 'ss')],
      ),
    ];
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
        currentGroupsStateProvider.overrideWithValue(
          const GroupsState(value: groups),
        ),
        groupsProvider.overrideWithValue(groups),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(viewSizeProvider.notifier).value = const Size(1280, 900);
    expect(container.read(proxiesTabStateProvider).groups, hasLength(5));
    expect(
      container.read(proxiesTabStateProvider).groups.first.all,
      hasLength(2),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(
          locale: Locale('zh', 'CN'),
          homeBuilder: _host,
          child: ProxiesView(),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(BusinessProxyList), findsNothing);

    await tester.tap(find.text('列表'));
    await tester.pump();
    expect(
      container.read(proxiesStyleSettingProvider).businessProxiesView,
      BusinessProxiesView.list,
    );
    expect(find.byType(BusinessProxyList), findsOneWidget);
    expect(find.text('场景模式'), findsNothing);
    expect(find.text('⚡ 自动选择'), findsNothing);
    expect(find.text('🇯🇵 Tokyo 1.5x'), findsNothing);
    expect(find.byType(ProxyCard), findsNWidgets(2));
    expect(find.text('Tokyo'), findsOneWidget);
    expect(find.text('ss'), findsNothing);
    expect(tester.getRect(find.byType(ProxyCard).first).height, closeTo(44, 1));

    await tester.tap(find.text('AI').last);
    await tester.pump();
    expect(find.byType(ProxyCard), findsNothing);
    await tester.tap(find.text('AI').last);
    await tester.pump();
    expect(find.byType(ProxyCard), findsNWidgets(2));

    await tester.tap(find.byType(ProxyCard).hitTestable().last);
    await tester.pump();
    expect(container.read(selectedProxyNameProvider('AI')), '🇯🇵 Tokyo');
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });
}

Widget _host(Widget child) => HostScaffold(body: child);
