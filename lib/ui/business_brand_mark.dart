import 'package:flutter/widgets.dart';

class BusinessBrandMark extends StatelessWidget {
  const BusinessBrandMark({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _BusinessBrandMarkPainter(),
    );
  }
}

class _BusinessBrandMarkPainter extends CustomPainter {
  const _BusinessBrandMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 32;
    final rect = Offset.zero & size;
    final backgroundPaint = Paint()..color = const Color(0xFF0E1726);
    canvas.drawRSuperellipse(
      RSuperellipse.fromRectAndRadius(rect, Radius.circular(8 * scale)),
      backgroundPaint,
    );
    canvas.drawCircle(
      Offset(16 * scale, 16 * scale),
      6.5 * scale,
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8 * scale,
    );
    canvas.drawCircle(
      Offset(21.3 * scale, 11.2 * scale),
      2.4 * scale,
      Paint()..color = const Color(0xFF5B8CFF),
    );
  }

  @override
  bool shouldRepaint(_BusinessBrandMarkPainter oldDelegate) => false;
}
