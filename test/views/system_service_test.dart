import 'package:fl_clash/core/desktop/helper_client.dart';
import 'package:fl_clash/views/system_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  for (final readiness in HelperReadiness.values) {
    testWidgets('shows the mapped status for ${readiness.name}', (
      tester,
    ) async {
      await tester.pumpWidget(
        TestApp(
          locale: const Locale('zh', 'CN'),
          wrapInProviderScope: true,
          child: SystemServiceView(
            readinessNameReader: () async => readiness.name,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final expected = switch (readiness) {
        HelperReadiness.ready => '已安装并运行',
        HelperReadiness.notReady => '未安装',
        HelperReadiness.manifestMissing => '异常',
      };
      expect(find.textContaining(expected), findsOneWidget);
      if (readiness == HelperReadiness.manifestMissing) {
        expect(find.textContaining(readiness.name), findsOneWidget);
      }
    });
  }

  test('unknown readiness names map to abnormal', () {
    expect(
      helperServiceStatusForName('futureReadiness'),
      HelperServiceStatus.abnormal,
    );
  });

  testWidgets('shows an unknown readiness name as abnormal', (tester) async {
    await tester.pumpWidget(
      TestApp(
        locale: const Locale('zh', 'CN'),
        wrapInProviderScope: true,
        child: SystemServiceView(
          readinessNameReader: () async => 'futureReadiness',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('异常'), findsOneWidget);
    expect(find.textContaining('futureReadiness'), findsOneWidget);
  });
}
