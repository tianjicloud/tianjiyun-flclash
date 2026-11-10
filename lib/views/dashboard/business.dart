import 'dart:async';
import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/default_line.dart';
import 'package:fl_clash/common/service_probe.dart' show routedOutbound;
import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/features.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/business_brand_mark.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/business_exit_warning_banner.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart';
import 'package:fl_clash/views/dashboard/widgets/current_outbound.dart';
import 'package:fl_clash/views/diagnostics.dart';
import 'package:fl_clash/views/dashboard/widgets/network_takeover.dart';
import 'package:fl_clash/views/dashboard/widgets/outbound_mode.dart';
import 'package:fl_clash/views/dashboard/widgets/profile_detail.dart';
import 'package:fl_clash/views/dashboard/widgets/profiles.dart';
import 'package:fl_clash/views/dashboard/widgets/proxy_groups.dart';
import 'package:fl_clash/views/dashboard/widgets/quick_lines.dart';
import 'package:fl_clash/views/dashboard/widgets/scene_bar.dart';
import 'package:fl_clash/views/dashboard/widgets/service_status.dart';
import 'package:fl_clash/views/dashboard/widgets/traffic_savings.dart';
import 'package:fl_clash/views/dashboard/widgets/update_status.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const _businessMaxWidth = 1284.0;

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
          opaqueAppBar: context.colorScheme.brightness == Brightness.light,
          title: mobile ? null : appLocalizations.dashboard,
          titleWidget: mobile
              ? const _MobileBrandTitle()
              : Padding(
                  padding: const EdgeInsetsDirectional.only(start: 13),
                  child: Text(
                    appLocalizations.dashboard,
                    style: BusinessText.pageTitle(context),
                  ),
                ),
          actions: [
            if (mobile) ...[
              const _MobileNotice(),
              const UpdateStatusButton(),
            ] else ...[
              const _DesktopBarStatus(),
              const UpdateStatusButton(),
            ],
          ],
          body: LayoutBuilder(
            builder: (context, constraints) {
              final scale = math.max(
                1.0,
                MediaQuery.textScalerOf(context).scale(1),
              );
              final room = constraints.biggest / scale;
              final density = _businessDensityOf(room);
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
    final started = ref.watch(isStartProvider);
    final coreConnected = ref.watch(coreStatusProvider) == CoreStatus.connected;
    final outboundEntry = ref.watch(
      outboundIpProbeProvider.select((state) => state.entryOf(routedOutbound)),
    );
    final tunEnabled = ref.watch(
      patchClashConfigProvider.select((state) => state.tun.enable),
    );
    final tunAuthorized =
        ref.watch(authorizedTunEnableProvider) ==
        TunAuthorizationState.authorized;
    final warningKind = businessExitWarningKind(
      active: started,
      coreConnected: coreConnected,
      probeFailed:
          outboundEntry.phase == ProbePhase.failed &&
          outboundEntry.value == null,
      tunEnabled: tunEnabled,
      tunAuthorized: tunAuthorized,
    );
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
    final subInfo = ref.watch(
      currentProfileProvider.select((profile) => profile?.subscriptionInfo),
    );
    final hasMobileMetrics =
        subInfo != null && subInfo.total > 0 && subInfo.expire > 0;
    final scale = DashboardDensityScope.scaleOf(context);
    final mobile = !density.isDesktop;
    final gap = mobile
        ? 13.0
        : density.isCompact
        ? 14.0
        : 14.0;
    final padding = EdgeInsetsDirectional.fromSTEB(
      mobile ? 18 : 29,
      mobile ? context.appBarInset - 23 : context.appBarInset - 18,
      mobile ? 18 : 29,
      (mobile ? 18 : 24) + context.bottomInset,
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
            children: [
              AnimatedSize(
                alignment: Alignment.topCenter,
                duration: context.motionDuration(commonDuration),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: warningKind == null ? 0 : gap,
                  children: [
                    if (warningKind != null)
                      BusinessExitWarningBanner(
                        kind: warningKind,
                        onRetry: () => ref
                            .read(outboundIpProbeProvider.notifier)
                            .refresh(const [routedOutbound]),
                        onAuthorize: () async {
                          try {
                            await ref
                                .read(setupActionProvider.notifier)
                                .applyProfile(force: true);
                          } catch (error) {
                            dialogs.showBanner(
                              error.toString(),
                              level: BannerLevel.error,
                            );
                          }
                        },
                        onDiagnostics: () => Navigator.of(context).push(
                          PagedSheetRoute(
                            builder: (_) => const DiagnosticsView(),
                          ),
                        ),
                      ),
                    UpdateStatusSlot(gap: gap),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: gap,
                children: [
                  if (density.isDesktop)
                    SizedBox(
                      height: 236 * scale,
                      child: const RepaintBoundary(
                        child: CurrentOutboundCard(),
                      ),
                    )
                  else
                    const RepaintBoundary(child: CurrentOutboundCard()),
                  if (ref.watch(scenePolicyProvider).available)
                    density.isDesktop
                        ? SizedBox(height: 60 * scale, child: const SceneBar())
                        : const SceneBar()
                  else ...[
                    if (ref
                            .watch(currentProfileProvider)
                            ?.overrides
                            .sceneNoticeDismissed !=
                        true)
                      const SceneUnavailableCard(),
                    if (density.isDesktop) const _OutboundModeFallback(),
                  ],
                  if (mobile && platform == SupportPlatform.Android)
                    const BusinessOutboundModeWarning(),
                  if (!density.isDesktop)
                    QuickLines(
                      onChooseResidential: () =>
                          showResidentialExitSheet(context),
                    ),
                  if (mobile) const _MobileExpiryNotice(),
                  if (density.isDesktop) ...[
                    if (needsTakeover)
                      Text(
                        context.appLocalizations.residentialCaptureOff,
                        style: DashboardText.label(
                          context,
                        ).copyWith(color: DashboardColors.of(context).warn),
                      ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final lineCard = _CardMinHeight(
                          minHeight: 214 * scale,
                          child: const BusinessLineCard(),
                        );
                        final trafficCard = _CardMinHeight(
                          minHeight: 214 * scale,
                          child: const TrafficSavingsCard(),
                        );
                        final profileCard = _CardMinHeight(
                          minHeight: 214 * scale,
                          child: ProfilesCard(
                            title: context.appLocalizations.subscriptionInfo,
                          ),
                        );
                        if (constraints.maxWidth / scale < 820) {
                          return Column(
                            spacing: gap,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _EqualHeightRow(
                                spacing: gap,
                                flexes: const [1, 1],
                                children: [lineCard, trafficCard],
                              ),
                              profileCard,
                            ],
                          );
                        }
                        return _EqualHeightRow(
                          spacing: gap,
                          flexes: const [1, 1, 1],
                          children: [lineCard, trafficCard, profileCard],
                        );
                      },
                    ),
                    SizedBox(
                      height: 72 * scale,
                      child: _ControlBar(platform: platform),
                    ),
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
                                RepaintBoundary(
                                  child: _CardMinHeight(
                                    minHeight: 110,
                                    child: MobileUsageCard(),
                                  ),
                                ),
                                RepaintBoundary(child: BusinessAIStatusCard()),
                              ]
                            : [
                                const RepaintBoundary(
                                  child: TrafficSavingsCard(),
                                ),
                                RepaintBoundary(
                                  child: ProfilesCard(
                                    title: context
                                        .appLocalizations
                                        .subscriptionInfo,
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
                  ],
                  if (!density.isDesktop)
                    _TakeoverRow(platform: platform, density: density),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutboundModeFallback extends StatelessWidget {
  const _OutboundModeFallback();

  @override
  Widget build(BuildContext context) => DashboardCard(
    semanticLabel: context.appLocalizations.outboundMode,
    padding: const EdgeInsetsDirectional.fromSTEB(18, 12, 18, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(
          context.appLocalizations.outboundMode,
          style: DashboardText.cardTitle(context),
        ),
        const OutboundModeInline(),
      ],
    ),
  );
}

DashboardDensity _businessDensityOf(Size size) {
  if (size.width < 640) return DashboardDensity.mobile;
  return size.width < 1040
      ? DashboardDensity.compact
      : DashboardDensity.standard;
}

class _MobileBrandTitle extends StatelessWidget {
  const _MobileBrandTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 9,
      children: [
        const BusinessBrandMark(size: 32),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              context.appLocalizations.brandName,
              maxLines: 1,
              style: AppTextStyle.custom(
                context,
                size: 18,
                leading: 22,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The bar's real state on desktop: the subscription's own update time and
/// the run state, as the design's top row shows them.
class _DesktopBarStatus extends ConsumerWidget {
  const _DesktopBarStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final updated = profile?.lastUpdateDate;
    final running = ref.watch(isStartProvider);
    final suspended = ref.watch(suspendProvider);
    final connecting = ref.watch(coreStatusProvider) == CoreStatus.connecting;
    final entry = ref.watch(
      outboundIpProbeProvider.select((state) => state.entryOf(routedOutbound)),
    );
    final route = ref.watch(routeTrackerProvider);
    final captured =
        ref.watch(
          networkSettingProvider.select((value) => value.systemProxy),
        ) ||
        ref.watch(patchClashConfigProvider.select((value) => value.tun.enable));
    final verified = isVerifiedOutbound(
      active: running && !suspended,
      captured: captured,
      phase: entry.phase,
      info: entry.value,
      stamp: entry.stamp,
      route: route,
      verdict: ref.watch(selectionCheckProvider),
    );
    final strings = context.appLocalizations;
    final tone = connecting || suspended
        ? DashboardColors.of(context).warn
        : verified
        ? DashboardColors.of(context).ok
        : context.colorScheme.onSurfaceVariant;
    final dashboardColors = DashboardColors.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        if (updated != null)
          Text(
            strings.businessSubscriptionUpdatedAt(
              updated.getLastUpdateTimeDesc(context),
            ),
            style: BusinessText.quickMetaMobile(
              context,
            ).copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: ShapeDecoration(
            color: verified
                ? dashboardColors.okContainer
                : dashboardColors.tone,
            shape: AppShape.full,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              if (verified)
                Container(
                  width: 6,
                  height: 6,
                  decoration: ShapeDecoration(
                    color: dashboardColors.ok,
                    shape: AppShape.circle,
                  ),
                ),
              Text(
                verified
                    ? strings.businessExitVerified
                    : connecting
                    ? strings.connecting
                    : suspended
                    ? strings.suspended
                    : running
                    ? strings.running
                    : strings.notRunning,
                style: BusinessText.metaLabel(context).copyWith(color: tone),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The phone bar's right side: the subscription update time, or the real
/// update state once one is downloading.
class _MobileNotice extends ConsumerWidget {
  const _MobileNotice();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final updated = ref.watch(currentProfileProvider)?.lastUpdateDate;
    final expiry = profile?.subscriptionInfo?.expireDate;
    final daysLeft = expiry == null
        ? null
        : math.max(0, expiry.difference(DateTime.now()).inDays);
    final download = ref.watch(updateDownloadStateProvider);
    final updateLabel = switch (download) {
      UpdateReady() => context.appLocalizations.updateReady,
      UpdateDownloading(:final received, :final total) =>
        total > 0 ? '${received * 100 ~/ total}%' : received.traffic.show,
      null => updated?.getLastUpdateTimeDesc(context),
    };
    final label = daysLeft == null
        ? updateLabel
        : '${context.appLocalizations.profileDaysLeft(daysLeft)} · ${context.appLocalizations.renew}';
    if (label == null) return const SizedBox.shrink();
    final soon = daysLeft != null && daysLeft <= 7;
    final dark = context.colorScheme.brightness == Brightness.dark;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 210),
      child: Tooltip(
        message: daysLeft == null
            ? label
            : context.appLocalizations.subscriptionInfo,
        child: PressRegion(
          shape: AppShape.full,
          overlay: PressRegion.hoverOverlay,
          onTap: daysLeft == null ? null : () => showProfilesSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: ShapeDecoration(
              color: soon
                  ? BusinessPalette.warningContainerFor(
                      context.colorScheme.brightness,
                    )
                  : dark
                  ? BusinessPalette.noticeDark
                  : BusinessPalette.sidebarSelection,
              shape: AppShape.full.copyWith(
                side: BorderSide(
                  color: soon
                      ? BusinessPalette.warningContainerFor(
                          context.colorScheme.brightness,
                        )
                      : context.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BusinessText.notice(context).copyWith(
                color: soon
                    ? BusinessPalette.warningForegroundFor(
                        context.colorScheme.brightness,
                      )
                    : dark
                    ? context.colorScheme.onSurface
                    : BusinessPalette.heroChipText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileExpiryNotice extends ConsumerWidget {
  const _MobileExpiryNotice();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expiry = ref
        .watch(currentProfileProvider)
        ?.subscriptionInfo
        ?.expireDate;
    if (expiry == null || expiry.difference(DateTime.now()).inDays > 7) {
      return const SizedBox.shrink();
    }
    final locale = Localizations.localeOf(context);
    final date = locale.languageCode == 'zh'
        ? context.appLocalizations.businessExpiryDateShort(
            expiry.month,
            expiry.day,
          )
        : DateFormat.MMMd(locale.toString()).format(expiry);
    final strings = context.appLocalizations;
    final brightness = context.colorScheme.brightness;
    return PressRegion(
      shape: AppShape.all(BusinessPalette.cardRadius),
      overlay: PressRegion.hoverOverlay,
      onTap: () => showProfilesSheet(context),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 11, 14, 11),
        decoration: ShapeDecoration(
          color: BusinessPalette.expiryContainerFor(brightness),
          shape: AppShape.all(BusinessPalette.cardRadius).copyWith(
            side: BorderSide(
              color: BusinessPalette.expiryBorderFor(brightness),
            ),
          ),
        ),
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: Text(
                strings.businessExpiryNotice(date),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: BusinessText.actionLabel(context).copyWith(
                  color: BusinessPalette.expiryForegroundFor(brightness),
                ),
              ),
            ),
            Text(
              strings.renew,
              style: BusinessText.actionLabel(context, emphasized: true)
                  .copyWith(
                    color: BusinessPalette.warningForegroundFor(brightness),
                  ),
            ),
          ],
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
        children: [...tiles],
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

class BusinessOutboundModeWarning extends ConsumerWidget {
  const BusinessOutboundModeWarning({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.mode),
    );
    if (mode == Mode.rule) return const SizedBox.shrink();
    final strings = context.appLocalizations;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 6, 8),
      decoration: ShapeDecoration(
        color: BusinessPalette.exitBannerBackgroundFor(
          context.colorScheme.brightness,
        ),
        shape: AppShape.all(BusinessRadius.heroDesktop).copyWith(
          side: BorderSide(
            color: BusinessPalette.exitBannerStrokeFor(
              context.colorScheme.brightness,
            ),
          ),
        ),
      ),
      child: Row(
        children: [
          const GlyphIcon(
            AppGlyphs.warning,
            size: 18,
            color: BusinessPalette.warning,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mode == Mode.global
                  ? strings.outboundModeGlobalWarning
                  : strings.outboundModeDirectWarning,
              style: BusinessText.cardTitle(context),
            ),
          ),
          TextButton(
            onPressed: () =>
                ref.read(setupActionProvider.notifier).changeMode(Mode.rule),
            child: Text(strings.outboundModeRestoreRule),
          ),
        ],
      ),
    );
  }
}

/// The desktop home's bottom strip: the takeover switches, AI service status
/// and diagnostics in one card, so the page ends with a single control
/// surface instead of a row of separate cards.
class _ControlBar extends StatelessWidget {
  const _ControlBar({required this.platform});

  final SupportPlatform platform;

  @override
  Widget build(BuildContext context) {
    final density = DashboardDensityScope.of(context);
    final hasTakeover = DashboardWidget.networkTakeover.platforms.contains(
      platform,
    );
    final blocks = hasTakeover
        ? const [
            NetworkTakeoverBlock(TakeoverSwitch.systemProxy, showIcon: false),
            NetworkTakeoverBlock(TakeoverSwitch.tun, showIcon: false),
          ]
        : const [VpnBlock()];
    final strings = context.appLocalizations;
    return DashboardCard(
      semanticLabel: strings.serviceStatus,
      radius: BusinessPalette.cardRadius,
      padding: EdgeInsets.symmetric(
        horizontal: density.isCompact ? 14 : 18,
        vertical: 0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final blockWidgets = [...blocks];
          final diagnostics = BusinessSecondaryButton(
            label: strings.diagnosticsTitle,
            width: 86,
            onPressed: () => Navigator.of(
              context,
            ).push(PagedSheetRoute(builder: (_) => const DiagnosticsView())),
          );
          final aiServices = Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 14,
            children: [
              Text(
                strings.businessAiServiceLabel,
                style: BusinessText.toggleTitle(context),
              ),
              const Flexible(child: BusinessAIStatusStrip()),
            ],
          );
          if (constraints.maxWidth / DashboardDensityScope.scaleOf(context) >=
              950) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (hasTakeover) ...[
                    blockWidgets[0],
                    const SizedBox(width: 22),
                    _controlDivider(context),
                    const SizedBox(width: 22),
                    blockWidgets[1],
                    const SizedBox(width: 22),
                    _controlDivider(context),
                    const SizedBox(width: 22),
                  ] else ...[
                    ...blockWidgets,
                    const SizedBox(width: 22),
                  ],
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: aiServices,
                    ),
                  ),
                  diagnostics,
                ],
              ),
            );
          }
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [...blockWidgets, aiServices, diagnostics],
          );
        },
      ),
    );
  }
}

Widget _controlDivider(BuildContext context) => SizedBox(
  width: 1,
  height: 28,
  child: ColoredBox(color: context.colorScheme.outlineVariant),
);

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
    return DashboardCard(
      semanticLabel: appLocalizations.residentialTitle,
      side: BorderSide.none,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: BusinessTheme.of(context)
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: [
            DashboardCardHeader(
              glyph: BusinessTheme.of(context) ? null : AppGlyphs.vpn,
              title: appLocalizations.residentialTitle,
              trailing: BusinessTheme.of(context) && policy.active
                  ? [
                      DashboardChip(
                        label: appLocalizations.businessLockedExit,
                        tone: DashboardChipTone.primary,
                      ),
                    ]
                  : const [],
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
              Text(
                appLocalizations.residentialLoadingCatalogDesc,
                style: label,
              ),
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
              if (BusinessTheme.of(context))
                Row(
                  spacing: 10,
                  children: [
                    if (ref.watch(
                          outboundIpProbeProvider.select(
                            (state) => state
                                .entryOf(routedOutbound)
                                .value
                                ?.countryCode,
                          ),
                        )
                        case final code? when code.isNotEmpty)
                      Container(
                        width: 34,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: BusinessPalette.deep,
                          shape: AppShape.all(BusinessRadius.code),
                        ),
                        child: Text(
                          code,
                          style: BusinessText.countryCode(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                    Expanded(
                      child: EmojiText(
                        policy.selectedExit ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: BusinessText.residentialExit(context),
                      ),
                    ),
                  ],
                )
              else
                EmojiText(
                  policy.selectedExit ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: BusinessText.residentialExit(
                    context,
                    mobile: !DashboardDensityScope.of(context).isDesktop,
                  ),
                ),
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
            if (policy.active && !missing) ...[
              SizedBox(height: BusinessTheme.of(context) ? 10 : 14),
              Text(
                policy.bulkBypass
                    ? appLocalizations.residentialBulkBypass
                    : appLocalizations.residentialBulkUnconfirmed,
                maxLines: BusinessTheme.of(context) ? 2 : null,
                overflow: BusinessTheme.of(context)
                    ? TextOverflow.ellipsis
                    : null,
                style: label,
              ),
            ],
            if (policy.active && !missing) ...[
              if (BusinessTheme.of(context) && constraints.hasBoundedHeight)
                const Spacer(),
              SizedBox(height: BusinessTheme.of(context) ? 4 : 14),
              _ExitActions(
                applying: applying,
                onChoose: () => showResidentialExitSheet(context),
                onClear: () => unawaited(
                  ref.read(residentialActionProvider.notifier).clear(),
                ),
              ),
            ],
          ],
        ),
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
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        BusinessPrimaryButton(
          label: appLocalizations.residentialChange,
          width: 86,
          onPressed: applying ? null : onChoose,
        ),
        BusinessSecondaryButton(
          label: appLocalizations.residentialUseSubscription,
          width: 99,
          onPressed: applying ? null : onClear,
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

class _CardMinHeight extends StatelessWidget {
  const _CardMinHeight({required this.minHeight, required this.child});

  final double minHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: child,
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
