import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/region_code_badge.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/line_data.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';

class QuickLines extends ConsumerWidget {
  const QuickLines({super.key, required this.onChooseResidential});

  final VoidCallback onChooseResidential;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = dashboardLines(ref);
    if (lines.length < 2) return const SizedBox.shrink();
    final density = DashboardDensityScope.of(context);
    final connected = ref.watch(isStartProvider) && !ref.watch(suspendProvider);
    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          context.appLocalizations.quickLines,
          style: density.isDesktop
              ? BusinessText.cardTitle(
                  context,
                ).copyWith(color: context.colorScheme.onSurface)
              : BusinessText.quickSectionTitle(
                  context,
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
                  context.appLocalizations.businessAllLines,
                  style: BusinessText.quickMetaMobile(
                    context,
                  ).copyWith(color: BusinessPalette.residentialChipText),
                ),
                const GlyphIcon(
                  AppGlyphs.chevronForward,
                  size: 14,
                  color: BusinessPalette.residentialChipText,
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
          connected: connected,
          onTap: line.residential
              ? onChooseResidential
              : () => unawaited(
                  ref
                      .read(proxiesActionProvider.notifier)
                      .changeProxy(
                        groupName: line.groupName,
                        proxyName: line.name,
                      ),
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
              return Column(spacing: 10, children: cards);
            }
            return Column(
              spacing: 10,
              children: [
                for (var index = 0; index < cards.length; index += 2)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 10,
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
  const _QuickLineCard({
    required this.line,
    required this.connected,
    required this.onTap,
  });

  final DashboardLine line;
  final bool connected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final density = DashboardDensityScope.of(context);
    final mobile = !density.isDesktop;
    final delay = line.delay;
    final delayColor = businessDelayColor(colorScheme, delay);
    final parsedRegion = _regionNameFromFlag(line.displayName);
    final regionName = (
      code: line.countryCode ?? parsedRegion.code,
      name: parsedRegion.name,
    );
    final meta = [
      if (!mobile) line.type.toUpperCase(),
      if (line.rate case final rate?)
        mobile
            ? '· ${rate.toStringAsFixed(1)}×'
            : '${context.appLocalizations.lineRate} ${rate.toStringAsFixed(2)}x',
      if (mobile && line.current)
        connected
            ? '· ${context.appLocalizations.businessCurrent}'
            : '· ${context.appLocalizations.businessSelected}',
    ].join(mobile ? ' ' : ' · ');
    final compact = density.isCompact;
    final cardHeight = mobile
        ? 66.0
        : compact
        ? 72.0
        : 92.0;
    final card = DashboardCard(
      onTap: onTap,
      semanticLabel: line.name,
      radius: mobile ? BusinessRadius.quickMobile : BusinessRadius.quickDesktop,
      side: line.current
          ? const BorderSide(color: BusinessPalette.accent, width: 2)
          : BorderSide.none,
      shadows: line.current
          ? DashboardShadows.accentGlow(color: BusinessPalette.blue)
          : null,
      padding: EdgeInsetsDirectional.fromSTEB(
        mobile ? 12 : 18,
        mobile ? 11 : 16,
        mobile ? 12 : 18,
        mobile ? 10 : 15,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: cardHeight - (mobile ? 23 : 31)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: mobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          spacing: mobile
              ? 4
              : compact
              ? 6
              : 8,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              spacing: 6,
              children: [
                if (mobile && regionName.code != null)
                  RegionCodeBadge(code: regionName.code!),
                Expanded(
                  child: Tooltip(
                    message: line.name,
                    child: EmojiText(
                      mobile ? regionName.name : line.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: BusinessText.quickName(
                        context,
                        mobile: mobile,
                        compact: compact,
                      ),
                    ),
                  ),
                ),
                if (!mobile && delay != null && delay >= 0)
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
                else if (!mobile && delay != null)
                  GlyphIcon(
                    AppGlyphs.warning,
                    size: 14,
                    color: colorScheme.error,
                  ),
              ],
            ),
            if (mobile)
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  if (delay != null && delay >= 0)
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$delay',
                            style: BusinessText.quickLineDelay(
                              context,
                            ).copyWith(color: delayColor),
                          ),
                          TextSpan(
                            text: ' ms',
                            style: BusinessText.quickLineDelay(context)
                                .copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    )
                  else if (delay != null)
                    GlyphIcon(
                      AppGlyphs.warning,
                      size: 14,
                      color: colorScheme.error,
                    )
                  else
                    Text(
                      context.appLocalizations.servicePending,
                      style: BusinessText.quickMetaMobile(
                        context,
                      ).copyWith(color: context.colorScheme.onSurfaceVariant),
                    ),
                  if (meta.isNotEmpty)
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: BusinessText.quickMetaMobile(
                        context,
                      ).copyWith(color: context.colorScheme.onSurfaceVariant),
                    ),
                ],
              )
            else
              Text(
                meta,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    (compact
                            ? BusinessText.quickMetaCompact(context)
                            : BusinessText.quickMeta(context))
                        .copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
          ],
        ),
      ),
    );
    return card;
  }
}

({String? code, String name}) _regionNameFromFlag(String name) {
  final prefix = RegExp(r'^([A-Z]{2})\s*[·|—-]\s*(.+)$').firstMatch(name);
  if (prefix != null) {
    return (code: prefix.group(1), name: prefix.group(2)!);
  }
  final runes = name.runes.toList();
  var start = 0;
  while (start < runes.length &&
      (runes[start] == 0x20 || runes[start] == 0xA0)) {
    start++;
  }
  if (start + 1 >= runes.length ||
      runes[start] < 0x1F1E6 ||
      runes[start] > 0x1F1FF ||
      runes[start + 1] < 0x1F1E6 ||
      runes[start + 1] > 0x1F1FF) {
    return (code: null, name: name);
  }
  final code = String.fromCharCodes([
    65 + runes[start] - 0x1F1E6,
    65 + runes[start + 1] - 0x1F1E6,
  ]);
  return (
    code: code,
    name: String.fromCharCodes(runes.skip(start + 2)).trimLeft(),
  );
}
