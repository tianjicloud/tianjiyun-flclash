import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/proxies/list.dart';
import 'package:fl_clash/views/proxies/business_browser.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessPrimaryButton, BusinessSecondaryButton;
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tab.dart';

class ProxiesView extends ConsumerStatefulWidget {
  const ProxiesView({super.key, this.picker = false});

  /// Leaves the bar only its search and delay test, for picking a proxy from a
  /// sheet.
  final bool picker;

  @override
  ConsumerState<ProxiesView> createState() => _ProxiesViewState();
}

class _ProxiesViewState extends ConsumerState<ProxiesView> {
  final GlobalKey<ProxiesTabViewState> _proxiesTabKey = GlobalKey();

  // The same instance on every build, so the bar changing with the current
  // group or its delay test leaves the page alone.
  late final _tabView = ProxiesTabView(key: _proxiesTabKey);
  bool _isTab = false;

  void _updateStyle(
    ProxiesStyleProps Function(ProxiesStyleProps state) update,
  ) {
    ref.read(proxiesStyleSettingProvider.notifier).update(update);
  }

  List<PopupMenuItem> _buildMenuItems(
    BuildContext context,
    ProxiesStyleProps style,
  ) {
    final appLocalizations = context.appLocalizations;
    return [
      _optionsMenuItem(
        glyph: AppGlyphs.appsList,
        label: appLocalizations.style,
        section: const PopupMenuSection(),
        options: ProxiesType.values,
        value: style.type,
        textOf: (type) => type.label,
        onSelected: (type) =>
            _updateStyle((state) => state.copyWith(type: type)),
      ),
      _optionsMenuItem(
        glyph: AppGlyphs.sort,
        label: appLocalizations.sort,
        options: ProxiesSortType.values,
        value: style.sortType,
        textOf: (type) => switch (type) {
          ProxiesSortType.none => appLocalizations.defaultText,
          ProxiesSortType.delay => appLocalizations.delay,
          ProxiesSortType.name => appLocalizations.name,
        },
        onSelected: (type) =>
            _updateStyle((state) => state.copyWith(sortType: type)),
      ),
      _optionsMenuItem(
        glyph: AppGlyphs.dashboard,
        label: appLocalizations.layout,
        options: ProxiesLayout.values,
        value: style.layout,
        textOf: (layout) => switch (layout) {
          ProxiesLayout.tight => appLocalizations.tight,
          ProxiesLayout.standard => appLocalizations.standard,
          ProxiesLayout.loose => appLocalizations.loose,
        },
        onSelected: (layout) =>
            _updateStyle((state) => state.copyWith(layout: layout)),
      ),
      _optionsMenuItem(
        glyph: AppGlyphs.textSize,
        label: appLocalizations.size,
        options: ProxyCardType.values,
        value: style.cardType,
        textOf: (type) => type.label,
        onSelected: (type) =>
            _updateStyle((state) => state.copyWith(cardType: type)),
      ),
      if (style.type == ProxiesType.list)
        _optionsMenuItem(
          glyph: AppGlyphs.iconTile,
          label: appLocalizations.iconStyle,
          options: ProxiesIconStyle.values,
          value: style.iconStyle,
          textOf: (iconStyle) => switch (iconStyle) {
            ProxiesIconStyle.filled => appLocalizations.iconStyleFilled,
            ProxiesIconStyle.plain => appLocalizations.iconStylePlain,
            ProxiesIconStyle.hidden => appLocalizations.iconStyleHidden,
          },
          onSelected: (iconStyle) =>
              _updateStyle((state) => state.copyWith(iconStyle: iconStyle)),
        ),
      PopupMenuItem(
        glyph: AppGlyphs.eyeOff,
        label: appLocalizations.hideTimeoutProxies,
        checked: style.hideTimeoutProxies,
        section: const PopupMenuSection(),
        onPressed: () => _updateStyle(
          (state) =>
              state.copyWith(hideTimeoutProxies: !state.hideTimeoutProxies),
        ),
      ),
    ];
  }

  IconButtonData? _buildPrimaryAction({required bool business}) {
    if (!_isTab && !business) {
      return null;
    }
    final isDelayTesting = ref.watch(currentGroupDelayTestingProvider);
    return IconButtonData(
      glyph: AppGlyphs.bolt,
      onPressed: () {
        if (_isTab) {
          _proxiesTabKey.currentState?.delayTestCurrentGroup();
        } else if (business) {
          final groupName = ref.read(proxiesTabStateProvider).currentGroupName;
          if (groupName != null) {
            ref
                .read(proxiesActionProvider.notifier)
                .delayTestPageGroup(groupName);
          }
        }
      },
      tooltip: context.appLocalizations.delayTest,
      isLoading: isDelayTesting,
    );
  }

  void _onSearch(String value) {
    ref.read(queryProvider(QueryTag.proxies).notifier).value = value;
  }

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      proxiesStyleSettingProvider.select(
        (state) => state.type == ProxiesType.tab,
      ),
      (prev, next) {
        if (prev != next) {
          setState(() {
            _isTab = next;
          });
        }
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = ref.watch(proxiesStyleSettingProvider);
    final business = isTianjiSubscriptionProfile(
      ref.watch(currentProfileProvider),
    );
    final isMobile = ref.watch(isMobileViewProvider);
    final businessDesktop = business && !isMobile;
    final businessDesktopSearch =
        businessDesktop && MediaQuery.sizeOf(context).width >= 900;
    final groups = ref.watch(proxiesTabStateProvider).groups;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final isLoading = ref.watch(loadingProvider(LoadingTag.proxies));
    final picker = widget.picker;
    final primaryAction = businessDesktop || (business && isMobile)
        ? null
        : _buildPrimaryAction(business: business);
    final desktopActions = businessDesktop
        ? <IconButtonData>[]
        : [
            if (_isTab && !picker)
              IconButtonData(
                glyph: AppGlyphs.locate,
                onPressed: () {
                  _proxiesTabKey.currentState?.scrollToGroupSelected();
                },
                tooltip: context.appLocalizations.scrollToSelected,
              ),
          ];
    return Scaffold(
      isLoading: isLoading,
      resizeToAvoidBottomInset: false,
      primaryAction: primaryAction,
      searchActions: business && isMobile ? const [] : [?primaryAction],
      iconActions: desktopActions,
      menuItems: picker || businessDesktopSearch
          ? const []
          : _buildMenuItems(context, style),
      title: business
          ? context.appLocalizations.businessLines
          : context.appLocalizations.proxies,
      titleWidget: businessDesktopSearch
          ? _BusinessProxyTitle(onSearch: _onSearch)
          : null,
      actions: businessDesktopSearch
          ? [
              BusinessSecondaryButton(
                label: context.appLocalizations.businessSortByDelay,
                width: 99 * textScale,
                onPressed: () => _updateStyle(
                  (state) => state.copyWith(
                    sortType: state.sortType == ProxiesSortType.delay
                        ? ProxiesSortType.none
                        : ProxiesSortType.delay,
                  ),
                ),
              ),
              BusinessPrimaryButton(
                label: context.appLocalizations.businessTestAll,
                width: 86 * textScale,
                onPressed: groups.isEmpty
                    ? null
                    : () => ref
                          .read(proxiesActionProvider.notifier)
                          .delayTestGroups(groups),
              ),
              PopupAnchor(
                targetBuilder: (open) => IconButton(
                  tooltip: context.appLocalizations.more,
                  onPressed: open,
                  style: ButtonStyle.from(
                    shape: AppShape.md,
                    fixedSize: const Size(34, 34),
                    minimumSize: const Size(34, 34),
                    maximumSize: const Size(34, 34),
                    padding: EdgeInsets.zero,
                    tapTargetSize: TapTargetSize.shrinkWrap,
                  ),
                  icon: const GlyphIcon(AppGlyphs.more),
                ),
                popupBuilder: (_) => PopupMenu(
                  maxVisibleItems: 7,
                  items: _buildMenuItems(context, style),
                ),
              ),
            ]
          : null,
      searchState: businessDesktopSearch
          ? null
          : AppBarSearchState(onSearch: _onSearch),
      body: switch ((business, style.type)) {
        (true, ProxiesType.list) => const BusinessProxyBrowser(),
        (_, ProxiesType.tab) => _tabView,
        (_, ProxiesType.list) => const ProxiesListView(),
      },
    );
  }
}

class _BusinessProxyTitle extends StatelessWidget {
  const _BusinessProxyTitle({required this.onSearch});

  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return Row(
      children: [
        Text(
          context.appLocalizations.businessLines,
          style: AppTextStyle.pageTitle.of(context),
        ),
        const Spacer(),
        DecoratedBox(
          decoration: ShapeDecoration(
            color: context.colorScheme.brightness == Brightness.dark
                ? context.colorScheme.surfaceContainer
                : const Color(0xFFFFFFFF),
            shape: RoundedSuperellipseBorder(
              side: BorderSide(
                color: context.colorScheme.brightness == Brightness.dark
                    ? BusinessPalette.secondaryButtonDarkStroke
                    : BusinessPalette.searchStroke,
                width: 0.5,
              ),
              borderRadius: AppRadius.full,
            ),
            shadows: [
              const BoxShadow(
                color: BusinessPalette.searchShadow,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: SizedBox(
            width: 240 * textScale,
            height: 34,
            child: SearchField(
              height: 34,
              hintText: context.appLocalizations.businessSearchHint,
              onChanged: onSearch,
            ),
          ),
        ),
      ],
    );
  }
}

PopupMenuItem _optionsMenuItem<T>({
  required Glyph glyph,
  required String label,
  required List<T> options,
  required T value,
  required String Function(T option) textOf,
  required ValueSetter<T> onSelected,
  PopupMenuSection? section,
}) {
  return PopupMenuItem(
    glyph: glyph,
    label: label,
    section: section,
    subItems: [
      for (final option in options)
        PopupMenuItem(
          label: textOf(option),
          checked: option == value,
          onPressed: () => onSelected(option),
        ),
    ],
  );
}
