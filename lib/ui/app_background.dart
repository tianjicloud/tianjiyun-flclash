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
    final preset = AppBackgroundScope.of(context);
    final dark = scheme.brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: !visible || inherited
                  ? const SizedBox.shrink()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final planet = preset == 'planet';
                        final deep = planet && dark;
                        final wide = constraints.maxWidth >= 640;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            if (deep) const ColoredBox(color: _planetDeep),
                            if (const [
                              'planet',
                              'aurora',
                              'nebula',
                              'globe',
                            ].contains(preset))
                              deep
                                  ? Opacity(
                                      opacity: 0.55,
                                      child: Image.asset(
                                        'assets/images/background_$preset.jpg',
                                        fit: BoxFit.cover,
                                        alignment: wide
                                            ? Alignment.center
                                            : Alignment.topCenter,
                                        excludeFromSemantics: true,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/background_$preset.jpg',
                                      fit: BoxFit.cover,
                                      excludeFromSemantics: true,
                                    )
                            else
                              SvgPicture.asset(
                                'assets/images/background_$preset.svg',
                                fit: BoxFit.cover,
                                excludeFromSemantics: true,
                              ),
                            if (deep)
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: _planetVeil(wide: wide),
                                ),
                              )
                            else
                              ColoredBox(
                                color: SurfaceLevel.page
                                    .colorOf(scheme)
                                    .withValues(alpha: dark ? 0.64 : 0.86),
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ),
        _PaintedBackground(visible: visible, child: child),
      ],
    );
  }
}

const _planetDeep = Color(0xFF070B1F);

/// Nearly black on the content side, letting the planet show through the other.
LinearGradient _planetVeil({required bool wide}) => wide
    ? const LinearGradient(
        begin: Alignment(-1, -0.18),
        end: Alignment(1, 0.18),
        colors: [
          Color(0xE0070B1F),
          Color(0xE0070B1F),
          Color(0x8C070B1F),
          Color(0x59070B1F),
        ],
        stops: [0, 0.30, 0.65, 1],
      )
    : const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xB8070B1F), Color(0xE6070B1F)],
        stops: [0, 0.55],
      );

class _PaintedBackground extends InheritedWidget {
  const _PaintedBackground({required this.visible, required super.child});

  final bool visible;

  @override
  bool updateShouldNotify(_PaintedBackground oldWidget) =>
      visible != oldWidget.visible;
}
