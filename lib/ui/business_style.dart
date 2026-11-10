import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';
import 'fonts.dart';

abstract final class BusinessPalette {
  static const blue = Color(0xFF0A55F5);
  static const onBlue = Color(0xFFFFFFFF);
  static const accent = blue;
  static const page = Color(0xFFF2F2F7);
  static const deep = Color(0xFF0E1726);
  static const secondary = Color(0xFF56616F);
  static const sidebarSecondary = Color(0xFF4A5568);
  static const sidebarDarkSecondary = Color(0xFFB9C0E4);
  static const sidebarDarkSelected = Color(0xFFEDF0FF);
  static const sidebarDarkSelectedBackground = Color(0x2E0A55F5);
  static const sidebarDarkSelectedAccent = activeGlyph;
  static const activeGlyph = Color(0xFFAEB9FF);
  static const sidebarDarkBackground = Color(0xFF1A2330);
  static const sidebarDarkMuted = Color(0xFF8E97C4);
  static const sidebarSelection = Color(0xFFFFFFFF);
  static const sidebarSelectionShadow = Color(0x140E1726);
  static const sidebarLight = Color(0xFFF7F8FA);
  static const hintBackground = Color(0xFFF4F8FF);
  static const searchStroke = Color(0x120E1726);
  static const searchShadow = Color(0x0A0E1726);
  static const sidebarDarkOverlay = Color(0x8C0A0F2B);
  static const heroChipText = Color(0xFF2D3748);
  static const connected = Color(0xFF0E8A5F);
  static const connectedText = Color(0xFF0B6E4B);
  static const connectedBackground = Color(0xFFE7F5EF);
  static const connectedTextDark = Color(0xFF5ADBB1);
  static const connectedBackgroundDark = Color(0xFF17352D);
  static const residentialChip = Color(0xFFE6EEFE);
  static const residentialChipText = Color(0xFF0842C2);
  static const secondaryButtonTop = Color(0xFFFFFFFF);
  static const secondaryButtonBottom = Color(0xFFF6F7F9);
  static const secondaryButtonDarkTop = Color(0xFF27313E);
  static const secondaryButtonDarkBottom = Color(0xFF1A2330);
  static const secondaryButtonStroke = Color(0x240E1726);
  static const secondaryButtonDarkStroke = Color(0x407E8A98);
  static const warning = Color(0xFFA15C00);
  static const exitWarningDark = Color(0xFFF2B44C);
  static const exitWarningInk = Color(0xFF241700);
  static const exitWarningGradientStart = Color(0xFFF7C66A);
  static const exitWarningGradientEnd = Color(0xFFF2B44C);
  static const exitBannerLight = Color(0xFFFFF8EC);
  static const exitBannerDark = Color(0xFF2A2111);
  static const exitBannerStrokeLight = Color(0x40A15C00);
  static const exitBannerStrokeDark = Color(0x59F2B44C);
  static const warningBackground = Color(0xFFFDF1E3);
  static const warningText = Color(0xFF8A4B00);
  static const warningTextDark = Color(0xFFFFCB75);
  static const warningBackgroundDark = Color(0xFF382B19);
  static const expiryBackground = Color(0xFFFFF8EC);
  static const expiryBorder = Color(0xFFF3D9A8);
  static const expiryText = Color(0xFF5C3A00);
  static const expiryBackgroundDark = Color(0xFF30281D);
  static const expiryBorderDark = Color(0xFF55432B);
  static const expiryTextDark = Color(0xFFF0D3A2);
  static const disconnected = Color(0xFF8A94A3);
  static const disconnectedBackground = Color(0xFFEEF1F4);
  static const disconnectedDark = Color(0xFFAAB4C2);
  static const disconnectedBackgroundDark = Color(0xFF242B34);
  static const idleOrbitPlate = Color(0x0A768096);
  static const idleOrbitPlateDark = Color(0x0A768096);
  static const dockLight = Color(0xF0FFFFFF);
  static const dockDark = Color(0xF0131921);
  static const noticeDark = Color(0xFF1C2430);
  static const error = Color(0xFFB42335);
  static const cardRadius = 18.0;
  static const buttonRadius = 16.0;
  static LinearGradient gradient(ColorScheme scheme) => LinearGradient(
    colors: [Color.lerp(blue, Colors.white, 0.12)!, blue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const navSelection = LinearGradient(
    colors: [Color(0xFFE6EEFE), Color(0xFFE6EEFE)],
  );

  static Color connectedContainerFor(Brightness brightness) =>
      brightness == Brightness.dark
      ? connectedBackgroundDark
      : connectedBackground;

  static Color connectedForegroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? connectedTextDark : connectedText;

  static Color warningContainerFor(Brightness brightness) =>
      brightness == Brightness.dark ? warningBackgroundDark : warningBackground;

  static Color warningForegroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? warningTextDark : warningText;

  static Color exitWarningForegroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? exitWarningDark : warning;

  static Color exitBannerBackgroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? exitBannerDark : exitBannerLight;

  static Color exitBannerStrokeFor(Brightness brightness) =>
      brightness == Brightness.dark
      ? exitBannerStrokeDark
      : exitBannerStrokeLight;

  static Color expiryContainerFor(Brightness brightness) =>
      brightness == Brightness.dark ? expiryBackgroundDark : expiryBackground;

  static Color expiryBorderFor(Brightness brightness) =>
      brightness == Brightness.dark ? expiryBorderDark : expiryBorder;

  static Color expiryForegroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? expiryTextDark : expiryText;

  static Color disconnectedContainerFor(Brightness brightness) =>
      brightness == Brightness.dark
      ? disconnectedBackgroundDark
      : disconnectedBackground;

  static Color disconnectedForegroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? disconnectedDark : disconnected;

  static Color idleOrbitPlateFor(Brightness brightness) =>
      brightness == Brightness.dark ? idleOrbitPlateDark : idleOrbitPlate;
}

abstract final class BusinessShadow {
  static BoxShadow selectedLine(Color color) => BoxShadow(
    color: color.withValues(alpha: 0.35),
    offset: const Offset(0, 12),
    blurRadius: (28 / 2 - 0.5) / 0.57735,
    spreadRadius: -12,
  );
}

Color businessDelayColor(ColorScheme colorScheme, int? delay) {
  if (delay == null) return colorScheme.onSurfaceVariant;
  return delay >= 0 && delay < 80
      ? BusinessPalette.connectedForegroundFor(colorScheme.brightness)
      : BusinessPalette.warningForegroundFor(colorScheme.brightness);
}

/// The business home's off-scale type roles. The Dynamic Type steps are close but
/// not the design's: its headline IP, 14 dp card titles and 10.5 dp dock
/// labels sit between steps, so they are named here once instead of repeated
/// as bare sizes at call sites.
abstract final class BusinessText {
  static const _tabular = [FontFeature.tabularFigures()];

  static TextStyle pageTitle(BuildContext context) => AppTextStyle.custom(
    context,
    size: 22,
    leading: 28,
    weight: FontWeight.w700,
  ).copyWith(letterSpacing: 0.5);

  static TextStyle heroIp(BuildContext context, {required double size}) =>
      AppTextStyle.custom(
        context,
        size: math.min(size, 46),
        leading: math.min(size, 46),
        weight: FontWeight.w600,
      ).copyWith(letterSpacing: -0.3, fontFeatures: _tabular).toJetBrainsMono;

  static TextStyle heroStatus(BuildContext context) => AppTextStyle.custom(
    context,
    size: 12,
    leading: 16,
    weight: FontWeight.w500,
  );

  static TextStyle heroSpeed(BuildContext context) => AppTextStyle.custom(
    context,
    size: 20,
    leading: 24,
    weight: FontWeight.w600,
  ).toJetBrainsMono;

  static TextStyle countryCode(BuildContext context) => AppTextStyle.custom(
    context,
    size: 11,
    leading: 14,
    weight: FontWeight.w600,
  ).toJetBrainsMono;

  static TextStyle metaLabel(BuildContext context) =>
      AppTextStyle.custom(context, size: 12, leading: 16);

  static TextStyle metaValue(BuildContext context) => AppTextStyle.custom(
    context,
    size: 15,
    leading: 20,
    weight: FontWeight.w600,
  );

  static TextStyle trafficTotal(BuildContext context) => AppTextStyle.custom(
    context,
    size: 22,
    leading: 26,
    weight: FontWeight.w600,
  ).toJetBrainsMono;

  static TextStyle actionLabel(
    BuildContext context, {
    bool emphasized = false,
  }) => AppTextStyle.custom(
    context,
    size: 13,
    leading: 18,
    weight: emphasized ? FontWeight.w600 : FontWeight.w500,
  );

  static TextStyle heroMetaValue(BuildContext context) => AppTextStyle.custom(
    context,
    size: 14,
    leading: 18,
    weight: FontWeight.w600,
  ).copyWith(fontFeatures: _tabular);

  static TextStyle cardTitle(BuildContext context, {bool mobile = false}) =>
      AppTextStyle.custom(
        context,
        size: mobile ? 12.5 : 14,
        leading: mobile ? 18 : 20,
        weight: FontWeight.w600,
      );

  static TextStyle cardDelay(BuildContext context) => AppTextStyle.custom(
    context,
    size: 15,
    leading: 18,
    weight: FontWeight.w600,
  ).toJetBrainsMono;

  static TextStyle linesNodeTitle(
    BuildContext context, {
    required bool emphasized,
  }) => AppTextStyle.custom(
    context,
    size: 15,
    leading: 19,
    weight: emphasized ? FontWeight.w600 : FontWeight.w400,
  );

  static TextStyle inlineIp(BuildContext context) =>
      AppTextStyle.custom(context, size: 12, leading: 16).toJetBrainsMono;

  static TextStyle quickName(
    BuildContext context, {
    bool mobile = false,
    bool compact = false,
  }) => AppTextStyle.custom(
    context,
    size: mobile
        ? 13.5
        : compact
        ? 14
        : 15.5,
    leading: mobile
        ? 18
        : compact
        ? 20
        : 22,
    weight: FontWeight.w600,
  );

  static TextStyle quickDelay(
    BuildContext context, {
    bool mobile = false,
    bool compact = false,
  }) => AppTextStyle.custom(
    context,
    size: mobile
        ? 16
        : compact
        ? 17
        : 19,
    leading: mobile
        ? 20
        : compact
        ? 20
        : 24,
    weight: FontWeight.w800,
  ).copyWith(fontFeatures: _tabular);

  static TextStyle quickUnit(
    BuildContext context, {
    bool mobile = false,
    bool compact = false,
  }) => AppTextStyle.custom(
    context,
    size: mobile || compact ? 10 : 11,
    leading: mobile || compact ? 12 : 14,
  );

  static TextStyle quickMetaCompact(BuildContext context) =>
      AppTextStyle.custom(context, size: 11.5, leading: 15);

  static TextStyle quickMeta(BuildContext context) =>
      AppTextStyle.custom(context, size: 12.5, leading: 17);

  static TextStyle quickMetaMobile(BuildContext context) =>
      AppTextStyle.custom(context, size: 11.5, leading: 16);

  static TextStyle dataBig(BuildContext context, {bool mobile = false}) =>
      AppTextStyle.custom(
        context,
        size: mobile ? 23 : 30,
        leading: mobile ? 28 : 36,
        weight: FontWeight.w700,
      ).copyWith(fontFeatures: _tabular);

  static TextStyle dataBigUnit(BuildContext context, {bool mobile = false}) =>
      AppTextStyle.custom(context, size: mobile ? 13 : 15, leading: 20);

  static TextStyle residentialExit(
    BuildContext context, {
    bool mobile = false,
  }) => AppTextStyle.custom(
    context,
    size: mobile ? 18 : 22,
    leading: mobile ? 24 : 28,
    weight: FontWeight.w700,
  );

  static TextStyle dataBody(BuildContext context, {bool mobile = false}) =>
      AppTextStyle.custom(
        context,
        size: mobile ? 11.5 : 12.5,
        leading: mobile ? 18 : 20,
      );

  static TextStyle notice(BuildContext context) => AppTextStyle.custom(
    context,
    size: 12,
    leading: 16,
    weight: FontWeight.w500,
  );

  static TextStyle sidebarBrand(BuildContext context) => AppTextStyle.custom(
    context,
    size: 17,
    leading: 22,
    weight: FontWeight.w700,
  ).copyWith(letterSpacing: 0.5);

  static TextStyle sidebarTagline(BuildContext context) =>
      AppTextStyle.custom(context, size: 11, leading: 14);

  static TextStyle sidebarNav(BuildContext context, {bool selected = false}) =>
      AppTextStyle.custom(
        context,
        size: 14,
        leading: 20,
        weight: selected ? FontWeight.w600 : FontWeight.w400,
      );

  static TextStyle sidebarAccount(BuildContext context) => AppTextStyle.custom(
    context,
    size: 13,
    leading: 18,
    weight: FontWeight.w600,
  );

  static TextStyle sidebarAccountSub(BuildContext context) =>
      AppTextStyle.custom(context, size: 11.5, leading: 16);

  static TextStyle dockLabel(BuildContext context, {bool selected = false}) =>
      AppTextStyle.custom(
        context,
        size: 12,
        leading: 16,
        weight: selected ? FontWeight.w600 : FontWeight.w400,
      );

  static TextStyle mobileMetric(BuildContext context) => AppTextStyle.custom(
    context,
    size: 15,
    leading: 20,
    weight: FontWeight.w600,
  ).copyWith(fontFeatures: _tabular).toJetBrainsMono;

  static TextStyle quickLineDelay(BuildContext context) => AppTextStyle.custom(
    context,
    size: 12,
    leading: 16,
  ).copyWith(fontFeatures: _tabular).toJetBrainsMono;

  static TextStyle quickSectionTitle(BuildContext context) =>
      AppTextStyle.custom(
        context,
        size: 15,
        leading: 20,
        weight: FontWeight.w700,
      );

  static TextStyle mobileMetricLabel(BuildContext context) =>
      AppTextStyle.custom(context, size: 12, leading: 16);

  static TextStyle mobileCardHeading(BuildContext context) =>
      AppTextStyle.custom(context, size: 12, leading: 16);

  static TextStyle mobileCardValue(BuildContext context) => AppTextStyle.custom(
    context,
    size: 13,
    leading: 18,
    weight: FontWeight.w600,
  );

  static TextStyle mobileUsageValue(BuildContext context) =>
      AppTextStyle.custom(
        context,
        size: 18,
        leading: 22,
        weight: FontWeight.w700,
      ).copyWith(fontFeatures: _tabular).toJetBrainsMono;

  static TextStyle mobileUsageUnit(BuildContext context) => AppTextStyle.custom(
    context,
    size: 12,
    leading: 16,
    weight: FontWeight.w600,
  );

  static TextStyle controlLabel(BuildContext context) =>
      AppTextStyle.custom(context, size: 12, leading: 16);

  static TextStyle controlValue(BuildContext context) => AppTextStyle.custom(
    context,
    size: 15,
    leading: 20,
    weight: FontWeight.w600,
  );

  static TextStyle sceneNote(BuildContext context) =>
      AppTextStyle.custom(context, size: 12.5, leading: 18);

  static TextStyle toggleTitle(BuildContext context) => AppTextStyle.custom(
    context,
    size: 13.5,
    leading: 18,
    weight: FontWeight.w600,
  );

  static TextStyle toggleSub(BuildContext context) =>
      AppTextStyle.custom(context, size: 11, leading: 15);

  static TextStyle segment(BuildContext context, {bool mobile = false}) =>
      AppTextStyle.custom(
        context,
        size: mobile ? 12.5 : 13.5,
        leading: mobile ? 17 : 18,
        weight: FontWeight.w600,
      );

  static TextStyle startLabel(BuildContext context) =>
      AppTextStyle.custom(context, size: 13, leading: 18);
}

/// The design's per-surface corner values, which one card token cannot carry.
abstract final class BusinessRadius {
  static const linesDesktop = 18.0;
  static const code = 5.0;
  static const brandMobile = 6.0;
  static const heroDesktop = 18.0;
  static const heroMobile = 18.0;
  static const sceneDesktop = 16.0;
  static const sceneMobile = 16.0;
  static const quickDesktop = 16.0;
  static const quickMobile = 16.0;
  static const dataDesktop = 18.0;
  static const dataMobile = 16.0;
  static const control = 16.0;
  static const metricMobile = 16.0;
  static const navItem = 10.0;
  static const account = 14.0;
  static const dock = 24.0;
}
