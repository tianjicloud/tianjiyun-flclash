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

import '../../helpers/host_scaffold.dart';
import '../../helpers/test_app.dart';
import '../../helpers/test_profiles.dart';

void main() {
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
    expect(container.read(proxiesTabStateProvider).groups, hasLength(2));
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
    expect(find.byType(ProxyCard), findsNWidgets(2));
    expect(find.text('Tokyo'), findsNWidgets(2));
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
