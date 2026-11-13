import 'package:fl_clash/views/core_startup_failure.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/host_scaffold.dart';
import '../helpers/test_app.dart';

Future<void> _pumpFailure(WidgetTester tester, String error) async {
  await tester.pumpWidget(
    TestApp(
      wrapInProviderScope: true,
      child: HostScaffold(
        body: Navigator(
          pages: [
            const RootPage(child: SizedBox.shrink()),
            RootPage(child: CoreStartupFailureView(error: error)),
          ],
          onDidRemovePage: (_) {},
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('port errors offer automatic port selection and report export', (
    tester,
  ) async {
    await _pumpFailure(
      tester,
      'listen tcp 127.0.0.1:7890: bind: address already in use',
    );

    expect(find.text('Choose an available port'), findsOneWidget);
    expect(find.text('Export support report'), findsOneWidget);
  });

  testWidgets('other startup errors only offer report export', (tester) async {
    await _pumpFailure(tester, 'configuration is invalid');

    expect(find.text('Choose an available port'), findsNothing);
    expect(find.text('Export support report'), findsOneWidget);
  });
}
