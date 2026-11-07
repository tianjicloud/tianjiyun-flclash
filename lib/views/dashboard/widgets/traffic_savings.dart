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
