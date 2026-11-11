import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;
import 'package:fl_clash/views/dashboard/style.dart' show DashboardColors;
import 'package:fl_clash/views/dashboard/business.dart'
    show showResidentialExitSheet;
import 'package:fl_clash/views/proxies/card.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

class BusinessProxyList extends ConsumerStatefulWidget {
  const BusinessProxyList({super.key});

  @override
  ConsumerState<BusinessProxyList> createState() => _BusinessProxyListState();
}

class _BusinessProxyListState extends ConsumerState<BusinessProxyList> {
  final Set<String> _expanded = {};
  bool _initializedExpansion = false;

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(
      proxiesTabStateProvider.select((state) => state.groups),
    );
    final selectedGroup = ref.watch(
      proxiesTabStateProvider.select((state) => state.currentGroupName),
    );
    final activeGroup = groups.any((group) => group.name == selectedGroup)
        ? selectedGroup
        : groups.isEmpty
        ? null
        : groups.first.name;
    if (!_initializedExpansion && activeGroup != null) {
      _expanded.add(activeGroup);
      _initializedExpansion = true;
    }
    final items = <_BusinessListItem>[];
    for (final group in groups) {
      items.add(_BusinessListItem.header(group));
      if (_expanded.contains(group.name)) {
        items.addAll(
          group.all.map((proxy) => _BusinessListItem.proxy(group, proxy)),
        );
      }
    }
    final top = (context.contentTopPadding - context.appBarInset).clamp(
      0.0,
      double.infinity,
    );
    return AppBarClearance(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, top, 24, 24),
        child: SurfaceScope(
          level: context.raisedSurfaceLevel,
          child: ClipPath(
            clipper: const ShapeBorderClipper(shape: AppShape.xl),
            child: ColoredBox(
              color: context.raisedSurfaceLevel.colorOf(context.colorScheme),
              child: CustomScrollView(
                slivers: [
                  SliverPrismList(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final last = index == items.length - 1;
                      final child = item.proxy == null
                          ? _BusinessGroupHeader(
                              group: item.group!,
                              selected: item.group!.name == activeGroup,
                              expanded: _expanded.contains(item.group!.name),
                              onToggle: () => setState(() {
                                if (!_expanded.add(item.group!.name)) {
                                  _expanded.remove(item.group!.name);
                                }
                              }),
                            )
                          : Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 34,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  tapTargetSize: TapTargetSize.shrinkWrap,
                                ),
                                child: ProxyCard(
                                  key: ValueKey(
                                    '${item.group!.name}:${item.proxy!.name}',
                                  ),
                                  groupName: item.group!.name,
                                  proxy: item.proxy!,
                                  groupType: item.group!.type,
                                  type: ProxyCardType.compact,
                                  testUrl: item.group!.testUrl,
                                  businessStyle: true,
                                  businessList: true,
                                ),
                              ),
                            );
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          child,
                          if (!last)
                            ColoredBox(
                              color: context.colorScheme.onSurface.withValues(
                                alpha: 0.12,
                              ),
                              child: const SizedBox(height: 1),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BusinessListItem {
  const _BusinessListItem._(this.group, this.proxy);

  factory _BusinessListItem.header(Group group) =>
      _BusinessListItem._(group, null);
  factory _BusinessListItem.proxy(Group group, Proxy proxy) =>
      _BusinessListItem._(group, proxy);

  final Group? group;
  final Proxy? proxy;
}

class _BusinessGroupHeader extends ConsumerWidget {
  const _BusinessGroupHeader({
    required this.group,
    required this.selected,
    required this.expanded,
    required this.onToggle,
  });

  final Group group;
  final bool selected;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locked = group.name == tianjiResidentialRootName;
    final appLocalizations = context.appLocalizations;
    final subtitle = locked
        ? appLocalizations.businessGroupLocked
        : '${group.type == GroupType.URLTest ? appLocalizations.businessAutoTest : appLocalizations.businessManualSelect} · ${group.all.length} ${appLocalizations.businessLineCount}';
    final current = ref.watch(selectedProxyNameProvider(group.name));
    final delay = current == null
        ? null
        : ref.watch(delayProvider(proxyName: current, testUrl: group.testUrl));
    final automatic = group.type != GroupType.Selector;
    return SizedBox(
      key: ValueKey('business-list-group:${group.name}'),
      height: 52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          spacing: 10,
          children: [
            PressRegion(
              onTap: onToggle,
              shape: AppShape.md,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  spacing: 8,
                  children: [
                    GlyphIcon(
                      expanded
                          ? AppGlyphs.chevronDown
                          : AppGlyphs.chevronForward,
                      size: 16,
                    ),
                    Text(
                      _cleanBusinessGroupName(group.name),
                      style: AppTextStyle.subheadline.of(
                        context,
                        emphasized: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.caption1
                    .of(context)
                    .copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
            ),
            if (current != null && current.isNotEmpty) ...[
              Text(
                appLocalizations.businessCurrent,
                style: AppTextStyle.caption1
                    .of(context)
                    .copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
              _CurrentProxyPill(
                name: automatic && delay != null && delay > 0
                    ? '${_cleanBusinessProxyName(current)} · $delay ms'
                    : _cleanBusinessProxyName(current),
                automatic: automatic,
              ),
            ],
            if (locked)
              BusinessSecondaryButton(
                label: appLocalizations.businessReplace,
                width: 58,
                onPressed: () => showResidentialExitSheet(context),
              )
            else
              BusinessSecondaryButton(
                label: appLocalizations.businessDelayTestShort,
                width: 58,
                onPressed: () => ref
                    .read(proxiesActionProvider.notifier)
                    .delayTestPageGroup(group.name),
              ),
          ],
        ),
      ),
    );
  }
}

String _cleanBusinessGroupName(String name) {
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

String _cleanBusinessProxyName(String name) => _cleanBusinessGroupName(
  name,
).replaceAll(RegExp(r'\s*\d+(?:\.\d+)?x\b', caseSensitive: false), '');

class _CurrentProxyPill extends StatelessWidget {
  const _CurrentProxyPill({required this.name, required this.automatic});

  final String name;
  final bool automatic;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: _pillColors(context).$1,
      shape: AppShape.full,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.caption1
            .of(context)
            .copyWith(color: _pillColors(context).$2),
      ),
    ),
  );

  (Color, Color) _pillColors(BuildContext context) {
    final colors = DashboardColors.of(context);
    if (automatic) return (colors.tone, context.colorScheme.onSurfaceVariant);
    if (context.colorScheme.brightness == Brightness.dark) {
      return (colors.brandContainer, colors.onBrandContainer);
    }
    return (
      BusinessPalette.residentialChip,
      BusinessPalette.residentialChipText,
    );
  }
}
