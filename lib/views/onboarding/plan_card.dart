import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';

class OnboardingPlanCard extends StatelessWidget {
  const OnboardingPlanCard({super.key, required this.info});

  final SubscriptionInfo? info;

  @override
  Widget build(BuildContext context) {
    final summary = subscriptionSummaryOf(info);
    if (summary.isEmpty) return const SizedBox.shrink();
    final remaining = summary.remaining;
    final expire = summary.expire;
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: SurfaceLevel.card.colorOf(colorScheme),
        shape: AppShape.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (remaining != null) ...[
            _PlanRow(
              label: appLocalizations.onboardingRemainingTraffic,
              value: remaining.traffic.show,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: info?.usage ?? 0,
              backgroundColor: colorScheme.primary.opacity15,
            ),
          ],
          if (remaining != null && expire != null) const SizedBox(height: 16),
          if (expire != null)
            _PlanRow(
              label: appLocalizations.onboardingExpireDate,
              value: expire.show,
            ),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyle.subheadline
                .of(context)
                .copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
        Text(
          value,
          style: AppTextStyle.subheadline
              .of(context, emphasized: true)
              .copyWith(color: colorScheme.onSurface),
        ),
      ],
    );
  }
}
