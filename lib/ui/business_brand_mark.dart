import 'dart:async';

import 'package:flutter/widgets.dart';

const _brandMarkAsset = 'assets/images/icon.png';

class BusinessBrandMark extends StatelessWidget {
  const BusinessBrandMark({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    final cacheSize = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return Image.asset(
      _brandMarkAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      cacheWidth: cacheSize,
      cacheHeight: cacheSize,
    );
  }
}

void precacheBusinessBrandMarks(BuildContext context) {
  final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
  for (final size in const [28.0, 34.0]) {
    final cacheSize = (size * devicePixelRatio).round();
    unawaited(
      precacheImage(
        ResizeImage(
          const AssetImage(_brandMarkAsset),
          width: cacheSize,
          height: cacheSize,
        ),
        context,
      ),
    );
  }
}
