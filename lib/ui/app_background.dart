import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prism_ui/prism_ui.dart';

class AppBackgroundScope extends InheritedWidget {
  const AppBackgroundScope({
    super.key,
    required this.preset,
    required super.child,
  });

  final String preset;

  static String of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<AppBackgroundScope>()
          ?.preset ??
      'solid';

  static const imagePresets = [
    'orbit',
    'mountains',
    'planet',
    'aurora',
    'nebula',
    'globe',
  ];

  static bool hasImage(BuildContext context) =>
      imagePresets.contains(of(context));

  @override
  bool updateShouldNotify(AppBackgroundScope oldWidget) =>
      preset != oldWidget.preset;
}

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, this.enabled = true, required this.child});

  final bool enabled;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inherited =
        context
            .dependOnInheritedWidgetOfExactType<_PaintedBackground>()
            ?.visible ??
        false;
    final visible = enabled && AppBackgroundScope.hasImage(context);
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: !visible || inherited
                  ? const SizedBox.shrink()
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        if (const [
                          'planet',
                          'aurora',
                          'nebula',
                          'globe',
                        ].contains(AppBackgroundScope.of(context)))
                          Image.asset(
                            'assets/images/background_${AppBackgroundScope.of(context)}.jpg',
                            fit: BoxFit.cover,
                            excludeFromSemantics: true,
                          )
                        else
                          SvgPicture.asset(
                            'assets/images/background_${AppBackgroundScope.of(context)}.svg',
                            fit: BoxFit.cover,
                            excludeFromSemantics: true,
                          ),
                        ColoredBox(
                          color: SurfaceLevel.page
                              .colorOf(scheme)
                              .withValues(
                                alpha: scheme.brightness == Brightness.dark
                                    ? 0.64
                                    : 0.86,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        _PaintedBackground(visible: visible, child: child),
      ],
    );
  }
}

class _PaintedBackground extends InheritedWidget {
  const _PaintedBackground({required this.visible, required super.child});

  final bool visible;

  @override
  bool updateShouldNotify(_PaintedBackground oldWidget) =>
      visible != oldWidget.visible;
}
