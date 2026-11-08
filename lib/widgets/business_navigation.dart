import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/common.dart';
import 'package:fl_clash/models/profile.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/business_brand_mark.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

const _expandedSidebarWidth = 220.0;
const _compactSidebarWidth = 56.0;
const _sidebarRowShape = RoundedSuperellipseBorder(
  borderRadius: BorderRadius.all(Radius.circular(13)),
);
const _dockHeight = 58.0;

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
    PageLabel.dns => l10n.dnsQueries,
  };
}

class BusinessNavigationSidebar extends ConsumerWidget {
  const BusinessNavigationSidebar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.expanded,
    required this.onSelected,
    required this.onToggle,
    required this.windowControls,
  });

  final List<NavigationItem> items;
  final int currentIndex;
  final bool expanded;
  final ValueChanged<int> onSelected;
  final VoidCallback? onToggle;
  final Size windowControls;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final dark = context.colorScheme.brightness == Brightness.dark;
    final width = expanded ? _expandedSidebarWidth : _compactSidebarWidth;
    final horizontalInset = expanded ? 16.0 : 8.0;
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: dark ? const Color(0x8C0A0F2B) : const Color(0xFFF7F8FA),
          shape: const RoundedSuperellipseBorder(),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalInset,
            18,
            horizontalInset,
            18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: windowControls.height),
              if (expanded) ...[
                _BusinessBrand(
                  onToggle: onToggle,
                  brandName: context.appLocalizations.brandName,
                ),
                const SizedBox(height: 22),
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
                if (profile != null) _SubscriptionSummary(profile: profile),
              ] else ...[
                if (onToggle != null)
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: _SidebarToggle(expanded: false, onTap: onToggle!),
                  ),
                const SizedBox(height: 12),
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
  const _BusinessBrand({required this.onToggle, required this.brandName});

  final VoidCallback? onToggle;
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
                        ? const Color(0xFFEDF0FF)
                        : context.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'TIANJI CLOUD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BusinessText.sidebarTagline(context).copyWith(
                    color: dark
                        ? const Color(0xFFB9C0E4)
                        : context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onToggle != null) ...[
            const SizedBox(width: 4),
            _SidebarToggle(expanded: true, onTap: onToggle!),
          ],
        ],
      ),
    );
  }
}

class _SidebarToggle extends StatelessWidget {
  const _SidebarToggle({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: expanded
          ? context.appLocalizations.showLess
          : context.appLocalizations.showMore,
      child: FocusRing(
        shape: _sidebarRowShape,
        child: Tooltip(
          message: expanded
              ? context.appLocalizations.showLess
              : context.appLocalizations.showMore,
          child: PressRegion(
            onTap: onTap,
            shape: _sidebarRowShape,
            overlay: PressRegion.hoverOverlay,
            child: SizedBox(
              height: 28,
              width: 28,
              child: Center(
                child: GlyphIcon(
                  Glyphs.sidebar(expanded ? 1 : 0),
                  size: 20,
                  color: dark
                      ? const Color(0xFFB9C0E4)
                      : context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
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
    final foreground = selected
        ? (dark ? const Color(0xFFEDF0FF) : context.colorScheme.onSurface)
        : (dark
              ? const Color(0xFFB9C0E4)
              : context.colorScheme.onSurfaceVariant);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Semantics(
        button: true,
        selected: selected,
        label: _navigationLabel(context, item.label),
        child: FocusRing(
          shape: _sidebarRowShape,
          child: PressRegion(
            onTap: onTap,
            shape: _sidebarRowShape,
            overlay: PressRegion.hoverOverlay,
            child: SizedBox(
              height: 38,
              child: Stack(
                children: [
                  if (selected)
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: dark
                              ? const Color(0xFF1A2330)
                              : const Color(0xFFFFFFFF),
                          shape: RoundedSuperellipseBorder(
                            side: BorderSide(
                              color: dark
                                  ? const Color(0xFF2A3442)
                                  : const Color(0xFFDCE1E7),
                            ),
                            borderRadius: _sidebarRowShape.borderRadius,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: expanded ? 12 : 0,
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
                            color: selected ? BusinessPalette.blue : foreground,
                          ),
                          child: AnimatedGlyph(
                            glyph: item.glyph,
                            filled: selected,
                          ),
                        ),
                        if (expanded) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _navigationLabel(context, item.label),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: BusinessText.sidebarNav(
                                context,
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
        color: dark ? const Color(0xFF1A2330) : const Color(0xFFFFFFFF),
        shape: AppShape.lg,
        shadows: dark
            ? const []
            : const [
                BoxShadow(
                  color: Color(0x140E1726),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Tooltip(
          message: '${profile.realLabel} · $remaining',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                profile.realLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: BusinessText.sidebarAccount(context).copyWith(
                  color: dark
                      ? const Color(0xFFEDF0FF)
                      : const Color(0xFF0E1726),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                remaining,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: BusinessText.sidebarAccountSub(context).copyWith(
                  color: dark
                      ? const Color(0xFFB9C0E4)
                      : const Color(0xFF56616F),
                ),
              ),
              if (usage != null) ...[
                const SizedBox(height: 2),
                Text(
                  '${(usage * 100).round()}% ${context.appLocalizations.usedShort}',
                  maxLines: 1,
                  style: BusinessText.sidebarAccountSub(context).copyWith(
                    color: dark
                        ? const Color(0xFFB9C0E4)
                        : const Color(0xFF56616F),
                  ),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  height: 6,
                  child: DecoratedBox(
                    decoration: const ShapeDecoration(
                      color: Color(0xFFEEF1F4),
                      shape: AppShape.full,
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FractionallySizedBox(
                        widthFactor: usage,
                        heightFactor: 1,
                        child: const DecoratedBox(
                          decoration: ShapeDecoration(
                            color: BusinessPalette.blue,
                            shape: AppShape.full,
                          ),
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
        color: context.colorScheme.chromeSurface,
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
        ? (dark ? const Color(0xFFEDF0FF) : context.colorScheme.onSurface)
        : (dark
              ? const Color(0xFF8E97C4)
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
                    color: selected ? BusinessPalette.blue : color,
                  ),
                  child: AnimatedGlyph(glyph: item.glyph, filled: selected),
                ),
                const SizedBox(height: 3),
                Text(
                  _navigationLabel(context, item.label, mobile: true),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: BusinessText.dockLabel(context).copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
