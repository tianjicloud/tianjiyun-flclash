import 'dart:math' as math;
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/traffic/model.dart';
import 'package:fl_clash/providers/traffic.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';

class TrafficSavingsCard extends ConsumerWidget {
  const TrafficSavingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final service = ref.watch(trafficStatsProvider);
    return DashboardCard(
      semanticLabel: appLocalizations.trafficStats,
      child: ValueListenableBuilder<TrafficSummary>(
        valueListenable: service.summary,
        builder: (context, summary, _) {
          if (BusinessTheme.of(context)) {
            final colors = DashboardColors.of(context);
            final entries = [
              (
                appLocalizations.businessProxyTraffic,
                summary.monthProxy,
                BusinessPalette.blue,
              ),
              (
                appLocalizations.businessMainlandDirect,
                summary.monthMainlandDirect,
                colors.ok,
              ),
              (
                appLocalizations.trafficOtherDirect,
                summary.month.otherDirect.total,
                colors.tone2,
              ),
            ];
            final total = entries.fold(0, (sum, entry) => sum + entry.$2);
            final bar = ClipRSuperellipse(
              borderRadius: AppRadius.full,
              child: SizedBox(
                height: 10,
                child: total == 0
                    ? ColoredBox(color: colors.tone2)
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final entry in entries)
                            if (entry.$2 > 0)
                              Expanded(
                                flex: math.max(
                                  1,
                                  (entry.$2 / total * 1000).round(),
                                ),
                                child: ColoredBox(color: entry.$3),
                              ),
                        ],
                      ),
              ),
            );
            final legend = Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                for (final (label, bytes, color) in entries)
                  Row(
                    spacing: 8,
                    children: [
                      CustomPaint(
                        painter: _LegendDotPainter(color),
                        child: const SizedBox.square(dimension: 8),
                      ),
                      Expanded(
                        child: Text(
                          label,
                          style:
                              BusinessText.dataBody(
                                context,
                                mobile: !DashboardDensityScope.of(
                                  context,
                                ).isDesktop,
                              ).copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                      Text(
                        dashboardTraffic(bytes),
                        style: BusinessText.quickMeta(context)
                            .copyWith(color: context.colorScheme.onSurface)
                            .toJetBrainsMono,
                      ),
                    ],
                  ),
              ],
            );
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 6,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DashboardCardHeader(
                            title: appLocalizations.businessMonthTraffic,
                          ),
                        ),
                        Text(
                          dashboardTraffic(total),
                          style: BusinessText.trafficTotal(context),
                        ),
                      ],
                    ),
                    bar,
                    legend,
                  ],
                ),
                Text(
                  appLocalizations.businessTrafficScope,
                  style: DashboardText.label(context),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardCardHeader(
                glyph: AppGlyphs.dataUsage,
                title: appLocalizations.trafficStats,
              ),
              const SizedBox(height: 4),
              Text(
                appLocalizations.trafficStatsScope,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: DashboardText.label(context),
              ),
              const SizedBox(height: 12),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: _TrafficStat(
                      label: appLocalizations.mainlandDirect,
                      bytes: summary.monthMainlandDirect,
                    ),
                  ),
                  Expanded(
                    child: _TrafficStat(
                      label: appLocalizations.vpnTraffic,
                      bytes: summary.monthProxy,
                    ),
                  ),
                  Expanded(
                    child: _TrafficStat(
                      label: appLocalizations.trafficSavedThisMonth,
                      bytes: summary.monthSavings,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TrafficStat extends StatelessWidget {
  const _TrafficStat({required this.label, required this.bytes});

  final String label;
  final int bytes;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DashboardText.label(context),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            dashboardTraffic(bytes),
            maxLines: 1,
            style: DashboardText.figure(context, AppTextStyle.title2),
          ),
        ),
      ],
    );
  }
}

class _LegendDotPainter extends CustomPainter {
  const _LegendDotPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_LegendDotPainter oldDelegate) =>
      color != oldDelegate.color;
}
