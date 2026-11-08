import 'dart:async';
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
    final residential = ref.watch(residentialPolicyProvider);
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
    final note = failed
        ? context.appLocalizations.residentialApplyFailed
        : policy.suspended
        ? context.appLocalizations.sceneSuspended
        : residential.bulkBypass
        ? context.appLocalizations.sceneNote
        : context.appLocalizations.residentialBulkUnconfirmed;
    if (mobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          SizedBox(width: double.infinity, child: segment),
          if (failed || applying || policy.suspended)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: policy.suspended && !failed && !applying
                  ? Tooltip(
                      message: context.appLocalizations.residentialExitLocked,
                      child: Text(
                        context.appLocalizations.sceneSuspended,
                        style: BusinessText.sceneNote(
                          context,
                        ).copyWith(color: context.colorScheme.onSurfaceVariant),
                      ),
                    )
                  : Text(
                      note,
                      style: BusinessText.sceneNote(context).copyWith(
                        color: failed
                            ? context.colorScheme.error
                            : context.colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
        ],
      );
    }
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final noteText = Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: BusinessText.sceneNote(context).copyWith(
              color: failed
                  ? context.colorScheme.error
                  : context.colorScheme.onSurfaceVariant,
            ),
          );
          if (constraints.maxWidth / DashboardDensityScope.scaleOf(context) <
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
          ? null
          : (scene) =>
                unawaited(ref.read(sceneActionProvider.notifier).select(scene)),
      height: mobile ? 34 : 38,
      mobile: mobile,
      expand: mobile,
    );
  }
}

class SceneUnavailableCard extends ConsumerWidget {
  const SceneUnavailableCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    if (profile?.overrides.sceneNoticeDismissed == true ||
        ref.watch(scenePolicyProvider).available) {
      return const SizedBox.shrink();
    }
    final strings = context.appLocalizations;
    return SizedBox(
      height: 40,
      child: Row(
        spacing: 8,
        children: [
          GlyphIcon(
            AppGlyphs.sliders,
            size: 16,
            color: context.colorScheme.onSurfaceVariant,
          ),
          Expanded(
            child: Tooltip(
              message: strings.sceneUnavailableDesc,
              child: Text(
                strings.sceneUnavailable,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DashboardText.label(
                  context,
                ).copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          IconButton(
            tooltip: strings.close,
            icon: const GlyphIcon(AppGlyphs.close, size: 16),
            onPressed: profile == null
                ? null
                : () {
                    final current = ref.read(currentProfileProvider);
                    if (current == null || current.id != profile.id) return;
                    ref
                        .read(profilesProvider.notifier)
                        .put(
                          current.copyWith(
                            overrides: current.overrides.copyWith(
                              sceneNoticeDismissed: true,
                            ),
                          ),
                        );
                  },
          ),
        ],
      ),
    );
  }
}
