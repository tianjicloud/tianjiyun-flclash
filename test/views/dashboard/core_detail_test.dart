import 'package:fl_clash/views/dashboard/core_detail.dart';
import 'package:fl_clash/views/dashboard/widgets/memory_info.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_app.dart';

class _MockCoreHandler extends Mock implements CoreHandlerInterface {}

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

  testWidgets('shows memory components and releases Core cache', (
    tester,
  ) async {
    final core = _MockCoreHandler();
    when(() => core.forceGc()).thenAnswer((_) async {});
    await tester.pumpWidget(
      TestApp(
        wrapInProviderScope: true,
        overrides: [
          coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
          coreStatusProvider.overrideWithValue(CoreStatus.connected),
        ],
        child: CoreDetailView(
          memoryReader: () async => const MemorySnapshot(
            app: 64 * 1024 * 1024,
            coreTotal: 32 * 1024 * 1024,
            core: CoreMemoryStats(
              rss: 32 * 1024 * 1024,
              heapInuse: 8 * 1024 * 1024,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Interface memory'), findsOneWidget);
    expect(find.text('Kernel memory'), findsOneWidget);
    expect(find.text('Heap in use'), findsOneWidget);
    await tester.tap(find.text('Release cache'));
    await tester.pump();
    verify(() => core.forceGc()).called(1);
  });
}
