import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/views/proxies/card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';
import '../../helpers/test_profiles.dart';

void main() {
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
      expect(tester.takeException(), isNull);
    },
  );
}
