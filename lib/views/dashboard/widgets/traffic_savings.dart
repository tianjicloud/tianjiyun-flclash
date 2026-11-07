import 'dart:math' as math;
import 'package:flutter/foundation.dart' show listEquals;
import 'package:fl_clash/views/dashboard/business_theme.dart';
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
                appLocalizations.vpnTraffic,
                summary.monthProxy,
                context.colorScheme.primary,
              ),
              (
                appLocalizations.mainlandDirect,
                summary.monthMainlandDirect,
                colors.ok,
              ),
              (
                appLocalizations.trafficOtherDirect,
                summary.month.otherDirect.total,
                colors.warn,
              ),
            ];
            final total = entries.fold(0, (sum, entry) => sum + entry.$2);
            final ring = SizedBox.square(
              dimension: 104,
              child: CustomPaint(
                painter: _SavingsRing(
                  values: [
                    for (final entry in entries)
                      total == 0 ? 0 : entry.$2 / total,
                  ],
                  colors: [for (final entry in entries) entry.$3],
                  track: colors.tone2,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: 68,
                        child: _TrafficStat(
                          label: appLocalizations.trafficSavedThisMonth,
                          bytes: summary.monthSavings,
                          centered: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            final legend = Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
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
                        child: Text(label, style: DashboardText.label(context)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${(total == 0 ? 0 : bytes / total * 100).toStringAsFixed(1)}%',
                            style: DashboardText.label(context),
                          ),
                          Text(
                            dashboardTraffic(bytes),
                            style: DashboardText.label(context),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                DashboardCardHeader(
                  glyph: AppGlyphs.dataUsage,
                  title: appLocalizations.trafficStats,
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth /
                            MediaQuery.textScalerOf(context).scale(1) <
                        240) {
                      return Column(spacing: 12, children: [ring, legend]);
                    }
                    return Row(
                      spacing: 16,
                      children: [
                        ring,
                        Expanded(child: legend),
                      ],
                    );
                  },
                ),
                Text(
                  appLocalizations.trafficStatsScope,
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
  const _TrafficStat({
    required this.label,
    required this.bytes,
    this.centered = false,
  });

  final bool centered;

  final String label;
  final int bytes;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DashboardText.label(context),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: centered
              ? Alignment.center
              : AlignmentDirectional.centerStart,
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
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_LegendDotPainter oldDelegate) => color != oldDelegate.color;
}

class _SavingsRing extends CustomPainter {
  const _SavingsRing({
    required this.values,
    required this.colors,
    required this.track,
  });

  final List<double> values;
  final List<Color> colors;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(5);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track);
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = math.pi * 2 * values[i];
      canvas.drawArc(rect, start, sweep, false, paint..color = colors[i]);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_SavingsRing oldDelegate) =>
      track != oldDelegate.track ||
      !listEquals(values, oldDelegate.values) ||
      !listEquals(colors, oldDelegate.colors);
}
