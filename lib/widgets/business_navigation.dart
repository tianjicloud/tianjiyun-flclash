import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/common.dart';
import 'package:fl_clash/models/profile.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/app_background.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/business_brand_mark.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

const _expandedSidebarWidth = 220.0;
const _compactSidebarWidth = 56.0;
const _sidebarRowShape = RoundedSuperellipseBorder(
  borderRadius: BorderRadius.all(Radius.circular(10)),
);
const _dockHeight = 72.0;

String _navigationLabel(
  BuildContext context,
  PageLabel page, {
  bool mobile = false,
}) {
  final l10n = context.appLocalizations;
  return switch (page) {
    PageLabel.dashboard => mobile ? l10n.businessHome : l10n.dashboard,
    PageLabel.proxies => l10n.businessLines,
    PageLabel.profiles => l10n.businessSubscriptions,
    PageLabel.requests => l10n.connections,
    PageLabel.logs => l10n.logsAndDiagnostics,
    PageLabel.tools => mobile ? l10n.tools : l10n.settings,
    PageLabel.resources => l10n.resources,
    PageLabel.dns => l10n.dnsResourcesDesktop,
  };
}

class BusinessNavigationSidebar extends ConsumerWidget {
  const BusinessNavigationSidebar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.expanded,
    required this.onSelected,
    required this.windowControls,
  });

  final List<NavigationItem> items;
  final int currentIndex;
  final bool expanded;
  final ValueChanged<int> onSelected;
  final Size windowControls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final dark = context.colorScheme.brightness == Brightness.dark;
    final macOS = defaultTargetPlatform == TargetPlatform.macOS;
    final hasWallpaper = AppBackgroundScope.hasImage(context);
    final width = expanded ? _expandedSidebarWidth : _compactSidebarWidth;
    final horizontalInset = macOS && expanded
        ? 10.0
        : expanded
        ? 12.5
        : 8.0;
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: hasWallpaper
              ? Colors.transparent
              : dark
              ? BusinessPalette.sidebarDarkOverlay
              : macOS
              ? null
              : BusinessPalette.sidebarLight,
          gradient: !dark && !hasWallpaper && macOS
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(247, 248, 251, 0.86),
                    Color.fromRGBO(239, 242, 247, 0.86),
                  ],
                )
              : null,
          shape: const RoundedSuperellipseBorder(),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalInset,
            macOS ? 14 : 18,
            horizontalInset,
            18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: macOS ? 38 : windowControls.height),
              if (expanded) ...[
                if (!macOS) ...[
                  _BusinessBrand(brandName: context.appLocalizations.brandName),
                  const SizedBox(height: 22),
                ],
                Expanded(
                  child: FocusTraversalGroup(
                    child: Shortcuts(
                      shortcuts: {
                        const SingleActivator(LogicalKeyboardKey.arrowDown):
                            const NextFocusIntent(),
                        const SingleActivator(LogicalKeyboardKey.arrowUp):
                            const PreviousFocusIntent(),
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (final (index, item) in items.indexed)
                              _BusinessSidebarItem(
                                item: item,
                                selected: currentIndex == index,
                                expanded: true,
                                onTap: () => onSelected(index),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (macOS) ...[
                  _MacSidebarFooter(
                    profile: profile,
                    onSettings: () {
                      final settingsIndex = items.indexWhere(
                        (item) => item.label == PageLabel.tools,
                      );
                      if (settingsIndex >= 0) onSelected(settingsIndex);
                    },
                  ),
                ] else if (profile != null)
                  _SubscriptionSummary(profile: profile),
              ] else ...[
                Expanded(
                  child: FocusTraversalGroup(
                    child: Shortcuts(
                      shortcuts: {
                        const SingleActivator(LogicalKeyboardKey.arrowDown):
                            const NextFocusIntent(),
                        const SingleActivator(LogicalKeyboardKey.arrowUp):
                            const PreviousFocusIntent(),
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (final (index, item) in items.indexed)
                              _BusinessSidebarItem(
                                item: item,
                                selected: currentIndex == index,
                                expanded: false,
                                onTap: () => onSelected(index),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BusinessBrand extends StatelessWidget {
  const _BusinessBrand({required this.brandName});

  final String brandName;

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 0, 0),
      child: Row(
        children: [
          const BusinessBrandMark(size: 34),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brandName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BusinessText.sidebarBrand(context).copyWith(
                    color: dark
                        ? BusinessPalette.sidebarDarkSelected
                        : context.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'TIANJI CLOUD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BusinessText.sidebarTagline(context).copyWith(
                    color: dark
                        ? BusinessPalette.sidebarDarkSecondary
                        : context.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacSidebarFooter extends StatelessWidget {
  const _MacSidebarFooter({required this.profile, required this.onSettings});

  final Profile? profile;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final expiry = profile?.subscriptionInfo?.expireDate;
    final remaining = expiry == null
        ? context.appLocalizations.unknown
        : context.appLocalizations.profileDaysLeft(
            math.max(0, expiry.difference(DateTime.now()).inDays),
          );
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 2, 0),
      child: Row(
        children: [
          const BusinessBrandMark(size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appLocalizations.brandName,
                  style: BusinessText.sidebarBrand(context),
                ),
                Text(
                  remaining,
                  style: BusinessText.sidebarAccountSub(
                    context,
                  ).copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.appLocalizations.settings,
            onPressed: onSettings,
            style: const ButtonStyle(
              fixedSize: Size(28, 28),
              minimumSize: Size(28, 28),
              maximumSize: Size(28, 28),
              padding: EdgeInsets.zero,
              shape: AppShape.md,
              tapTargetSize: TapTargetSize.shrinkWrap,
            ),
            icon: const GlyphIcon(AppGlyphs.settings),
          ),
        ],
      ),
    );
  }
}

class _BusinessSidebarItem extends StatelessWidget {
  const _BusinessSidebarItem({
    required this.item,
    required this.selected,
    required this.expanded,
    required this.onTap,
  });

  final NavigationItem item;
  final bool selected;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    final macOS = defaultTargetPlatform == TargetPlatform.macOS;
    final foreground = selected
        ? (dark
              ? BusinessPalette.sidebarDarkSelected
              : context.colorScheme.onSurface)
        : (dark
              ? BusinessPalette.sidebarDarkSecondary
              : BusinessPalette.sidebarSecondary);
    return Padding(
      padding: EdgeInsets.only(
        bottom: defaultTargetPlatform == TargetPlatform.macOS ? 2 : 4,
      ),
      child: Semantics(
        button: true,
        selected: selected,
        label: _navigationLabel(context, item.label),
        child: Tooltip(
          message: _navigationLabel(context, item.label),
          child: FocusRing(
            shape: _sidebarRowShape,
            child: PressRegion(
              onTap: onTap,
              shape: _sidebarRowShape,
              overlay: PressRegion.hoverOverlay,
              child: SizedBox(
                key: ValueKey('business-sidebar-${item.label.name}'),
                height: defaultTargetPlatform == TargetPlatform.macOS ? 32 : 38,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    if (selected)
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: macOS && !dark
                                ? Colors.white
                                : dark
                                ? BusinessPalette.sidebarDarkBackground
                                : BusinessPalette.sidebarSelection,
                            shape: RoundedSuperellipseBorder(
                              borderRadius: _sidebarRowShape.borderRadius,
                            ),
                            shadows: dark || macOS
                                ? const []
                                : const [
                                    BoxShadow(
                                      color: BusinessPalette
                                          .sidebarSelectionShadow,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: expanded ? 10 : 0,
                        end: expanded ? 8 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: expanded
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          IconTheme.merge(
                            data: IconThemeData(
                              size: 20,
                              color: selected
                                  ? context.colorScheme.primary
                                  : foreground,
                            ),
                            child: AnimatedGlyph(
                              glyph: item.glyph,
                              filled: selected,
                            ),
                          ),
                          if (expanded) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _navigationLabel(context, item.label),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: BusinessText.sidebarNav(
                                  context,
                                  selected: selected,
                                ).copyWith(color: foreground),
                              ),
                            ),
                          ],
                        ],
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

class _SubscriptionSummary extends StatelessWidget {
  const _SubscriptionSummary({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    final info = profile.subscriptionInfo;
    final expiry = info?.expireDate;
    final usage = info?.usage;
    final daysLeft = expiry == null
        ? null
        : math.max(0, expiry.difference(DateTime.now()).inDays);
    final remaining = daysLeft == null
        ? context.appLocalizations.unknown
        : context.appLocalizations.profileDaysLeft(daysLeft);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: dark
            ? BusinessPalette.sidebarDarkBackground
            : BusinessPalette.sidebarSelection,
        shape: AppShape.all(BusinessPalette.cardRadius),
        shadows: dark
            ? const []
            : const [
                BoxShadow(
                  color: BusinessPalette.sidebarSelectionShadow,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Tooltip(
          message: '${profile.realLabel} · $remaining',
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 66),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  profile.realLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BusinessText.sidebarAccount(context).copyWith(
                    color: dark
                        ? BusinessPalette.sidebarDarkSelected
                        : BusinessPalette.deep,
                  ),
                ),
                Text(
                  usage == null
                      ? remaining
                      : '$remaining · ${context.appLocalizations.businessUsagePercent((usage * 100).round())}',
                  style: BusinessText.sidebarAccountSub(context).copyWith(
                    color: dark
                        ? BusinessPalette.sidebarDarkSecondary
                        : BusinessPalette.secondary,
                  ),
                ),
                if (usage != null)
                  SizedBox(
                    height: 8,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: DashboardColors.of(context).track,
                        shape: AppShape.full,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: FractionallySizedBox(
                          widthFactor: usage,
                          heightFactor: 1,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: context.colorScheme.primary,
                              shape: AppShape.full,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BusinessNavigationDock extends StatelessWidget {
  const BusinessNavigationDock({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<NavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static double insetOf(BuildContext context) =>
      _dockHeight + MediaQuery.paddingOf(context).bottom;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: _dockHeight + bottom,
      child: Surface(
        color: context.colorScheme.brightness == Brightness.light
            ? BusinessPalette.dockLight
            : BusinessPalette.dockDark,
        shape: Border(top: Divider.createBorderSide(context)),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: SizedBox(
            key: const ValueKey('business-navigation-dock-bar'),
            height: _dockHeight,
            child: Row(
              children: [
                for (final (index, item) in items.indexed)
                  Expanded(
                    child: _BusinessDockItem(
                      item: item,
                      selected: selectedIndex == index,
                      onTap: () => onSelected(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BusinessDockItem extends StatelessWidget {
  const _BusinessDockItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final NavigationItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    final color = selected
        ? (dark
              ? BusinessPalette.sidebarDarkSelectedAccent
              : context.colorScheme.onSurface)
        : (dark
              ? BusinessPalette.sidebarDarkMuted
              : context.colorScheme.onSurfaceVariant);
    return Semantics(
      button: true,
      selected: selected,
      label: _navigationLabel(context, item.label, mobile: true),
      child: FocusRing(
        shape: AppShape.md,
        child: PressRegion(
          onTap: onTap,
          overlay: PressRegion.hoverOverlay,
          child: SizedBox(
            height: _dockHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconTheme.merge(
                  data: IconThemeData(
                    size: 20,
                    color: selected
                        ? (dark
                              ? BusinessPalette.sidebarDarkSelectedAccent
                              : context.colorScheme.primary)
                        : color,
                  ),
                  child: Container(
                    width: 56,
                    height: 30,
                    decoration: ShapeDecoration(
                      color: selected
                          ? dark
                                ? BusinessPalette.sidebarDarkSelectedBackground
                                : BusinessPalette.residentialChip
                          : Colors.transparent,
                      shape: AppShape.full,
                    ),
                    child: Center(
                      child: AnimatedGlyph(
                        glyph: item.label == PageLabel.tools
                            ? AppGlyphs.sliders
                            : item.glyph,
                        filled: selected,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _navigationLabel(context, item.label, mobile: true),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BusinessText.dockLabel(
                    context,
                    selected: selected,
                  ).copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
