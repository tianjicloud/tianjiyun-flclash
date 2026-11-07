import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/profiles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('business colors remain local to the dashboard', (tester) async {
    final colors = <Color>[];
    final markers = <bool>[];
    Widget sample() => Builder(
      builder: (context) {
        colors.add(Theme.of(context).colorScheme.surface);
        markers.add(BusinessTheme.of(context));
        return const SizedBox();
      },
    );
    final scheme = seededColorScheme(
      seedColor: const Color(0xFF123456),
      brightness: Brightness.dark,
    );
    await tester.pumpWidget(
      TestApp(
        theme: ThemeData(colorScheme: scheme),
        child: Column(
          children: [
            sample(),
            BusinessAppearance(child: sample()),
            sample(),
          ],
        ),
      ),
    );
    expect(colors, [scheme.surface, BusinessPalette.page, scheme.surface]);
    expect(markers, [false, true, false]);
  });

  for (final days in [5, 28]) {
    testWidgets('expiry banner only appears near expiry: $days days', (
      tester,
    ) async {
      final expiry = DateTime.now().add(Duration(days: days, hours: 1));
      final profile = Profile(
        id: 1,
        autoUpdateDuration: Duration.zero,
        subscriptionInfo: SubscriptionInfo(
          expire: expiry.millisecondsSinceEpoch ~/ 1000,
        ),
      );
      await tester.pumpWidget(
        TestApp(
          locale: const Locale('en'),
          overrides: [currentProfileProvider.overrideWithValue(profile)],
          child: const BusinessAppearance(child: BusinessSubscriptionStatus()),
        ),
      );
      expect(
        find.textContaining('Expires'),
        days <= 7 ? findsOneWidget : findsNothing,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
