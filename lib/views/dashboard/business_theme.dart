import 'dart:math' as math;

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
  Widget build(BuildContext context) => BusinessTheme(child: child);
}

class OrbitPainter extends CustomPainter {
  const OrbitPainter({required this.color, required this.focused, this.pulse});

  final Color color;
  final bool focused;
  final double? pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    if (pulse case final pulse? when pulse < 0.3) {
      final wave = pulse / 0.3;
      final spread = radius * (0.78 + 0.2 * wave);
      canvas.drawCircle(
        center,
        spread,
        Paint()
          ..color = color.withValues(alpha: 0.35 * (1 - wave))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      canvas.drawCircle(
        center,
        radius * 0.97,
        Paint()
          ..color = color.withValues(
            alpha: 0.12 + 0.1 * math.sin(wave * math.pi),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawCircle(
      center,
      radius * 0.99,
      Paint()
        ..color = color.withValues(alpha: focused ? 0.6 : 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
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
            Color.lerp(color, Colors.white, 0.32)!,
            color,
            Color.lerp(color, BusinessPalette.deep, 0.55)!,
          ],
        ).createShader(ball),
    );
    final specular = center + Offset(-radius * 0.24, -radius * 0.34);
    final specularRadius = radius * 0.3;
    canvas.drawCircle(
      specular,
      specularRadius,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.34),
                Colors.white.withValues(alpha: 0),
              ],
            ).createShader(
              Rect.fromCircle(center: specular, radius: specularRadius),
            ),
    );
    final satellite = center + Offset(0, -radius * 0.985);
    final satelliteRadius = math.max(2.0, radius * 0.038);
    canvas.drawCircle(
      satellite,
      satelliteRadius * 2.6,
      Paint()
        ..color = Color.lerp(color, Colors.white, 0.7)!.withValues(alpha: 0.22),
    );
    canvas.drawCircle(
      satellite,
      satelliteRadius,
      Paint()..color = Color.lerp(color, Colors.white, 0.9)!,
    );
  }

  @override
  bool shouldRepaint(OrbitPainter oldDelegate) =>
      color != oldDelegate.color ||
      focused != oldDelegate.focused ||
      pulse != oldDelegate.pulse;
}
