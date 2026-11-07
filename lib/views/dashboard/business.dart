import 'dart:async';
import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/default_line.dart';
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/features.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart';
import 'package:fl_clash/views/dashboard/widgets/core_status_button.dart';
import 'package:fl_clash/views/dashboard/widgets/current_outbound.dart';
import 'package:fl_clash/views/dashboard/widgets/network_takeover.dart';
import 'package:fl_clash/views/dashboard/widgets/outbound_mode.dart';
import 'package:fl_clash/views/dashboard/widgets/profile_detail.dart';
import 'package:fl_clash/views/dashboard/widgets/profiles.dart';
import 'package:fl_clash/views/dashboard/widgets/proxy_groups.dart';
import 'package:fl_clash/views/dashboard/widgets/quick_lines.dart';
import 'package:fl_clash/views/dashboard/widgets/scene_bar.dart';
import 'package:fl_clash/views/dashboard/widgets/traffic_savings.dart';
import 'package:fl_clash/views/dashboard/widgets/update_status.dart';
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
    return BusinessAppearance(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: DashboardColors.of(context).page,
          title: appLocalizations.dashboard,
          actions: [
            const UpdateStatusButton(),
            if (coreLib == null) const CoreStatusButton(),
          ],
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
        ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  UpdateStatusSlot(gap: gap),
                  const BusinessSubscriptionStatus(),
                ],
              ),
              const RepaintBoundary(child: CurrentOutboundCard()),
              if (ref.watch(scenePolicyProvider).available)
                const SceneBar()
              else
                const SceneUnavailableCard(),
              const QuickLines(),
              if (density.isDesktop) ...[
                if (needsTakeover)
                  Text(
                    context.appLocalizations.residentialCaptureOff,
                    style: DashboardText.label(
                      context,
                    ).copyWith(color: DashboardColors.of(context).warn),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: gap,
                  children: [
                    const Expanded(flex: 4, child: BusinessLineCard()),
                    const Expanded(flex: 3, child: TrafficSavingsCard()),
                    Expanded(
                      flex: 3,
                      child: ProfilesCard(
                        title: context.appLocalizations.subscriptionInfo,
                      ),
                    ),
                  ],
                ),
                _ControlBar(platform: platform),
              ] else ...[
                if (needsTakeover)
                  Text(
                    context.appLocalizations.residentialCaptureOff,
                    style: DashboardText.label(
                      context,
                    ).copyWith(color: DashboardColors.of(context).warn),
                  ),
                const RepaintBoundary(child: BusinessLineCard()),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cards = [
                      const RepaintBoundary(child: TrafficSavingsCard()),
                      RepaintBoundary(
                        child: ProfilesCard(
                          title: context.appLocalizations.subscriptionInfo,
                        ),
                      ),
                    ];
                    if (constraints.maxWidth / scale < 350) {
                      return Column(
                        spacing: gap,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: cards,
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: gap,
                      children: [
                        for (final card in cards) Expanded(child: card),
                      ],
                    );
                  },
                ),
              ],
              if (!density.isDesktop)
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

/// The desktop home's bottom strip: outbound mode on the left and the
/// takeover switches on the right, inside one card, so the page ends with
/// a single control surface instead of two rows of separate cards.
class _ControlBar extends StatelessWidget {
  const _ControlBar({required this.platform});

  final SupportPlatform platform;

  @override
  Widget build(BuildContext context) {
    final density = DashboardDensityScope.of(context);
    final tiles = DashboardWidget.networkTakeover.platforms.contains(platform)
        ? const [
            NetworkTakeoverTile(TakeoverSwitch.systemProxy),
            NetworkTakeoverTile(TakeoverSwitch.tun),
          ]
        : const [VpnTile()];
    return DashboardCard(
      semanticLabel: context.appLocalizations.outboundMode,
      padding: EdgeInsets.symmetric(
        horizontal: dashboardCardPadding(density).left,
        vertical: 10,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileWidth = constraints.maxWidth >= 900 ? 230.0 : 190.0;
          return Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                context.appLocalizations.outboundMode,
                style: DashboardText.cardTitle(context),
              ),
              const OutboundModeInline(),
              for (final tile in tiles)
                SizedBox(width: tileWidth, height: 56, child: tile),
            ],
          );
        },
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
    final catalog = DefaultLineCatalog(groups);
    final selections = ref.watch(selectedMapProvider);
    final selected = catalog.selected(selections);
    final node = catalog.currentNode(selections);
    final mode = ref.watch(
      patchClashConfigProvider.select((config) => config.mode),
    );
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
              selected?.name ?? strings.businessSmartRouting,
              style: DashboardText.figure(context, AppTextStyle.title2),
            ),
            if (mode == Mode.rule &&
                node != null &&
                node != selected?.name) ...[
              Text(
                strings.businessCurrentNode,
                style: DashboardText.label(context),
              ),
              EmojiText(node, style: DashboardText.rowTitle(context)),
            ],
            Text(
              strings.businessRoutingDesc,
              style: DashboardText.label(context),
            ),
            if (mode != Mode.rule) ...[
              Text(
                '${strings.outboundMode}: ${mode.label}',
                style: DashboardText.rowTitle(context),
              ),
              Text(
                strings.businessRuleModeRequired,
                style: DashboardText.label(context),
              ),
              FilledButton(
                onPressed: () => ref
                    .read(patchClashConfigProvider.notifier)
                    .update((state) => state.copyWith(mode: Mode.rule)),
                child: Text(strings.businessEnableRules),
              ),
            ] else
              FilledButton(
                onPressed: catalog.root == null
                    ? () => showProxiesSheet(context)
                    : () => _showDefaultLineSheet(context),
                child: Text(strings.businessChooseLine),
              ),
          ],
        ],
      ),
    );
  }
}

Future<void> _showDefaultLineSheet(BuildContext context) {
  final profile = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(currentProfileProvider);
  return showSheet<void>(
    context: context,
    builder: (_) => BusinessTheme.of(context)
        ? BusinessAppearance(
            child: _DefaultLineSheet(profileId: profile?.id, url: profile?.url),
          )
        : _DefaultLineSheet(profileId: profile?.id, url: profile?.url),
  );
}

class _DefaultLineSheet extends ConsumerStatefulWidget {
  const _DefaultLineSheet({required this.profileId, required this.url});

  final int? profileId;
  final String? url;

  @override
  ConsumerState<_DefaultLineSheet> createState() => _DefaultLineSheetState();
}

class _DefaultLineSheetState extends ConsumerState<_DefaultLineSheet> {
  bool _applying = false;
  bool _failed = false;

  bool _matches(Profile? profile) =>
      profile?.id == widget.profileId && profile?.url == widget.url;

  Future<void> _select(DefaultLineChoice choice) async {
    if (_applying || !_matches(ref.read(currentProfileProvider))) return;
    setState(() {
      _applying = true;
      _failed = false;
    });
    var applied = false;
    try {
      applied = await ref
          .read(proxiesActionProvider.notifier)
          .changeDefaultLine(choice);
      if (mounted && applied) Navigator.of(context).pop();
    } catch (error) {
      commonPrint.log(
        'default line selection failed: ${compactError(error)}',
        logLevel: coreFailureLogLevel(error),
      );
    } finally {
      if (mounted) {
        setState(() {
          _applying = false;
          _failed = !applied;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.appLocalizations;
    final profile = ref.watch(currentProfileProvider);
    final valid =
        _matches(profile) &&
        ref
            .watch(groupsSourceProfileProvider)
            .matches(profile?.id, profile?.url) &&
        ref.watch(patchClashConfigProvider.select((config) => config.mode)) ==
            Mode.rule;
    final catalog = DefaultLineCatalog(
      valid ? ref.watch(groupsProvider) : const [],
    );
    final selected = catalog.selected(ref.watch(selectedMapProvider));
    return SelectionSheet<DefaultLineChoice>(
      title: _applying
          ? strings.residentialApplying
          : _failed
          ? strings.businessLineFailed
          : strings.businessChooseLine,
      sections: [SelectionSection(items: catalog.choices)],
      labelBuilder: (choice) => choice.name,
      titleBuilder: (choice, _) => EmojiText(choice.name),
      selectedOf: (_) => selected,
      emptyLabel: valid
          ? strings.businessLinesEmpty
          : strings.businessSelectionStale,
      onSelected: (choice) => unawaited(_select(choice)),
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
      side: BusinessTheme.of(context)
          ? BorderSide(color: BusinessPalette.purple.withValues(alpha: 0.35))
          : BorderSide.none,
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
          if (policy.active && !missing) ...[
            const SizedBox(height: 6),
            Text(
              policy.bulkBypass
                  ? appLocalizations.residentialBulkBypass
                  : appLocalizations.residentialBulkUnconfirmed,
              style: label,
            ),
          ],
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
    builder: (_) => BusinessTheme.of(context)
        ? const BusinessAppearance(child: _ResidentialExitSheet())
        : const _ResidentialExitSheet(),
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
      sections: [
        SelectionSection(
          label: policy.active
              ? policy.bulkBypass
                    ? appLocalizations.residentialBulkBypass
                    : appLocalizations.residentialBulkUnconfirmed
              : null,
          items: policy.choices,
        ),
      ],
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
