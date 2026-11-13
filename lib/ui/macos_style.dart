import 'package:flutter/widgets.dart';
import 'package:prism_ui/paged_sheet.dart';
import 'package:prism_ui/motion.dart' show fadeTabDuration;
import 'package:prism_ui/prism_ui.dart'
    show BuildContextExtension, ElasticPress, Theme;

class MacOSTextScaler extends TextScaler {
  const MacOSTextScaler(this.userScale);

  final double userScale;

  static const _ios = [11.0, 12, 13, 15, 17, 20, 22, 28, 34];
  static const _mac = [10.0, 10, 10, 11, 13, 15, 17, 22, 26];

  @override
  double scale(double fontSize) {
    if (fontSize <= 2) return fontSize * userScale;
    if (fontSize <= _ios.first) return 10 * userScale;
    for (var index = 1; index < _ios.length; index++) {
      if (fontSize <= _ios[index]) {
        final fraction =
            (fontSize - _ios[index - 1]) / (_ios[index] - _ios[index - 1]);
        return (_mac[index - 1] + (_mac[index] - _mac[index - 1]) * fraction) *
            userScale;
      }
    }
    return (_mac.last + (fontSize - _ios.last) * (_mac.last / _ios.last)) *
        userScale;
  }

  @override
  double get textScaleFactor => userScale;

  @override
  TextScaler clamp({
    double minScaleFactor = 0.0,
    double maxScaleFactor = double.infinity,
  }) => _ClampedMacOSTextScaler(this, minScaleFactor, maxScaleFactor);
}

class _ClampedMacOSTextScaler extends TextScaler {
  const _ClampedMacOSTextScaler(this.parent, this.min, this.max);

  final MacOSTextScaler parent;
  final double min;
  final double max;

  @override
  double scale(double fontSize) =>
      parent.scale(fontSize).clamp(fontSize * min, fontSize * max);

  @override
  double get textScaleFactor => parent.userScale;

  @override
  TextScaler clamp({
    double minScaleFactor = 0.0,
    double maxScaleFactor = double.infinity,
  }) => _ClampedMacOSTextScaler(parent, minScaleFactor, maxScaleFactor);
}

class MacOSStyle extends InheritedWidget {
  const MacOSStyle({required this.enabled, required super.child, super.key});

  final bool enabled;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MacOSStyle>()?.enabled ??
      Theme.of(context).platform == TargetPlatform.macOS;

  @override
  bool updateShouldNotify(MacOSStyle oldWidget) => enabled != oldWidget.enabled;
}

class MacOSPlatformStyle extends StatelessWidget {
  const MacOSPlatformStyle({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final enabled = Theme.of(context).platform == TargetPlatform.macOS;
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: enabled
          ? media.copyWith(
              textScaler: MacOSTextScaler(media.textScaler.scale(1)),
            )
          : media,
      child: MacOSStyle(enabled: enabled, child: child),
    );
  }
}

class MacOSPressFeedback extends StatelessWidget {
  const MacOSPressFeedback({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) => MacOSStyle.of(context)
      ? child
      : ElasticPress(enabled: enabled, child: child);
}

class MacOSPagedSheetRoute<T> extends PagedSheetRoute<T> {
  MacOSPagedSheetRoute({
    required this.macOS,
    this.reducedMotion = false,
    required super.builder,
  });

  final bool macOS;
  final bool reducedMotion;
  final SnapshotController _snapshot = SnapshotController();

  @override
  void dispose() {
    _snapshot.dispose();
    super.dispose();
  }

  @override
  Duration get transitionDuration => macOS
      ? reducedMotion
            ? Duration.zero
            : fadeTabDuration
      : super.transitionDuration;

  @override
  Duration get reverseTransitionDuration => macOS
      ? reducedMotion
            ? Duration.zero
            : const Duration(milliseconds: 120)
      : super.reverseTransitionDuration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (!macOS) {
      return super.buildTransitions(
        context,
        animation,
        secondaryAnimation,
        child,
      );
    }
    if (context.disableAnimations) {
      return child;
    }
    final transition = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    return FadeTransition(
      opacity: transition,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.98, end: 1).animate(transition),
        child: SnapshotWidget(
          controller: _snapshot,
          mode: SnapshotMode.permissive,
          autoresize: true,
          child: child,
        ),
      ),
    );
  }
}

abstract final class MacOSMetrics {
  static double pageContentInset(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 24 : fallback;
  static double pageHeaderHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 44 : fallback;
  static double pageHeaderTopInset(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 13 : fallback;
  static double pageHeaderContentGap(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 20 : fallback;
  static double pageContentTop(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context)
      ? context.appBarInset + pageHeaderContentGap(context, fallback: fallback)
      : fallback;
  static double narrowPageWidth(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 680 : fallback;
  static double cardGap(BuildContext context, {required double fallback}) =>
      MacOSStyle.of(context) ? 12 : fallback;
  static double cardTitleGap(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 8 : fallback;
  static double singleLineRowHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 34 : fallback;
  static double doubleLineRowHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 48 : fallback;
  static double sidebarSectionGap(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 12 : fallback;
  static double switchTrailingInset(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 4 : fallback;
  static double cardRadius(BuildContext context, {required double fallback}) =>
      MacOSStyle.of(context) ? 9 : fallback;
  static EdgeInsets cardPadding(
    BuildContext context,
    EdgeInsetsGeometry fallback,
  ) => (MacOSStyle.of(context) ? const EdgeInsets.all(16) : fallback).resolve(
    Directionality.of(context),
  );
  static EdgeInsets compactCardPadding(
    BuildContext context, {
    required EdgeInsets fallback,
  }) => MacOSStyle.of(context)
      ? const EdgeInsets.symmetric(horizontal: 12, vertical: 4)
      : fallback;
  static double buttonHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 26 : fallback;
  static double dashboardPowerSize(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 148 : fallback;
  static double dashboardSummaryCardHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 148 : fallback;
  static double dashboardHeroMinHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 0 : fallback;
  static double dashboardSceneHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 48 : fallback;
  static double dashboardControlHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 48 : fallback;
  static double dashboardTopPadding(
    BuildContext context, {
    required double appBarInset,
    required double fallback,
  }) => MacOSStyle.of(context)
      ? appBarInset + pageHeaderContentGap(context, fallback: fallback)
      : fallback;
  static double switchWidth(BuildContext context, {required double fallback}) =>
      MacOSStyle.of(context) ? 32 : fallback;
  static double switchHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 18 : fallback;
  static double chipHeight(BuildContext context, {required double fallback}) =>
      MacOSStyle.of(context) ? 20 : fallback;
  static double inputHeight(BuildContext context, {required double fallback}) =>
      MacOSStyle.of(context) ? 28 : fallback;
  static double segmentedHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 24 : fallback;
  static double listRowHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 34 : fallback;
  static double proxyGroupHeaderHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 34 : fallback;
  static double sidebarRowHeight(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 28 : fallback;
  static double sidebarIconSize(
    BuildContext context, {
    required double fallback,
  }) => MacOSStyle.of(context) ? 16 : fallback;
  static double pageMargin(BuildContext context, {required double fallback}) =>
      MacOSStyle.of(context) ? 24 : fallback;
}
