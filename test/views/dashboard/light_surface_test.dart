import 'dart:math' as math;
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/business_navigation.dart';

import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('light sidebar selection uses white with the brand icon', (
    tester,
  ) async {
    final scheme = seededColorScheme(
      seedColor: const Color(0xFF3D5AFE),
      brightness: Brightness.light,
    );
    await tester.pumpWidget(
      TestApp(
        themeMode: ThemeMode.light,
        theme: ThemeData(colorScheme: scheme),
        overrides: [currentProfileProvider.overrideWithValue(null)],
        child: BusinessNavigationSidebar(
          items: [
            NavigationItem(
              glyph: AppGlyphs.dashboard,
              label: PageLabel.dashboard,
              builder: (_) => const SizedBox(),
            ),
          ],
          currentIndex: 0,
          expanded: true,
          onSelected: (_) {},
          onToggle: null,
          windowControls: Size.zero,
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('Dashboard'));
    expect(text.style!.color, scheme.onSurface);
    final backgrounds = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((w) => w.decoration)
        .whereType<ShapeDecoration>();
    expect(backgrounds.any((d) => d.gradient != null), isFalse);
    expect(backgrounds.any((d) => d.color == const Color(0xFFFFFFFF)), isTrue);
  });

  for (final brightness in Brightness.values) {
    testWidgets('business card depth and status contrast: $brightness', (
      tester,
    ) async {
      final scheme = seededColorScheme(
        seedColor: const Color(0xFF3D5AFE),
        brightness: brightness,
      );
      late DashboardColors colors;
      await tester.pumpWidget(
        TestApp(
          themeMode: ThemeMode.light,
          theme: ThemeData(colorScheme: scheme),
          child: BusinessAppearance(
            child: Builder(
              builder: (context) {
                colors = DashboardColors.of(context);
                return const DashboardCard(child: Text('Card'));
              },
            ),
          ),
        ),
      );
      final decoration = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(DashboardCard),
              matching: find.byType(Container),
            ),
          )
          .map((widget) => widget.decoration)
          .whereType<ShapeDecoration>()
          .first;
      if (brightness == Brightness.light) {
        expect(decoration.shadows, isNotEmpty);
        final foreground = colors.onOkContainer.computeLuminance();
        final background = colors.okContainer.computeLuminance();
        expect(
          (math.max(foreground, background) + 0.05) /
              (math.min(foreground, background) + 0.05),
          greaterThanOrEqualTo(4.5),
        );
      } else {
        expect(decoration.shadows, isEmpty);
        expect(colors.card, const Color(0xFF131A22));
      }
    });
  }
}
