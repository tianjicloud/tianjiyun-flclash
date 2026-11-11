import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/widgets/icon.dart';
import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';

class BusinessPackageIcon extends StatelessWidget {
  const BusinessPackageIcon({
    super.key,
    required this.packageName,
    required this.label,
    required this.size,
  });

  final String packageName;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial = label.isEmpty
        ? '?'
        : String.fromCharCode(label.runes.first).toUpperCase();
    final hash = _stableHash(packageName);
    final color = BusinessPalette
        .connectionAppColors[hash % BusinessPalette.connectionAppColors.length];
    return SizedBox.square(
      dimension: size,
      child: ClipRSuperellipse(
        borderRadius: AppRadius.all(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: color,
              child: Center(
                child: Text(
                  initial,
                  style: AppTextStyle.body
                      .of(context, emphasized: true)
                      .copyWith(color: BusinessPalette.onBlue),
                ),
              ),
            ),
            if (packageName.isNotEmpty)
              PackageIcon(packageName: packageName, size: size),
          ],
        ),
      ),
    );
  }
}

int _stableHash(String value) {
  var hash = 0x811c9dc5;
  for (final rune in value.runes) {
    hash = ((hash ^ rune) * 0x01000193) & 0xffffffff;
  }
  return hash;
}
