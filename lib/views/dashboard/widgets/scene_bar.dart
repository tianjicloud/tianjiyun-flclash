import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';
import 'outbound_mode.dart';

String _sceneLabel(BuildContext context, SceneKind scene) => switch (scene) {
  SceneKind.daily => context.appLocalizations.sceneDaily,
  SceneKind.ai => context.appLocalizations.sceneAi,
  SceneKind.watch => context.appLocalizations.sceneWatch,
};

/// The second layer of the business home: the scene switch on the left and
/// the outbound mode on the right, one card, one row on desktop. Scenes are
/// a real switch: a tap persists the pick and re-applies the profile (see
/// SceneAction). A subscription without scene groups gets an honest
/// unavailable note instead of a dead control.
class SceneBar extends ConsumerWidget {
  const SceneBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final density = DashboardDensityScope.of(context);
    final policy = ref.watch(scenePolicyProvider);
    final applyState = ref.watch(sceneActionProvider);
    final applying = applyState.applying && applyState.matches(_profileId(ref));
    final failed = applyState.failed && applyState.matches(_profileId(ref));
    final segment = _SceneSegment(policy: policy, applying: applying);
    final children = <Widget>[
      Flexible(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            GlyphIcon(
              AppGlyphs.sliders,
              size: 18,
              color: context.colorScheme.onSurfaceVariant,
            ),
            Text(
              context.appLocalizations.scene,
              style: DashboardText.cardTitle(context),
            ),
            Flexible(child: segment),
          ],
        ),
      ),
      if (density.isDesktop)
        Flexible(
          child: Text(
            failed
                ? context.appLocalizations.residentialApplyFailed
                : context.appLocalizations.sceneNote,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: DashboardText.label(context),
          ),
        ),
      const OutboundModeInline(),
    ];
    return DashboardCard(
      semanticLabel: context.appLocalizations.scene,
      padding: EdgeInsets.symmetric(
        horizontal: dashboardCardPadding(density).left,
        vertical: 10,
      ),
      child: density.isDesktop
          ? Row(spacing: 16, children: children)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                children[0],
                if (failed)
                  Text(
                    context.appLocalizations.residentialApplyFailed,
                    style: DashboardText.label(
                      context,
                    ).copyWith(color: DashboardColors.of(context).warn),
                  ),
                children[2],
              ],
            ),
    );
  }

  int? _profileId(WidgetRef ref) => ref.read(currentProfileProvider)?.id;
}

class _SceneSegment extends ConsumerWidget {
  const _SceneSegment({required this.policy, required this.applying});

  final ScenePolicy policy;
  final bool applying;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disabled = !policy.available || applying || policy.suspended;
    return DashboardConnectedGroup(
      children: [
        for (final (index, scene) in SceneKind.values.indexed)
          DashboardConnectedButton(
            selected: policy.current == scene,
            first: index == 0,
            last: index == SceneKind.values.length - 1,
            outer: BusinessPalette.buttonRadius,
            inner: 10,
            background: DashboardColors.of(context).tone,
            semanticLabel: _sceneLabel(context, scene),
            onTap: disabled
                ? () {}
                : () => unawaited(
                    ref.read(sceneActionProvider.notifier).select(scene),
                  ),
            builder: (foreground) => SizedBox(
              height: 40 * DashboardDensityScope.scaleOf(context),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    _sceneLabel(context, scene),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.subheadline
                        .of(context, emphasized: true)
                        .copyWith(color: foreground),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Shown in place of the scene bar when the profile has no scene groups:
/// the honest state, in the same slot, without a control that cannot work.
class SceneUnavailableCard extends StatelessWidget {
  const SceneUnavailableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final density = DashboardDensityScope.of(context);
    return DashboardCard(
      semanticLabel: context.appLocalizations.sceneUnavailable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.sliders,
            title: context.appLocalizations.sceneUnavailable,
          ),
          Text(
            context.appLocalizations.sceneUnavailableDesc,
            style: DashboardText.label(context),
          ),
          SizedBox(height: density.isDesktop ? 2 : 0),
        ],
      ),
    );
  }
}

/// The note that replaces the scene bar under a residential exit: scenes
/// resume as soon as the exit is released back to the subscription.
class SceneNoteLine extends StatelessWidget {
  const SceneNoteLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.appLocalizations.sceneNote,
      style: DashboardText.label(context),
    );
  }
}
