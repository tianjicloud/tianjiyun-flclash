import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/proxies/business_browser.dart';
import 'package:fl_clash/views/proxies/card.dart';
import 'package:fl_clash/views/proxies/proxies.dart';
import 'package:fl_clash/views/proxies/tab.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/host_scaffold.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

const _subscriptionUrl = 'https://sub1.tianjiyun.org/s/test_subscription_001';

class _RecordingProxiesAction extends ProxiesAction {
  static final groupsTested = <String>[];

  @override
  Future<void> delayTestPageGroup(
    String groupName, {
    bool matchSearch = true,
  }) async {
    groupsTested.add(groupName);
  }
}

void main() {
  testWidgets(
    'mobile browser syncs the visible fallback before delay testing',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final profile = Profile.normal(
        url: _subscriptionUrl,
      ).copyWith(currentGroupName: null);
      final groups = [
        const Group(
          name: '🇯🇵 Japan',
          type: GroupType.Selector,
          hidden: false,
          all: [
            Proxy(
              name: '🇯🇵 Tokyo 01',
              type: 'ss',
              providerName:
                  'A very long provider name for accessibility testing',
            ),
          ],
        ),
        const Group(
          name: '🇺🇸 US',
          type: GroupType.Selector,
          hidden: false,
          all: [Proxy(name: '🇺🇸 Los Angeles 01', type: 'vmess')],
        ),
      ];
      final container = ProviderContainer(
        overrides: [
          viewModeProvider.overrideWithValue(ViewMode.mobile),
          profilesProvider.overrideWith(() => TestProfiles([profile])),
          currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
          currentGroupsStateProvider.overrideWithValue(
            GroupsState(value: groups),
          ),
          proxiesActionProvider.overrideWith(_RecordingProxiesAction.new),
        ],
      );
      addTearDown(container.dispose);
      globalState.container = container;
      container.read(groupsProvider.notifier).value = groups;
      container.read(viewSizeProvider.notifier).value = const Size(390, 844);
      container
          .read(proxiesStyleSettingProvider.notifier)
          .update(
            (state) => state.copyWith(
              type: ProxiesType.list,
              cardType: ProxyCardType.compact,
            ),
          );
      _RecordingProxiesAction.groupsTested.clear();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            homeBuilder: (child) => MediaQuery(
              data: const MediaQueryData(
                size: Size(390, 844),
                textScaler: TextScaler.linear(1.4),
              ),
              child: HostScaffold(body: child),
            ),
            child: const ProxiesView(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(BusinessProxyBrowser), findsOneWidget);
      expect(
        container.read(proxiesStyleSettingProvider).type,
        ProxiesType.list,
      );
      expect(
        container.read(currentProfileProvider)?.currentGroupName,
        '🇯🇵 Japan',
      );
      expect(find.text('JP'), findsOneWidget);
      expect(find.text('Tokyo 01'), findsOneWidget);
      expect(tester.takeException(), isNull);

      final firstCard = find.byType(ProxyCard).first;
      expect(tester.getRect(firstCard).width, lessThanOrEqualTo(390));
      final localization = tester
          .element(find.byType(ProxiesView))
          .appLocalizations;
      await tester.tap(find.byTooltip(localization.delayTest));
      await tester.pump();
      expect(_RecordingProxiesAction.groupsTested, ['🇯🇵 Japan']);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    },
  );

  testWidgets('business profile keeps tab layout when that preference is set', (
    tester,
  ) async {
    final profile = Profile.normal(
      url: _subscriptionUrl,
    ).copyWith(currentGroupName: 'Japan');
    final groups = [
      const Group(
        name: 'Japan',
        type: GroupType.Selector,
        hidden: false,
        all: [Proxy(name: 'Tokyo', type: 'ss')],
      ),
    ];
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
        currentGroupsStateProvider.overrideWithValue(
          GroupsState(value: groups),
        ),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(groupsProvider.notifier).value = groups;
    container
        .read(proxiesStyleSettingProvider.notifier)
        .update((state) => state.copyWith(type: ProxiesType.tab));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          homeBuilder: (child) => HostScaffold(body: child),
          child: const ProxiesView(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ProxiesTabView), findsOneWidget);
    expect(find.byType(BusinessProxyBrowser), findsNothing);
    expect(container.read(proxiesStyleSettingProvider).type, ProxiesType.tab);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
