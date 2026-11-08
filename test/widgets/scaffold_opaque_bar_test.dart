import 'package:fl_clash/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  for (final opaque in [false, true]) {
    testWidgets('app bar opacity is opt in: $opaque', (tester) async {
      await tester.pumpWidget(
        TestApp(
          wrapInProviderScope: true,
          child: Scaffold(
            opaqueAppBar: opaque,
            title: 'Dashboard',
            body: ListView(
              children: [
                for (var i = 0; i < 20; i++)
                  SizedBox(height: 100, child: Text('Row $i')),
              ],
            ),
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, -450));
      await tester.pumpAndSettle();
      final bar = find.byKey(const ValueKey('opaque-app-bar'));
      expect(bar, opaque ? findsOneWidget : findsNothing);
      if (opaque) {
        final decoration =
            tester.widget<DecoratedBox>(bar).decoration as BoxDecoration;
        expect(decoration.color!.a, 1);
        expect(decoration.border!.bottom.width, greaterThan(0));
      }
      expect(tester.takeException(), isNull);
    });
  }
}
