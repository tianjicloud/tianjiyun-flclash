import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';

abstract final class BusinessPalette {
  static const blue = Color(0xFF3D5AFE);
  static const violet = Color(0xFF7C4DFF);
  static const accent = Color(0xFF6A5CFF);
  static const page = Color(0xFF0A0F2B);
  static const deep = Color(0xFF070B1F);
  static const secondary = Color(0xFF98A2C8);
  static const purple = Color(0xFF8C78FF);
  static const connected = Color(0xFF34E0B0);
  static const warning = Color(0xFFFFC24D);
  static const error = Color(0xFFFF5C7A);
  static const cardRadius = 22.0;
  static const buttonRadius = 14.0;
  static const gradient = LinearGradient(colors: [blue, accent]);
  static const navSelection = LinearGradient(
    colors: [Color(0x523D5AFE), Color(0x2E7C4DFF)],
  );
}

/// The V3 home's off-scale type roles. The Dynamic Type steps are close but
/// not the design's: its headline IP, 14 dp card titles and 10.5 dp dock
/// labels sit between steps, so they are named here once instead of repeated
/// as bare sizes at call sites.
abstract final class BusinessText {
  static const _tabular = [FontFeature.tabularFigures()];

  static TextStyle pageTitle(BuildContext context) => AppTextStyle.custom(
    context,
    size: 26,
    leading: 32,
    weight: FontWeight.w700,
  ).copyWith(letterSpacing: 0.5);

  static TextStyle heroIp(BuildContext context, {required double size}) =>
      AppTextStyle.custom(
        context,
        size: size,
        leading: size * 1.08,
        weight: FontWeight.w800,
      ).copyWith(letterSpacing: 0.5, fontFeatures: _tabular);

  static TextStyle heroStatus(BuildContext context) => AppTextStyle.custom(
    context,
    size: 13,
    leading: 18,
    weight: FontWeight.w500,
  );

  static TextStyle metaLabel(BuildContext context) =>
      AppTextStyle.custom(context, size: 12, leading: 16);

  static TextStyle metaValue(BuildContext context) => AppTextStyle.custom(
    context,
    size: 15,
    leading: 20,
    weight: FontWeight.w600,
  );

  static TextStyle cardTitle(BuildContext context, {bool mobile = false}) =>
      AppTextStyle.custom(
        context,
        size: mobile ? 12.5 : 14,
        leading: mobile ? 18 : 20,
        weight: FontWeight.w600,
      );

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
        weight: FontWeight.w800,
      ).copyWith(fontFeatures: _tabular);

  static TextStyle dataBigUnit(BuildContext context, {bool mobile = false}) =>
      AppTextStyle.custom(context, size: mobile ? 13 : 15, leading: 20);

  static TextStyle dataBody(BuildContext context, {bool mobile = false}) =>
      AppTextStyle.custom(
        context,
        size: mobile ? 11.5 : 12.5,
        leading: mobile ? 18 : 20,
      );

  static TextStyle notice(BuildContext context) => AppTextStyle.custom(
    context,
    size: 11.5,
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

  static TextStyle sidebarNav(BuildContext context) =>
      AppTextStyle.custom(context, size: 14.5, leading: 20);

  static TextStyle sidebarAccount(BuildContext context) => AppTextStyle.custom(
    context,
    size: 13,
    leading: 18,
    weight: FontWeight.w600,
  );

  static TextStyle sidebarAccountSub(BuildContext context) =>
      AppTextStyle.custom(context, size: 11.5, leading: 16);

  static TextStyle dockLabel(BuildContext context) => AppTextStyle.custom(
    context,
    size: 10.5,
    leading: 14,
    weight: FontWeight.w500,
  );

  static TextStyle controlLabel(BuildContext context) =>
      AppTextStyle.custom(context, size: 13, leading: 18);

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
  static const brandMobile = 10.0;
  static const heroDesktop = 26.0;
  static const heroMobile = 24.0;
  static const sceneDesktop = 20.0;
  static const sceneMobile = 24.0;
  static const quickDesktop = 20.0;
  static const quickMobile = 18.0;
  static const dataDesktop = 24.0;
  static const dataMobile = 20.0;
  static const control = 22.0;
  static const metricMobile = 20.0;
  static const navItem = 13.0;
  static const account = 15.0;
  static const dock = 24.0;
}
