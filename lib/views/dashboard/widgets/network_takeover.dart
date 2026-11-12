import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/shapes/shapes.dart';

import 'card.dart';

typedef _RowMetrics = ({
  EdgeInsets padding,
  double titleStart,
  double radius,
  double icon,
  bool subtitle,
});

const _RowMetrics _cardRowMetrics = (
  padding: EdgeInsets.fromLTRB(10, 10, 12, 10),
  titleStart: 14,
  radius: 20,
  icon: 38,
  subtitle: true,
);

/// A tile's icon and switch sit as far in from its ends as from its edges, so
/// a full pill keeps both concentric with its corners. Without the icon, the
/// title lines up with the content of the cards above and below.
_RowMetrics _tileMetricsOf(DashboardDensity density, BuildContext context) =>
    density.isCompact
    ? (
        padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
        titleStart: dashboardCardPadding(density, context: context).left,
        radius: dashboardCardRadius(density, context: context),
        icon: 36,
        subtitle: false,
      )
    : (
        padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
        titleStart: dashboardCardPadding(density, context: context).left,
        radius: dashboardCardRadius(density, context: context),
        icon: 40,
        subtitle: true,
      );

enum TakeoverSwitch { systemProxy, tun }

class _TakeoverRow extends ConsumerWidget {
  const _TakeoverRow({
    required this.kind,
    required this.metrics,
    required this.showIcon,
    this.color,
  });

  final TakeoverSwitch kind;
  final _RowMetrics metrics;
  final bool showIcon;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final systemProxy = kind == TakeoverSwitch.systemProxy;
    final title = _titleOf(context, kind);
    final value = systemProxy
        ? ref.watch(networkSettingProvider.select((state) => state.systemProxy))
        : ref.watch(
            patchClashConfigProvider.select((state) => state.tun.enable),
          );
    final on = systemProxy
        ? appLocalizations.portValue(
            ref.watch(
              patchClashConfigProvider.select((state) => state.mixedPort),
            ),
          )
        : appLocalizations.enabled;
    void change(bool value) => systemProxy
        ? ref
              .read(networkSettingProvider.notifier)
              .update((state) => state.copyWith(systemProxy: value))
        : ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.tun(enable: value));
    return DashboardSwitchRow(
      glyph: systemProxy ? AppGlyphs.shuffle : AppGlyphs.vpn,
      title: title,
      subtitle: metrics.subtitle
          ? value
                ? on
                : appLocalizations.disabled
          : null,
      value: value,
      iconSize: metrics.icon,
      padding: showIcon
          ? metrics.padding
          : metrics.padding.copyWith(left: metrics.titleStart),
      radius: metrics.radius,
      color: color,
      showIcon: showIcon,
      onTap: () => change(!value),
      onChanged: change,
    );
  }
}

String _titleOf(BuildContext context, TakeoverSwitch kind) => switch (kind) {
  TakeoverSwitch.systemProxy => context.appLocalizations.systemProxy,
  TakeoverSwitch.tun => context.appLocalizations.tun,
};

/// Both switches in one card, for the card list of a narrow window.
class NetworkTakeoverCard extends StatelessWidget {
  const NetworkTakeoverCard({super.key});

  @override
  Widget build(BuildContext context) {
    const metrics = _cardRowMetrics;
    final appLocalizations = context.appLocalizations;
    return DashboardCard(
      semanticLabel: appLocalizations.networkTakeover,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.shuffle,
            title: appLocalizations.networkTakeover,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final showIcon = DashboardSwitchRow.iconFits(
                context,
                width: constraints.maxWidth,
                iconSize: metrics.icon,
                padding: metrics.padding,
                titles: [
                  for (final kind in TakeoverSwitch.values)
                    _titleOf(context, kind),
                ],
              );
              return Column(
                spacing: 8,
                children: [
                  for (final kind in TakeoverSwitch.values)
                    _TakeoverRow(
                      kind: kind,
                      metrics: metrics,
                      showIcon: showIcon,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// One switch as a card of its own, in the desktop's control row.
class NetworkTakeoverTile extends StatelessWidget {
  const NetworkTakeoverTile(this.kind, {super.key});

  final TakeoverSwitch kind;

  @override
  Widget build(BuildContext context) {
    final metrics = _tileMetricsOf(DashboardDensityScope.of(context), context);
    return DashboardCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) => _TakeoverRow(
          kind: kind,
          metrics: metrics,
          color: Colors.transparent,
          showIcon: DashboardSwitchRow.iconFits(
            context,
            width: constraints.maxWidth,
            iconSize: metrics.icon,
            padding: metrics.padding,
            titles: [
              for (final kind in TakeoverSwitch.values) _titleOf(context, kind),
            ],
          ),
        ),
      ),
    );
  }
}

void _setVpn(WidgetRef ref, bool value) => ref
    .read(vpnSettingProvider.notifier)
    .update((state) => state.copyWith(enable: value));

/// The VPN switch in the grid's control row, in place of the takeover tiles.
class VpnTile extends ConsumerWidget {
  const VpnTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final metrics = _tileMetricsOf(DashboardDensityScope.of(context), context);
    final enabled = ref.watch(
      vpnSettingProvider.select((state) => state.enable),
    );
    return DashboardCard(
      padding: EdgeInsets.zero,
      child: DashboardSwitchRow(
        glyph: AppGlyphs.vpn,
        title: 'VPN',
        subtitle: metrics.subtitle
            ? enabled
                  ? appLocalizations.enabled
                  : appLocalizations.disabled
            : null,
        value: enabled,
        iconSize: metrics.icon,
        padding: metrics.padding,
        radius: metrics.radius,
        color: Colors.transparent,
        onTap: () => _setVpn(ref, !enabled),
        onChanged: (value) => _setVpn(ref, value),
      ),
    );
  }
}

/// A takeover switch in the design's bottom control bar: icon, title, state
/// and switch in one inline block, with the same real actions as the tile.
class NetworkTakeoverBlock extends ConsumerWidget {
  const NetworkTakeoverBlock(this.kind, {super.key, this.showIcon = true});

  final TakeoverSwitch kind;
  final bool showIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final systemProxy = kind == TakeoverSwitch.systemProxy;
    final value = systemProxy
        ? ref.watch(networkSettingProvider.select((state) => state.systemProxy))
        : ref.watch(
            patchClashConfigProvider.select((state) => state.tun.enable),
          );
    final subtitle = systemProxy
        ? appLocalizations.portValue(
            ref.watch(
              patchClashConfigProvider.select((state) => state.mixedPort),
            ),
          )
        : BusinessTheme.of(context) && !showIcon
        ? appLocalizations.businessTunCaption
        : value
        ? appLocalizations.enabled
        : appLocalizations.disabled;
    void change(bool next) => systemProxy
        ? ref
              .read(networkSettingProvider.notifier)
              .update((state) => state.copyWith(systemProxy: next))
        : ref
              .read(patchClashConfigProvider.notifier)
              .update((state) => state.copyWith.tun(enable: next));
    return _TakeoverBlockBody(
      glyph: systemProxy ? AppGlyphs.shuffle : AppGlyphs.vpn,
      title:
          BusinessTheme.of(context) && !showIcon && kind == TakeoverSwitch.tun
          ? appLocalizations.businessTunTitle
          : _titleOf(context, kind),
      subtitle: subtitle,
      value: value,
      onTap: () => change(!value),
      onChanged: change,
      showIcon: showIcon,
      compactSwitch: !showIcon,
    );
  }
}

class VpnBlock extends ConsumerWidget {
  const VpnBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final enabled = ref.watch(
      vpnSettingProvider.select((state) => state.enable),
    );
    return _TakeoverBlockBody(
      glyph: AppGlyphs.vpn,
      title: 'VPN',
      subtitle: enabled ? appLocalizations.enabled : appLocalizations.disabled,
      value: enabled,
      onTap: () => _setVpn(ref, !enabled),
      onChanged: (value) => _setVpn(ref, value),
    );
  }
}

class _TakeoverBlockBody extends StatelessWidget {
  const _TakeoverBlockBody({
    required this.glyph,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
    required this.onChanged,
    this.showIcon = true,
    this.compactSwitch = false,
  });

  final Glyph glyph;
  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback onTap;
  final ValueChanged<bool> onChanged;
  final bool showIcon;
  final bool compactSwitch;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final text = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: BusinessText.toggleTitle(
            context,
          ).copyWith(color: colorScheme.onSurface),
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: BusinessText.toggleSub(
            context,
          ).copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
    return PressRegion(
      shape: AppShape.md,
      overlay: PressRegion.hoverOverlay,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: showIcon ? 10 : 0,
          vertical: MacOSStyle.of(context) ? 4 : 8,
        ),
        child: Row(
          mainAxisSize: showIcon ? MainAxisSize.max : MainAxisSize.min,
          spacing: showIcon ? 11 : 14,
          children: [
            if (showIcon)
              Container(
                width: 32,
                height: 32,
                decoration: ShapeDecoration(
                  color: Color.alphaBlend(
                    (BusinessTheme.of(context)
                            ? BusinessPalette.blue
                            : colorScheme.primary)
                        .withValues(alpha: value ? 0.28 : 0.16),
                    BusinessPalette.deep,
                  ),
                  shape: AppShape.sm,
                ),
                child: Center(
                  child: GlyphIcon(
                    glyph,
                    size: 17,
                    color: value
                        ? BusinessPalette.activeGlyph
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (showIcon) Expanded(child: text) else text,
            DashboardSwitch(
              value: value,
              onChanged: onChanged,
              semanticLabel: title,
              compact: compactSwitch,
            ),
          ],
        ),
      ),
    );
  }
}

class VpnCard extends ConsumerWidget {
  const VpnCard({super.key});

  static const _iconSize = 48.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final colors = DashboardColors.of(context);
    final enabled = ref.watch(
      vpnSettingProvider.select((state) => state.enable),
    );
    void change(bool value) => _setVpn(ref, value);
    return DashboardCard(
      semanticLabel: 'VPN',
      padding:
          dashboardCardPadding(
            DashboardDensityScope.of(context),
            context: context,
          ).copyWith(
            top: MacOSStyle.of(context) ? 12 : 16,
            bottom: MacOSStyle.of(context) ? 12 : 16,
          ),
      onTap: () => change(!enabled),
      child: Row(
        spacing: 14,
        children: [
          ShapeBadge(
            shape: enabled
                ? MaterialShapes.cookie6Sided
                : MaterialShapes.circle,
            color: enabled
                ? BusinessTheme.of(context)
                      ? BusinessPalette.blue
                      : colorScheme.primary
                : colors.tone,
            size: _iconSize,
            child: GlyphIcon(
              AppGlyphs.vpn,
              size: 22,
              color: enabled
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VPN',
                  style: AppTextStyle.callout.of(context, emphasized: true),
                ),
                Text(
                  enabled
                      ? appLocalizations.enabled
                      : appLocalizations.disabled,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.footnote
                      .of(context)
                      .copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          DashboardSwitch(
            value: enabled,
            semanticLabel: 'VPN',
            onChanged: change,
          ),
        ],
      ),
    );
  }
}
