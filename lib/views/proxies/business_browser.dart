import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
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
      if (latest.groups.any((group) => group.name == selected) &&
          latest.currentGroupName != selected) {
        _selectGroup(selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(proxiesTabStateProvider);
    final groups = state.groups;
    _pruneControllers(groups);
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
                      columns: getProxiesColumns(
                        math.max(width - 32, 0),
                        layout,
                      ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 220,
                    child: Card(
                      radius: AppCorner.xl,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                            child: Text(
                              context.appLocalizations.proxyGroup,
                              style: AppTextStyle.footnote
                                  .of(context, emphasized: true)
                                  .copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: PrismListView(
                              itemCount: groups.length,
                              gap: 4,
                              itemBuilder: (_, index) => _GroupChoice(
                                group: groups[index],
                                selected: groups[index].name == selected?.name,
                                onTap: () => _selectGroup(groups[index].name),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (selected != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                            child: Row(
                              spacing: 10,
                              children: [
                                EmojiText(
                                  selected.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.title3.of(
                                    context,
                                    emphasized: true,
                                  ),
                                ),
                                if (selectedProxyName case final name?
                                    when name.isNotEmpty)
                                  Expanded(
                                    child: EmojiText(
                                      name,
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
    return Semantics(
      button: true,
      selected: selected,
      label: group.name,
      child: FocusRing(
        shape: AppShape.md,
        child: PressRegion(
          onTap: onTap,
          shape: AppShape.md,
          overlay: PressRegion.hoverOverlay,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: selected
                  ? dark
                        ? const Color(0xFF1A2330)
                        : const Color(0xFFFFFFFF)
                  : const Color(0x00FFFFFF),
              shape: RoundedSuperellipseBorder(
                side: BorderSide(
                  color: selected
                      ? dark
                            ? const Color(0xFF2A3442)
                            : const Color(0xFFDCE1E7)
                      : const Color(0x00000000),
                ),
                borderRadius: AppRadius.md,
              ),
            ),
            child: SizedBox(
              height: compact ? 38 : 42,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 10),
                child: Row(
                  children: [
                    Expanded(
                      child: EmojiText(
                        group.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.subheadline
                            .of(context, emphasized: selected)
                            .copyWith(
                              color: selected
                                  ? dark
                                        ? const Color(0xFFEDF0FF)
                                        : BusinessPalette.deep
                                  : context.colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
