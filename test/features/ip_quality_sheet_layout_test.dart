import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/ip_quality.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/ip_quality/ip_quality_sheet.dart';
import 'package:fl_clash/providers/ip_quality.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('query failure switches network details without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ipQualityProvider.overrideWith(
            (_, _) async => throw const IpQualityLookupException([
              (source: IpQualitySource.ipApiCom, status: IpQualitySourceStatus.failed),
              (source: IpQualitySource.identMe, status: IpQualitySourceStatus.timeout),
            ]),
          ),
        ],
        child: TestApp(
          child: Builder(
            builder: (context) => FilledButton(
              onPressed: () => showIpQualitySheet(context, ip: '203.0.113.9'),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(currentAppLocalizations.ipQualitySources), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
