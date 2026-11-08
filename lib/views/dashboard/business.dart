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
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _businessMaxWidth = 1280.0;

class BusinessDashboardView extends ConsumerWidget {
  const BusinessDashboardView({super.key, required this.platform});

  final SupportPlatform platform;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final mobile = MediaQuery.sizeOf(context).width < 640;
    return BusinessAppearance(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: DashboardColors.of(context).page,
          title: mobile ? null : appLocalizations.dashboard,
          titleWidget: mobile ? const _MobileBrandTitle() : null,
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
    final gap = density.isCompact
        ? 12.0
        : cardSpacingOf(context, ViewMode.desktop);
    final subInfo = ref.watch(
      currentProfileProvider.select((profile) => profile?.subscriptionInfo),
    );
    final hasMobileMetrics =
        subInfo != null && subInfo.total > 0 && subInfo.expire > 0;
    final scale = DashboardDensityScope.scaleOf(context);
    final padding = EdgeInsetsDirectional.fromSTEB(
      16,
      context.contentTopPadding,
      24,
      24 + context.bottomInset,
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
                _EqualHeightRow(
                  spacing: gap,
                  flexes: const [4, 3, 3],
                  children: [
                    const BusinessLineCard(),
                    const TrafficSavingsCard(),
                    ProfilesCard(
                      title: context.appLocalizations.subscriptionInfo,
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cards = hasMobileMetrics
                        ? const [
                            RepaintBoundary(child: RemainingTrafficCard()),
                            RepaintBoundary(child: PlanValidityCard()),
                          ]
                        : [
                            const RepaintBoundary(child: TrafficSavingsCard()),
                            RepaintBoundary(
                              child: ProfilesCard(
                                title:
                                    context.appLocalizations.subscriptionInfo,
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
                    return _EqualHeightRow(
                      spacing: gap,
                      flexes: const [1, 1],
                      children: cards,
                    );
                  },
                ),
                const RepaintBoundary(child: BusinessLineCard()),
                if (hasMobileMetrics) ...[
                  const RepaintBoundary(child: TrafficSavingsCard()),
                  RepaintBoundary(
                    child: ProfilesCard(
                      title: context.appLocalizations.subscriptionInfo,
                    ),
                  ),
                ],
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

class _MobileBrandTitle extends StatelessWidget {
  const _MobileBrandTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 9,
      children: [
        ClipRSuperellipse(
          borderRadius: AppRadius.sm,
          child: Image.asset(
            'assets/images/icon.png',
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
        ),
        Text('天机云', style: AppTextStyle.headline.of(context, emphasized: true)),
      ],
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
        children: [
          DashboardCard(
            semanticLabel: context.appLocalizations.outboundMode,
            padding: EdgeInsets.symmetric(
              horizontal: dashboardCardPadding(density).left,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Text(
                  context.appLocalizations.outboundMode,
                  style: DashboardText.cardTitle(context),
                ),
                const OutboundModeInline(),
              ],
            ),
          ),
          ...tiles,
        ],
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
          final label = Text(
            context.appLocalizations.outboundMode,
            style: DashboardText.cardTitle(context),
          );
          final tileWidgets = [
            for (final tile in tiles)
              SizedBox(width: tileWidth, height: 56, child: tile),
          ];
          return Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              label,
              const IntrinsicWidth(child: OutboundModeInline()),
              ...tileWidgets,
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

class _EqualHeightRow extends MultiChildRenderObjectWidget {
  const _EqualHeightRow({
    required this.spacing,
    required this.flexes,
    required super.children,
  });

  final double spacing;
  final List<int> flexes;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderEqualHeightRow(spacing: spacing, flexes: flexes);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderEqualHeightRow renderObject,
  ) {
    renderObject
      ..spacing = spacing
      ..flexes = flexes;
  }
}

class _EqualHeightRowParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderEqualHeightRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _EqualHeightRowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _EqualHeightRowParentData> {
  _RenderEqualHeightRow({required double spacing, required List<int> flexes})
    : _spacing = spacing,
      _flexes = flexes;

  double _spacing;
  List<int> _flexes;

  double get spacing => _spacing;

  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  List<int> get flexes => _flexes;

  set flexes(List<int> value) {
    if (_flexes == value) return;
    _flexes = value;
    markNeedsLayout();
  }

  List<double> _widthsFor(double maxWidth, int count) {
    final available = math.max(0.0, maxWidth - _spacing * (count - 1));
    var totalFlex = 0;
    for (var i = 0; i < count; i++) {
      totalFlex += i < _flexes.length ? _flexes[i] : 1;
    }
    return [
      for (var i = 0; i < count; i++)
        totalFlex == 0
            ? available / count
            : available * (i < _flexes.length ? _flexes[i] : 1) / totalFlex,
    ];
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _EqualHeightRowParentData) {
      child.parentData = _EqualHeightRowParentData();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final count = childCount;
    if (count == 0 || !constraints.hasBoundedWidth) {
      return constraints.smallest;
    }
    final widths = _widthsFor(constraints.maxWidth, count);
    var maxHeight = 0.0;
    var child = firstChild;
    var index = 0;
    while (child != null) {
      final childSize = child.getDryLayout(
        BoxConstraints(minWidth: widths[index], maxWidth: widths[index]),
      );
      maxHeight = math.max(maxHeight, childSize.height);
      child = childAfter(child);
      index++;
    }
    final height = maxHeight
        .clamp(constraints.minHeight, constraints.maxHeight)
        .toDouble();
    return Size(constraints.maxWidth, height);
  }

  @override
  void performLayout() {
    final count = childCount;
    if (count == 0) {
      size = constraints.smallest;
      return;
    }
    final widths = _widthsFor(constraints.maxWidth, count);
    var maxHeight = 0.0;
    var child = firstChild;
    var index = 0;
    while (child != null) {
      child.layout(
        BoxConstraints(minWidth: widths[index], maxWidth: widths[index]),
        parentUsesSize: true,
      );
      maxHeight = math.max(maxHeight, child.size.height);
      child = childAfter(child);
      index++;
    }
    final height = maxHeight
        .clamp(constraints.minHeight, constraints.maxHeight)
        .toDouble();
    child = firstChild;
    index = 0;
    var x = 0.0;
    while (child != null) {
      child.layout(
        BoxConstraints.tightFor(width: widths[index], height: height),
        parentUsesSize: true,
      );
      (child.parentData! as _EqualHeightRowParentData).offset = Offset(x, 0);
      x += widths[index] + _spacing;
      child = childAfter(child);
      index++;
    }
    size = Size(constraints.maxWidth, height);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
