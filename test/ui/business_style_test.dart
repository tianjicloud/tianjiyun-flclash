import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';

import '../helpers/test_app.dart';

Future<BuildContext> _context(WidgetTester tester) async {
  late BuildContext context;
  await tester.pumpWidget(
    TestApp(
      child: Builder(
        builder: (inner) {
          context = inner;
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return context;
}

void main() {
  test('the expiry notice swaps its whole palette with the brightness', () {
    for (final brightness in Brightness.values) {
      final dark = brightness == Brightness.dark;
      expect(
        BusinessPalette.expiryContainerFor(brightness),
        dark
            ? BusinessPalette.expiryBackgroundDark
            : BusinessPalette.expiryBackground,
      );
      expect(
        BusinessPalette.expiryBorderFor(brightness),
        dark ? BusinessPalette.expiryBorderDark : BusinessPalette.expiryBorder,
      );
      expect(
        BusinessPalette.expiryForegroundFor(brightness),
        dark ? BusinessPalette.expiryTextDark : BusinessPalette.expiryText,
      );
    }
  });

  test('a delay is good below 80 ms and a warning from 80 ms or a timeout', () {
    final scheme = ColorScheme.fromSeed(seedColor: BusinessPalette.blue);
    final good = BusinessPalette.connectedForegroundFor(scheme.brightness);
    final warn = BusinessPalette.warningForegroundFor(scheme.brightness);
    expect(businessDelayColor(scheme, null), scheme.onSurfaceVariant);
    expect(businessDelayColor(scheme, 79), good);
    expect(businessDelayColor(scheme, 80), warn);
    expect(businessDelayColor(scheme, -1), warn);
  });

  testWidgets('addresses, protocols and metrics are set in the mono face', (
    tester,
  ) async {
    final context = await _context(tester);
    final mono = FontFamily.jetBrainsMono.value;
    for (final style in [
      BusinessText.dnsDomain(context),
      BusinessText.proxyProtocol(context),
      BusinessText.customRuleContent(context),
      BusinessText.mobileSubscriptionMetric(context),
      BusinessText.inlineIp(context),
      BusinessText.quickLineDelay(context),
    ]) {
      expect(style.fontFamily, mono);
    }
    for (final style in [
      BusinessText.dnsPreviewTitle(context),
      BusinessText.customEditorTitle(context),
      BusinessText.mobileSubscriptionTitle(context),
      BusinessText.mobileSubscriptionLargeUnit(context),
      BusinessText.mobileSubscriptionUnit(context),
      BusinessText.quickMetaCompact(context),
    ]) {
      expect(style.fontFamily, isNot(mono));
    }
  });

  testWidgets('delays keep tabular figures so they do not shift as they tick', (
    tester,
  ) async {
    final context = await _context(tester);
    const tabular = FontFeature.tabularFigures();
    for (final style in [
      BusinessText.quickDelay(context),
      BusinessText.quickDelay(context, compact: true),
      BusinessText.quickDelay(context, mobile: true),
      BusinessText.quickLineDelay(context),
    ]) {
      expect(style.fontFeatures, contains(tabular));
    }
  });

  testWidgets('selection and emphasis only change the weight', (tester) async {
    final context = await _context(tester);
    final tab = BusinessText.customEditorTab(context, selected: false);
    final selectedTab = BusinessText.customEditorTab(context, selected: true);
    expect(selectedTab.fontSize, tab.fontSize);
    expect(selectedTab.fontWeight, FontWeight.w600);
    expect(tab.fontWeight, FontWeight.w400);
    final path = BusinessText.connectionPath(context);
    final emphasized = BusinessText.connectionPath(context, emphasized: true);
    expect(emphasized.fontSize, path.fontSize);
    expect(emphasized.fontWeight, FontWeight.w700);
    expect(path.fontWeight, FontWeight.w500);
    for (final compact in [false, true]) {
      for (final mobile in [false, true]) {
        final unit = BusinessText.quickUnit(
          context,
          mobile: mobile,
          compact: compact,
        );
        expect(unit.fontSize, mobile || compact ? 10 : 11);
      }
    }
  });
}
