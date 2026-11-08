import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';

class _QuickLine {
  const _QuickLine({
    required this.groupName,
    required this.name,
    required this.displayName,
    required this.type,
    required this.delay,
    required this.current,
    required this.rate,
  });

  final String groupName;
  final String name;
  final String displayName;
  final String type;
  final int? delay;
  final bool current;
  final double? rate;
}

final _ratePatterns = [
  RegExp(r'倍率\s*(\d+(?:\.\d+)?)\s*[x×]?'),
  RegExp(r'(\d+(?:\.\d+)?)\s*[x×](?![0-9a-zA-Z])'),
];

({double rate, String name})? _rateOf(String name) {
  for (final pattern in _ratePatterns) {
    final match = pattern.firstMatch(name);
    if (match == null) continue;
    final rate = double.tryParse(match.group(1)!);
    if (rate == null || rate <= 0) continue;
    final stripped = (name.replaceRange(match.start, match.end, ''))
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^[\s·|/—-]+|[\s·|/—-]+$'), '')
        .trim();
    return (rate: rate, name: stripped.isEmpty ? name : stripped);
  }
  return null;
}

/// Up to four one-tap lines under the scene bar: the scene group's members
/// first (they are the subscription's own curated exits), then the members
/// of the first ordinary selector group. A tap goes through the same proxy
/// action the proxies page uses, so manual-selection bookkeeping and the
/// residential lock apply unchanged. Protocol and delay come from the live
/// groups; nothing here is invented, and a card only appears for a member
/// that resolves to a real proxy or group.
class QuickLines extends ConsumerWidget {
  const QuickLines({super.key});

  static const _limit = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = _lines(ref);
    if (lines.length < 2) return const SizedBox.shrink();
    final density = DashboardDensityScope.of(context);
    final header = Row(
      children: [
        Text(
          context.appLocalizations.quickLines,
          style: DashboardText.cardTitle(context),
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
                  style: DashboardText.label(context),
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
      spacing: 10,
      children: [
        header,
        if (density.isDesktop)
          Row(
            spacing: 12,
            children: [for (final card in cards) Expanded(child: card)],
          )
        else
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.4,
            children: cards,
          ),
      ],
    );
  }

  List<_QuickLine> _lines(WidgetRef ref) {
    final groups = ref.watch(currentGroupsStateProvider).value;
    if (groups.isEmpty) return const [];
    final byName = {for (final group in groups) group.name: group};
    final delays = ref.watch(delaysAtLastTestBatchProvider);
    final testUrl = ref.watch(realTestUrlProvider());
    Group? host;
    for (final candidate in [sceneGroupName, sceneRootGroupName]) {
      final group = byName[candidate];
      if (group != null && group.type == GroupType.Selector) {
        host = group;
        break;
      }
    }
    host ??= groups
        .where((group) => group.type == GroupType.Selector)
        .firstOrNull;
    if (host == null) return const [];
    final selected = ref.watch(selectedProxyNameProvider(host.name));
    final lines = <_QuickLine>[];
    for (final member in host.all) {
      if (lines.length >= _limit) break;
      final target = byName[member.name];
      final resolved = target == null
          ? member.name
          : target.getCurrentSelectedName(
              ref.watch(selectedProxyNameProvider(target.name)) ?? '',
            );
      final leaf = byName[resolved];
      final leafProxy = leaf?.all.firstOrNull;
      final type = leafProxy?.type ?? member.type;
      if (type.isEmpty) continue;
      final ownRate = _rateOf(member.name);
      final parsed = ownRate ?? _rateOf(resolved);
      lines.add(
        _QuickLine(
          groupName: host.name,
          name: member.name,
          displayName: ownRate?.name ?? member.name,
          type: type,
          delay: delays[testUrl]?[resolved],
          current: selected == member.name,
          rate: parsed?.rate,
        ),
      );
    }
    return lines;
  }
}

class _QuickLineCard extends StatelessWidget {
  const _QuickLineCard({required this.line, required this.onTap});

  final _QuickLine line;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final delay = line.delay;
    final delayColor = colorScheme.delayColor(delay);
    return DashboardCard(
      onTap: onTap,
      semanticLabel: line.name,
      side: line.current
          ? const BorderSide(color: BusinessPalette.accent, width: 1.5)
          : BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  line.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DashboardText.rowTitle(context),
                ),
              ),
              if (delay != null && delay >= 0)
                Text(
                  '$delay ms',
                  style: AppTextStyle.footnote
                      .of(context, emphasized: true)
                      .toTabular
                      .copyWith(color: delayColor),
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
            line.rate == null
                ? line.type.toUpperCase()
                : '${line.type.toUpperCase()} · ${context.appLocalizations.lineRate} ${line.rate!.toStringAsFixed(2)}x',
            maxLines: 1,
            style: DashboardText.label(context),
          ),
        ],
      ),
    );
  }
}
