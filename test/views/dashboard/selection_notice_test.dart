import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:fl_clash/views/dashboard/widgets/selection_notice.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('egress mismatch shows actual and selected countries', (
    tester,
  ) async {
    await tester.pumpWidget(
      TestApp(
        locale: const Locale('zh', 'CN'),
        overrides: [
          selectionCheckProvider.overrideWith(() => _MismatchSelectionCheck()),
        ],
        child: const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 320, child: SelectionNotice()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('出口在美国，所选线路在日本'), findsOneWidget);
  });

  for (final verdict in SelectionVerdict.values) {
    testWidgets('selection notice renders $verdict at large text', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          locale: const Locale('zh', 'CN'),
          overrides: [
            selectionCheckProvider.overrideWithBuild((_, _) => verdict),
          ],
          child: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(1.6)),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: 320, child: SelectionNotice()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final hidden =
          verdict == SelectionVerdict.untouched ||
          verdict == SelectionVerdict.consistent;
      expect(find.byType(Text), hidden ? findsNothing : findsWidgets);
      expect(
        find.text('重新检测'),
        !hidden && verdict != SelectionVerdict.confirming
            ? findsOneWidget
            : findsNothing,
      );
    });
  }
}

class _MismatchSelectionCheck extends SelectionCheck {
  @override
  SelectionVerdict build() {
    egressMismatchCountries = (actual: 'US', expected: 'JP');
    return SelectionVerdict.egressMismatch;
  }
}
