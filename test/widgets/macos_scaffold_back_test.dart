import 'package:fl_clash/ui/scaffold/scaffold.dart' show Scaffold;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart' show AppBar, ThemeData, ViewScope;

import '../helpers/test_app.dart';

void main() {
  testWidgets('macOS detail page back button returns to its parent', (
    tester,
  ) async {
    await tester.pumpWidget(
      HostApp(
        theme: ThemeData(platform: TargetPlatform.macOS),
        builder: (context, child) => ViewScope(
          size: const Size(1280, 800),
          isMobile: false,
          child: wrapAppScopes(context, child!),
        ),
        home: Builder(
          builder: (context) => Scaffold(
            title: 'Parent',
            body: GestureDetector(
              onTap: () => Navigator.of(context).push<void>(
                PageRouteBuilder<void>(
                  pageBuilder: (_, _, _) => const Scaffold(
                    businessTitleInset: true,
                    title: 'Detail',
                    body: SizedBox.expand(),
                  ),
                ),
              ),
              child: const Text('Open detail'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open detail'));
    await tester.pumpAndSettle();

    expect(find.text('Detail'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(tester.getSize(find.byType(AppBar)).height, 44);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Parent'), findsOneWidget);
  });
}
