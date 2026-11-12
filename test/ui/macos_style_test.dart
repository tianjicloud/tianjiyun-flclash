import 'package:fl_clash/ui/macos_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart' show Theme, ThemeData;

void main() {
  test('maps the iOS typography steps to macOS sizes', () {
    const source = [11.0, 12.0, 13.0, 15.0, 17.0, 20.0, 22.0, 28.0, 34.0];
    const expected = [10.0, 10.0, 10.0, 11.0, 13.0, 15.0, 17.0, 22.0, 26.0];
    const scaler = MacOSTextScaler(1);

    for (var index = 0; index < source.length; index++) {
      expect(scaler.scale(source[index]), expected[index]);
    }
    expect(scaler.scale(14), 10.5);
    expect(scaler.scale(9), 10);
  });

  test('applies the user scale after the macOS mapping', () {
    expect(const MacOSTextScaler(1.25).scale(17), 16.25);
    expect(const MacOSTextScaler(1.25).scale(1), 1.25);
    expect(const MacOSTextScaler(1.25).clamp().scale(17), 16.25);
  });

  testWidgets('platform style installs only the macOS text scaler', (
    tester,
  ) async {
    for (final platform in [TargetPlatform.macOS, TargetPlatform.windows]) {
      late TextScaler scaler;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
          child: Theme(
            data: ThemeData(platform: platform),
            child: MacOSPlatformStyle(
              child: Builder(
                builder: (context) {
                  scaler = MediaQuery.textScalerOf(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      if (platform == TargetPlatform.macOS) {
        expect(scaler, isA<MacOSTextScaler>());
        expect(scaler.scale(17), closeTo(16.9, 0.001));
      } else {
        expect(scaler, isNot(isA<MacOSTextScaler>()));
        expect(scaler.scale(17), closeTo(22.1, 0.001));
      }
    }
  });

  testWidgets('macOS metrics switch together and preserve other platforms', (
    tester,
  ) async {
    Future<void> expectMetrics(bool macOS) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MacOSStyle(
            enabled: macOS,
            child: Builder(
              builder: (context) {
                const fallback = EdgeInsets.all(20);
                expect(
                  MacOSMetrics.cardRadius(context, fallback: 18),
                  macOS ? 9 : 18,
                );
                expect(
                  MacOSMetrics.cardPadding(context, fallback),
                  macOS ? const EdgeInsets.all(12) : fallback,
                );
                expect(
                  MacOSMetrics.buttonHeight(context, fallback: 40),
                  macOS ? 26 : 40,
                );
                expect(
                  MacOSMetrics.switchWidth(context, fallback: 50),
                  macOS ? 32 : 50,
                );
                expect(
                  MacOSMetrics.switchHeight(context, fallback: 30),
                  macOS ? 18 : 30,
                );
                expect(
                  MacOSMetrics.segmentedHeight(context, fallback: 36),
                  macOS ? 24 : 36,
                );
                expect(
                  MacOSMetrics.listRowHeight(context, fallback: 48),
                  macOS ? 26 : 48,
                );
                expect(
                  MacOSMetrics.sidebarRowHeight(context, fallback: 40),
                  macOS ? 28 : 40,
                );
                expect(
                  MacOSMetrics.pageMargin(context, fallback: 16),
                  macOS ? 20 : 16,
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    }

    await expectMetrics(false);
    await expectMetrics(true);
  });
}
