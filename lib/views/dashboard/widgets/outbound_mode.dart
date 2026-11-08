import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';

import 'card.dart';

Glyph _glyphOf(Mode mode) => switch (mode) {
  Mode.rule => AppGlyphs.rules,
  Mode.global => AppGlyphs.proxies,
  Mode.direct => AppGlyphs.target,
};

void _changeMode(WidgetRef ref, Mode mode) {
  if (ref.read(patchClashConfigProvider).mode == mode) return;
  ref.read(setupActionProvider.notifier).changeMode(mode);
}

class OutboundModeCard extends ConsumerWidget {
  const OutboundModeCard({super.key});

  static const _outer = 26.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );
    final tone = DashboardColors.of(context).tone;
    final style = AppTextStyle.footnote.of(context, emphasized: true);
    return DashboardCard(
      semanticLabel: context.appLocalizations.outboundMode,
      child: Column(
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.split,
            title: context.appLocalizations.outboundMode,
          ),
          const SizedBox(height: 12),
          DashboardConnectedGroup(
            children: [
              for (final (index, item) in Mode.values.indexed)
                Expanded(
                  child: DashboardConnectedButton(
                    selected: item == mode,
                    first: index == 0,
                    last: index == Mode.values.length - 1,
                    outer: BusinessTheme.of(context)
                        ? BusinessPalette.buttonRadius
                        : _outer,
                    inner: 12,
                    background: tone,
                    semanticLabel: item.label,
                    onTap: () => _changeMode(ref, item),
                    builder: (foreground) => SizedBox(
                      height: BusinessTheme.of(context)
                          ? 52 * DashboardDensityScope.scaleOf(context)
                          : 52,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 2,
                        children: [
                          GlyphIcon(
                            _glyphOf(item),
                            size: 18,
                            color: foreground,
                          ),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: style.copyWith(color: foreground),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The mode switch without its card, for rows that already live inside one
/// (the scene bar, the bottom control bar).
class OutboundModeInline extends ConsumerWidget {
  const OutboundModeInline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );
    final style = AppTextStyle.subheadline.of(context, emphasized: true);
    final stretch = !DashboardDensityScope.of(context).isDesktop;
    return DashboardConnectedGroup(
      children: [
        for (final (index, item) in Mode.values.indexed)
          if (stretch)
            Expanded(
              child: DashboardConnectedButton(
                selected: item == mode,
                first: index == 0,
                last: index == Mode.values.length - 1,
                outer: BusinessPalette.buttonRadius,
                inner: 10,
                background: DashboardColors.of(context).tone,
                semanticLabel: item.label,
                onTap: () => _changeMode(ref, item),
                builder: (foreground) => _ModeButtonBody(
                  item: item,
                  foreground: foreground,
                  style: style,
                ),
              ),
            )
          else
            DashboardConnectedButton(
              selected: item == mode,
              first: index == 0,
              last: index == Mode.values.length - 1,
              outer: BusinessPalette.buttonRadius,
              inner: 10,
              background: DashboardColors.of(context).tone,
              semanticLabel: item.label,
              onTap: () => _changeMode(ref, item),
              builder: (foreground) => _ModeButtonBody(
                item: item,
                foreground: foreground,
                style: style,
              ),
            ),
      ],
    );
  }
}

class _ModeButtonBody extends StatelessWidget {
  const _ModeButtonBody({
    required this.item,
    required this.foreground,
    required this.style,
  });

  final Mode item;
  final Color foreground;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40 * DashboardDensityScope.scaleOf(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              GlyphIcon(_glyphOf(item), size: 16, color: foreground),
              Flexible(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The desktop control row's mode switch; its buttons sit as far in from the
/// card's ends as from its edges so their corners stay concentric.
class OutboundModeBar extends ConsumerWidget {
  const OutboundModeBar({super.key});

  static const _inset = 8.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final density = DashboardDensityScope.of(context);
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );
    final appLocalizations = context.appLocalizations;
    final outer = dashboardCardRadius(density) - _inset;
    final style = AppTextStyle.subheadline.of(context, emphasized: true);
    return DashboardCard(
      semanticLabel: appLocalizations.outboundMode,
      padding: EdgeInsetsDirectional.fromSTEB(
        dashboardCardPadding(density).left,
        _inset,
        _inset,
        _inset,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          spacing: 16,
          children: [
            GlyphIcon(
              AppGlyphs.split,
              size: 18,
              color: context.colorScheme.onSurfaceVariant,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth / 4),
              child: Text(
                appLocalizations.outboundMode,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DashboardText.cardTitle(context),
              ),
            ),
            Expanded(
              child: DashboardConnectedGroup(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, item) in Mode.values.indexed)
                    Expanded(
                      child: DashboardConnectedButton(
                        selected: item == mode,
                        first: index == 0,
                        last: index == Mode.values.length - 1,
                        outer: outer,
                        inner: 10,
                        background: DashboardColors.of(context).tone,
                        semanticLabel: item.label,
                        onTap: () => _changeMode(ref, item),
                        builder: (foreground) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 6,
                          children: [
                            GlyphIcon(
                              _glyphOf(item),
                              size: 18,
                              color: foreground,
                            ),
                            Flexible(
                              child: Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: style.copyWith(color: foreground),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
