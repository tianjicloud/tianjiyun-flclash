import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/views/proxies/card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';
import '../../helpers/test_profiles.dart';

void main() {
  testWidgets('business delay slot keeps its width across live states', (
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
    const group = Group(
      name: 'Japan',
      type: GroupType.Selector,
      hidden: false,
      now: 'Tokyo',
      all: [proxy],
    );
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
        groupsProvider.overrideWithValue([group]),
        selectedMapProvider.overrideWithValue(const {'Japan': 'Tokyo'}),
        viewModeProvider.overrideWithValue(ViewMode.desktop),
        tianjiNodeProvider(
          'Tokyo',
        ).overrideWithValue(const TianjiNode(name: 'Tokyo')),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container
        .read(delayDataSourceProvider.notifier)
        .setDelay(const Delay(name: 'Tokyo', url: 'probe-url', value: 123));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(
          child: ProxyCard(
            groupName: 'Japan',
            proxy: proxy,
            groupType: GroupType.Selector,
            type: ProxyCardType.compact,
            testUrl: 'probe-url',
            businessStyle: true,
          ),
        ),
      ),
    );
    await tester.pump();
    final slot = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.child is AnimatedSwitcher,
    );
    expect(slot, findsOneWidget);
    final initialWidth = tester.getSize(slot).width;
    expect(find.text('123 ms'), findsOneWidget);

    container
        .read(delayDataSourceProvider.notifier)
        .setDelay(const Delay(name: 'Tokyo', url: 'probe-url', value: -1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Timeout'), findsOneWidget);
    expect(tester.getSize(slot).width, initialWidth);

    final delayKey = delayTestKey('probe-url', 'Tokyo');
    container
        .read(pendingDelayTestsProvider.notifier)
        .apply(acquired: [delayKey], started: [delayKey]);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('…'), findsOneWidget);
    expect(tester.getSize(slot).width, initialWidth);
    expect(tester.takeException(), isNull);
  });

  for (final locale in [const Locale('en'), const Locale('ru')]) {
    testWidgets('proxy timeout slot fits at 1.6 text scale in $locale', (
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
      const group = Group(
        name: 'Japan',
        type: GroupType.Selector,
        hidden: false,
        now: 'Tokyo',
        all: [proxy],
      );
      final container = ProviderContainer(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([profile])),
          currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
          groupsProvider.overrideWithValue([group]),
          selectedMapProvider.overrideWithValue(const {'Japan': 'Tokyo'}),
          viewModeProvider.overrideWithValue(ViewMode.desktop),
          delayProvider(proxyName: 'Tokyo').overrideWithValue(-1),
        ],
      );
      addTearDown(container.dispose);
      globalState.container = container;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            locale: locale,
            child: const MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(1.6)),
              child: ProxyCard(
                groupName: 'Japan',
                proxy: proxy,
                groupType: GroupType.Selector,
                type: ProxyCardType.compact,
                testUrl: null,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final timeoutText = AppLocalizations.of(
        tester.element(find.byType(ProxyCard)),
      ).timeout;
      final timeout = find.text(timeoutText);
      expect(timeout, findsOneWidget);
      expect(
        tester.renderObject<RenderParagraph>(timeout).didExceedMaxLines,
        isFalse,
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final locale in [const Locale('en'), const Locale('ru')]) {
    testWidgets('business timeout text is not clipped in $locale', (
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
      const group = Group(
        name: 'Japan',
        type: GroupType.Selector,
        hidden: false,
        now: 'Tokyo',
        all: [proxy],
      );
      final provider = delayProvider(proxyName: 'Tokyo');
      final container = ProviderContainer(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([profile])),
          currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
          groupsProvider.overrideWithValue([group]),
          selectedMapProvider.overrideWithValue(const {'Japan': 'Tokyo'}),
          viewModeProvider.overrideWithValue(ViewMode.desktop),
          provider.overrideWithValue(-1),
          tianjiNodeProvider(
            'Tokyo',
          ).overrideWithValue(const TianjiNode(name: 'Tokyo')),
        ],
      );
      addTearDown(container.dispose);
      globalState.container = container;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            locale: locale,
            child: const ProxyCard(
              groupName: 'Japan',
              proxy: proxy,
              groupType: GroupType.Selector,
              type: ProxyCardType.compact,
              testUrl: null,
              businessStyle: true,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      final l10n = AppLocalizations.of(tester.element(find.byType(ProxyCard)));
      final timeout = find.text(l10n.businessDelayTimeout);
      expect(timeout, findsOneWidget);
      final paragraph = tester.renderObject<RenderParagraph>(timeout);
      expect(paragraph.didExceedMaxLines, isFalse);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'selected business proxy shows its blue ring and selected semantics',
    (tester) async {
      final profile =
          Profile.normal(
            url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
          ).copyWith(
            currentGroupName: 'AI 专线',
            selectedMap: const {'AI 专线': '🇺🇸 洛杉矶 住宅 02'},
          );
      const proxy = Proxy(name: '🇺🇸 洛杉矶 住宅 02', type: 'ss');
      const group = Group(
        name: 'AI 专线',
        type: GroupType.Selector,
        hidden: false,
        now: '🇺🇸 洛杉矶 住宅 02',
        all: [proxy],
      );
      final container = ProviderContainer(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([profile])),
          currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
          groupsProvider.overrideWithValue([group]),
          tianjiNodeProvider('🇺🇸 洛杉矶 住宅 02').overrideWithValue(
            const TianjiNode(
              name: '🇺🇸 洛杉矶 住宅 02',
              multiplier: 0.5,
              expectedExit: EgressExit(kind: 'residential', countryCode: 'US'),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      globalState.container = container;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestApp(
            child: ProxyCard(
              groupName: 'AI 专线',
              proxy: proxy,
              groupType: GroupType.Selector,
              type: ProxyCardType.compact,
              testUrl: null,
              businessStyle: true,
            ),
          ),
        ),
      );
      await tester.pump();

      final selectedDecorations = find.descendant(
        of: find.byType(ProxyCard),
        matching: find.byWidgetPredicate((widget) {
          if (widget is! DecoratedBox ||
              widget.decoration is! ShapeDecoration) {
            return false;
          }
          final shape = (widget.decoration as ShapeDecoration).shape;
          return shape is RoundedSuperellipseBorder &&
              shape.side.width == 2 &&
              shape.side.color == BusinessPalette.blue;
        }),
      );
      final selectedSemantics = find.descendant(
        of: find.byType(ProxyCard),
        matching: find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.selected == true,
        ),
      );
      expect(selectedDecorations, findsOneWidget);
      expect(selectedSemantics, findsOneWidget);
      expect(find.text('Rate 0.5×'), findsOneWidget);
      expect(find.text('Residential'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
