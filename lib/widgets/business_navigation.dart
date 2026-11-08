import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/common.dart';
import 'package:fl_clash/models/profile.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/prism_ui.dart';

const _expandedSidebarWidth = 216.0;
const _compactSidebarWidth = 56.0;
const _sidebarRowShape = RoundedSuperellipseBorder(
  borderRadius: BorderRadius.all(Radius.circular(13)),
);
const _dockMargin = 14.0;
const _dockHeight = 68.0;

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
          color: dark
              ? const Color(0x8C0A0F2B)
              : context.colorScheme.chromeSurface,
          shape: const RoundedSuperellipseBorder(),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalInset,
            26,
            horizontalInset,
            26,
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
          ClipRSuperellipse(
            borderRadius: AppRadius.sm,
            child: Image.asset(
              'assets/images/icon.png',
              width: 34,
              height: 34,
              fit: BoxFit.cover,
            ),
          ),
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
                        ? BusinessPalette.secondary
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
        label: item.label.label,
        child: FocusRing(
          shape: _sidebarRowShape,
          child: PressRegion(
            onTap: onTap,
            shape: _sidebarRowShape,
            overlay: PressRegion.hoverOverlay,
            child: SizedBox(
              height: 44,
              child: Stack(
                children: [
                  if (selected)
                    const Positioned.fill(
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          gradient: BusinessPalette.navSelection,
                          shape: _sidebarRowShape,
                        ),
                      ),
                    ),
                  if (selected)
                    const PositionedDirectional(
                      start: 0,
                      top: 11,
                      bottom: 11,
                      child: SizedBox(
                        width: 2.5,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: BusinessPalette.accent,
                            shape: AppShape.full,
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
                          data: IconThemeData(size: 20, color: foreground),
                          child: AnimatedGlyph(
                            glyph: item.glyph,
                            filled: selected,
                          ),
                        ),
                        if (expanded) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.label.label,
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
    final usage = info?.usage;
    final expiry = info?.expireDate;
    final daysLeft = expiry == null
        ? null
        : math.max(0, expiry.difference(DateTime.now()).inDays);
    final usageLabel = usage == null
        ? context.appLocalizations.noData
        : '${(usage * 100).round()}% ${context.appLocalizations.usedShort}';
    final remaining = daysLeft == null
        ? context.appLocalizations.unknown
        : context.appLocalizations.profileDaysLeft(daysLeft);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: dark
            ? const Color(0x0DFFFFFF)
            : context.colorScheme.onSurface.withValues(alpha: 0.04),
        shape: RoundedSuperellipseBorder(
          side: BorderSide(
            color: dark
                ? const Color(0x248C96FF)
                : context.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          borderRadius: AppRadius.md,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BusinessText.sidebarAccount(context).copyWith(
                color: dark
                    ? const Color(0xFFEDF0FF)
                    : context.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '$remaining · $usageLabel',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BusinessText.sidebarAccountSub(context).copyWith(
                color: dark
                    ? BusinessPalette.purple
                    : context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 9),
            ClipRSuperellipse(
              borderRadius: AppRadius.full,
              child: SizedBox(
                height: 5,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ColoredBox(
                        color: dark
                            ? const Color(0x1FFFFFFF)
                            : const Color(0x12000000),
                      ),
                    ),
                    if (usage != null)
                      FractionallySizedBox(
                        alignment: AlignmentDirectional.centerStart,
                        widthFactor: usage.clamp(0.0, 1.0).toDouble(),
                        child: const DecoratedBox(
                          decoration: ShapeDecoration(
                            gradient: BusinessPalette.gradient,
                            shape: AppShape.full,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
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
      _dockHeight + math.max(_dockMargin, MediaQuery.paddingOf(context).bottom);

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    final bottom = math.max(_dockMargin, MediaQuery.paddingOf(context).bottom);
    final width = MediaQuery.sizeOf(context).width - _dockMargin * 2;
    return SizedBox(
      height: _dockHeight + bottom,
      child: Padding(
        padding: EdgeInsets.fromLTRB(_dockMargin, 0, _dockMargin, bottom),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 362),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: dark
                    ? const Color(0xD10D122E)
                    : context.colorScheme.chromeSurface,
                shape: RoundedSuperellipseBorder(
                  side: BorderSide(
                    color: dark
                        ? const Color(0x2E8C96FF)
                        : context.colorScheme.outlineVariant.withValues(
                            alpha: 0.35,
                          ),
                  ),
                  borderRadius: AppRadius.xl,
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x33020412),
                    blurRadius: 22,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: SizedBox(
                key: const ValueKey('business-navigation-dock-bar'),
                height: _dockHeight,
                width: math.min(width, 362.0),
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
      label: item.label.label,
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
                  data: IconThemeData(size: 20, color: color),
                  child: AnimatedGlyph(glyph: item.glyph, filled: selected),
                ),
                const SizedBox(height: 3),
                Text(
                  item.label.label,
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
