import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/macos_style.dart';

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        colorScheme: MacOSStyle.of(context)
            ? theme.colorScheme
            : theme.colorScheme.copyWith(
                primary: BusinessPalette.blue,
                onPrimary: BusinessPalette.onBlue,
                primaryContainer: BusinessPalette.residentialChip,
                onPrimaryContainer: BusinessPalette.residentialChipText,
                surfaceTint: BusinessPalette.blue,
              ),
      ),
      child: BusinessTheme(child: child),
    );
  }
}

class OrbitPainter extends CustomPainter {
  const OrbitPainter({
    required this.color,
    required this.primary,
    required this.idleCore,
    required this.idleStroke,
    required this.idleShadow,
    required this.idlePlate,
    required this.focused,
    required this.running,
    this.loadingProgress,
    this.pulse,
  });

  final Color color;
  final Color primary;
  final Color idleCore;
  final Color idleStroke;
  final Color idleShadow;
  final Color idlePlate;
  final bool focused;
  final bool running;
  final double? loadingProgress;
  final double? pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final tickStart = radius * 0.86;
    final tickEnd = radius * 0.95;
    final ballRadius = radius * 0.71;
    if (running) {
      canvas.drawCircle(
        center,
        radius * 0.84,
        Paint()..color = primary.withValues(alpha: 0.08),
      );
    } else {
      final plate = Rect.fromCircle(center: center, radius: radius);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [idlePlate, idlePlate.withValues(alpha: 0)],
            stops: const [0.82, 1],
          ).createShader(plate),
      );
    }
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
    for (var i = 0; i < 48; i++) {
      final phase = loadingProgress == null
          ? 1.0
          : ((i / 48 - loadingProgress!) % 1 + 1) % 1;
      final highlighted = loadingProgress != null && phase < 0.18;
      final tick = Paint()
        ..color = color.withValues(
          alpha: loadingProgress == null
              ? focused
                    ? 0.96
                    : 0.78
              : highlighted
              ? 0.62 + 0.38 * (1 - phase / 0.18)
              : 0.08,
        )
        ..strokeWidth = math.max(1.2, radius * (highlighted ? 0.032 : 0.022))
        ..strokeCap = StrokeCap.round;
      final angle = i * math.pi / 24 - math.pi / 2;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * tickStart,
        center + direction * tickEnd,
        tick,
      );
    }
    final ball = Rect.fromCircle(center: center, radius: ballRadius);
    if (!running) {
      canvas.drawCircle(
        center + Offset(0, radius * 0.06),
        ballRadius,
        Paint()
          ..color = idleShadow
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.09),
      );
    }
    if (running) {
      canvas.drawCircle(
        center,
        ballRadius + radius * 0.04,
        Paint()
          ..color = primary.withValues(alpha: 0.08)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.07),
      );
    }
    canvas.drawCircle(
      center,
      ballRadius,
      Paint()
        ..color = running ? primary : idleCore
        ..shader = running
            ? RadialGradient(
                center: const Alignment(0, -0.44),
                radius: 1.12,
                colors: [
                  Color.lerp(primary, Colors.white, 0.38)!,
                  primary,
                  Color.lerp(primary, Colors.black, 0.22)!,
                ],
                stops: const [0, 0.52, 1],
              ).createShader(ball)
            : null,
    );
    if (running) {
      canvas.drawCircle(
        center,
        ballRadius,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Color(0x70FFFFFF), Color(0x00FFFFFF)],
          ).createShader(ball),
      );
    }
    canvas.drawCircle(
      center,
      ballRadius,
      Paint()
        ..color = running ? Colors.white.withValues(alpha: 0.16) : idleStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = running ? 1 : 0.5,
    );
  }

  @override
  bool shouldRepaint(OrbitPainter oldDelegate) =>
      color != oldDelegate.color ||
      focused != oldDelegate.focused ||
      running != oldDelegate.running ||
      primary != oldDelegate.primary ||
      idleCore != oldDelegate.idleCore ||
      idleStroke != oldDelegate.idleStroke ||
      idleShadow != oldDelegate.idleShadow ||
      idlePlate != oldDelegate.idlePlate ||
      pulse != oldDelegate.pulse ||
      loadingProgress != oldDelegate.loadingProgress;
}
