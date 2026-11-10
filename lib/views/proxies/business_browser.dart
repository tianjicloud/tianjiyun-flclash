import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart';
import 'package:fl_clash/views/proxies/tab.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessProxyBrowser extends ConsumerStatefulWidget {
  const BusinessProxyBrowser({super.key});

  @override
  ConsumerState<BusinessProxyBrowser> createState() =>
      _BusinessProxyBrowserState();
}

class _BusinessProxyBrowserState extends ConsumerState<BusinessProxyBrowser> {
  final Map<String, ScrollController> _controllers = {};
  int _selectionRevision = 0;

  ScrollController _controllerOf(String groupName) =>
      _controllers.putIfAbsent(groupName, () => sheetScrollController(context));

  void _pruneControllers(List<Group> groups) {
    final names = {for (final group in groups) group.name};
    final dropped = [
      for (final entry in _controllers.entries)
        if (!names.contains(entry.key)) entry,
    ];
    for (final entry in dropped) {
      _controllers.remove(entry.key);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => entry.value.dispose(),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _selectGroup(String name) {
    _selectionRevision++;
    ref.read(proxiesActionProvider.notifier).updateCurrentGroupName(name);
  }

  void _synchronizeSelectedGroup(String current, String selected) {
    if (current == selected) return;
    final revision = ++_selectionRevision;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || revision != _selectionRevision) return;
      final latest = ref.read(proxiesTabStateProvider);
      if (!latest.groups.any((group) => group.name == current) &&
          latest.groups.any((group) => group.name == selected) &&
          latest.currentGroupName != selected) {
        _selectGroup(selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(proxiesTabStateProvider);
    final allGroups = state.groups;
    final groups = [
      for (final group in allGroups)
        if ((group.type == GroupType.Selector &&
                group.name != sceneGroupName) ||
            (group.type == GroupType.URLTest &&
                group.name.trim().endsWith('自动选择')))
          group,
    ];
    _pruneControllers(allGroups);
    final selected =
        groups.getGroup(state.currentGroupName ?? '') ??
        (groups.isEmpty ? null : groups.first);
    final selectedProxyName = selected == null
        ? null
        : ref.watch(selectedProxyNameProvider(selected.name));
    if (selected != null && selected.name != state.currentGroupName) {
      _synchronizeSelectedGroup(state.currentGroupName ?? '', selected.name);
    }
    final cardType = state.proxyCardType;
    final layout = ref.watch(
      proxiesStyleSettingProvider.select((value) => value.layout),
    );
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final isMobile = ref.watch(isMobileViewProvider);
    return NullStatusSwitcher(
      isEmpty: groups.isEmpty,
      isSearching: ref.watch(
        queryProvider(
          QueryTag.proxies,
        ).select((query) => SearchQuery(query).isNotEmpty),
      ),
      nullStatus: NullStatus(
        illustration: NullStatusIllustration.proxies,
        label: context.appLocalizations.nullTip(
          context.appLocalizations.proxies,
        ),
      ),
      child: AppBarClearance(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = !isMobile && constraints.maxWidth > 760;
            final top = math
                .max(context.contentTopPadding - context.appBarInset, 0)
                .toDouble();
            final content = selected == null
                ? const SizedBox.shrink()
                : WidthBuilder(
                    builder: (_, width) => ProxyGroupView(
                      key: ValueKey(selected.name),
                      group: selected,
                      controller: _controllerOf(selected.name),
                      columns: textScale > 1.25
                          ? (desktop ? 2 : getProxiesColumns(width, layout))
                          : desktop
                          ? 3
                          : getProxiesColumns(math.max(width - 32, 0), layout),
                      cardType: cardType,
                      businessStyle: true,
                    ),
                  );
            if (!desktop) {
              return Padding(
                padding: EdgeInsets.only(top: top),
                child: Column(
                  children: [
                    SizedBox(
                      height: 48,
                      child: PrismListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: groups.length,
                        gap: 8,
                        itemBuilder: (_, index) => SizedBox(
                          width: 180,
                          child: _GroupChoice(
                            group: groups[index],
                            selected: groups[index].name == selected?.name,
                            onTap: () => _selectGroup(groups[index].name),
                            compact: true,
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: content),
                  ],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(24, top, 24, 12),
              child: Column(
                children: [
                  const _SelectionHint(),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 232,
                          child: _GroupPanel(
                            groups: groups,
                            selected: selected,
                            onSelect: _selectGroup,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (selected != null)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    4,
                                    0,
                                    4,
                                    12,
                                  ),
                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      Text(
                                        _cleanGroupName(selected.name),
                                        style: AppTextStyle.title3.of(
                                          context,
                                          emphasized: true,
                                        ),
                                      ),
                                      if (selectedProxyName case final name?
                                          when name.isNotEmpty)
                                        Expanded(
                                          child: Text(
                                            context.appLocalizations
                                                .businessCurrentLineState(
                                                  _currentProxyLabel(name),
                                                  _verdictSummary(
                                                    ref.watch(
                                                      selectionCheckProvider,
                                                    ),
                                                    context,
                                                  ),
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.footnote
                                                .of(context)
                                                .copyWith(
                                                  color: context
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              Expanded(child: content),
                              if (ref.watch(isStartProvider)) ...[
                                const SizedBox(height: 12),
                                _VerificationCard(
                                  verdict: ref.watch(selectionCheckProvider),
                                  selectedName: _cleanProxyName(
                                    selectedProxyName ?? '',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GroupChoice extends StatelessWidget {
  const _GroupChoice({
    required this.group,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final Group group;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    final locked = group.name == tianjiResidentialRootName;
    return Semantics(
      button: true,
      selected: selected,
      label: _cleanGroupName(group.name),
      child: FocusRing(
        shape: AppShape.all(BusinessRadius.linesDesktop),
        child: PressRegion(
          onTap: onTap,
          shape: AppShape.all(BusinessRadius.linesDesktop),
          overlay: PressRegion.hoverOverlay,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: selected
                  ? dark
                        ? context.colorScheme.surfaceContainer
                        : const Color(0xFFFFFFFF)
                  : const Color(0x00FFFFFF),
              shape: RoundedSuperellipseBorder(
                side: BorderSide.none,
                borderRadius: AppRadius.all(BusinessRadius.linesDesktop),
              ),
              shadows: selected
                  ? [
                      BoxShadow(
                        color: BusinessPalette.deep.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : const [],
            ),
            child: SizedBox(
              height: compact ? 38 : 44,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 10),
                child: Row(
                  children: [
                    Expanded(
                      child: EmojiText(
                        _cleanGroupName(group.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.subheadline
                            .of(context, emphasized: selected)
                            .copyWith(
                              color: selected
                                  ? dark
                                        ? const Color(0xFFEDF0FF)
                                        : BusinessPalette.deep
                                  : dark
                                  ? BusinessPalette.sidebarDarkSecondary
                                  : context.colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (locked)
                      DashboardChip(
                        label: context.appLocalizations.businessLocked,
                        tone: DashboardChipTone.primary,
                      ),
                    if (locked) const SizedBox(width: 6),
                    Text(
                      group.all.length.toString(),
                      style: AppTextStyle.caption1
                          .of(context)
                          .copyWith(
                            color: selected && dark
                                ? const Color(0xFFB9C0E4)
                                : context.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionHint extends StatelessWidget {
  const _SelectionHint();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: context.colorScheme.brightness == Brightness.dark
          ? Color.alphaBlend(
              BusinessPalette.blue.withValues(alpha: 0.12),
              context.colorScheme.surfaceContainer,
            )
          : BusinessPalette.hintBackground,
      shape: AppShape.all(BusinessRadius.linesDesktop),
    ),
    child: SizedBox(
      height: 45,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          spacing: 10,
          children: [
            GlyphIcon(
              AppGlyphs.info,
              color: context.colorScheme.brightness == Brightness.dark
                  ? BusinessPalette.activeGlyph
                  : BusinessPalette.blue,
            ),
            Expanded(
              child: Text(
                context.appLocalizations.businessLineSelectionHint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.footnote
                    .of(context)
                    .copyWith(
                      color: context.colorScheme.brightness == Brightness.dark
                          ? BusinessPalette.sidebarDarkSecondary
                          : BusinessPalette.sidebarSecondary,
                    ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _GroupPanel extends ConsumerWidget {
  const _GroupPanel({
    required this.groups,
    required this.selected,
    required this.onSelect,
  });

  final List<Group> groups;
  final Group? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policy = ref.watch(residentialPolicyProvider);
    final dark = context.colorScheme.brightness == Brightness.dark;
    final lockedName = policy.selectedExit;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: dark
            ? context.colorScheme.surfaceContainerHigh
            : BusinessPalette.sidebarLight,
        shape: AppShape.all(BusinessRadius.linesDesktop),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
              child: Text(
                context.appLocalizations.businessGroupHeader,
                style: AppTextStyle.caption1
                    .of(context)
                    .copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
            ),
            Expanded(
              child: PrismListView(
                itemCount: groups.length,
                gap: 2,
                itemBuilder: (_, index) => _GroupChoice(
                  group: groups[index],
                  selected: groups[index].name == selected?.name,
                  onTap: () => onSelect(groups[index].name),
                ),
              ),
            ),
            if (policy.active && lockedName != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                child: Text(
                  context.appLocalizations.businessResidentialLockedHint(
                    _cleanGroupName(lockedName),
                  ),
                  style: AppTextStyle.caption1
                      .of(context)
                      .copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VerificationCard extends ConsumerWidget {
  const _VerificationCard({required this.verdict, required this.selectedName});

  final SelectionVerdict verdict;
  final String selectedName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(
      outboundIpProbeProvider.select((state) => state.entryOf(routedOutbound)),
    );
    final success = verdict == SelectionVerdict.consistent;
    final message = _verdictSummary(verdict, context);
    final ip = entry.value?.ip ?? '';
    final detail = success
        ? context.appLocalizations.businessExitVerifiedDetail(selectedName, ip)
        : message;
    final ipOffset = ip.isEmpty ? -1 : detail.indexOf(ip);
    final detailText = ipOffset < 0
        ? Text(
            detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.caption1
                .of(context)
                .copyWith(color: context.colorScheme.onSurfaceVariant),
          )
        : Text.rich(
            TextSpan(
              style: AppTextStyle.caption1
                  .of(context)
                  .copyWith(color: context.colorScheme.onSurfaceVariant),
              children: [
                TextSpan(text: detail.substring(0, ipOffset)),
                TextSpan(
                  text: ip,
                  style: BusinessText.inlineIp(
                    context,
                  ).copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
                TextSpan(text: detail.substring(ipOffset + ip.length)),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
    final color = success
        ? BusinessPalette.connectedForegroundFor(context.colorScheme.brightness)
        : BusinessPalette.warningForegroundFor(context.colorScheme.brightness);
    final background = success
        ? BusinessPalette.connectedContainerFor(context.colorScheme.brightness)
        : BusinessPalette.warningContainerFor(context.colorScheme.brightness);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: context.colorScheme.surface,
        shape: AppShape.all(BusinessRadius.linesDesktop),
      ),
      child: SizedBox(
        height: 75,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 12,
            children: [
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: background,
                  shape: AppShape.all(AppCorner.sm),
                ),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: GlyphIcon(
                      success ? AppGlyphs.check : AppGlyphs.warning,
                      color: color,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      success
                          ? context.appLocalizations.businessExitVerified
                          : message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.subheadline.of(
                        context,
                        emphasized: true,
                      ),
                    ),
                    const SizedBox(height: 3),
                    detailText,
                  ],
                ),
              ),
              BusinessSecondaryButton(
                label: context.appLocalizations.businessRecheck,
                width: 100,
                onPressed: () => ref
                    .read(outboundIpProbeProvider.notifier)
                    .recheck(routedOutbound),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _verdictSummary(
  SelectionVerdict verdict,
  BuildContext context,
) => switch (verdict) {
  SelectionVerdict.consistent =>
    context.appLocalizations.businessExitVerifiedShort,
  SelectionVerdict.untouched => context.appLocalizations.selectionUnknown,
  SelectionVerdict.confirming => context.appLocalizations.selectionConfirming,
  SelectionVerdict.failed => context.appLocalizations.serviceFailed,
  SelectionVerdict.notCaptured => context.appLocalizations.selectionNotCaptured,
  SelectionVerdict.residentialLocked =>
    context.appLocalizations.selectionResidentialLocked,
  SelectionVerdict.groupOverridden =>
    context.appLocalizations.selectionGroupOverridden,
  SelectionVerdict.unknownPending =>
    context.appLocalizations.selectionUnknownPending,
  SelectionVerdict.unknown => context.appLocalizations.selectionUnknown,
};

String _cleanGroupName(String name) {
  final runes = name.runes.toList();
  var start = 0;
  while (start < runes.length &&
      (runes[start] == 0x20 ||
          runes[start] == 0xA0 ||
          runes[start] == 0x00B7 ||
          (runes[start] >= 0x1F000 && runes[start] <= 0x1FAFF))) {
    start++;
  }
  return String.fromCharCodes(runes.skip(start)).trim();
}

String _cleanProxyName(String name) => _cleanGroupName(
  name,
).replaceAll(RegExp(r'\s*\d+(?:\.\d+)?x\b', caseSensitive: false), '');

String _currentProxyLabel(String name) {
  final runes = name.runes.toList();
  if (runes.length < 2 ||
      runes[0] < 0x1F1E6 ||
      runes[0] > 0x1F1FF ||
      runes[1] < 0x1F1E6 ||
      runes[1] > 0x1F1FF) {
    return _cleanProxyName(name);
  }
  final code = String.fromCharCodes([
    runes[0] - 0x1F1E6 + 65,
    runes[1] - 0x1F1E6 + 65,
  ]);
  return '$code · ${_cleanProxyName(name)}';
}
