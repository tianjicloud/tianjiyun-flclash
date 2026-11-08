import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';
import 'fonts.dart';

abstract final class BusinessPalette {
  static const blue = Color(0xFF0A55F5);
  static const violet = Color(0xFF6A4BD8);
  static const accent = blue;
  static const page = Color(0xFFF2F2F7);
  static const deep = Color(0xFF0E1726);
  static const secondary = Color(0xFF56616F);
  static const purple = Color(0xFF6A4BD8);
  static const connected = Color(0xFF0B6E4B);
  static const warning = Color(0xFFA15C00);
  static const error = Color(0xFFB42335);
  static const cardRadius = 18.0;
  static const buttonRadius = 16.0;
  static const gradient = LinearGradient(
    colors: [Color(0xFF2E6DFF), blue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const navSelection = LinearGradient(
    colors: [Color(0xFFE6EEFE), Color(0xFFE6EEFE)],
  );
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
        leading: math.min(size, 46) * 1.08,
        weight: FontWeight.w800,
      ).copyWith(letterSpacing: -0.3, fontFeatures: _tabular).toJetBrainsMono;

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
  static const brandMobile = 6.0;
  static const heroDesktop = 18.0;
  static const heroMobile = 18.0;
  static const sceneDesktop = 16.0;
  static const sceneMobile = 16.0;
  static const quickDesktop = 16.0;
  static const quickMobile = 14.0;
  static const dataDesktop = 18.0;
  static const dataMobile = 16.0;
  static const control = 16.0;
  static const metricMobile = 16.0;
  static const navItem = 10.0;
  static const account = 14.0;
  static const dock = 24.0;
}
