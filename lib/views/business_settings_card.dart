import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';

class BusinessSettingsCard extends StatelessWidget {
  const BusinessSettingsCard({
    super.key,
    required this.title,
    required this.items,
    this.trailing,
  });

  final String title;
  final List<Widget> items;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: context.colorScheme.brightness == Brightness.dark
          ? context.colorScheme.surfaceContainerLow
          : context.colorScheme.surface,
      shape: AppShape.all(BusinessPalette.cardRadius),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: BusinessText.cardTitle(context)),
                ),
                ?trailing,
              ],
            ),
          ),
          const SizedBox(height: 8),
          generateGroup(items),
        ],
      ),
    ),
  );
}
