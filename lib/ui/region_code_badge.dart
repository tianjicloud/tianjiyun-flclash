import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';

class RegionCodeBadge extends StatelessWidget {
  const RegionCodeBadge({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final width = math.max(30.0, code.length * 6.5 * scale + 12);
    final height = math.max(20.0, 15 * scale);
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: Color(0xFF0E1726),
        shape: AppShape.sm,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            code.toUpperCase(),
            maxLines: 1,
            style: AppTextStyle.custom(
              context,
              size: 10,
              leading: 12,
              weight: FontWeight.w600,
            ).copyWith(color: const Color(0xFFFFFFFF)),
          ),
        ),
      ),
    );
  }
}
