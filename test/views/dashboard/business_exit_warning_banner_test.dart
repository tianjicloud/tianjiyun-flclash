import 'package:fl_clash/views/dashboard/business_exit_warning_banner.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/host_scaffold.dart';
import '../../helpers/test_app.dart';

Widget _app({
  required BusinessExitWarningKind? kind,
  required VoidCallback onRetry,
  required VoidCallback onAuthorize,
  required VoidCallback onDiagnostics,
}) => TestApp(
  locale: const Locale('en'),
  child: BusinessAppearance(
    child: HostScaffold(
      body: SizedBox(
        width: 1000,
        child: BusinessExitWarningBanner(
          kind: kind,
          onRetry: onRetry,
          onAuthorize: onAuthorize,
          onDiagnostics: onDiagnostics,
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('probe failure shows retry and diagnostics actions', (
    tester,
  ) async {
    var retries = 0;
    var diagnostics = 0;
    await tester.pumpWidget(
      _app(
        kind: BusinessExitWarningKind.probeFailed,
        onRetry: () => retries++,
        onAuthorize: () {},
        onDiagnostics: () => diagnostics++,
      ),
    );
    await tester.pump();
    expect(find.text('Unable to confirm exit for now'), findsOneWidget);
    expect(
      find.text(
        'The exit check returned no result. The proxy may still be working. Retry or run diagnostics to see why.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Check again'));
    await tester.tap(find.text('View diagnostics'));
    expect(retries, 1);
    expect(diagnostics, 1);
  });

  testWidgets('TUN authorization shows its action', (tester) async {
    var authorizations = 0;
    await tester.pumpWidget(
      _app(
        kind: BusinessExitWarningKind.tunUnauthorized,
        onRetry: () {},
        onAuthorize: () => authorizations++,
        onDiagnostics: () {},
      ),
    );
    await tester.pump();
    expect(
      find.text('Your selected line does not match the actual exit'),
      findsOneWidget,
    );
    await tester.tap(find.text('Authorize virtual adapter'));
    expect(authorizations, 1);
  });

  testWidgets('normal state has no banner content', (tester) async {
    await tester.pumpWidget(
      _app(
        kind: null,
        onRetry: () {},
        onAuthorize: () {},
        onDiagnostics: () {},
      ),
    );
    await tester.pump();
    expect(find.text('Unable to confirm exit for now'), findsNothing);
    expect(tester.getSize(find.byType(BusinessExitWarningBanner)).height, 0);
  });

  test('probe failure takes priority over TUN authorization', () {
    expect(
      businessExitWarningKind(
        active: true,
        coreConnected: true,
        probeFailed: true,
        tunEnabled: true,
        tunAuthorized: false,
      ),
      BusinessExitWarningKind.probeFailed,
    );
    expect(
      businessExitWarningKind(
        active: true,
        coreConnected: true,
        probeFailed: false,
        tunEnabled: true,
        tunAuthorized: false,
      ),
      BusinessExitWarningKind.tunUnauthorized,
    );
    expect(
      businessExitWarningKind(
        active: false,
        coreConnected: true,
        probeFailed: false,
        tunEnabled: true,
        tunAuthorized: false,
      ),
      isNull,
    );
  });
}
