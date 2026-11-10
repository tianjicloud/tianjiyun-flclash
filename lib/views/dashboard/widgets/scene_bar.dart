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
    final scale = DashboardDensityScope.scaleOf(context);
    final policy = ref.watch(scenePolicyProvider);
    final applyState = ref.watch(sceneActionProvider);
    final applying = applyState.applying && applyState.matches(_profileId(ref));
    final failed = applyState.failed && applyState.matches(_profileId(ref));
    final segment = _SceneSegment(policy: policy, applying: applying);
    final label = _sectionLabel(context.appLocalizations.scene, context);
    final outboundLabel = _sectionLabel(
      context.appLocalizations.businessOutboundLabel,
      context,
    );
    final note = failed
        ? context.appLocalizations.residentialApplyFailed
        : policy.suspended
        ? context.appLocalizations.sceneSuspended
        : context.appLocalizations.sceneNote;
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
      radius: mobile ? BusinessRadius.sceneMobile : BusinessPalette.cardRadius,
      padding: EdgeInsetsDirectional.fromSTEB(
        mobile ? 14 : 18,
        mobile ? 11 : 13,
        mobile ? 14 : 18,
        mobile ? 11 : 13,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final noteText = Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
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
                SizedBox(width: 156 * scale, child: segment),
                outboundLabel,
                SizedBox(width: 170 * scale, child: const OutboundModeInline()),
                SizedBox(
                  width: constraints.maxWidth,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 38 * scale),
                    child: noteText,
                  ),
                ),
              ],
            );
          }
          return Row(
            children: [
              label,
              const SizedBox(width: 14),
              SizedBox(width: 156 * scale, child: segment),
              const SizedBox(width: 14),
              Expanded(child: noteText),
              const SizedBox(width: 14),
              outboundLabel,
              const SizedBox(width: 14),
              SizedBox(width: 170 * scale, child: const OutboundModeInline()),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionLabel(String value, BuildContext context) => Text(
    value,
    style: BusinessText.controlLabel(
      context,
    ).copyWith(color: context.colorScheme.onSurfaceVariant),
  );

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
      height: mobile ? 34 : 30,
      mobile: mobile,
      expand: true,
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
