import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/pages/home.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/navigation.dart';
import 'package:fl_clash/widgets/business_navigation.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

const _subscriptionUrl = 'https://sub1.tianjiyun.org/s/test_subscription_001';

Profile _profile({required bool business}) {
  if (!business) return Profile.normal(label: 'Regular profile');
  return Profile.normal(label: 'Tianji Plan', url: _subscriptionUrl).copyWith(
    subscriptionInfo: SubscriptionInfo(
      upload: 150,
      download: 100,
      total: 1000,
      expire:
          DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch ~/
          1000,
    ),
  );
}

List<NavigationItem> _items() => [
  NavigationItem(
    glyph: AppGlyphs.dashboard,
    label: PageLabel.dashboard,
    builder: (_) => const _InsetAwarePage(),
  ),
  NavigationItem(
    glyph: AppGlyphs.proxies,
    label: PageLabel.proxies,
    builder: (_) => const Text('proxy route'),
  ),
  NavigationItem(
    glyph: AppGlyphs.requests,
    label: PageLabel.requests,
    builder: (_) => const Text('request route'),
  ),
];

ProviderContainer _container(Profile profile) {
  final container = ProviderContainer(
    overrides: [
      profilesProvider.overrideWith(() => _TestProfiles([profile])),
      currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
      navigationItemsStateProvider.overrideWithValue(
        NavigationItemsState(value: _items()),
      ),
    ],
  );
  globalState.container = container;
  return container;
}

void _setSize(WidgetTester tester, ProviderContainer container, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  container.read(viewSizeProvider.notifier).value = size;
}

void main() {
  setUp(() {
    navigationPort = navigation;
    addTearDown(() => navigationPort = null);
  });

  testWidgets('business desktop sidebar routes and keeps keyboard focus', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1568, 1024);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = _container(_profile(business: true));
    addTearDown(container.dispose);
    _setSize(tester, container, const Size(1568, 1024));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(includeNavigatorKey: false, child: HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BusinessNavigationSidebar), findsOneWidget);
    expect(tester.getSize(find.byType(BusinessNavigationSidebar)).width, 216);
    expect(find.textContaining('Tianji Plan · '), findsOneWidget);
    expect(find.textContaining('25% used'), findsNothing);
    expect(find.textContaining('days'), findsOneWidget);
    expect(find.text('Orders'), findsNothing);

    final dashboardLabel = find.text('Dashboard');
    final proxiesLabel = find.text('Proxies');
    bool navigationItemHasFocus(Finder label) {
      final focus = FocusManager.instance.primaryFocus;
      return focus?.context
                  ?.findAncestorWidgetOfExactType<
                    BusinessNavigationSidebar
                  >() !=
              null &&
          focus!.rect.contains(tester.getCenter(label));
    }

    for (
      var index = 0;
      index < 30 && !navigationItemHasFocus(dashboardLabel);
      index++
    ) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
    }
    expect(navigationItemHasFocus(dashboardLabel), isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(navigationItemHasFocus(proxiesLabel), isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(container.read(currentPageLabelProvider), PageLabel.proxies);
    expect(find.text('proxy route'), findsOneWidget);
    expect(navigationItemHasFocus(proxiesLabel), isTrue);

    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    expect(container.read(currentPageLabelProvider), PageLabel.dashboard);
    expect(tester.takeException(), isNull);
  });

  testWidgets('business mobile dock leaves its content inset available', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = _container(_profile(business: true));
    addTearDown(container.dispose);
    _setSize(tester, container, const Size(390, 844));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(includeNavigatorKey: false, child: HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    final dockBar = find.byKey(const ValueKey('business-navigation-dock-bar'));
    final dockRect = tester.getRect(dockBar);
    expect(dockRect.width, 362);
    expect(dockRect.height, 68);
    expect(dockRect.bottom, 830);
    final insetContext = tester.element(
      find.byKey(const ValueKey('bottom-content')),
    );
    expect(BottomInsetScope.of(insetContext), 82);
    expect(find.text('Orders'), findsNothing);
    expect(find.text('Tianji Plan'), findsNothing);

    final contentRect = tester.getRect(
      find.byKey(const ValueKey('bottom-content')),
    );
    expect(contentRect.bottom, lessThanOrEqualTo(dockRect.top));

    await tester.tap(find.text('Proxies'));
    await tester.pumpAndSettle();
    expect(container.read(currentPageLabelProvider), PageLabel.proxies);
    expect(tester.takeException(), isNull);
  });

  testWidgets('regular profiles keep the existing navigation widgets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = _container(_profile(business: false));
    addTearDown(container.dispose);
    _setSize(tester, container, const Size(1200, 800));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(includeNavigatorKey: false, child: HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationSidebar), findsOneWidget);
    expect(find.byType(BusinessNavigationSidebar), findsNothing);
  });
}

class _InsetAwarePage extends StatelessWidget {
  const _InsetAwarePage();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: BottomInsetScope.of(context)),
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                key: ValueKey('bottom-content'),
                height: 20,
                child: Text('bottom content'),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              onPressed: () {},
              icon: const SizedBox.square(dimension: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestProfiles extends Profiles {
  _TestProfiles(this.initial);

  final List<Profile> initial;

  @override
  List<Profile> build() => initial;
}
