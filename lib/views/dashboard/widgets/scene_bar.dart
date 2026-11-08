import 'dart:async';
import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';
import 'outbound_mode.dart';
import 'segmented.dart';

String _sceneLabel(BuildContext context, SceneKind scene) => switch (scene) {
  SceneKind.daily => context.appLocalizations.sceneDaily,
  SceneKind.ai => context.appLocalizations.sceneAi,
  SceneKind.watch => context.appLocalizations.sceneWatch,
};

class SceneBar extends ConsumerWidget {
  const SceneBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final density = DashboardDensityScope.of(context);
    final mobile = !density.isDesktop;
    final policy = ref.watch(scenePolicyProvider);
    final applyState = ref.watch(sceneActionProvider);
    final applying = applyState.applying && applyState.matches(_profileId(ref));
    final failed = applyState.failed && applyState.matches(_profileId(ref));
    final segment = _SceneSegment(policy: policy, applying: applying);
    final label = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        GlyphIcon(
          AppGlyphs.sliders,
          size: 16,
          color: context.colorScheme.onSurfaceVariant,
        ),
        Text(
          context.appLocalizations.scene,
          style: BusinessText.controlLabel(
            context,
          ).copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      ],
    );
    return DashboardCard(
      semanticLabel: context.appLocalizations.scene,
      radius: mobile ? BusinessRadius.sceneMobile : BusinessRadius.sceneDesktop,
      padding: EdgeInsetsDirectional.fromSTEB(
        mobile ? 14 : 18,
        mobile
            ? 11
            : density.isCompact
            ? 8
            : 13,
        mobile ? 14 : 18,
        mobile
            ? 11
            : density.isCompact
            ? 8
            : 13,
      ),
      child: mobile
          ? LayoutBuilder(
              builder: (context, constraints) {
                final scale = DashboardDensityScope.scaleOf(context);
                final width = math.min(180 * scale, constraints.maxWidth - 88);
                return Row(
                  spacing: 10,
                  children: [
                    label,
                    const Spacer(),
                    SizedBox(width: width, child: segment),
                  ],
                );
              },
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final note = failed
                    ? context.appLocalizations.residentialApplyFailed
                    : context.appLocalizations.sceneNote;
                final noteText = Text(
                  note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: BusinessText.sceneNote(
                    context,
                  ).copyWith(color: const Color(0xFF7E89B8)),
                );
                if (constraints.maxWidth /
                        DashboardDensityScope.scaleOf(context) <
                    950) {
                  return Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      label,
                      IntrinsicWidth(child: segment),
                      const IntrinsicWidth(child: OutboundModeInline()),
                      SizedBox(width: constraints.maxWidth, child: noteText),
                    ],
                  );
                }
                return Row(
                  spacing: 14,
                  children: [
                    label,
                    IntrinsicWidth(child: segment),
                    Expanded(child: noteText),
                    const IntrinsicWidth(child: OutboundModeInline()),
                  ],
                );
              },
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
    final mobile = !DashboardDensityScope.of(context).isDesktop;
    return BusinessSegmented<SceneKind>(
      items: [
        for (final scene in SceneKind.values)
          BusinessSegment(value: scene, label: _sceneLabel(context, scene)),
      ],
      selected: policy.current ?? SceneKind.values.first,
      onSelected: disabled
          ? (_) {}
          : (scene) =>
                unawaited(ref.read(sceneActionProvider.notifier).select(scene)),
      height: mobile ? 34 : 38,
      mobile: mobile,
      expand: mobile,
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
    final mobile = !density.isDesktop;
    final strings = context.appLocalizations;
    return DashboardCard(
      semanticLabel: strings.sceneUnavailable,
      radius: mobile ? BusinessRadius.sceneMobile : BusinessRadius.sceneDesktop,
      padding: EdgeInsets.symmetric(
        horizontal: dashboardCardPadding(density).left,
        vertical: 10,
      ),
      child: Row(
        spacing: 10,
        children: [
          GlyphIcon(
            AppGlyphs.sliders,
            size: 18,
            color: context.colorScheme.onSurfaceVariant,
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: strings.sceneUnavailable,
                    style: DashboardText.rowTitle(context),
                  ),
                  TextSpan(
                    text: ' · ${strings.sceneUnavailableDesc}',
                    style: DashboardText.label(context),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
