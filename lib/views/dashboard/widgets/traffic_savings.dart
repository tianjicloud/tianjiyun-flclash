import 'dart:math' as math;
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
            final total = summary.monthMainlandDirect + summary.monthProxy;
            final value = total == 0
                ? 0.0
                : summary.monthMainlandDirect / total;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                DashboardCardHeader(
                  glyph: AppGlyphs.dataUsage,
                  title: appLocalizations.trafficStats,
                ),
                Center(
                  child: SizedBox.square(
                    dimension: 112,
                    child: CustomPaint(
                      painter: _SavingsRing(
                        value: value,
                        color: context.colorScheme.primary,
                        track: DashboardColors.of(context).tone2,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _TrafficStat(
                            label: appLocalizations.trafficSavedThisMonth,
                            bytes: summary.monthSavings,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _TrafficStat(
                  label: appLocalizations.mainlandDirect,
                  bytes: summary.monthMainlandDirect,
                ),
                _TrafficStat(
                  label: appLocalizations.vpnTraffic,
                  bytes: summary.monthProxy,
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
  const _TrafficStat({required this.label, required this.bytes});

  final String label;
  final int bytes;

  @override
  Widget build(BuildContext context) {
    return Column(
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

class _SavingsRing extends CustomPainter {
  const _SavingsRing({
    required this.value,
    required this.color,
    required this.track,
  });

  final double value;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(5);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      paint..color = color,
    );
  }

  @override
  bool shouldRepaint(_SavingsRing oldDelegate) =>
      value != oldDelegate.value ||
      color != oldDelegate.color ||
      track != oldDelegate.track;
}
