import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';

abstract final class BusinessPalette {
  static const blue = Color(0xFF3D5AFE);
  static const violet = Color(0xFF7C4DFF);
  static const accent = Color(0xFF6A5CFF);
  static const page = Color(0xFF0A0F2B);
  static const deep = Color(0xFF070B1F);
  static const paper = Color(0xFFF2F4FF);
  static const text = Color(0xFFEDF0FF);
  static const secondary = Color(0xFF98A2C8);
  static const purple = Color(0xFF8C78FF);
  static const connected = Color(0xFF34E0B0);
  static const warning = Color(0xFFFFC24D);
  static const error = Color(0xFFFF5C7A);
  static const cardRadius = 22.0;
  static const buttonRadius = 14.0;
  static const gradient = LinearGradient(colors: [blue, accent]);
}

class BusinessTheme extends InheritedTheme {
  const BusinessTheme({super.key, required super.child});

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BusinessTheme>() != null;

  @override
  bool updateShouldNotify(BusinessTheme oldWidget) => false;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      BusinessTheme(child: child);
}

class BusinessAppearance extends StatelessWidget {
  const BusinessAppearance({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final page = dark ? BusinessPalette.page : BusinessPalette.paper;
    final panel = Color.alphaBlend(
      Colors.white.withValues(alpha: dark ? 0.04 : 0.7),
      page,
    );
    final scheme = theme.colorScheme.copyWith(
      surface: page,
      surfaceContainer: dark ? panel : page,
      surfaceBright: panel,
      surfaceContainerHigh: Color.alphaBlend(
        Colors.white.withValues(alpha: dark ? 0.08 : 0.4),
        page,
      ),
      surfaceContainerHighest: Color.alphaBlend(
        BusinessPalette.secondary.withValues(alpha: 0.18),
        page,
      ),
      onSurface: dark ? BusinessPalette.text : BusinessPalette.page,
      onSurfaceVariant: dark
          ? BusinessPalette.secondary
          : Color.lerp(BusinessPalette.secondary, BusinessPalette.page, 0.55),
      error: dark ? BusinessPalette.error : theme.colorScheme.error,
    );
    return BusinessTheme(
      child: Theme(
        data: theme.copyWith(colorScheme: scheme, elevatedColorScheme: scheme),
        child: ButtonTheme.merge(
          data: ButtonThemeData(
            filled: ButtonStyle.from(
              shape: AppShape.all(BusinessPalette.buttonRadius),
            ),
            text: ButtonStyle.from(
              shape: AppShape.all(BusinessPalette.buttonRadius),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class BusinessBackdrop extends StatelessWidget {
  const BusinessBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: IgnorePointer(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _SpacePainter(Theme.brightnessOf(context)),
            ),
          ),
        ),
      ),
      child,
    ],
  );
}

class _SpacePainter extends CustomPainter {
  const _SpacePainter(this.brightness);

  final Brightness brightness;

  @override
  void paint(Canvas canvas, Size size) {
    final dark = brightness == Brightness.dark;
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [BusinessPalette.page, BusinessPalette.deep]
              : [BusinessPalette.paper, Colors.white],
        ).createShader(rect),
    );
    for (final (center, color) in [
      (const Alignment(0.9, -1), BusinessPalette.violet),
      (const Alignment(-1, 1), BusinessPalette.blue),
    ]) {
      canvas.drawRect(
        rect,
        Paint()
          ..shader = RadialGradient(
            center: center,
            radius: 0.9,
            colors: [
              color.withValues(alpha: dark ? 0.16 : 0.06),
              color.withValues(alpha: 0),
            ],
          ).createShader(rect),
      );
    }
    if (dark) {
      final paint = Paint()
        ..color = BusinessPalette.text.withValues(alpha: 0.3);
      for (var i = 0; i < 20; i++) {
        canvas.drawCircle(
          Offset(
            ((i * 137 + 51) % 997) / 997 * size.width,
            ((i * 233 + 97) % 991) / 991 * size.height,
          ),
          i.isEven ? 0.8 : 0.5,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SpacePainter oldDelegate) =>
      brightness != oldDelegate.brightness;
}

class OrbitPainter extends CustomPainter {
  const OrbitPainter({required this.color, required this.focused});

  final Color color;
  final bool focused;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    final ring = Paint()
      ..color = color.withValues(alpha: focused ? 1 : 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = focused ? 2 : 1;
    for (var i = 0; i < 48; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.91),
        i * math.pi / 24,
        math.pi / 48,
        false,
        ring,
      );
    }
    canvas.drawCircle(
      center,
      radius * 0.77,
      Paint()..color = color.withValues(alpha: 0.14),
    );
    final ball = Rect.fromCircle(center: center, radius: radius * 0.69);
    canvas.drawCircle(
      center,
      radius * 0.69,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 1,
          colors: [
            Color.lerp(color, Colors.white, 0.22)!,
            color,
            Color.lerp(color, BusinessPalette.deep, 0.5)!,
          ],
        ).createShader(ball),
    );
  }

  @override
  bool shouldRepaint(OrbitPainter oldDelegate) =>
      color != oldDelegate.color || focused != oldDelegate.focused;
}
