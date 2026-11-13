import 'dart:async';
import 'dart:math';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/app_background.dart';
import 'package:fl_clash/views/font_family.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/theme_choices.dart';
import 'package:fl_clash/views/theme_preview.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key, this.business = false});

  final bool business;

  @override
  Widget build(BuildContext context) {
    if (business) {
      return Consumer(
        builder: (context, ref, _) => ref.watch(isMobileViewProvider)
            ? const _BusinessMobileThemeView()
            : const _BusinessThemeView(),
      );
    }
    final appLocalizations = context.appLocalizations;
    return BaseScaffold(
      title: appLocalizations.theme,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          MacOSMetrics.pageMargin(context, fallback: 0),
          context.appBarInset,
          MacOSMetrics.pageMargin(context, fallback: 0),
          32 + context.bottomInset,
        ),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ThemeLivePreview(),
                  const SizedBox(height: 16),
                  const _ThemeModeItem(),
                  const SizedBox(height: 16),
                  const _PrimaryColorItem(),
                  const SizedBox(height: 16),
                  if (MacOSStyle.of(context)) ...[
                    const _FollowSystemAccentItem(),
                    const SizedBox(height: 16),
                  ],
                  const _FontFamilyItem(),
                  const SizedBox(height: 16),
                  const _TextScaleFactorItem(),
                  const SizedBox(height: 16),
                  const _PureBlackItem(),
                  const SizedBox(height: 16),
                  const _NavigationBarItem(),
                  const SizedBox(height: 16),
                  const _TabAnimationItem(),
                  const SizedBox(height: 16),
                  const _LiquidGlassItem(),
                  const SizedBox(height: 16),
                  if (system.isDesktop) ...[
                    const _CompactSidebarItem(),
                    const SizedBox(height: 16),
                  ],
                  if (system.isWindows) ...[
                    const _SidebarBlurItem(),
                    const SizedBox(height: 16),
                  ],
                  const _BackgroundItem(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowSystemAccentItem extends StatelessWidget {
  const _FollowSystemAccentItem();

  @override
  Widget build(BuildContext context) => ConfigToggleItem(
    title: (l) => l.followSystemAccent,
    selector: themeSettingProvider.select((state) => state.followSystemAccent),
    onChanged: (ref, value) => ref
        .read(themeSettingProvider.notifier)
        .update((state) => state.copyWith(followSystemAccent: value)),
  );
}

class _BusinessMobileThemeView extends ConsumerWidget {
  const _BusinessMobileThemeView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final locale = ref.watch(
      appSettingProvider.select((state) => state.locale),
    );
    String localeLabel(Locale? locale) => switch (locale?.toString()) {
      null => l10n.businessFollowSystem,
      'zh_CN' => l10n.businessToolsSimplifiedChinese,
      _ => locale!.label,
    };
    return Scaffold(
      title: l10n.businessToolsAppearanceLanguage,
      body: ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: context.sectionsTopPadding,
          bottom: context.bottomInset + 20,
        ),
        children: [
          _BusinessThemeCard(
            title: l10n.theme,
            child: const BusinessThemeChoices(),
          ),
          const SizedBox(height: 14),
          _BusinessThemeCard(
            title: l10n.businessAccentColor,
            child: const _PrimaryColorItem(business: true, mobile: true),
          ),
          const SizedBox(height: 14),
          BusinessSettingsCard(
            title: l10n.language,
            items: [
              for (final option in [
                null,
                ...AppLocalizations.delegate.supportedLocales,
              ])
                ListItem(
                  title: Text(localeLabel(option)),
                  trailing: locale == option?.toString()
                      ? const GlyphIcon(AppGlyphs.check)
                      : null,
                  onTap: () => ref
                      .read(appSettingProvider.notifier)
                      .update(
                        (state) => state.copyWith(locale: option?.toString()),
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BusinessThemeView extends StatelessWidget {
  const _BusinessThemeView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    return ListView(
      padding: EdgeInsets.only(
        left: MacOSMetrics.pageMargin(context, fallback: 40),
        right: MacOSMetrics.pageMargin(context, fallback: 0),
        bottom: context.bottomInset + 20,
      ),
      children: [
        _BusinessThemeCard(
          title: l10n.theme,
          child: const BusinessThemeChoices(),
        ),
        const SizedBox(height: 14),
        _BusinessThemeCard(
          title: l10n.businessAccentColor,
          child: Column(
            children: [
              const _PrimaryColorItem(business: true),
              if (MacOSStyle.of(context)) ...[
                SizedBox(
                  height: 1,
                  child: ColoredBox(color: context.colorScheme.outlineVariant),
                ),
                const _FollowSystemAccentItem(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        _BusinessThemeCard(
          title: l10n.businessTypographyLayout,
          child: Column(
            children: [
              const _FontFamilyItem(business: true),
              SizedBox(
                height: 1,
                child: ColoredBox(color: context.colorScheme.outlineVariant),
              ),
              const _TextScaleFactorItem(business: true),
              SizedBox(
                height: 1,
                child: ColoredBox(color: context.colorScheme.outlineVariant),
              ),
              const _BusinessProxyStyleRows(),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _BusinessThemeCard(
          title: l10n.colorStyle,
          child: const _ColorStyleItem(),
        ),
        const SizedBox(height: 14),
        _BusinessThemeCard(
          title: l10n.appBackground,
          child: const _BackgroundItem(business: true),
        ),
        const SizedBox(height: 14),
        _BusinessThemeCard(
          title: l10n.liquidGlass,
          child: const _LiquidGlassItem(business: true),
        ),
        const SizedBox(height: 14),
        _BusinessThemeCard(
          title: l10n.pureBlackMode,
          child: const _PureBlackItem(business: true),
        ),
        const SizedBox(height: 14),
        _BusinessThemeCard(
          title: l10n.navigationBarStyle,
          child: const _NavigationBarItem(business: true),
        ),
        const SizedBox(height: 14),
        _BusinessThemeCard(
          title: l10n.tabAnimation,
          child: const _TabAnimationItem(business: true),
        ),
        if (system.isDesktop) ...[
          const SizedBox(height: 14),
          _BusinessThemeCard(
            title: l10n.sidebar,
            child: Column(
              children: [
                const _CompactSidebarItem(),
                if (system.isWindows) ...[
                  SizedBox(
                    height: 1,
                    child: ColoredBox(
                      color: context.colorScheme.outlineVariant,
                    ),
                  ),
                  const _SidebarBlurItem(business: true),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _BusinessProxyStyleRows extends ConsumerWidget {
  const _BusinessProxyStyleRows();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = context.appLocalizations;
    final style = ref.watch(proxiesStyleSettingProvider);
    return Column(
      children: [
        ListItem<ProxyCardType>.options(
          title: Text(strings.businessProxyCardDensity),
          options: ProxyCardType.values,
          value: style.cardType,
          textBuilder: (type) => type.label,
          onChanged: (value) => ref
              .read(proxiesStyleSettingProvider.notifier)
              .update((state) => state.copyWith(cardType: value)),
        ),
        SizedBox(
          height: 1,
          child: ColoredBox(color: context.colorScheme.outlineVariant),
        ),
        ListItem<ProxiesIconStyle>.options(
          title: Text(strings.businessProxyIcons),
          options: ProxiesIconStyle.values,
          value: style.iconStyle,
          textBuilder: (value) => switch (value) {
            ProxiesIconStyle.filled => strings.iconStyleFilled,
            ProxiesIconStyle.plain => strings.iconStylePlain,
            ProxiesIconStyle.hidden => strings.iconStyleHidden,
          },
          onChanged: (value) => ref
              .read(proxiesStyleSettingProvider.notifier)
              .update((state) => state.copyWith(iconStyle: value)),
        ),
      ],
    );
  }
}

class _BusinessThemeCard extends StatelessWidget {
  const _BusinessThemeCard({this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: MacOSMetrics.cardPadding(context, const EdgeInsets.all(18)),
      decoration: ShapeDecoration(
        color: dark ? color.surfaceContainerLow : color.surface,
        shape: AppShape.all(MacOSMetrics.cardRadius(context, fallback: 18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title case final title?) ...[
            Text(
              title,
              style: AppTextStyle.custom(
                context,
                size: 14,
                leading: 20,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
          ],
          ListItemInsets(padding: EdgeInsets.zero, child: child),
        ],
      ),
    );
  }
}

class _ThemeModeItem extends ConsumerWidget {
  const _ThemeModeItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final themeMode = ref.watch(
      themeSettingProvider.select((state) => state.themeMode),
    );
    final floatingBar = ref.watch(_floatingBarProvider);
    final liquidGlass = ref.watch(_liquidGlassProvider);
    final light = MiniScreen(
      colorScheme: ref.watch(genColorSchemeProvider(Brightness.light)),
      floatingBar: floatingBar,
      liquidGlass: liquidGlass,
    );
    final dark = MiniScreen(
      colorScheme: ref.watch(genColorSchemeProvider(Brightness.dark)),
      floatingBar: floatingBar,
      liquidGlass: liquidGlass,
    );
    return PreviewChoiceGroup<ThemeMode>(
      info: Info(label: appLocalizations.themeMode, glyph: AppGlyphs.sun),
      value: themeMode,
      choices: [
        PreviewChoice(
          value: ThemeMode.system,
          label: appLocalizations.auto,
          pictogram: MiniScreenThumb(
            screen: MiniSplitScreen(light: light, dark: dark),
          ),
        ),
        PreviewChoice(
          value: ThemeMode.light,
          label: appLocalizations.light,
          pictogram: MiniScreenThumb(screen: light),
        ),
        PreviewChoice(
          value: ThemeMode.dark,
          label: appLocalizations.dark,
          pictogram: MiniScreenThumb(screen: dark),
        ),
      ],
      onChanged: (value) {
        ref
            .read(themeSettingProvider.notifier)
            .update((state) => state.copyWith(themeMode: value));
      },
    );
  }
}

class _PrimaryColorItem extends ConsumerWidget {
  const _PrimaryColorItem({this.business = false, this.mobile = false});

  final bool business;
  final bool mobile;

  Future<void> _handleReset(BuildContext context, WidgetRef ref) async {
    final res = await dialogs.showMessage(
      message: TextSpan(text: context.appLocalizations.resetTip),
      destructive: true,
      confirmText: context.appLocalizations.reset,
    );
    if (res != true || !context.mounted) {
      return;
    }
    ref.read(themeSettingProvider.notifier).update((state) {
      return state.copyWith(
        primaryColors: defaultPrimaryColors,
        primaryColor: defaultPrimaryColor,
        colorStyle: ColorStyle.vivid,
      );
    });
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    int color,
  ) async {
    final appLocalizations = context.appLocalizations;
    final res = await dialogs.showMessage(
      message: TextSpan(
        text: appLocalizations.deleteTip(appLocalizations.color),
      ),
      destructive: true,
      confirmText: appLocalizations.delete,
    );
    if (res != true || !context.mounted) {
      return;
    }
    ref.read(themeSettingProvider.notifier).update((state) {
      final primaryColors = List<int>.from(state.primaryColors)..remove(color);
      var primaryColor = state.primaryColor;
      if (primaryColor == color) {
        primaryColor = primaryColors.contains(defaultPrimaryColor)
            ? defaultPrimaryColor
            : null;
      }
      return state.copyWith(
        primaryColors: primaryColors,
        primaryColor: primaryColor,
      );
    });
  }

  void _showColorSheet(
    BuildContext context,
    Color initialColor,
    ValueChanged<int> onConfirmed,
  ) {
    showSheet<void>(
      context: context,
      props: const SheetProps(detents: [0.9]),
      builder: (_) => _CustomColorSheet(
        initialColor: initialColor,
        onConfirmed: (color) {
          if (context.mounted) {
            onConfirmed(color);
          }
        },
      ),
    );
  }

  void _handleAdd(BuildContext context, WidgetRef ref) {
    final primaryColor = ref.read(themeSettingProvider).primaryColor;
    _showColorSheet(
      context,
      primaryColor != null
          ? Color(primaryColor)
          : ref.read(dynamicColorProvider).accentColor,
      (color) => _update(
        ref,
        (state) => state.copyWith(
          primaryColors: state.primaryColors.contains(color)
              ? state.primaryColors
              : [...state.primaryColors, color],
          primaryColor: color,
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context, WidgetRef ref, int color) {
    _showColorSheet(
      context,
      Color(color),
      (edited) => _update(ref, (state) {
        final index = state.primaryColors.indexOf(color);
        if (edited == color || index == -1) {
          return state;
        }
        final primaryColors = List<int>.from(state.primaryColors);
        if (primaryColors.contains(edited)) {
          primaryColors.removeAt(index);
        } else {
          primaryColors[index] = edited;
        }
        return state.copyWith(
          primaryColors: primaryColors,
          primaryColor: state.primaryColor == color
              ? edited
              : state.primaryColor,
        );
      }),
    );
  }

  void _update(WidgetRef ref, ThemeProps Function(ThemeProps state) update) {
    ref.read(themeSettingProvider.notifier).update(update);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final themeColors = ref.watch(
      themeSettingProvider.select(
        (state) => ThemeColorsSelectorState(
          primaryColor: state.primaryColor,
          primaryColors: state.primaryColors,
          colorStyle: state.colorStyle,
          isDefault:
              state.primaryColor == defaultPrimaryColor &&
              intListEquality.equals(
                state.primaryColors,
                defaultPrimaryColors,
              ) &&
              state.colorStyle == ColorStyle.vivid,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!business)
          InfoHeader(
            info: Info(
              label: appLocalizations.themeColor,
              glyph: AppGlyphs.palette,
            ),
            actions: [
              if (!themeColors.isDefault)
                _ResetButton(onPressed: () => _handleReset(context, ref)),
            ],
          ),
        Padding(
          padding: business
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: business ? 12 : 8,
            children: [
              if (business && !themeColors.isDefault)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: _ResetButton(
                    onPressed: () => _handleReset(context, ref),
                  ),
                ),
              _ColorSwatches(
                colors: [
                  null,
                  ...themeColors.primaryColors.take(mobile ? 4 : 100),
                ],
                selected: themeColors.primaryColor,
                business: business,
                onSelect: (color) => _update(
                  ref,
                  (state) => state.copyWith(primaryColor: color),
                ),
                onEdit: (color) => _handleEdit(context, ref, color),
                onDelete: (color) => _handleDelete(context, ref, color),
                onAdd: () => _handleAdd(context, ref),
              ),
              if (!business)
                generateGroup([
                  ListItem<ColorStyle>.options(
                    title: Text(appLocalizations.colorStyle),
                    options: ColorStyle.values,
                    value: themeColors.colorStyle,
                    textBuilder: (style) => style.label,
                    onChanged: (style) => _update(
                      ref,
                      (state) => state.copyWith(colorStyle: style),
                    ),
                  ),
                ]),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorStyleItem extends ConsumerWidget {
  const _ColorStyleItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(
      themeSettingProvider.select((state) => state.colorStyle),
    );
    return ListItem<ColorStyle>.options(
      title: Text(context.appLocalizations.colorStyle),
      options: ColorStyle.values,
      value: value,
      textBuilder: (style) => style.label,
      onChanged: (style) => ref
          .read(themeSettingProvider.notifier)
          .update((state) => state.copyWith(colorStyle: style)),
    );
  }
}

class _ColorSwatches extends ConsumerWidget {
  const _ColorSwatches({
    required this.colors,
    required this.selected,
    this.business = false,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
  });

  static const double _minGap = 6;

  // Lines the dots, not their selection rings, up with the rows' text.
  static const double _inset = 16 - (_ColorSwatch.size - _ColorSwatch.dot) / 2;

  final List<int?> colors;
  final int? selected;
  final bool business;
  final ValueChanged<int?> onSelect;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final level = context.raisedSurfaceLevel;
    final systemColor = ref
        .watch(dynamicColorProvider)
        .seedOf(Theme.of(context).brightness);
    return Container(
      padding: EdgeInsets.all(business ? 0 : _inset),
      decoration: business
          ? null
          : ShapeDecoration(
              color: level.colorOf(colorScheme),
              shape: AppShape.xl,
            ),
      child: SurfaceScope(
        level: level,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final cell = business ? 32.0 : _ColorSwatch.size;
            final width = constraints.maxWidth;
            final columns = max(
              1,
              ((width + _minGap) / (cell + _minGap)).floor(),
            );
            final gap = business
                ? 14.0
                : columns > 1
                ? ((width - columns * cell) / (columns - 1)).floorToDouble()
                : 0.0;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final color in colors)
                  _ColorSwatch(
                    color: color == null ? null : Color(color),
                    systemColor: systemColor,
                    isSelected: color == selected,
                    business: business,
                    label: color == null
                        ? appLocalizations.followSystem
                        : Color(color).hex,
                    onPressed: () => onSelect(color),
                    menuItems: color == null
                        ? null
                        : [
                            PopupMenuItem(
                              glyph: AppGlyphs.edit,
                              label: appLocalizations.edit,
                              onPressed: () => onEdit(color),
                            ),
                            PopupMenuItem(
                              danger: true,
                              glyph: AppGlyphs.delete,
                              label: appLocalizations.delete,
                              onPressed: () => onDelete(color),
                            ),
                          ],
                  ),
                _AddColorButton(onPressed: onAdd, business: business),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.systemColor,
    required this.isSelected,
    required this.label,
    required this.onPressed,
    this.business = false,
    this.menuItems,
  });

  static const double size = 44;
  static const double dot = 32;
  static const double _ring = 2.5;
  static const _duration = Duration(milliseconds: 200);

  static const double _badge = 20;

  /// Null follows the system's accent color, [systemColor].
  final Color? color;
  final Color systemColor;
  final bool isSelected;
  final String label;
  final VoidCallback onPressed;
  final bool business;
  final List<PopupMenuItem>? menuItems;

  @override
  Widget build(BuildContext context) {
    final fill = color ?? systemColor;
    final selected = isSelected;
    final check = ThemeData.estimateBrightnessForColor(fill) == Brightness.dark
        ? Colors.white
        : Colors.black;
    final swatchSize = business ? 32.0 : size;
    final dotSize = business ? 24.0 : dot;
    final swatch = SizedBox.square(
      dimension: swatchSize,
      child: PressSurface(
        fill: Colors.transparent,
        shape: AppShape.circle,
        ringStandsOff: selected,
        selected: selected,
        childFills: true,
        onPressed: onPressed,
        child: Semantics(
          label: label,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: selected ? 1 : 0,
                duration: _duration,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: AppShape.circle.copyWith(
                      side: BorderSide(
                        color: fill,
                        width: business ? 2 : _ring,
                      ),
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
              SizedBox.square(
                dimension: dotSize,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: fill,
                    shape: AppShape.circle,
                  ),
                ),
              ),
              if (color == null)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _EyedropperBadge(size: business ? 16 : _badge),
                ),
              if (MacOSStyle.of(context)) ...[
                if (selected)
                  GlyphIcon(
                    AppGlyphs.check,
                    size: business ? 14 : 18,
                    fill: 1,
                    color: check,
                  ),
              ] else ...[
                AnimatedScale(
                  scale: selected ? 1 : 0,
                  duration: _duration,
                  curve: Curves.easeOutBack,
                  child: GlyphIcon(
                    AppGlyphs.check,
                    size: business ? 14 : 18,
                    fill: 1,
                    color: check,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    final menuItems = this.menuItems;
    if (menuItems == null) {
      return swatch;
    }
    return ContextMenuRegion(menuItems: menuItems, child: swatch);
  }
}

class _EyedropperBadge extends StatelessWidget {
  const _EyedropperBadge({required this.size});

  static const double _gap = 2;

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(_gap),
      decoration: ShapeDecoration(
        color: context.surfaceLevel.colorOf(colorScheme),
        shape: AppShape.circle,
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: context.raisedSurfaceLevel.colorOf(colorScheme),
          shape: AppShape.circle,
        ),
        child: Center(
          child: GlyphIcon(
            AppGlyphs.eyedropper,
            size: size - _gap * 2 - 4,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _AddColorButton extends StatelessWidget {
  const _AddColorButton({required this.onPressed, this.business = false});

  final VoidCallback onPressed;
  final bool business;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Tooltip(
      message: context.appLocalizations.add,
      child: SizedBox.square(
        dimension: business ? 32 : _ColorSwatch.size,
        child: PressSurface(
          fill: Colors.transparent,
          shape: AppShape.circle,
          childFills: true,
          onPressed: onPressed,
          child: Center(
            child: Container(
              width: business ? 24 : _ColorSwatch.dot,
              height: business ? 24 : _ColorSwatch.dot,
              decoration: ShapeDecoration(
                color: context.raisedSurfaceLevel.colorOf(colorScheme),
                shape: AppShape.circle,
              ),
              child: GlyphIcon(
                AppGlyphs.add,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final _floatingBarProvider = appSettingProvider.select(
  (state) => state.floatingNavigationBar,
);

final _liquidGlassProvider = themeSettingProvider.select(
  (state) => state.liquidGlass != LiquidGlassMode.none,
);

class _PureBlackItem extends ConsumerWidget {
  const _PureBlackItem({this.business = false});

  final bool business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final pureBlack = ref.watch(
      themeSettingProvider.select((state) => state.pureBlack),
    );
    final floatingBar = ref.watch(_floatingBarProvider);
    final liquidGlass = ref.watch(_liquidGlassProvider);
    Widget preview(bool pureBlack) => MiniScreenThumb(
      screen: MiniScreen(
        colorScheme: ref.watch(
          genColorSchemeProvider(Brightness.dark, pureBlack: pureBlack),
        ),
        floatingBar: floatingBar,
        liquidGlass: liquidGlass,
      ),
    );
    return PreviewChoiceGroup<bool>(
      info: Info(
        label: appLocalizations.pureBlackMode,
        glyph: AppGlyphs.pureBlack,
      ),
      value: pureBlack,
      showInfoHeader: !business,
      choices: [
        PreviewChoice(
          value: false,
          label: appLocalizations.standard,
          pictogram: preview(false),
        ),
        PreviewChoice(
          value: true,
          label: appLocalizations.pureBlack,
          pictogram: preview(true),
        ),
      ],
      onChanged: (value) {
        ref
            .read(themeSettingProvider.notifier)
            .update((state) => state.copyWith(pureBlack: value));
      },
    );
  }
}

class _NavigationBarItem extends ConsumerWidget {
  const _NavigationBarItem({this.business = false});

  final bool business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final floatingBar = ref.watch(_floatingBarProvider);
    final liquidGlass = ref.watch(_liquidGlassProvider);
    final colorScheme = context.colorScheme;
    return PreviewChoiceGroup<bool>(
      info: Info(
        label: appLocalizations.navigationBarStyle,
        glyph: AppGlyphs.layers,
      ),
      value: floatingBar,
      showInfoHeader: !business,
      choices: [
        PreviewChoice(
          value: true,
          label: appLocalizations.floating,
          pictogram: MiniScreenThumb(
            screen: MiniScreen(
              colorScheme: colorScheme,
              floatingBar: true,
              liquidGlass: liquidGlass,
            ),
          ),
        ),
        PreviewChoice(
          value: false,
          label: appLocalizations.docked,
          pictogram: MiniScreenThumb(
            screen: MiniScreen(colorScheme: colorScheme, floatingBar: false),
          ),
        ),
      ],
      onChanged: (value) {
        ref
            .read(appSettingProvider.notifier)
            .update((state) => state.copyWith(floatingNavigationBar: value));
      },
    );
  }
}

class _TabAnimationItem extends ConsumerWidget {
  const _TabAnimationItem({this.business = false});

  final bool business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final tabAnimation = ref.watch(
      appSettingProvider.select((state) => state.tabAnimation),
    );
    final floatingBar = ref.watch(_floatingBarProvider);
    final liquidGlass = ref.watch(_liquidGlassProvider);
    final colorScheme = context.colorScheme;
    Widget switching(TabAnimation tabAnimation) => MiniScreenThumb(
      screen: MiniScreen(
        colorScheme: colorScheme,
        floatingBar: floatingBar,
        liquidGlass: liquidGlass,
        selected: 1,
        previous: 0,
        progress: 0.55,
        tabAnimation: tabAnimation,
      ),
    );
    return PreviewChoiceGroup<TabAnimation>(
      info: Info(label: appLocalizations.tabAnimation, glyph: AppGlyphs.motion),
      value: tabAnimation,
      showInfoHeader: !business,
      choices: [
        PreviewChoice(
          value: TabAnimation.slide,
          label: appLocalizations.slide,
          pictogram: switching(TabAnimation.slide),
        ),
        PreviewChoice(
          value: TabAnimation.fade,
          label: appLocalizations.fade,
          pictogram: switching(TabAnimation.fade),
        ),
      ],
      onChanged: (value) {
        ref
            .read(appSettingProvider.notifier)
            .update((state) => state.copyWith(tabAnimation: value));
      },
    );
  }
}

class _LiquidGlassItem extends ConsumerWidget {
  const _LiquidGlassItem({this.business = false});

  final bool business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final mode = ref.watch(
      themeSettingProvider.select((state) => state.liquidGlass),
    );
    final colorScheme = context.colorScheme;
    // Floating either way, as a docked bar stays a fill, over the list page,
    // whose rows run on under the bar where glass shows them.
    Widget preview(bool liquidGlass) => MiniScreenThumb(
      screen: MiniScreen(
        colorScheme: colorScheme,
        floatingBar: true,
        liquidGlass: liquidGlass,
        selected: 1,
      ),
    );
    return PreviewChoiceGroup<LiquidGlassMode>(
      info: Info(
        label: appLocalizations.liquidGlass,
        glyph: AppGlyphs.liquidGlass,
      ),
      value: mode,
      showInfoHeader: !business,
      choices: [
        PreviewChoice(
          value: LiquidGlassMode.none,
          label: appLocalizations.none,
          pictogram: preview(false),
        ),
        PreviewChoice(
          value: LiquidGlassMode.standard,
          label: appLocalizations.standard,
          pictogram: preview(true),
        ),
        PreviewChoice(
          value: LiquidGlassMode.ultra,
          label: appLocalizations.ultra,
          pictogram: preview(true),
        ),
      ],
      onChanged: (value) {
        ref
            .read(themeSettingProvider.notifier)
            .update((state) => state.copyWith(liquidGlass: value));
      },
    );
  }
}

class _CompactSidebarItem extends StatelessWidget {
  const _CompactSidebarItem();

  @override
  Widget build(BuildContext context) => ConfigToggleItem(
    title: (l) => l.compactSidebar,
    selector: appSettingProvider.select((state) => !state.sidebarExpanded),
    onChanged: (ref, value) => ref
        .read(appSettingProvider.notifier)
        .update((state) => state.copyWith(sidebarExpanded: !value)),
  );
}

class _SidebarBlurItem extends StatelessWidget {
  const _SidebarBlurItem({this.business = false});

  final bool business;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!business)
          InfoHeader(
            info: Info(label: appLocalizations.sidebar, glyph: AppGlyphs.blur),
          ),
        Padding(
          padding: business
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: generateGroup([
            ConfigToggleItem(
              title: (l) => l.backgroundBlur,
              selector: themeSettingProvider.select(
                (state) => state.sidebarBlur,
              ),
              onChanged: (ref, value) => ref
                  .read(themeSettingProvider.notifier)
                  .update((state) => state.copyWith(sidebarBlur: value)),
            ),
          ]),
        ),
      ],
    );
  }
}

class _FontFamilyItem extends ConsumerWidget {
  const _FontFamilyItem({this.business = false});

  final bool business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final fontFamily = ref.watch(
      themeSettingProvider.select((state) => state.fontFamily),
    );
    if (business) {
      return ListItem.open(
        title: Text(appLocalizations.fontFamily),
        subtitle: Text(fontFamily ?? appLocalizations.defaultText),
        widget: const FontFamilyView(),
      );
    }
    final preview = Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      child: Row(
        spacing: 12,
        children: [
          Text(
            'Aa',
            style: AppTextStyle.headline
                .of(context)
                .copyWith(fontFamily: fontFamily),
          ),
          Expanded(
            child: Text(
              fontFamily ?? appLocalizations.defaultText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.subheadline
                  .of(context)
                  .copyWith(
                    fontFamily: fontFamily,
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          GlyphIcon(
            AppGlyphs.chevronForward,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
    final cardColor = context.raisedSurfaceLevel.colorOf(colorScheme);
    Widget card(VoidCallback onTap) => PressSurface(
      fill: cardColor,
      shape: AppShape.lg,
      childFills: true,
      clipsChild: true,
      onPressed: onTap,
      child: preview,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoHeader(
          info: Info(label: appLocalizations.fontFamily, glyph: AppGlyphs.font),
        ),
        Padding(
          padding: business
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: context.isMobileView
              ? OpenContainer<void>(
                  closedShape: AppShape.lg,
                  closedBuilder: (_, open) => card(open),
                  openBuilder: (_, _) => const FontFamilyView(),
                )
              : card(
                  () => showSheet<void>(
                    context: context,
                    builder: (_) => const FontFamilyView(),
                  ),
                ),
        ),
      ],
    );
  }
}

class _TextScaleFactorItem extends ConsumerStatefulWidget {
  const _TextScaleFactorItem({this.business = false});

  final bool business;

  static const _step = 0.05;

  @override
  ConsumerState<_TextScaleFactorItem> createState() =>
      _TextScaleFactorItemState();
}

class _TextScaleFactorItemState extends ConsumerState<_TextScaleFactorItem> {
  double? _draft;

  void _update(TextScale Function(TextScale textScale) update) {
    setState(() => _draft = null);
    ref
        .read(themeSettingProvider.notifier)
        .update((state) => state.copyWith(textScale: update(state.textScale)));
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final textScale = ref.watch(
      themeSettingProvider.select((state) => state.textScale),
    );
    final systemScale = systemTextScaleOf(
      context,
    ).clamp(minTextScale, maxTextScale).toDouble();
    final scale = _draft ?? (textScale.enable ? textScale.scale : systemScale);
    final percent = '${(scale * 100).round()}%';
    final level = context.raisedSurfaceLevel;
    final divisions =
        ((maxTextScale - minTextScale) / _TextScaleFactorItem._step).round();
    if (widget.business) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  appLocalizations.textScale,
                  style: AppTextStyle.subheadline.of(context),
                ),
              ),
              Text(
                percent,
                style: AppTextStyle.subheadline
                    .of(context, emphasized: true)
                    .copyWith(color: colorScheme.onSurfaceVariant),
              ),
              if (textScale.enable && textScale.scale != 1)
                _ResetButton(
                  onPressed: () => _update((state) => state.copyWith(scale: 1)),
                ),
            ],
          ),
          MediaQuery.withNoTextScaling(
            child: Row(
              spacing: 10,
              children: [
                Text('A', style: AppTextStyle.footnote.of(context)),
                Expanded(
                  child: Slider(
                    min: minTextScale,
                    max: maxTextScale,
                    divisions: divisions,
                    value: scale,
                    label: percent,
                    onChanged: textScale.enable
                        ? (value) => setState(() => _draft = value)
                        : null,
                    onChangeEnd: (value) =>
                        _update((state) => state.copyWith(scale: value)),
                  ),
                ),
                Text('A', style: AppTextStyle.title2.of(context)),
              ],
            ),
          ),
          SegmentedControl<bool>(
            segments: [
              (false, appLocalizations.followSystem),
              (true, appLocalizations.custom),
            ],
            value: textScale.enable,
            onChanged: (value) =>
                _update((state) => state.copyWith(enable: value)),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoHeader(
          info: Info(
            label: appLocalizations.textScale,
            glyph: AppGlyphs.textSize,
          ),
          actions: [
            if (textScale.enable && textScale.scale != 1)
              _ResetButton(
                onPressed: () => _update((state) => state.copyWith(scale: 1)),
              ),
          ],
        ),
        Padding(
          padding: widget.business
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            spacing: 8,
            children: [
              SegmentedControl<bool>(
                segments: [
                  (false, appLocalizations.followSystem),
                  (true, appLocalizations.custom),
                ],
                value: textScale.enable,
                onChanged: (value) =>
                    _update((state) => state.copyWith(enable: value)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: ShapeDecoration(
                  color: level.colorOf(colorScheme),
                  shape: AppShape.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Expanded(
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topLeft,
                            child: MediaQuery(
                              data: MediaQuery.of(
                                context,
                              ).copyWith(textScaler: TextScaler.linear(scale)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  Text(
                                    'Aa',
                                    style: AppTextStyle.title3.of(context),
                                  ),
                                  Text(
                                    appLocalizations.textScalePreview,
                                    style: AppTextStyle.subheadline
                                        .of(context)
                                        .copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: ShapeDecoration(
                            color: level.next.colorOf(colorScheme),
                            shape: AppShape.full,
                          ),
                          child: Text(
                            percent,
                            style: AppTextStyle.subheadline
                                .of(context, emphasized: true)
                                .copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    MediaQuery.withNoTextScaling(
                      child: Row(
                        spacing: 12,
                        children: [
                          ExcludeSemantics(
                            child: Text(
                              'A',
                              style: AppTextStyle.footnote
                                  .of(context)
                                  .copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              min: minTextScale,
                              max: maxTextScale,
                              divisions: divisions,
                              value: scale,
                              label: percent,
                              onChanged: textScale.enable
                                  ? (value) => setState(() => _draft = value)
                                  : null,
                              onChangeEnd: (value) => _update(
                                (state) => state.copyWith(scale: value),
                              ),
                            ),
                          ),
                          ExcludeSemantics(
                            child: Text(
                              'A',
                              style: AppTextStyle.title2
                                  .of(context)
                                  .copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TonalButtonTheme(
      size: TonalButtonSize.section,
      child: MacOSPressFeedback(
        child: IconButton(
          tooltip: context.appLocalizations.reset,
          onPressed: onPressed,
          icon: const GlyphIcon(AppGlyphs.reset),
        ),
      ),
    );
  }
}

class _CustomColorSheet extends StatefulWidget {
  const _CustomColorSheet({
    required this.initialColor,
    required this.onConfirmed,
  });

  final Color initialColor;

  /// Runs once the sheet has closed, so retheming every page cannot stall it.
  final ValueChanged<int> onConfirmed;

  @override
  State<_CustomColorSheet> createState() => _CustomColorSheetState();
}

class _CustomColorSheetState extends State<_CustomColorSheet> {
  late final _controller = ValueNotifier<Color>(widget.initialColor);

  void _confirm() {
    final color = _controller.value.toARGB32();
    final onConfirmed = widget.onConfirmed;
    unawaited(
      ModalRoute.of(context)!.completed.whenComplete(() => onConfirmed(color)),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    // Clears Android's edge back-swipe zone; exclusion rects stop at 200 dp.
    final gestureInsets = MediaQuery.systemGestureInsetsOf(context);
    return Scaffold(
      title: appLocalizations.customColor,
      confirmationAction: IconButtonData(
        glyph: AppGlyphs.check,
        tooltip: appLocalizations.confirm,
        onPressed: _confirm,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          max(16, gestureInsets.left),
          context.contentTopPadding,
          max(16, gestureInsets.right),
          20 + context.bottomInset,
        ),
        children: [
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (_, color, _) => _CustomColorPreview(
              color: color,
              onChanged: (color) => _controller.value = color,
            ),
          ),
          const SizedBox(height: 16),
          Palette(controller: _controller),
        ],
      ),
    );
  }
}

class _CustomColorPreview extends ConsumerWidget {
  const _CustomColorPreview({required this.color, required this.onChanged});

  static const Size _screenSize = Size(96, 128);
  static const double _scale = 0.75;

  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floatingBar = ref.watch(_floatingBarProvider);
    final liquidGlass = ref.watch(_liquidGlassProvider);
    final level = context.raisedSurfaceLevel;
    Widget screen(Brightness brightness) => ExcludeSemantics(
      child: SizedBox.fromSize(
        size: _screenSize * _scale,
        child: ClipRSuperellipse(
          borderRadius: AppRadius.md,
          child: FittedBox(
            child: SizedBox.fromSize(
              size: _screenSize,
              child: MiniScreen(
                colorScheme: ref.watch(
                  genColorSchemeProvider(brightness, color: color),
                ),
                floatingBar: floatingBar,
                liquidGlass: liquidGlass,
              ),
            ),
          ),
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: level.colorOf(context.colorScheme),
        shape: AppShape.xl,
      ),
      child: SurfaceScope(
        level: level,
        child: Row(
          spacing: 12,
          children: [
            screen(Brightness.light),
            screen(Brightness.dark),
            Expanded(
              child: HexColorField(color: color, onChanged: onChanged),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundItem extends ConsumerWidget {
  const _BackgroundItem({this.business = false});

  final bool business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = context.appLocalizations;
    final background = ref.watch(
      themeSettingProvider.select((state) => state.background),
    );
    return PreviewChoiceGroup<String>(
      info: Info(label: strings.appBackground, glyph: AppGlyphs.sun),
      value: AppBackgroundScope.imagePresets.contains(background)
          ? background
          : 'solid',
      showInfoHeader: !business,
      choices: [
        for (final (value, label) in [
          ('solid', strings.backgroundSolid),
          ('orbit', strings.backgroundOrbit),
          ('planet', strings.backgroundPlanet),
          ('aurora', strings.backgroundAurora),
          ('nebula', strings.backgroundNebula),
          ('globe', strings.backgroundGlobe),
          ('mountains', strings.backgroundMountains),
        ])
          PreviewChoice(
            value: value,
            label: label,
            // Raw asset: a nested AppBackground is suppressed, and veiled.
            pictogram: SizedBox(
              width: 96,
              height: 64,
              child: ClipRSuperellipse(
                borderRadius: AppRadius.sm,
                child: switch (value) {
                  'solid' => ColoredBox(color: context.colorScheme.surface),
                  'orbit' || 'mountains' => SvgPicture.asset(
                    'assets/images/background_$value.svg',
                    fit: BoxFit.cover,
                  ),
                  _ => Image.asset(
                    'assets/images/background_$value.jpg',
                    fit: BoxFit.cover,
                    cacheHeight: (64 * MediaQuery.devicePixelRatioOf(context))
                        .round(),
                  ),
                },
              ),
            ),
          ),
      ],
      onChanged: (value) => ref
          .read(themeSettingProvider.notifier)
          .update((state) => state.copyWith(background: value)),
    );
  }
}
