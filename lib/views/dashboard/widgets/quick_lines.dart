import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/line_data.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';

class QuickLines extends ConsumerWidget {
  const QuickLines({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = dashboardLines(ref);
    if (lines.length < 2) return const SizedBox.shrink();
    final density = DashboardDensityScope.of(context);
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          context.appLocalizations.quickLines,
          style: BusinessText.cardTitle(
            context,
            mobile: !density.isDesktop,
          ).copyWith(color: context.colorScheme.onSurface),
        ),
        const Spacer(),
        PressRegion(
          shape: AppShape.full,
          overlay: PressRegion.hoverOverlay,
          onTap: () => ref
              .read(currentPageLabelProvider.notifier)
              .toPage(PageLabel.proxies),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                Text(
                  context.appLocalizations.proxies,
                  style: BusinessText.quickMetaMobile(
                    context,
                  ).copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
                GlyphIcon(
                  AppGlyphs.chevronForward,
                  size: 14,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
    final cards = [
      for (final line in lines)
        _QuickLineCard(
          line: line,
          onTap: () => unawaited(
            ref
                .read(proxiesActionProvider.notifier)
                .changeProxy(groupName: line.groupName, proxyName: line.name),
          ),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: density.isCompact ? 8 : 9,
      children: [
        header,
        LayoutBuilder(
          builder: (context, constraints) {
            if (density.isDesktop) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 14,
                  children: [for (final card in cards) Expanded(child: card)],
                ),
              );
            }
            final scale = MediaQuery.textScalerOf(context).scale(1);
            if (constraints.maxWidth / scale < 340) {
              return Column(spacing: 11, children: cards);
            }
            return Column(
              spacing: 11,
              children: [
                for (var index = 0; index < cards.length; index += 2)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 11,
                      children: [
                        Expanded(child: cards[index]),
                        if (index + 1 < cards.length)
                          Expanded(child: cards[index + 1])
                        else
                          const Spacer(),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _QuickLineCard extends StatelessWidget {
  const _QuickLineCard({required this.line, required this.onTap});

  final DashboardLine line;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final density = DashboardDensityScope.of(context);
    final mobile = !density.isDesktop;
    final delay = line.delay;
    final delayColor = colorScheme.delayColor(delay);
    final meta = [
      line.type.toUpperCase(),
      if (line.rate case final rate?)
        '${context.appLocalizations.lineRate} ${rate.toStringAsFixed(2)}x',
      if (mobile && line.current) context.appLocalizations.businessCurrentNode,
    ].join(' · ');
    final compact = density.isCompact;
    final cardHeight = mobile
        ? 77.0
        : compact
        ? 72.0
        : 92.0;
    return DashboardCard(
      onTap: onTap,
      semanticLabel: line.name,
      radius: mobile ? BusinessRadius.quickMobile : BusinessRadius.quickDesktop,
      side: line.current
          ? const BorderSide(color: BusinessPalette.accent, width: 1.5)
          : BorderSide.none,
      padding: EdgeInsetsDirectional.fromSTEB(
        mobile ? 14 : 18,
        mobile ? 12 : 16,
        mobile ? 14 : 18,
        mobile ? 11 : 15,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: cardHeight - (mobile ? 23 : 31)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: mobile || compact ? 6 : 8,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              spacing: 6,
              children: [
                Expanded(
                  child: Tooltip(
                    message: line.name,
                    child: EmojiText(
                      line.displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: BusinessText.quickName(
                        context,
                        mobile: mobile,
                        compact: compact,
                      ),
                    ),
                  ),
                ),
                if (delay != null && delay >= 0)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$delay',
                          style: BusinessText.quickDelay(
                            context,
                            mobile: mobile,
                            compact: compact,
                          ).copyWith(color: delayColor),
                        ),
                        TextSpan(
                          text: ' ms',
                          style:
                              BusinessText.quickUnit(
                                context,
                                mobile: mobile,
                                compact: compact,
                              ).copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                  )
                else if (delay != null)
                  GlyphIcon(
                    AppGlyphs.warning,
                    size: 14,
                    color: colorScheme.error,
                  ),
              ],
            ),
            Text(
              meta,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  (mobile
                          ? BusinessText.quickMetaMobile(context)
                          : compact
                          ? BusinessText.quickMetaCompact(context)
                          : BusinessText.quickMeta(context))
                      .copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
