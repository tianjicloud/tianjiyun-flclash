import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/core/traffic/service.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/widgets/traffic_savings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/host_scaffold.dart';
import '../../helpers/test_app.dart';
import '../../helpers/traffic_stats_store.dart';

String _traffic(num bytes) {
  final show = bytes.traffic;
  return '${show.value} ${show.unit}';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TrafficAccountingService stats;
  late ProviderContainer container;

  setUp(() {
    stats = TrafficAccountingService(
      store: MemoryTrafficStatsStore(),
      readSnapshot: () async => const TrafficSnapshot(
        version: 1,
        epoch: 1,
        mainlandDirect: TrafficBytes.zero,
        proxy: TrafficBytes.zero,
        otherDirect: TrafficBytes.zero,
      ),
      sampleInterval: const Duration(hours: 1),
      flushInterval: const Duration(hours: 1),
    );
    stats.summary.value = const TrafficSummary(
      today: TrafficAllocation(
        mainlandDirect: TrafficBytes(up: 1024, down: 2048),
        proxy: TrafficBytes(up: 2048, down: 4096),
      ),
      month: TrafficAllocation(
        mainlandDirect: TrafficBytes(up: 1 << 20, down: 2 << 20),
        proxy: TrafficBytes(up: 4 << 20, down: 8 << 20),
      ),
    );
    container = ProviderContainer(
      overrides: [trafficStatsProvider.overrideWithValue(stats)],
    );
    globalState.container = container;
  });

  tearDown(() {
    stats.dispose();
    container.dispose();
  });

  Future<void> pumpCard(
    WidgetTester tester,
    Size size, {
    bool business = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          locale: const Locale('en'),
          child: HostScaffold(
            body: ListView(
              children: [
                DashboardDensityScope(
                  density: size.width >= 640
                      ? DashboardDensity.standard
                      : DashboardDensity.mobile,
                  scale: 1,
                  child: business
                      ? const BusinessAppearance(child: TrafficSavingsCard())
                      : const TrafficSavingsCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('business ring shows all shares and centers mainland direct', (
    tester,
  ) async {
    stats.summary.value = const TrafficSummary(
      month: TrafficAllocation(
        mainlandDirect: TrafficBytes(down: 30),
        proxy: TrafficBytes(down: 60),
        otherDirect: TrafficBytes(down: 10),
      ),
    );
    await pumpCard(tester, const Size(400, 800), business: true);
    for (final value in ['60.0%', '30.0%', '10.0%']) {
      expect(find.text(value), findsOneWidget);
    }
    expect(find.text('Direct (region unconfirmed)'), findsOneWidget);
    final label = tester.widget<Text>(find.text('Mainland direct this month'));
    expect(label.maxLines, isNull);
    expect(label.overflow, TextOverflow.visible);
    expect(label.textAlign, TextAlign.center);
    final title = tester.getCenter(find.text('Mainland direct this month'));
    final saved = tester.getCenter(find.text(_traffic(30)).first);
    expect(saved.dx, closeTo(title.dx, 0.1));
    expect(tester.takeException(), isNull);
    stats.summary.value = TrafficSummary.empty;
    await tester.pump();
    expect(find.text('0.0%'), findsNWidgets(3));
    expect(find.text('NaN%'), findsNothing);
  });

  testWidgets('localizes and fits at a phone width', (tester) async {
    await pumpCard(tester, const Size(400, 800));

    expect(find.text('Traffic statistics'), findsOneWidget);
    expect(find.text('Mainland direct'), findsOneWidget);
    expect(find.text('VPN'), findsOneWidget);
    expect(find.text('Saved this month'), findsOneWidget);

    final monthMainland = _traffic((1 << 20) + (2 << 20));
    final monthProxy = _traffic((4 << 20) + (8 << 20));
    expect(
      find.descendant(
        of: find.byType(TrafficSavingsCard),
        matching: find.text(monthMainland),
      ),
      findsNWidgets(2),
    );
    expect(
      find.descendant(
        of: find.byType(TrafficSavingsCard),
        matching: find.text(monthProxy),
      ),
      findsOneWidget,
    );
    expect(find.text(_traffic(1024 + 2048)), findsNothing);
    expect(find.text(_traffic(2048 + 4096)), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('fits in a desktop column and at a large text scale', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await pumpCard(tester, const Size(1000, 800));

    expect(find.text('Traffic statistics'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
