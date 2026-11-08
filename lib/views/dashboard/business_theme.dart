import 'dart:math' as math;

import 'package:fl_clash/ui/business_style.dart';
import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';

export 'package:fl_clash/ui/business_style.dart'
    show BusinessPalette, BusinessRadius, BusinessText;

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
    final ticks = radius;
    final ballRadius = radius * 0.78;
    if (pulse case final pulse? when pulse < 0.3) {
      final wave = pulse / 0.3;
      canvas.drawCircle(
        center,
        radius * (1.08 + 0.22 * wave),
        Paint()
          ..color = color.withValues(alpha: 0.32 * (1 - wave))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    canvas.drawCircle(
      center,
      radius * 1.18,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0),
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0),
          ],
          stops: const [0.76, 0.92, 1],
        ).createShader(Rect.fromCircle(center: center, radius: radius * 1.18)),
    );
    canvas.drawCircle(
      center,
      radius * 1.18,
      Paint()
        ..color = BusinessPalette.accent.withValues(
          alpha: focused ? 0.55 : 0.35,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final dash = Paint()
      ..color = const Color(0xFF96A0FF).withValues(alpha: focused ? 0.62 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < 40; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: ticks),
        i * math.pi / 20,
        math.pi / 34,
        false,
        dash,
      );
    }
    final ball = Rect.fromCircle(center: center, radius: ballRadius);
    canvas.drawCircle(
      center,
      ballRadius,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.32, -0.4),
          radius: 1.08,
          colors: [Color(0xFFAAB8FF), Color(0xFF3D5AFE), Color(0xFF4527A0)],
          stops: [0, 0.52, 1],
        ).createShader(ball),
    );
    canvas.drawCircle(
      center,
      ballRadius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.18, -0.42),
          radius: 0.9,
          colors: [
            Colors.white.withValues(alpha: 0.26),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(ball),
    );
    final specular = center + Offset(-ballRadius * 0.34, -ballRadius * 0.42);
    final specularRadius = ballRadius * 0.42;
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
    final satellite = center + Offset(0, -ticks);
    final satelliteRadius = math.max(2.4, radius * 0.045);
    canvas.drawCircle(
      satellite,
      satelliteRadius * 2.8,
      Paint()..color = const Color(0xFF8FA2FF).withValues(alpha: 0.28),
    );
    canvas.drawCircle(
      satellite,
      satelliteRadius,
      Paint()..color = const Color(0xFFC9D3FF),
    );
  }

  @override
  bool shouldRepaint(OrbitPainter oldDelegate) =>
      color != oldDelegate.color ||
      focused != oldDelegate.focused ||
      pulse != oldDelegate.pulse;
}
