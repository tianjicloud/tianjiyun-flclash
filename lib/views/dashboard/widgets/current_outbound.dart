import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/common/tianji_api.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/features.dart';
import 'package:fl_clash/features/ip_quality/labels.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/providers/ip_quality.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/ui/app_background.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/business_exit_warning_banner.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/line_data.dart';
import 'package:fl_clash/views/dashboard/probe_start_hold.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prism_ui/shapes/shapes.dart';

import 'card.dart';
import 'selection_notice.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';

const _builtinOutbounds = {'DIRECT', 'REJECT', 'REJECT-DROP', 'PASS'};

bool isBuiltinOutbound(String name) => _builtinOutbounds.contains(name);

const _ipMask = '*****';

const _decorationGrowth = 0.12;

const _decorationTurn = 2 * math.pi / 12;

String? outboundLocationLabel({
  required String? countryCode,
  required String? city,
  required bool desktop,
}) {
  if (countryCode == null || countryCode.isEmpty) return null;
  if (city == null || city.isEmpty) return countryCode;
  return desktop ? '$countryCode · $city' : '$countryCode $city';
}

String businessResidentialLabel(
  AppLocalizations l10n, {
  required bool desktop,
}) =>
    desktop ? l10n.businessResidentialBroadband : l10n.businessResidentialShort;

bool isVerifiedOutbound({
  required bool active,
  required bool captured,
  required ProbePhase phase,
  required IpInfo? info,
  required RouteStamp? stamp,
  required RouteState route,
  required SelectionVerdict verdict,
}) =>
    active &&
    captured &&
    phase == ProbePhase.fresh &&
    info != null &&
    stamp != null &&
    route.isFresh(stamp) &&
    stamp.proxied &&
    stamp.hits.isNotEmpty &&
    stamp.chains.isNotEmpty &&
    (verdict == SelectionVerdict.untouched ||
        verdict == SelectionVerdict.consistent);

/// The address the proxied traffic leaves by, next to the start button.
class CurrentOutboundCard extends ConsumerStatefulWidget {
  const CurrentOutboundCard({super.key});

  @override
  ConsumerState<CurrentOutboundCard> createState() =>
      _CurrentOutboundCardState();
}

class _CurrentOutboundCardState extends ConsumerState<CurrentOutboundCard>
    with ProbeStartHold<CurrentOutboundCard> {
  late final OutboundIpProbe _probe;

  @override
  void initState() {
    super.initState();
    _probe = ref.read(outboundIpProbeProvider.notifier)..watch(routedOutbound);
  }

  @override
  void dispose() {
    _probe.unwatch(routedOutbound);
    super.dispose();
  }

  void _refresh(String? ip) {
    _probe.refresh(const [routedOutbound]);
    if (ip != null && ref.read(ipQualityProvider(ip)).hasError) {
      ref.invalidate(ipQualityProvider(ip));
    }
  }

  @override
  Widget build(BuildContext context) {
    final density = DashboardDensityScope.of(context);
    final hasProfile = ref.watch(
      profilesProvider.select((state) => state.isNotEmpty),
    );
    final isStart = ref.watch(isStartProvider);
    final suspended = isStart && ref.watch(suspendProvider);
    final coreStatus = ref.watch(coreStatusProvider);
    final connectingStatus = coreStatus == CoreStatus.connecting;
    final rootAccess =
        mitmFeature && (ref.watch(rootAccessProvider).value ?? false);
    final entry = ref.watch(
      outboundIpProbeProvider.select((state) => state.entryOf(routedOutbound)),
    );
    final ipInfo = entry.value;
    final phase = shownPhase(entry);
    final failed = phase == ProbePhase.failed && ipInfo == null;
    final qualityState = ipInfo == null
        ? null
        : ref.watch(ipQualityProvider(ipInfo.ip));
    final quality = qualityState?.value;
    final qualityLoading =
        qualityState != null && quality == null && qualityState.isLoading;
    final loading = ipInfo == null ? !failed : qualityLoading;
    final metrics = _OutboundMetrics.of(density);
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final colors = DashboardColors.of(context);
    final (chipLabel, chipTone) = suspended
        ? (appLocalizations.suspended, DashboardChipTone.warn)
        : isStart
        ? (appLocalizations.running, DashboardChipTone.ok)
        : (appLocalizations.notRunning, DashboardChipTone.idle);
    final verdict = ref.watch(selectionCheckProvider);
    final showSelection =
        !failed &&
        (isStart || !BusinessTheme.of(context)) &&
        verdict != SelectionVerdict.untouched &&
        verdict != SelectionVerdict.consistent;
    if (BusinessTheme.of(context)) {
      final active = isStart && !suspended;
      final exitName = isStart && phase == ProbePhase.fresh
          ? entry.stamp?.hits.firstOrNull?.exit
          : null;
      final line = currentDashboardLine(ref);
      final checking = phase == ProbePhase.probing || qualityLoading;
      final tunEnabled = ref.watch(
        patchClashConfigProvider.select((value) => value.tun.enable),
      );
      final tunAuthorized =
          ref.watch(authorizedTunEnableProvider) ==
          TunAuthorizationState.authorized;
      final captured =
          ref.watch(
            networkSettingProvider.select((value) => value.systemProxy),
          ) ||
          tunEnabled;
      final route = ref.watch(routeTrackerProvider);
      final stamp = entry.stamp;
      final exitWarning = businessExitWarningKind(
        active: isStart,
        coreConnected: coreStatus == CoreStatus.connected,
        probeFailed: failed,
        tunEnabled: tunEnabled,
        tunAuthorized: tunAuthorized,
      );
      final exitAbnormal = exitWarning != null;
      final showBusinessSelection = showSelection && !exitAbnormal;
      final verifiedExit = isVerifiedOutbound(
        active: active,
        captured: captured,
        phase: phase,
        info: ipInfo,
        stamp: stamp,
        route: route,
        verdict: verdict,
      );
      final ringColor = switch ((checking, failed, verdict)) {
        _ when connectingStatus => BusinessPalette.blue,
        _ when !isStart => const Color(0xFF98A2AD),
        _ when exitAbnormal => BusinessPalette.exitWarningForegroundFor(
          colorScheme.brightness,
        ),
        _ when suspended => colors.warn,
        (
          _,
          _,
          SelectionVerdict.failed ||
              SelectionVerdict.notCaptured ||
              SelectionVerdict.residentialLocked ||
              SelectionVerdict.groupOverridden ||
              SelectionVerdict.trafficNotOnTianji ||
              SelectionVerdict.egressMismatch ||
              SelectionVerdict.egressAnomaly,
        ) =>
          colors.warn,
        _ when verifiedExit => colors.ok,
        _ when phase == ProbePhase.probing => BusinessPalette.blue,
        _ => const Color(0xFF98A2AD),
      };
      final statusText = density.isDesktop
          ? switch (exitWarning) {
              BusinessExitWarningKind.probeFailed =>
                appLocalizations.businessConnectedProbeFailed,
              BusinessExitWarningKind.tunUnauthorized =>
                appLocalizations.businessConnectedUnverified,
              _ => appLocalizations.businessCurrentExitIp,
            }
          : connectingStatus
          ? appLocalizations.connecting
          : exitWarning == BusinessExitWarningKind.probeFailed
          ? appLocalizations.businessConnectedProbeFailed
          : exitWarning == BusinessExitWarningKind.tunUnauthorized
          ? appLocalizations.businessConnectedUnverified
          : suspended
          ? appLocalizations.suspended
          : verifiedExit
          ? appLocalizations.businessExitVerified
          : isStart
          ? appLocalizations.running
          : appLocalizations.businessNotConnected;
      final statusTone = exitAbnormal
          ? BusinessPalette.exitWarningForegroundFor(colorScheme.brightness)
          : connectingStatus || suspended
          ? colors.warn
          : failed
          ? colorScheme.error
          : verifiedExit
          ? colors.ok
          : colorScheme.onSurfaceVariant;
      final toggle = _StartToggle(
        size: density.isDesktop
            ? 184
            : isStart
            ? 164
            : 180,
        enabled: hasProfile,
        running: isStart,
        suspended: suspended,
        pulseEnabled: density.isDesktop,
        ringColor: exitAbnormal ? null : ringColor,
        abnormal: exitAbnormal,
        showLabel: density.isDesktop,
        idleLabel: density.isDesktop ? null : appLocalizations.start,
      );
      final details = _BusinessHeroDetails(
        showStatus: density.isDesktop,
        compact: density.isCompact,
        statusText: statusText,
        statusTone: statusTone,
        checking: checking && connectingStatus,
        info: isStart ? ipInfo : null,
        failed: isStart && failed,
        loading: isStart && loading,
        quality: isStart ? quality : null,
        active: active,
        onRefresh: () => _refresh(ipInfo?.ip),
        line: line,
        exitName: exitName,
        showSelection: showBusinessSelection,
      );
      final content = density.isDesktop
          ? ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 210 + (showBusinessSelection ? 84 : 0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: details),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 22),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: toggle),
                        Container(
                          width: 1,
                          height: 132,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          color: const Color(0xFFE5E9EE),
                        ),
                        _HeroSpeeds(active: active, vertical: true),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: _BusinessStatusLine(
                    text: statusText,
                    tone: statusTone,
                    checking: checking && connectingStatus,
                    centered: true,
                  ),
                ),
                SizedBox(height: isStart ? 6 : 12),
                Center(child: toggle),
                if (isStart) ...[
                  const SizedBox(height: 10),
                  _MobileConnectedSummary(
                    info: ipInfo,
                    failed: failed,
                    loading: loading,
                    active: active,
                    quality: quality,
                    line: line,
                    onRefresh: () => _refresh(ipInfo?.ip),
                  ),
                ] else ...[
                  const SizedBox(height: 12),
                  const _BusinessIdlePrompt(),
                ],
                if (showBusinessSelection) ...[
                  const SizedBox(height: 12),
                  const SelectionNotice(),
                ],
              ],
            );
      final businessContent = density.isDesktop
          ? content
          : ConstrainedBox(
              constraints: BoxConstraints(minHeight: isStart ? 336 : 311),
              child: content,
            );
      return DashboardCard(
        radius: density.isDesktop
            ? BusinessRadius.heroDesktop
            : BusinessRadius.heroMobile,
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.zero,
        semanticLabel: rootAccess
            ? '${appLocalizations.status} ${appLocalizations.root}'
            : appLocalizations.status,
        side: rootAccess
            ? const BorderSide(color: BusinessPalette.blue, width: 1.5)
            : BorderSide.none,
        child: Stack(
          children: [
            Positioned.fill(child: _HeroBackdrop(mobile: !density.isDesktop)),
            Padding(
              padding: density.isDesktop
                  ? const EdgeInsetsDirectional.fromSTEB(26, 13, 26, 13)
                  : EdgeInsetsDirectional.fromSTEB(
                      20,
                      isStart ? 18 : 22,
                      20,
                      18,
                    ),
              child: businessContent,
            ),
          ],
        ),
      );
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(end: rootAccess ? 1 : 0),
      duration: context.motionDuration(commonDuration),
      builder: (context, root, child) => DashboardCard(
        padding: EdgeInsets.zero,
        semanticLabel: rootAccess
            ? '${appLocalizations.status} ${appLocalizations.root}'
            : appLocalizations.status,
        side: root == 0
            ? BorderSide.none
            : BorderSide(
                color: context.colorScheme.primary.withValues(alpha: root),
                width: 1.5,
              ),
        child: child!,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: ShapeBorderClipper(
                shape: AppShape.all(dashboardCardRadius(density)),
                textDirection: Directionality.of(context),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  PositionedDirectional(
                    end: metrics.decorationEnd,
                    top: metrics.decorationTop,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: isStart ? 1 : 0),
                      duration: context.motionDuration(_morphDuration),
                      curve: Curves.easeOutBack,
                      builder: (_, progress, _) => Transform.rotate(
                        angle: _decorationTurn * progress,
                        child: Transform.scale(
                          scale: 1 + _decorationGrowth * progress,
                          child: ShapeBadge(
                            shape: MaterialShapes.cookie12Sided,
                            color: Color.lerp(
                              colors.tone,
                              Color.alphaBlend(
                                colorScheme.primary.withValues(alpha: 0.1),
                                colors.card,
                              ),
                              progress.clamp(0, 1),
                            )!,
                            size: metrics.decorationSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: metrics.padding,
            child: Row(
              spacing: metrics.gap,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DashboardCardHeader(
                        glyph: AppGlyphs.status,
                        title: appLocalizations.status,
                        leading: [
                          DashboardChip(
                            label: chipLabel,
                            tone: chipTone,
                            dot: isStart,
                          ),
                        ],
                      ),
                      SizedBox(height: metrics.ipTop),
                      _ExitRow(
                        info: ipInfo,
                        failed: failed,
                        loading: loading,
                        checking: phase == ProbePhase.probing || qualityLoading,
                        onRefresh: () => _refresh(ipInfo?.ip),
                        quality: quality,
                        active: isStart,
                        metrics: metrics,
                        large: !density.isDesktop,
                      ),
                      if (density.isDesktop)
                        const Spacer()
                      else
                        const SizedBox(height: 16),
                      if (showSelection)
                        const SizedBox(
                          height: 44,
                          child: SingleChildScrollView(
                            child: SelectionNotice(),
                          ),
                        )
                      else
                        _Cells(
                          quality: quality,
                          loading: loading,
                          active: isStart && !suspended,
                          gap: metrics.cellGap,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: metrics.buttonSlot,
                  child: Center(
                    child: _StartToggle(
                      size: metrics.buttonSize,
                      enabled: hasProfile,
                      running: isStart,
                      suspended: suspended,
                      ringColor: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutboundMetrics {
  const _OutboundMetrics({
    required this.padding,
    required this.gap,
    required this.ipTop,
    required this.cellGap,
    required this.badgeSize,
    required this.ip,
    required this.buttonSize,
    required this.buttonSlot,
    required this.decorationSize,
    required this.decorationEnd,
    required this.decorationTop,
  });

  factory _OutboundMetrics.of(DashboardDensity density) => switch (density) {
    DashboardDensity.standard => _OutboundMetrics(
      padding: dashboardCardPadding(density),
      gap: 16,
      ipTop: 10,
      cellGap: 28,
      badgeSize: 48,
      ip: AppTextStyle.title1,
      buttonSize: 184,
      buttonSlot: 184,
      decorationSize: 290,
      decorationEnd: -64,
      decorationTop: -87,
    ),
    DashboardDensity.compact => _OutboundMetrics(
      padding: dashboardCardPadding(density),
      gap: 16,
      ipTop: 8,
      cellGap: 22,
      badgeSize: 40,
      ip: AppTextStyle.title2,
      buttonSize: 184,
      buttonSlot: 184,
      decorationSize: 250,
      decorationEnd: -64,
      decorationTop: -75,
    ),
    DashboardDensity.mobile => const _OutboundMetrics(
      padding: EdgeInsetsDirectional.fromSTEB(20, 18, 16, 18),
      gap: 10,
      ipTop: 12,
      cellGap: 24,
      badgeSize: 48,
      ip: AppTextStyle.title2,
      buttonSize: 88,
      buttonSlot: 88,
      decorationSize: 240,
      decorationEnd: -60,
      decorationTop: -66,
    ),
  };

  final EdgeInsetsGeometry padding;
  final double gap;
  final double ipTop;
  final double cellGap;
  final double badgeSize;
  final AppTextStyle ip;
  final double buttonSize;
  final double buttonSlot;
  final double decorationSize;
  final double decorationEnd;
  final double decorationTop;
}

class _BusinessStatusLine extends StatelessWidget {
  const _BusinessStatusLine({
    required this.text,
    required this.tone,
    required this.checking,
    required this.centered,
  });

  final String text;
  final Color tone;
  final bool checking;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final label = checking
        ? '$text · ${context.appLocalizations.checkingExit}'
        : text;
    final warning =
        text == context.appLocalizations.businessConnectedProbeFailed ||
        text == context.appLocalizations.businessConnectedUnverified;
    final status = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: centered
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      spacing: 8,
      children: [
        if (centered || warning)
          Container(
            width: 8,
            height: 8,
            decoration: ShapeDecoration(
              color: warning
                  ? BusinessPalette.exitWarningForegroundFor(
                      context.colorScheme.brightness,
                    )
                  : text == context.appLocalizations.businessNotConnected
                  ? BusinessPalette.disconnectedForegroundFor(
                      context.colorScheme.brightness,
                    )
                  : tone,
              shape: AppShape.circle,
            ),
          ),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: BusinessText.heroStatus(context).copyWith(
              color: warning
                  ? BusinessPalette.exitWarningForegroundFor(
                      context.colorScheme.brightness,
                    )
                  : text == context.appLocalizations.businessNotConnected
                  ? BusinessPalette.disconnectedForegroundFor(
                      context.colorScheme.brightness,
                    )
                  : centered
                  ? BusinessPalette.connectedForegroundFor(
                      context.colorScheme.brightness,
                    )
                  : context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
    if (!centered && !warning) return status;
    final connected = text != context.appLocalizations.businessNotConnected;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(11, 4, 11, 4),
      decoration: ShapeDecoration(
        color: warning
            ? BusinessPalette.warningContainerFor(
                context.colorScheme.brightness,
              )
            : connected
            ? BusinessPalette.connectedContainerFor(
                context.colorScheme.brightness,
              )
            : BusinessPalette.disconnectedContainerFor(
                context.colorScheme.brightness,
              ),
        shape: AppShape.full,
      ),
      child: status,
    );
  }
}

class _BusinessIdlePrompt extends ConsumerWidget {
  const _BusinessIdlePrompt();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final line = currentDashboardLine(ref);
    if (line == null) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.appLocalizations.businessTapToConnect,
          style: BusinessText.residentialExit(
            context,
            mobile: true,
          ).copyWith(color: context.colorScheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          context.appLocalizations.businessConnectVia(line.displayName),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: BusinessText.mobileCardHeading(
            context,
          ).copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _BusinessHeroDetails extends ConsumerWidget {
  const _BusinessHeroDetails({
    required this.showStatus,
    required this.compact,
    required this.statusText,
    required this.statusTone,
    required this.checking,
    required this.info,
    required this.failed,
    required this.loading,
    required this.quality,
    required this.active,
    required this.onRefresh,
    required this.line,
    required this.exitName,
    required this.showSelection,
  });

  final bool showStatus;
  final bool compact;
  final String statusText;
  final Color statusTone;
  final bool checking;
  final IpInfo? info;
  final bool failed;
  final bool loading;
  final IpQuality? quality;
  final bool active;
  final VoidCallback onRefresh;
  final DashboardLine? line;
  final String? exitName;
  final bool showSelection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runTime = ref.watch(runTimeProvider);
    final delay =
        line?.delay ??
        (exitName == null
            ? null
            : ref.watch(delaysAtLastTestBatchProvider)[ref.watch(
                realTestUrlProvider(),
              )]?[exitName]);
    final status = showStatus
        ? _BusinessStatusLine(
            text: statusText,
            tone: statusTone,
            checking: checking,
            centered: false,
          )
        : null;
    final ip = _BusinessIp(
      info: info,
      failed: failed,
      loading: loading,
      size: 46,
      active: active,
      onRefresh: onRefresh,
    );
    final chips = _BusinessChips(
      info: info,
      quality: quality,
      loading: loading,
      large: !compact,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        status!,
        SizedBox(height: compact ? 6 : 10),
        ip,
        SizedBox(height: compact ? 8 : 12),
        chips,
        SizedBox(height: compact ? 10 : 14),
        if (showSelection) ...[
          const SizedBox(height: 8),
          const SelectionNotice(),
        ] else
          LayoutBuilder(
            builder: (context, constraints) {
              final cells = [
                _Cell(
                  label: context.appLocalizations.businessCurrentLine,
                  value: switch (exitName ?? line?.displayName) {
                    final exit? => EmojiText(
                      exit,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: BusinessText.heroMetaValue(context),
                    ),
                    _ => const _Placeholder(),
                  },
                ),
                _Cell(
                  label: context.appLocalizations.runTime,
                  value: active
                      ? _CellText(getTimeText(runTime))
                      : const _Placeholder(),
                ),
                _Cell(
                  label: context.appLocalizations.delay,
                  value: delay != null
                      ? _CellText(
                          '$delay ms',
                          color: businessDelayColor(context.colorScheme, delay),
                        )
                      : const _Placeholder(),
                ),
              ];
              final fixed = !compact && constraints.maxWidth >= 438;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: fixed ? 0 : 16,
                children: [
                  for (final cell in cells)
                    if (fixed)
                      SizedBox(width: 146, child: cell)
                    else
                      Expanded(child: cell),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _MobileConnectedSummary extends ConsumerWidget {
  const _MobileConnectedSummary({
    required this.info,
    required this.failed,
    required this.loading,
    required this.active,
    required this.quality,
    required this.line,
    required this.onRefresh,
  });

  final IpInfo? info;
  final bool failed;
  final bool loading;
  final bool active;
  final IpQuality? quality;
  final DashboardLine? line;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = this.info;
    final delay = line?.delay;
    final speed = ref.watch(
      trafficsProvider.select((state) => state.list.safeLast(const Traffic())),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        _BusinessIp(
          info: active ? info : null,
          failed: failed,
          loading: loading,
          size: 30,
          active: active,
          onRefresh: onRefresh,
        ),
        _BusinessChips(
          info: active ? info : null,
          quality: active ? quality : null,
          loading: active && loading,
          large: true,
        ),
        Container(height: 1, color: DashboardColors.of(context).tone),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: _MobileMetric(
                label: context.appLocalizations.delay,
                value: delay == null ? null : '$delay ms',
                color: businessDelayColor(context.colorScheme, delay),
                active: active,
              ),
            ),
            Expanded(
              child: _MobileMetric(
                label: context.appLocalizations.download,
                value: '${speed.down.traffic.value} ${speed.down.traffic.unit}',
                suffix: '/s',
                active: active,
              ),
            ),
            Expanded(
              child: _MobileMetric(
                label: context.appLocalizations.upload,
                value: '${speed.up.traffic.value} ${speed.up.traffic.unit}',
                suffix: '/s',
                active: active,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MobileMetric extends StatelessWidget {
  const _MobileMetric({
    required this.label,
    required this.value,
    required this.active,
    this.color,
    this.suffix = '',
  });

  final String label;
  final String? value;
  final String suffix;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(label, style: BusinessText.mobileMetricLabel(context)),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          active && value != null ? '$value$suffix' : '—',
          maxLines: 1,
          style: BusinessText.mobileMetric(context).copyWith(
            color: active
                ? color ?? context.colorScheme.onSurface
                : context.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}

class _BusinessIp extends StatelessWidget {
  const _BusinessIp({
    required this.info,
    required this.failed,
    required this.loading,
    required this.size,
    required this.active,
    required this.onRefresh,
  });

  final IpInfo? info;
  final bool failed;
  final bool loading;
  final double size;
  final bool active;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final style = BusinessText.heroIp(context, size: size).copyWith(
      color: active ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
    );
    final info = this.info;
    if (info == null && !failed && !loading) {
      return const _Placeholder();
    }
    if (info != null) {
      return Align(
        alignment: BusinessTheme.of(context) && size == 30
            ? Alignment.center
            : AlignmentDirectional.centerStart,
        child: Tooltip(
          message: context.appLocalizations.details(
            context.appLocalizations.outboundIp,
          ),
          child: FocusRing(
            shape: AppShape.xs,
            standsOff: true,
            child: PressRegion(
              onTap: () => showIpQualitySheet(context, ip: info.ip),
              shape: AppShape.xs,
              overlay: PressRegion.focusOverlay,
              child: _IpText(ip: info.ip, style: style),
            ),
          ),
        ),
      );
    }
    if (failed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.appLocalizations.serviceFailed,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.body
                .of(context)
                .copyWith(
                  color: BusinessPalette.exitWarningForegroundFor(
                    colorScheme.brightness,
                  ),
                ),
          ),
          TextButton(
            onPressed: onRefresh,
            child: Text(context.appLocalizations.selectionRecheck),
          ),
        ],
      );
    }
    return Align(
      alignment: BusinessTheme.of(context) && size == 30
          ? Alignment.center
          : AlignmentDirectional.centerStart,
      child: SkeletonText(width: size * 3.2, style: style),
    );
  }
}

class _BusinessChips extends StatelessWidget {
  const _BusinessChips({
    required this.info,
    required this.quality,
    required this.loading,
    required this.large,
  });

  final IpInfo? info;
  final IpQuality? quality;
  final bool loading;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final quality = this.quality;
    final business = BusinessTheme.of(context);
    if (info == null && quality == null && !loading) {
      return const SizedBox.shrink();
    }
    final code = info?.countryCode;
    final city = info?.fromTianji == true ? null : info?.city;
    final desktop = DashboardDensityScope.of(context).isDesktop;
    final location = info?.fromTianji == true
        ? code == null
              ? null
              : '$code · ${localizedRegion(context.appLocalizations, code)}'
        : outboundLocationLabel(
            countryCode: code,
            city: city,
            desktop: desktop,
          );
    final country = location == null
        ? null
        : DashboardChip(label: location, large: false);
    final isp = info?.isp;
    final chips = <Widget>[
      if (business && info?.fromTianji == true)
        DashboardChip(
          label: context.appLocalizations.businessOrdinaryWebExit,
          large: false,
        ),
      ?country,
      if (business && isp != null && isp.isNotEmpty)
        DashboardChip(label: isp, large: false),
      if (quality != null) ...[
        DashboardChip(
          label: quality.type == IpType.residential
              ? businessResidentialLabel(
                  context.appLocalizations,
                  desktop: desktop,
                )
              : quality.type.label(context),
          tone: quality.type == IpType.residential
              ? DashboardChipTone.residential
              : DashboardChipTone.idle,
          large: business ? false : large,
        ),
        if (!business || !large)
          DashboardChip(
            label:
                '${context.appLocalizations.ipQualityShort} ${quality.level.label(context)}',
            tone: switch (quality.level) {
              IpQualityLevel.good => DashboardChipTone.ok,
              IpQualityLevel.normal => DashboardChipTone.idle,
              IpQualityLevel.risky => DashboardChipTone.warn,
            },
            large: business ? false : large,
          ),
        if (quality.organization case final organization?
            when organization.isNotEmpty && (isp == null || isp.isEmpty))
          DashboardChip(label: organization, large: business ? false : large)
        else if (quality.asn case final asn?)
          DashboardChip(label: 'AS$asn', large: business ? false : large),
      ] else if (loading)
        for (final width in _chipSkeletonWidths)
          SkeletonPill(width: width, height: _chipHeight(large))
      else
        DashboardChip(
          label: context.appLocalizations.ipTypeUnknown,
          large: large,
        ),
    ];
    return Wrap(
      alignment: business && large ? WrapAlignment.center : WrapAlignment.start,
      spacing: 6,
      runSpacing: 6,
      children: chips,
    );
  }
}

class _HeroSpeeds extends ConsumerWidget {
  const _HeroSpeeds({required this.active, required this.vertical});

  final bool active;
  final bool vertical;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(
      trafficsProvider.select((state) => state.list.safeLast(const Traffic())),
    );
    final runTime = vertical ? null : ref.watch(runTimeProvider);
    final cells = [
      if (!vertical)
        _Cell(
          label: context.appLocalizations.runTime,
          value: active
              ? _CellText(getTimeText(runTime))
              : const _Placeholder(),
        ),
      _Cell(
        label: context.appLocalizations.download,
        value: active ? _SpeedText(speed.down.traffic) : const _Placeholder(),
      ),
      _Cell(
        label: context.appLocalizations.upload,
        value: active ? _SpeedText(speed.up.traffic) : const _Placeholder(),
      ),
    ];
    if (!vertical) {
      return Wrap(spacing: 28, runSpacing: 10, children: cells);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: cells,
    );
  }
}

class _HeroBackdrop extends StatelessWidget {
  const _HeroBackdrop({required this.mobile});

  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final image =
        AppBackgroundScope.hasImage(context) &&
        context.colorScheme.brightness == Brightness.dark;
    if (!image) {
      return const SizedBox.shrink();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: mobile ? 0.3 : 0.5,
          child: Image.asset(
            'assets/images/background_planet.jpg',
            fit: BoxFit.cover,
            alignment: mobile
                ? const Alignment(0.95, -0.85)
                : const Alignment(1.35, -1.15),
            excludeFromSemantics: true,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: mobile
                ? const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xE6070B1F), Color(0xA6070B1F)],
                    stops: [0.2, 1],
                  )
                : const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xF00D1230),
                      Color(0xB80D1230),
                      Color(0x260D1230),
                    ],
                    stops: [0, 0.55, 1],
                  ),
          ),
        ),
      ],
    );
  }
}

class _ExitRow extends StatelessWidget {
  const _ExitRow({
    required this.info,
    required this.failed,
    required this.loading,
    required this.checking,
    required this.onRefresh,
    required this.quality,
    required this.active,
    required this.metrics,
    required this.large,
  });

  final IpInfo? info;
  final bool failed;
  final bool loading;
  final bool checking;
  final VoidCallback onRefresh;
  final IpQuality? quality;
  final bool active;
  final _OutboundMetrics metrics;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final style = DashboardText.figure(
      context,
      BusinessTheme.of(context)
          ? (large
                ? AppTextStyle.display
                : DashboardDensityScope.of(context).isDesktop
                ? AppTextStyle.title1
                : metrics.ip)
          : metrics.ip,
      color: active ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
    ).copyWith(letterSpacing: 0);
    final info = this.info;
    final appLocalizations = context.appLocalizations;
    final Widget ip = info != null
        ? Tooltip(
            message: appLocalizations.details(appLocalizations.outboundIp),
            child: FocusRing(
              shape: AppShape.xs,
              standsOff: true,
              child: PressRegion(
                onTap: () => showIpQualitySheet(context, ip: info.ip),
                shape: AppShape.xs,
                overlay: PressRegion.focusOverlay,
                child: _IpText(ip: info.ip, style: style),
              ),
            ),
          )
        : failed
        ? Text(
            appLocalizations.serviceFailed,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.body
                .of(context)
                .copyWith(
                  color: BusinessPalette.exitWarningForegroundFor(
                    colorScheme.brightness,
                  ),
                ),
          )
        : SkeletonText(width: 140, style: style);
    return Row(
      spacing: 12,
      children: [
        _CountryBadge(
          countryCode: info?.countryCode,
          size: metrics.badgeSize,
          active: active,
          checking: checking,
          onRefresh: onRefresh,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: BusinessTheme.of(context)
                    ? null
                    : metrics.ip.leading *
                          DashboardDensityScope.scaleOf(context),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ip,
                ),
              ),
              const SizedBox(height: 4),
              if (failed)
                SizedBox(
                  height: _chipHeight(large),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      appLocalizations.tapIconToRetry,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DashboardText.label(context),
                    ),
                  ),
                )
              else
                _IpChips(quality: quality, loading: loading, large: large),
            ],
          ),
        ),
      ],
    );
  }
}

class _IpText extends ConsumerWidget {
  const _IpText({required this.ip, required this.style});

  final String ip;
  final TextStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideIp = ref.watch(
      appSettingProvider.select((state) => state.hideIp),
    );
    return DashboardFitText(hideIp ? _ipMask : ip, style: style);
  }
}

double _chipHeight(bool large) => large ? 28 : 24;

const _chipSkeletonWidths = [48.0, 72.0];

class _IpChips extends StatelessWidget {
  const _IpChips({
    required this.quality,
    required this.loading,
    required this.large,
  });

  final IpQuality? quality;
  final bool loading;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final quality = this.quality;
    final height = _chipHeight(large);
    final chips = Wrap(
      spacing: 6,
      runSpacing: BusinessTheme.of(context) ? 6 : height,
      children: switch (quality) {
        final quality? => [
          DashboardChip(
            label:
                BusinessTheme.of(context) && quality.type == IpType.residential
                ? context.appLocalizations.businessResidentialBroadband
                : quality.type.label(context),
            tone:
                BusinessTheme.of(context) && quality.type == IpType.residential
                ? DashboardChipTone.residential
                : DashboardChipTone.idle,
            large: large,
          ),
          DashboardChip(
            label:
                '${context.appLocalizations.ipQualityShort} ${quality.level.label(context)}',
            tone: switch (quality.level) {
              IpQualityLevel.good => DashboardChipTone.ok,
              IpQualityLevel.normal => DashboardChipTone.idle,
              IpQualityLevel.risky => DashboardChipTone.warn,
            },
            large: large,
          ),
        ],
        null when loading => [
          for (final width in _chipSkeletonWidths)
            SkeletonPill(width: width, height: height),
        ],
        null => [
          DashboardChip(
            label: context.appLocalizations.ipTypeUnknown,
            large: large,
          ),
        ],
      },
    );
    if (BusinessTheme.of(context)) return chips;
    return SizedBox(
      height: height,
      child: ClipRect(child: chips),
    );
  }
}

const _spinPeriod = Duration(milliseconds: 1500);

/// The exit's country on a clover that checks the exit again when tapped and
/// turns while it is being checked.
class _CountryBadge extends StatefulWidget {
  const _CountryBadge({
    required this.countryCode,
    required this.size,
    required this.active,
    required this.checking,
    required this.onRefresh,
  });

  final String? countryCode;
  final double size;
  final bool active;
  final bool checking;
  final VoidCallback onRefresh;

  @override
  State<_CountryBadge> createState() => _CountryBadgeState();
}

class _CountryBadgeState extends State<_CountryBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _turns = AnimationController(
    vsync: this,
    duration: _spinPeriod,
  );
  var _hovered = false;
  var _focused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _spin();
  }

  @override
  void didUpdateWidget(_CountryBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checking != widget.checking) {
      _spin();
    }
  }

  @override
  void dispose() {
    _turns.dispose();
    super.dispose();
  }

  void _spin() {
    if (context.disableAnimations) {
      _turns.value = 0;
    } else if (widget.checking) {
      _turns.repeat();
    } else {
      // A clover looks the same every quarter turn, so it stops on the next.
      final rest = (_turns.value * 4).ceil() / 4;
      _turns.animateTo(rest, duration: _spinPeriod * (rest - _turns.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final foreground = widget.active
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant;
    final enabled = !widget.checking;
    final size = widget.size;
    final code = widget.countryCode;
    final tooltip = context.appLocalizations.retry;
    final color = Color.alphaBlend(
      foreground.withValues(alpha: enabled && _hovered ? 0.08 : 0),
      DashboardColors.of(context).tone2,
    );
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: tooltip,
        child: PressRegion(
          onTap: enabled ? widget.onRefresh : null,
          onHover: (value) => setState(() => _hovered = value),
          onFocusChange: (value) => setState(() => _focused = value),
          child: ElasticPress(
            enabled: enabled,
            child: AnimatedBuilder(
              animation: _turns,
              builder: (_, child) => ShapeBadge(
                shape: MaterialShapes.clover4Leaf,
                color: color,
                size: size,
                rotation: _turns.value * 2 * math.pi,
                ring: _focused ? focusRingSide(colorScheme) : null,
                child: child,
              ),
              child: code == null || code.isEmpty
                  ? GlyphIcon(
                      AppGlyphs.proxies,
                      size: size * 0.42,
                      color: foreground,
                    )
                  : Text(
                      code.toUpperCase(),
                      maxLines: 1,
                      style: AppTextStyle.footnote
                          .of(context, emphasized: true)
                          .copyWith(
                            color: foreground,
                            letterSpacing: 0.04 * AppTextStyle.footnote.size,
                          ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Cells extends StatelessWidget {
  const _Cells({
    required this.quality,
    required this.loading,
    required this.active,
    required this.gap,
  });

  final IpQuality? quality;
  final bool loading;
  final bool active;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final organization = switch (quality) {
      IpQuality(organization: final name?) when name.isNotEmpty => name,
      IpQuality(asn: final asn?) => 'AS$asn',
      _ => null,
    };
    return Row(
      spacing: gap,
      children: [
        _Cell(
          label: appLocalizations.runTime,
          value: active ? const _RunTimeValue() : const _Placeholder(),
        ),
        Flexible(
          child: _Cell(
            label: appLocalizations.ipOrganization,
            value: organization != null
                ? _CellText(organization)
                : loading
                ? SkeletonText(width: 96, style: _cellStyle(context))
                : const _Placeholder(),
          ),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: DashboardText.label(context),
        ),
        const SizedBox(height: 4),
        value,
      ],
    );
  }
}

TextStyle _cellStyle(BuildContext context) =>
    BusinessText.heroMetaValue(context).toJetBrainsMono;

class _CellText extends StatelessWidget {
  const _CellText(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _cellStyle(context).copyWith(color: color),
    );
  }
}

class _SpeedText extends StatelessWidget {
  const _SpeedText(this.value);

  final TrafficShow value;

  @override
  Widget build(BuildContext context) => Text(
    '${value.value} ${value.unit}/s',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: BusinessText.heroSpeed(context),
  );
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Text('—', maxLines: 1, style: _cellStyle(context));
  }
}

class _RunTimeValue extends ConsumerWidget {
  const _RunTimeValue();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _CellText(getTimeText(ref.watch(runTimeProvider)));
  }
}

const _morphDuration = Duration(milliseconds: 450);
const _stateDuration = Duration(milliseconds: 150);

final _startMorph = Morph(MaterialShapes.circle, MaterialShapes.cookie9Sided);

Path _morphPath(double progress) => _startMorph.toPath(progress: progress);

double _morphTurn(double progress) => progress * 2 * math.pi / 9;

/// A circle with a play glyph while stopped that grows the cookie-9 of a
/// running tunnel, the way the M3 Expressive loader morphs between shapes.
class _StartToggle extends ConsumerStatefulWidget {
  const _StartToggle({
    required this.size,
    required this.enabled,
    required this.running,
    required this.suspended,
    this.ringColor,
    this.abnormal = false,
    this.pulseEnabled = true,
    this.showLabel = true,
    this.idleLabel,
  });

  final double size;
  final bool enabled;
  final bool running;
  final bool suspended;
  final Color? ringColor;
  final bool abnormal;
  final bool pulseEnabled;
  final bool showLabel;

  /// Replaces the start label while stopped, for the design's "tap to start".
  final String? idleLabel;

  @override
  ConsumerState<_StartToggle> createState() => _StartToggleState();
}

class _StartToggleState extends ConsumerState<_StartToggle>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _morphDuration,
    value: widget.running ? 1 : 0,
  );
  late final CurvedAnimation _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutBack,
    reverseCurve: Curves.easeInCubic,
  );
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  var _hovered = false;
  var _pressed = false;
  var _focused = false;
  var oldConnecting = false;

  /// The M3 state layer, painted inside the shape: the card's decoration
  /// covers the button, so ink on the card would never show.
  double get _overlay => !widget.enabled
      ? 0
      : _focused
      ? 0.1
      : _hovered
      ? 0.08
      : 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  bool get _settled => !_controller.isAnimating && !_progress.isAnimating;

  void _syncPulse() {
    final idle =
        BusinessTheme.of(context) &&
        widget.pulseEnabled &&
        widget.enabled &&
        !widget.running &&
        !widget.suspended &&
        ref.read(coreStatusProvider) != CoreStatus.connecting;
    if (idle && !context.disableAnimations && _settled) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(period: const Duration(milliseconds: 8000));
      }
    } else {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  @override
  void didUpdateWidget(_StartToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.running != widget.running) {
      if (context.disableAnimations) {
        _controller.value = widget.running ? 1 : 0;
      } else {
        widget.running ? _controller.forward() : _controller.reverse();
      }
      if (_settled) {
        _syncPulse();
      } else {
        _controller.addStatusListener(_pulseOnSettle);
      }
    }
  }

  void _pulseOnSettle(AnimationStatus status) {
    if (status != AnimationStatus.completed &&
        status != AnimationStatus.dismissed) {
      return;
    }
    _controller.removeStatusListener(_pulseOnSettle);
    if (mounted) _syncPulse();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_pulseOnSettle);
    _progress.dispose();
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggle() {
    _pulseController.stop();
    _pulseController.value = 0;
    ref.read(commonActionProvider.notifier).toggleRunning();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final appLocalizations = context.appLocalizations;
    final glass = LiquidGlassScope.of(context);
    final size = widget.size;
    final enabled = widget.enabled;
    final fill = enabled
        ? BusinessPalette.blue
        : DashboardColors.of(context).tone2;
    final ink = enabled ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    final tooltip = widget.suspended
        ? appLocalizations.suspended
        : widget.running
        ? appLocalizations.stop
        : appLocalizations.start;
    if (BusinessTheme.of(context)) {
      final connecting = ref.watch(coreStatusProvider) == CoreStatus.connecting;
      if (!connecting && (oldConnecting)) _syncPulse();
      oldConnecting = connecting;
      final color = !enabled
          ? BusinessPalette.secondary
          : connecting || widget.suspended
          ? BusinessPalette.warning
          : widget.abnormal
          ? BusinessPalette.exitWarningForegroundFor(colorScheme.brightness)
          : widget.running
          ? BusinessPalette.blue
          : BusinessPalette.accent;
      final label = connecting
          ? appLocalizations.connecting
          : widget.abnormal
          ? appLocalizations.businessConnectedAbnormal
          : widget.running && !widget.suspended
          ? appLocalizations.businessConnectedDisconnect
          : !widget.running && !widget.suspended && widget.idleLabel != null
          ? widget.idleLabel!
          : tooltip;
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Tooltip(
            message: label,
            child: Semantics(
              button: true,
              enabled: enabled,
              label: label,
              child: PressRegion(
                onTap: enabled ? _toggle : null,
                shape: AppShape.circle,
                overlay: PressRegion.hoverOverlay,
                onFocusChange: (value) => setState(() => _focused = value),
                child: RepaintBoundary(
                  child: TweenAnimationBuilder<Color?>(
                    tween: ColorTween(end: color),
                    duration: context.motionDuration(_morphDuration),
                    builder: (context, animatedColor, _) => AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, _) => AnimatedBuilder(
                        animation: _progress,
                        builder: (context, _) => CustomPaint(
                          painter: OrbitPainter(
                            color: widget.ringColor ?? animatedColor ?? color,
                            primary: BusinessPalette.blue,
                            idleCore: DashboardColors.of(context).card,
                            idleStroke: colorScheme.outlineVariant.withValues(
                              alpha: 0.65,
                            ),
                            idleShadow: colorScheme.shadow.withValues(
                              alpha: 0.12,
                            ),
                            idlePlate: BusinessPalette.idleOrbitPlateFor(
                              colorScheme.brightness,
                            ),
                            focused: _focused,
                            running: widget.running && !widget.abnormal,
                            pulse:
                                widget.pulseEnabled &&
                                    _pulseController.isAnimating
                                ? _pulseController.value
                                : null,
                          ),
                          child: SizedBox.square(
                            dimension: size,
                            child: Center(
                              child: GlyphIcon(
                                widget.suspended
                                    ? AppGlyphs.wifiOff
                                    : AppGlyphs.power,
                                size: size * 0.22,
                                color: widget.abnormal
                                    ? BusinessPalette.exitWarningForegroundFor(
                                        colorScheme.brightness,
                                      )
                                    : widget.running
                                    ? Colors.white
                                    : BusinessPalette.blue,
                                fill: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.showLabel)
            Text(
              label,
              style: BusinessText.startLabel(
                context,
              ).copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
        ],
      );
    }
    final stateDuration = context.motionDuration(_stateDuration);
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: tooltip,
        child: PressRegion(
          onTap: enabled ? _toggle : null,
          onHover: (value) => setState(() => _hovered = value),
          onPressedChanged: (value) => setState(() => _pressed = value),
          onFocusChange: (value) => setState(() => _focused = value),
          child: ElasticPress(
            enabled: enabled,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: _overlay),
              duration: stateDuration,
              builder: (_, overlay, child) => AnimatedBuilder(
                animation: _progress,
                builder: (_, child) {
                  final progress = _progress.value;
                  final color = Color.alphaBlend(
                    ink.withValues(alpha: overlay),
                    fill,
                  );
                  return CustomPaint(
                    painter: _MorphPainter(
                      progress: progress,
                      color: glass ? null : color,
                      shadow: enabled
                          ? colorScheme.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                      ring: _focused
                          ? focusRingSide(colorScheme, standsOff: true)
                          : null,
                    ),
                    child: glass
                        ? LiquidGlass(
                            style: LiquidGlassStyle.tinted(colorScheme, color),
                            clipper: _MorphClipper(progress),
                            pressed: _pressed,
                            child: child,
                          )
                        : child,
                  );
                },
                child: child,
              ),
              child: SizedBox.square(
                dimension: size,
                child: Center(
                  child: widget.suspended
                      ? GlyphIcon(
                          AppGlyphs.wifiOff,
                          size: size * 0.34,
                          color: ink,
                          fill: 1,
                        )
                      : TweenAnimationBuilder<double>(
                          tween: Tween(end: widget.running ? 1 : 0),
                          duration: _morphDuration,
                          curve: Curves.easeOutBack,
                          builder: (_, progress, _) => GlyphIcon(
                            AppGlyphs.playPause(progress),
                            size: size * 0.34,
                            color: ink,
                            fill: 1,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fills the morph, or with no [color] leaves its inside to glass and casts
/// [shadow] only outside it, as one under glass would show through.
class _MorphPainter extends CustomPainter {
  const _MorphPainter({
    required this.progress,
    required this.color,
    required this.shadow,
    required this.ring,
  });

  static const _shadowOffset = Offset(0, 6);
  static const _shadowBlur = 14.0;

  final double progress;
  final Color? color;
  final Color shadow;
  final BorderSide? ring;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _morphPath(progress);
    final color = this.color;
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..rotate(_morphTurn(progress))
      ..scale(size.width, size.height)
      ..translate(-0.5, -0.5);
    if (shadow.a > 0) {
      canvas.save();
      if (color == null) {
        canvas.clipPath(
          Path()
            ..fillType = PathFillType.evenOdd
            ..addRect(const Rect.fromLTRB(-1, -1, 2, 2))
            ..addPath(path, Offset.zero),
        );
      }
      canvas
        ..translate(
          _shadowOffset.dx / size.width,
          _shadowOffset.dy / size.height,
        )
        ..drawPath(
          path,
          Paint()
            ..color = shadow
            ..maskFilter = MaskFilter.blur(
              BlurStyle.normal,
              _shadowBlur / 2 / size.width,
            ),
        )
        ..restore();
    }
    if (color != null) {
      canvas.drawPath(path, Paint()..color = color);
    }
    if (ring case final ring?) {
      strokeUnitShape(canvas, path, size.width, ring);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MorphPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.shadow != shadow ||
      oldDelegate.ring != ring;
}

class _MorphClipper extends CustomClipper<Path> {
  const _MorphClipper(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    final transform =
        Matrix4.translationValues(size.width / 2, size.height / 2, 0)
          ..rotateZ(_morphTurn(progress))
          ..scaleByDouble(size.width, size.height, 1, 1)
          ..translateByDouble(-0.5, -0.5, 0, 1);
    return _morphPath(progress).transform(transform.storage);
  }

  @override
  bool shouldReclip(_MorphClipper oldClipper) =>
      oldClipper.progress != progress;
}
