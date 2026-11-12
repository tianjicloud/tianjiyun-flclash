import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:fl_clash/providers/dashboard_lines.dart';
import 'package:fl_clash/common/service_probe.dart' show routedOutbound;
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/region_code_badge.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/dashboard/widgets/segmented.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResidentialView extends ConsumerStatefulWidget {
  const ResidentialView({super.key});

  @override
  ConsumerState<ResidentialView> createState() => _ResidentialViewState();
}

class _ResidentialViewState extends ConsumerState<ResidentialView> {
  String? _draft;
  late final _outbound = ref.read(outboundIpProbeProvider.notifier);

  @override
  void initState() {
    super.initState();
    _outbound.watch(routedOutbound);
  }

  @override
  void dispose() {
    _outbound.unwatch(routedOutbound);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final policy = ref.watch(residentialPolicyProvider);
    final groups = ref.watch(currentGroupsStateProvider).value;
    final choices = policy.choices;
    final action = ref.watch(residentialActionProvider);
    final applying =
        action.matches(policy.profileId, policy.fingerprint) && action.applying;
    final selected = _draft ?? policy.selectedExit;
    final entry = ref.watch(
      outboundIpProbeProvider.select((state) => state.entryOf(routedOutbound)),
    );
    final selection = ref.watch(selectionCheckProvider);
    final selectedNode = policy.selectedExit == null
        ? null
        : ref.watch(tianjiNodeProvider(policy.selectedExit!));
    final categories = ref.watch(tianjiCategoriesProvider);
    final bypass = _categoriesText(l10n, selectedNode, categories);

    return Scaffold(
      title: l10n.residentialTitle,
      actions: [
        BusinessSegmented<bool>(
          items: [
            BusinessSegment(value: true, label: l10n.residentialFollowSelected),
            BusinessSegment(
              value: false,
              label: l10n.residentialUseSubscription,
            ),
          ],
          selected: policy.active,
          onSelected: applying
              ? null
              : (follow) {
                  final notifier = ref.read(residentialActionProvider.notifier);
                  if (follow) {
                    final candidate = selected;
                    if (candidate != null) {
                      unawaited(notifier.select(candidate));
                    }
                  } else {
                    unawaited(notifier.clear());
                  }
                },
        ),
      ],
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          MacOSMetrics.pageMargin(context, fallback: 20),
          context.appBarInset + 12,
          MacOSMetrics.pageMargin(context, fallback: 20),
          16 + context.bottomInset,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              radius: MacOSMetrics.cardRadius(context, fallback: AppCorner.xl),
              padding: MacOSMetrics.cardPadding(
                context,
                const EdgeInsets.all(22),
              ),
              child: Row(
                spacing: 24,
                children: [
                  Expanded(
                    child: _SummaryValue(
                      label: l10n.businessCurrentNode,
                      value: policy.active
                          ? _displayName(policy.selectedExit ?? '')
                          : l10n.residentialSubscriptionPolicy,
                    ),
                  ),
                  Expanded(
                    child: _SummaryValue(
                      label: '${l10n.businessOutboundLabel} IP',
                      value: entry.value?.ip ?? '—',
                      detail: entry.value?.isp,
                      monospace: true,
                    ),
                  ),
                  _StatusBadge(
                    verified: selection == SelectionVerdict.consistent,
                    label: selection == SelectionVerdict.consistent
                        ? l10n.businessExitVerified
                        : _selectionStatus(l10n, selection),
                  ),
                ],
              ),
            ),
            if (bypass != null) ...[
              const SizedBox(height: 8),
              Text(
                bypass,
                style: AppTextStyle.footnote
                    .of(context)
                    .copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Text(
                  l10n.residentialTitle,
                  style: AppTextStyle.title3.of(context, emphasized: true),
                ),
                const SizedBox(width: 7),
                Text(
                  '${choices.length}',
                  style: AppTextStyle.subheadline.of(context),
                ),
                const Spacer(),
                TonalButton(
                  label: l10n.businessDelayTestShort,
                  onPressed: applying || choices.isEmpty
                      ? null
                      : () {
                          final members = [
                            for (final group in groups)
                              ...group.all.where(
                                (proxy) => choices.contains(proxy.name),
                              ),
                          ];
                          unawaited(
                            ref
                                .read(proxiesActionProvider.notifier)
                                .delayTest(members),
                          );
                        },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: !policy.catalogReady
                  ? Center(child: Text(l10n.residentialLoadingCatalog))
                  : choices.isEmpty
                  ? Center(child: Text(l10n.residentialNoPlan))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth < 980 ? 2 : 3;
                        final cardWidth =
                            (constraints.maxWidth - 12 * (columns - 1)) /
                            columns;
                        return SingleChildScrollView(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              for (final name in choices)
                                SizedBox(
                                  width: cardWidth,
                                  child: _ExitChoiceCard(
                                    name: name,
                                    selected: name == selected,
                                    current: name == policy.selectedExit,
                                    onPressed: applying
                                        ? null
                                        : () => setState(() => _draft = name),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            if (selected != null) ...[
              const SizedBox(height: 12),
              Card(
                radius: MacOSMetrics.cardRadius(
                  context,
                  fallback: AppCorner.xl,
                ),
                padding: MacOSMetrics.cardPadding(
                  context,
                  const EdgeInsets.all(18),
                ),
                child: Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.residentialPageExplanation,
                        style: AppTextStyle.footnote
                            .of(context)
                            .copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    FilledButton(
                      onPressed: applying
                          ? null
                          : () => unawaited(
                              ref
                                  .read(residentialActionProvider.notifier)
                                  .select(selected),
                            ),
                      child: Text(l10n.residentialUseExit(selected)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.label,
    required this.value,
    this.detail,
    this.monospace = false,
  });

  final String label;
  final String value;
  final String? detail;
  final bool monospace;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: AppTextStyle.footnote
            .of(context)
            .copyWith(color: context.colorScheme.onSurfaceVariant),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: monospace
            ? AppTextStyle.title2.of(context, emphasized: true).toJetBrainsMono
            : AppTextStyle.title2.of(context, emphasized: true),
      ),
      if (detail != null && detail!.isNotEmpty) ...[
        const SizedBox(height: 2),
        Text(
          detail!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.caption1
              .of(context)
              .copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      ],
    ],
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.verified, required this.label});

  final bool verified;
  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: verified
          ? DashboardColors.of(context).okContainer
          : context.colorScheme.surfaceContainerHigh,
      shape: AppShape.full,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        label,
        style: AppTextStyle.caption1
            .of(context, emphasized: true)
            .copyWith(
              color: verified
                  ? DashboardColors.of(context).ok
                  : context.colorScheme.onSurfaceVariant,
            ),
      ),
    ),
  );
}

class _ExitChoiceCard extends ConsumerWidget {
  const _ExitChoiceCard({
    required this.name,
    required this.selected,
    required this.current,
    required this.onPressed,
  });

  final String name;
  final bool selected;
  final bool current;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final node = ref.watch(tianjiNodeProvider(name));
    final delay = ref.watch(
      delayProvider(proxyName: name, testUrl: ref.watch(realTestUrlProvider())),
    );
    final region = _region(name, node?.countryCode);
    final multiplier = node?.multiplier ?? businessMultiplierFromName(name);
    final phase = ref.watch(
      delayTestPhaseProvider(
        proxyName: name,
        testUrl: ref.watch(realTestUrlProvider()),
      ),
    );
    final latencyColor = businessDelayColor(context.colorScheme, delay);

    return Card(
      isSelected: selected,
      onPressed: onPressed,
      radius: MacOSMetrics.cardRadius(context, fallback: AppCorner.lg),
      padding: MacOSMetrics.cardPadding(context, const EdgeInsets.all(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 108),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                if (region.code != null) RegionCodeBadge(code: region.code!),
                Expanded(
                  child: Text(
                    region.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.headline.of(context, emphasized: true),
                  ),
                ),
                _ResidentialRadio(selected: selected),
              ],
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 6,
              runSpacing: 5,
              children: [
                if (multiplier != null)
                  _MetaChip(label: l10n.businessMultiplier('$multiplier')),
                if (node?.expectedExit?.kind == 'residential')
                  _MetaChip(label: l10n.businessResidential),
                if (node?.expectedExit?.kind == 'datacenter')
                  _MetaChip(label: l10n.businessDatacenter),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  phase == DelayTestPhase.running ||
                          phase == DelayTestPhase.queued
                      ? '…'
                      : delay != null && delay > 0
                      ? '$delay ms'
                      : '—',
                  style: AppTextStyle.subheadline
                      .of(context, emphasized: true)
                      .copyWith(color: latencyColor),
                ),
                if (current) ...[
                  const SizedBox(width: 8),
                  Text(
                    l10n.businessCurrentNode,
                    style: AppTextStyle.caption1
                        .of(context)
                        .copyWith(color: context.colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: context.colorScheme.surfaceContainerHigh,
      shape: AppShape.full,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      child: Text(label, style: AppTextStyle.caption2.of(context)),
    ),
  );
}

class _ResidentialRadio extends StatelessWidget {
  const _ResidentialRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: selected ? context.colorScheme.primary : const Color(0x00000000),
      shape: RoundedSuperellipseBorder(
        side: BorderSide(
          color: selected
              ? context.colorScheme.primary
              : context.colorScheme.outlineVariant,
          width: 2,
        ),
        borderRadius: AppRadius.full,
      ),
    ),
    child: SizedBox(
      width: 20,
      height: 20,
      child: selected
          ? Center(
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: context.colorScheme.onPrimary,
                  shape: AppShape.circle,
                ),
                child: const SizedBox(width: 6, height: 6),
              ),
            )
          : null,
    ),
  );
}

({String? code, String name}) _region(String name, String? countryCode) {
  final codedName = RegExp(r'^([A-Z]{2})\s*[·|—-]\s*(.+)$').firstMatch(name);
  if (codedName != null) {
    return (code: codedName.group(1), name: _displayName(codedName.group(2)!));
  }
  final flag = name.runes.toList();
  if (flag.length >= 2 &&
      flag[0] >= 0x1F1E6 &&
      flag[0] <= 0x1F1FF &&
      flag[1] >= 0x1F1E6 &&
      flag[1] <= 0x1F1FF) {
    final code = String.fromCharCodes([
      flag[0] - 0x1F1E6 + 65,
      flag[1] - 0x1F1E6 + 65,
    ]);
    return (code: code, name: _displayName(String.fromCharCodes(flag.skip(2))));
  }
  return (code: countryCode, name: _displayName(name));
}

String _displayName(String value) => value
    .replaceAll(RegExp(r'\s*\d+(?:\.\d+)?x\b', caseSensitive: false), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

String? _categoriesText(
  AppLocalizations strings,
  TianjiNode? node,
  Map<String, String> categories,
) {
  if (node == null) return null;
  final names = node.substitutedCategories
      .map((key) => categories[key])
      .whereType<String>()
      .where((name) => name.isNotEmpty)
      .toList();
  return names.isEmpty
      ? null
      : strings.businessSubstitutedCategories(names.join('、'));
}

String _selectionStatus(AppLocalizations l10n, SelectionVerdict verdict) =>
    switch (verdict) {
      SelectionVerdict.consistent => l10n.businessExitVerified,
      SelectionVerdict.confirming ||
      SelectionVerdict.egressPending ||
      SelectionVerdict.unknownPending => l10n.selectionConfirming,
      SelectionVerdict.failed => l10n.serviceFailed,
      SelectionVerdict.notCaptured => l10n.selectionNotCaptured,
      SelectionVerdict.residentialLocked => l10n.selectionResidentialLocked,
      SelectionVerdict.groupOverridden => l10n.selectionGroupOverridden,
      SelectionVerdict.unknown => l10n.selectionUnknown,
      SelectionVerdict.trafficNotOnTianji => l10n.businessTrafficNotOnTianji,
      SelectionVerdict.egressMismatch => l10n.businessExitKindMismatch,
      SelectionVerdict.egressAnomaly => l10n.businessExitAnomaly,
      SelectionVerdict.untouched => l10n.selectionUnknown,
    };
