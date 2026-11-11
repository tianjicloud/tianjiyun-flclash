import 'package:fl_clash/views/dashboard/core_detail.dart';
import 'package:fl_clash/views/dashboard/widgets/memory_info.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('shows core status and the confirmed restart action', (
    tester,
  ) async {
    await tester.pumpWidget(
      TestApp(
        wrapInProviderScope: true,
        child: CoreDetailView(
          memoryReader: () async => const MemorySnapshot(app: 64 * 1024 * 1024),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Core status'), findsAtLeastNWidgets(1));
    expect(find.text('Not running'), findsOneWidget);
    expect(find.text('Restart core'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
