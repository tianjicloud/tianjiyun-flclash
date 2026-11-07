import 'dart:async';
import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/features.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart';
import 'package:fl_clash/views/dashboard/widgets/core_status_button.dart';
import 'package:fl_clash/views/dashboard/widgets/current_outbound.dart';
import 'package:fl_clash/views/dashboard/widgets/network_takeover.dart';
import 'package:fl_clash/views/dashboard/widgets/profile_detail.dart';
import 'package:fl_clash/views/dashboard/widgets/profiles.dart';
import 'package:fl_clash/views/dashboard/widgets/proxy_groups.dart';
import 'package:fl_clash/views/dashboard/widgets/traffic_savings.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _businessMaxWidth = 1120.0;

class BusinessDashboardView extends ConsumerWidget {
  const BusinessDashboardView({super.key, required this.platform});

  final SupportPlatform platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    return Scaffold(
      backgroundColor: DashboardColors.of(context).page,
      title: appLocalizations.dashboard,
      actions: [if (coreLib == null) const CoreStatusButton()],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = math.max(
            1.0,
            MediaQuery.textScalerOf(context).scale(1),
          );
          final room = constraints.biggest / scale;
          final density = DashboardDensity.of(room);
          return DashboardDensityScope(
            density: density,
            scale: scale,
            child: _BusinessBody(density: density, platform: platform),
          );
        },
      ),
    );
  }
}

class _BusinessBody extends ConsumerWidget {
  const _BusinessBody({required this.density, required this.platform});

  final DashboardDensity density;
  final SupportPlatform platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needsTakeover =
        DashboardWidget.networkTakeover.platforms.contains(platform) &&
        ref.watch(isStartProvider) &&
        !ref.watch(suspendProvider) &&
        !ref.watch(
          networkSettingProvider.select((state) => state.systemProxy),
        ) &&
        !(ref.watch(
              patchClashConfigProvider.select((state) => state.tun.enable),
            ) &&
            ref.watch(authorizedTunEnableProvider) ==
                TunAuthorizationState.authorized);
    final gap = cardSpacingOf(context, ViewMode.desktop);
    final scale = DashboardDensityScope.scaleOf(context);
    final padding = EdgeInsetsDirectional.fromSTEB(
      16,
      context.contentTopPadding,
      24,
      24 + MediaQuery.paddingOf(context).bottom,
    );
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _businessMaxWidth * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: gap,
            children: [
              SizedBox(
                height: density.isDesktop
                    ? (density.isCompact ? 176 : 208) * scale
                    : null,
                child: const RepaintBoundary(child: CurrentOutboundCard()),
              ),
              if (needsTakeover)
                Text(
                  context.appLocalizations.residentialCaptureOff,
                  style: DashboardText.label(
                    context,
                  ).copyWith(color: DashboardColors.of(context).warn),
                ),
              const RepaintBoundary(child: BusinessLineCard()),
              if (density.isDesktop)
                SizedBox(
                  height: (density.isCompact ? 152 : 176) * scale,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: gap,
                    children: [
                      const Expanded(child: TrafficSavingsCard()),
                      Expanded(
                        child: ProfilesCard(
                          title: context.appLocalizations.subscriptionInfo,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                const RepaintBoundary(child: TrafficSavingsCard()),
                RepaintBoundary(
                  child: ProfilesCard(
                    title: context.appLocalizations.subscriptionInfo,
                  ),
                ),
              ],
              _TakeoverRow(platform: platform, density: density),
            ],
          ),
        ),
      ),
    );
  }
}

class _TakeoverRow extends StatelessWidget {
  const _TakeoverRow({required this.platform, required this.density});

  final SupportPlatform platform;
  final DashboardDensity density;

  @override
  Widget build(BuildContext context) {
    final tiles = DashboardWidget.networkTakeover.platforms.contains(platform)
        ? const [
            NetworkTakeoverTile(TakeoverSwitch.systemProxy),
            NetworkTakeoverTile(TakeoverSwitch.tun),
          ]
        : const [VpnTile()];
    if (!density.isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: tiles,
      );
    }
    return SizedBox(
      height: (density.isCompact ? 56 : 64),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [for (final tile in tiles) Expanded(child: tile)],
      ),
    );
  }
}

class BusinessLineCard extends ConsumerWidget {
  const BusinessLineCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policy = ref.watch(residentialPolicyProvider);
    if (policy.active || (policy.catalogReady && policy.hasPlan)) {
      return const ResidentialExitCard();
    }
    final strings = context.appLocalizations;
    final groups = policy.catalogReady
        ? ref.watch(groupsProvider)
        : const <Group>[];
    final root = groups.where((group) => group.name == appName).firstOrNull;
    final selected = root == null
        ? null
        : ref.watch(selectedProxyNameProvider(root.name));
    return DashboardCard(
      semanticLabel: strings.businessLineTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.shuffle,
            title: strings.businessLineTitle,
          ),
          if (!policy.catalogReady)
            Text(
              strings.businessLinesLoading,
              style: DashboardText.label(context),
            )
          else if (groups.isEmpty) ...[
            Text(
              strings.businessLinesEmpty,
              style: DashboardText.rowTitle(context),
            ),
            FilledButton(
              onPressed: () => showProfilesSheet(context),
              child: Text(strings.residentialManageSubscription),
            ),
          ] else ...[
            EmojiText(
              selected?.isNotEmpty == true
                  ? selected!
                  : strings.businessSmartRouting,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DashboardText.figure(context, AppTextStyle.title2),
            ),
            Text(
              strings.businessRoutingDesc,
              style: DashboardText.label(context),
            ),
            FilledButton(
              onPressed: () => showProxiesSheet(context, groupName: root?.name),
              child: Text(strings.businessChooseLine),
            ),
          ],
        ],
      ),
    );
  }
}

class ResidentialExitCard extends ConsumerWidget {
  const ResidentialExitCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final policy = ref.watch(residentialPolicyProvider);
    final action = ref.watch(residentialActionProvider);
    final matches = action.matches(policy.profileId, policy.fingerprint);
    final applying = matches && action.applying;
    final failed = matches && action.failed;
    final resetFailed = matches && action.resetFailed;
    final catalogReady = policy.catalogReady;
    final missing = catalogReady && policy.missingExit;
    final noPlan = catalogReady && !policy.hasPlan && !policy.active;
    final warn = DashboardColors.of(context).warn;
    final label = DashboardText.label(context);
    final explanation = Text(
      appLocalizations.residentialExplanation,
      style: label,
    );
    final routeNote = Text(appLocalizations.residentialRouteNote, style: label);
    return DashboardCard(
      semanticLabel: appLocalizations.residentialTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.vpn,
            title: appLocalizations.residentialTitle,
            leading: [
              if (applying)
                DashboardChip(
                  label: appLocalizations.residentialApplying,
                  tone: DashboardChipTone.warn,
                )
              else if (missing || failed)
                DashboardChip(
                  label: appLocalizations.residentialUnavailable,
                  tone: DashboardChipTone.warn,
                )
              else if (policy.active)
                DashboardChip(
                  label: appLocalizations.residentialSelected,
                  tone: DashboardChipTone.ok,
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (!catalogReady) ...[
            Text(
              appLocalizations.residentialLoadingCatalog,
              style: DashboardText.rowTitle(context),
            ),
            const SizedBox(height: 6),
            Text(appLocalizations.residentialLoadingCatalogDesc, style: label),
          ] else if (noPlan) ...[
            Text(
              appLocalizations.residentialNoPlan,
              style: DashboardText.rowTitle(context),
            ),
            const SizedBox(height: 6),
            Text(appLocalizations.residentialNoPlanDesc, style: label),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () => showProfilesSheet(context),
              child: Text(appLocalizations.residentialManageSubscription),
            ),
          ] else if (missing) ...[
            Text(
              policy.configuredExit ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DashboardText.figure(
                context,
                AppTextStyle.title2,
                color: warn,
              ),
            ),
            const SizedBox(height: 6),
            Text(appLocalizations.residentialMissing, style: label),
            const SizedBox(height: 6),
            Text(appLocalizations.residentialMissingDesc, style: label),
            const SizedBox(height: 14),
            _ExitActions(
              applying: applying,
              onChoose: () => showResidentialExitSheet(context),
              onClear: () => unawaited(
                ref.read(residentialActionProvider.notifier).clear(),
              ),
            ),
          ] else if (policy.active) ...[
            EmojiText(
              policy.selectedExit ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DashboardText.figure(context, AppTextStyle.title2),
            ),
            const SizedBox(height: 6),
            Text(appLocalizations.residentialActiveDesc, style: label),
            if (failed) ...[
              const SizedBox(height: 6),
              Text(
                appLocalizations.residentialApplyFailed,
                style: label.copyWith(color: warn),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: applying
                    ? null
                    : () => unawaited(
                        ref.read(residentialActionProvider.notifier).retry(),
                      ),
                child: Text(appLocalizations.retry),
              ),
            ] else if (resetFailed) ...[
              const SizedBox(height: 6),
              Text(
                appLocalizations.residentialResetFailed,
                style: label.copyWith(color: warn),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: applying
                    ? null
                    : () => unawaited(
                        ref.read(residentialActionProvider.notifier).retry(),
                      ),
                child: Text(appLocalizations.retry),
              ),
            ] else if (applying) ...[
              const SizedBox(height: 6),
              Text(appLocalizations.residentialPending, style: label),
            ] else
              const SizedBox(height: 10),
            _ExitActions(
              applying: applying,
              onChoose: () => showResidentialExitSheet(context),
              onClear: () => unawaited(
                ref.read(residentialActionProvider.notifier).clear(),
              ),
            ),
          ] else ...[
            Text(
              appLocalizations.residentialSubscriptionPolicy,
              style: DashboardText.rowTitle(context),
            ),
            const SizedBox(height: 6),
            Text(appLocalizations.residentialUsingSubscription, style: label),
            if (applying) ...[
              const SizedBox(height: 6),
              Text(appLocalizations.residentialPending, style: label),
            ] else if (failed) ...[
              const SizedBox(height: 6),
              Text(
                appLocalizations.residentialApplyFailed,
                style: label.copyWith(color: warn),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () => unawaited(
                  ref.read(residentialActionProvider.notifier).retry(),
                ),
                child: Text(appLocalizations.retry),
              ),
            ],
            const SizedBox(height: 14),
            FilledButton(
              onPressed: applying
                  ? null
                  : () => showResidentialExitSheet(context),
              child: Text(appLocalizations.residentialChoose),
            ),
          ],
          const SizedBox(height: 14),
          explanation,
          const SizedBox(height: 6),
          routeNote,
        ],
      ),
    );
  }
}

class _ExitActions extends StatelessWidget {
  const _ExitActions({
    required this.applying,
    required this.onChoose,
    required this.onClear,
  });

  final bool applying;
  final VoidCallback onChoose;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return Row(
      spacing: 12,
      children: [
        FilledButton(
          onPressed: applying ? null : onChoose,
          child: Text(appLocalizations.residentialChange),
        ),
        Flexible(
          child: TextButton(
            onPressed: applying ? null : onClear,
            child: Text(appLocalizations.residentialUseSubscription),
          ),
        ),
      ],
    );
  }
}

Future<void> showResidentialExitSheet(BuildContext context) {
  return showSheet<void>(
    context: context,
    builder: (_) => const _ResidentialExitSheet(),
  );
}

class _ResidentialExitSheet extends ConsumerWidget {
  const _ResidentialExitSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final policy = ref.watch(residentialPolicyProvider);
    return SelectionSheet<String>(
      title: appLocalizations.residentialTitle,
      sections: [SelectionSection(items: policy.choices)],
      labelBuilder: (item) => item,
      selectedOf: (_) => policy.selectedExit,
      emptyLabel: appLocalizations.residentialNoPlan,
      onSelected: (item) {
        Navigator.of(context).pop();
        unawaited(ref.read(residentialActionProvider.notifier).select(item));
      },
    );
  }
}
