import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';

class BusinessWarningBanner extends StatelessWidget {
  const BusinessWarningBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: ShapeDecoration(
      color: BusinessPalette.exitBannerBackgroundFor(
        context.colorScheme.brightness,
      ),
      shape: AppShape.all(BusinessRadius.heroDesktop).copyWith(
        side: BorderSide(
          color: BusinessPalette.exitBannerStrokeFor(
            context.colorScheme.brightness,
          ),
        ),
      ),
    ),
    child: Text(
      message,
      style: BusinessText.metaLabel(context).copyWith(
        color: BusinessPalette.exitWarningForegroundFor(
          context.colorScheme.brightness,
        ),
      ),
    ),
  );
}

class BusinessSettingsCard extends StatelessWidget {
  const BusinessSettingsCard({
    super.key,
    this.title,
    required this.items,
    this.trailing,
    this.footer,
  });

  final String? title;
  final List<Widget> items;
  final Widget? trailing;
  final Widget? footer;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: context.colorScheme.brightness == Brightness.dark
          ? context.colorScheme.surfaceContainerLow
          : context.colorScheme.surface,
      shape: AppShape.all(
        MacOSMetrics.cardRadius(context, fallback: BusinessPalette.cardRadius),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: MacOSStyle.of(context) ? 8 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null && title!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title!, style: BusinessText.cardTitle(context)),
                  ),
                  ?trailing,
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          MacOSStyle.of(context)
              ? ListItemInsets(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: generateGroup(items),
                )
              : generateGroup(items),
          ?footer,
        ],
      ),
    ),
  );
}
