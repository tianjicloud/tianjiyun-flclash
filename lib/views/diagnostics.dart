import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/common/tianji_api.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:fl_clash/providers/service_status.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessPrimaryButton;
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _diagnosticServices = [
  ServiceTarget.chatgpt,
  ServiceTarget.claude,
  ServiceTarget.gemini,
];

enum DiagnosticResult { passed, failed, unverified }

class _DiagnosticCheck {
  const _DiagnosticCheck({
    required this.title,
    required this.result,
    this.detail,
    this.detailIsVerdict = false,
  });

  final String title;
  final DiagnosticResult result;
  final String? detail;
  final bool detailIsVerdict;
}

void refreshDiagnostics(WidgetRef ref) {
  ref.read(serviceStatusProvider.notifier).refresh(_diagnosticServices);
  ref.read(outboundIpProbeProvider.notifier).refresh(const [routedOutbound]);
  ref.read(selectionCheckProvider);
}

class DiagnosticsView extends ConsumerWidget {
  const DiagnosticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = _isLoading(ref);
    final hasResult = _hasDiagnosticResult(ref);
    return Scaffold(
      title: context.appLocalizations.diagnosticsTitle,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ).copyWith(top: context.sectionsTopPadding, bottom: 16),
              child: DiagnosticsPanel(
                onRun: () => refreshDiagnostics(ref),
                isLoading: isLoading,
                showRunButton: false,
                mobileLayout: ViewScope.isMobileOf(context),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + context.bottomInset),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: isLoading ? null : () => refreshDiagnostics(ref),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    if (isLoading) const ActivityIndicator(),
                    Text(
                      hasResult
                          ? context.appLocalizations.diagnosticsRunAgain
                          : context.appLocalizations.diagnosticsStart,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagnosticsPanel extends ConsumerStatefulWidget {
  const DiagnosticsPanel({
    super.key,
    required this.onRun,
    this.isLoading = false,
    this.showRunButton = true,
    this.mobileLayout = false,
  });

  final VoidCallback onRun;
  final bool isLoading;
  final bool showRunButton;
  final bool mobileLayout;

  @override
  ConsumerState<DiagnosticsPanel> createState() => _DiagnosticsPanelState();
}

class _DiagnosticsPanelState extends ConsumerState<DiagnosticsPanel> {
  late final _services = ref.read(serviceStatusProvider.notifier);
  late final _outbound = ref.read(outboundIpProbeProvider.notifier);

  @override
  void initState() {
    super.initState();
    for (final target in _diagnosticServices) {
      _services.watch(target);
    }
    _outbound.watch(routedOutbound);
  }

  @override
  void dispose() {
    for (final target in _diagnosticServices) {
      _services.unwatch(target);
    }
    _outbound.unwatch(routedOutbound);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final widget = this.widget;
    final strings = context.appLocalizations;
    final isLoading = widget.isLoading || _isLoading(ref);
    final hasResult = _hasDiagnosticResult(ref);
    final starting = ref.watch(isStartProvider);
    final active = starting && !ref.watch(suspendProvider);
    final coreStatus = ref.watch(coreStatusProvider);
    final profile = ref.watch(currentProfileProvider);
    final selection = ref.watch(selectionCheckProvider);
    final outbound = ref.watch(
      outboundIpProbeProvider.select((state) => state.entryOf(routedOutbound)),
    );
    final selectedNode = ref.watch(
      tianjiNodeProvider(outbound.stamp?.chains.firstOrNull ?? ''),
    );
    final services = ref.watch(serviceStatusProvider);
    final dns = ref.watch(patchClashConfigProvider).dns;
    final mainlandPolicy = dns.nameserverPolicy.entries.any((entry) {
      final key = entry.key.toLowerCase();
      final server = entry.value;
      return (key.contains('cn') || key.endsWith('.cn')) &&
          (server.contains('114.114.114.114') || server.contains('223.5.5.5'));
    });
    final dnsDetail = [
      if (dns.enhancedMode == DnsMode.fakeIp || dns.nameserver.isNotEmpty)
        strings.businessProxyDnsRemote,
      if (mainlandPolicy) strings.businessRegionLocalDns,
    ].join(' · ');
    final route = ref.watch(routeTrackerProvider);
    final outboundResult = outboundDiagnosticResult(
      active: active,
      entry: outbound,
      route: route,
    );
    final outboundFresh = outboundResult == DiagnosticResult.passed;
    final checks = <_DiagnosticCheck>[
      _DiagnosticCheck(
        title: strings.core,
        result: active && coreStatus == CoreStatus.connected
            ? DiagnosticResult.passed
            : active && coreStatus == CoreStatus.disconnected
            ? DiagnosticResult.failed
            : DiagnosticResult.unverified,
        detail: switch ((active, coreStatus)) {
          (true, CoreStatus.connected) => strings.connected,
          (true, CoreStatus.disconnected) => strings.disconnected,
          _ => null,
        },
      ),
      _DiagnosticCheck(
        title: strings.profile,
        result: profile == null
            ? DiagnosticResult.failed
            : DiagnosticResult.passed,
        detail: profile?.realLabel,
      ),
      _DiagnosticCheck(
        title: strings.diagnosticsSelection,
        result: active
            ? _selectionResult(selection)
            : DiagnosticResult.unverified,
        detail: active
            ? _selectionDetail(
                strings,
                selection,
                actual: localizedRegion(
                  strings,
                  outbound.value?.exit?.countryCode,
                ),
                expected: localizedRegion(
                  strings,
                  selectedNode?.expectedExit?.countryCode,
                ),
              )
            : null,
        detailIsVerdict:
            selection == SelectionVerdict.egressMismatch ||
            selection == SelectionVerdict.egressAnomaly,
      ),
      _DiagnosticCheck(
        title: strings.outboundIp,
        result: outboundResult,
        detail: outboundFresh
            ? outbound.value?.ip
            : outboundResult == DiagnosticResult.failed
            ? strings.serviceFailed
            : null,
      ),
      for (final target in _diagnosticServices)
        _serviceCheck(
          strings,
          target,
          services.entryOf(target),
          active: active,
          route: route,
        ),
    ];
    final passed = checks
        .where((check) => check.result == DiagnosticResult.passed)
        .length;
    final failed = checks
        .where((check) => check.result == DiagnosticResult.failed)
        .length;
    final unverified = checks.length - passed - failed;
    final counts = Row(
      spacing: 8,
      children: [
        Expanded(
          child: _DiagnosticCount(
            value: passed,
            label: strings.diagnosticsPassed,
            result: DiagnosticResult.passed,
            mobile: widget.mobileLayout,
          ),
        ),
        Expanded(
          child: _DiagnosticCount(
            value: failed,
            label: strings.diagnosticsFailed,
            result: DiagnosticResult.failed,
            mobile: widget.mobileLayout,
          ),
        ),
        Expanded(
          child: _DiagnosticCount(
            value: unverified,
            label: strings.diagnosticsUnverified,
            result: DiagnosticResult.unverified,
            mobile: widget.mobileLayout,
          ),
        ),
      ],
    );
    if (widget.mobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          counts,
          Card(
            radius: AppCorner.xl,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < checks.length; index++) ...[
                  _DiagnosticRow(check: checks[index], mobile: true),
                  if (index < checks.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
          if (dnsDetail.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                dnsDetail,
                style: AppTextStyle.footnote
                    .of(context)
                    .copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
            ),
        ],
      );
    }
    return Card(
      radius: AppCorner.xl,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.diagnosticsTitle,
                  style: BusinessText.cardTitle(context),
                ),
              ),
              if (widget.showRunButton)
                BusinessPrimaryButton(
                  label: hasResult
                      ? strings.diagnosticsRunAgain
                      : strings.diagnosticsStart,
                  width: 122,
                  onPressed: isLoading ? null : widget.onRun,
                ),
            ],
          ),
          const SizedBox(height: 14),
          counts,
          const SizedBox(height: 10),
          for (final check in checks) _DiagnosticRow(check: check),
          if (dnsDetail.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              dnsDetail,
              style: AppTextStyle.footnote
                  .of(context)
                  .copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

bool _isLoading(WidgetRef ref) {
  final services = ref.watch(serviceStatusProvider);
  return _diagnosticServices.any(services.isLoading) ||
      ref.watch(outboundIpProbeProvider).isLoading(routedOutbound);
}

bool _hasDiagnosticResult(WidgetRef ref) {
  final services = ref.watch(serviceStatusProvider);
  final outbound = ref.watch(outboundIpProbeProvider);
  return _diagnosticServices.any(
        (target) => services.entryOf(target).phase != ProbePhase.empty,
      ) ||
      outbound.entryOf(routedOutbound).phase != ProbePhase.empty;
}

_DiagnosticCheck _serviceCheck(
  AppLocalizations strings,
  ServiceTarget target,
  ProbeEntry<ServiceCheck> entry, {
  required bool active,
  required RouteState route,
}) {
  final result = serviceDiagnosticResult(
    active: active,
    entry: entry,
    route: route,
  );
  final fresh =
      result != DiagnosticResult.unverified && entry.phase == ProbePhase.fresh;
  final check = fresh ? entry.value : null;
  final detail = result == DiagnosticResult.failed && !fresh
      ? strings.serviceFailed
      : check == null
      ? null
      : _serviceStatusLabel(strings, check.status);
  final delay = check?.delay;
  return _DiagnosticCheck(
    title: target.label,
    result: result,
    detail: !fresh && result != DiagnosticResult.failed
        ? detail
        : delay == null
        ? detail
        : '$detail · $delay ms',
  );
}

@visibleForTesting
DiagnosticResult serviceDiagnosticResult({
  required bool active,
  required ProbeEntry<ServiceCheck> entry,
  required RouteState route,
}) {
  if (!active) return DiagnosticResult.unverified;
  if (entry.phase == ProbePhase.failed) {
    final stamp = entry.stamp;
    return stamp == null || route.isFresh(stamp)
        ? DiagnosticResult.failed
        : DiagnosticResult.unverified;
  }
  final fresh =
      entry.phase == ProbePhase.fresh &&
      entry.stamp != null &&
      route.isFresh(entry.stamp!);
  if (!fresh) return DiagnosticResult.unverified;
  return entry.value?.status == ServiceProbeStatus.available
      ? DiagnosticResult.passed
      : DiagnosticResult.failed;
}

@visibleForTesting
DiagnosticResult outboundDiagnosticResult({
  required bool active,
  required ProbeEntry<IpInfo> entry,
  required RouteState route,
}) {
  if (!active) return DiagnosticResult.unverified;
  if (entry.phase == ProbePhase.failed) {
    final stamp = entry.stamp;
    return stamp == null || route.isFresh(stamp)
        ? DiagnosticResult.failed
        : DiagnosticResult.unverified;
  }
  final stamp = entry.stamp;
  if (entry.phase != ProbePhase.fresh ||
      stamp == null ||
      !route.isFresh(stamp) ||
      entry.value == null) {
    return DiagnosticResult.unverified;
  }
  return DiagnosticResult.passed;
}

String _serviceStatusLabel(
  AppLocalizations strings,
  ServiceProbeStatus status,
) => switch (status) {
  ServiceProbeStatus.available => strings.serviceAvailable,
  ServiceProbeStatus.restricted => strings.serviceRestricted,
  ServiceProbeStatus.unavailable => strings.serviceUnavailable,
  ServiceProbeStatus.disallowedIsp => strings.serviceDisallowedIsp,
  ServiceProbeStatus.blocked => strings.serviceBlocked,
  ServiceProbeStatus.unsupportedRegion => strings.serviceUnsupportedRegion,
  ServiceProbeStatus.originalsOnly => strings.serviceOriginalsOnly,
  ServiceProbeStatus.comingSoon => strings.serviceComingSoon,
  ServiceProbeStatus.timeout => strings.timeout,
  ServiceProbeStatus.failed => strings.serviceFailed,
};

DiagnosticResult _selectionResult(SelectionVerdict selection) =>
    switch (selection) {
      SelectionVerdict.consistent => DiagnosticResult.passed,
      SelectionVerdict.failed ||
      SelectionVerdict.notCaptured ||
      SelectionVerdict.residentialLocked ||
      SelectionVerdict.groupOverridden ||
      SelectionVerdict.trafficNotOnTianji ||
      SelectionVerdict.egressMismatch ||
      SelectionVerdict.egressAnomaly => DiagnosticResult.failed,
      SelectionVerdict.untouched ||
      SelectionVerdict.confirming ||
      SelectionVerdict.unknownPending ||
      SelectionVerdict.unknown => DiagnosticResult.unverified,
      SelectionVerdict.egressPending => DiagnosticResult.unverified,
    };

String _selectionDetail(
  AppLocalizations strings,
  SelectionVerdict selection, {
  required String actual,
  required String expected,
}) => switch (selection) {
  SelectionVerdict.untouched => strings.servicePending,
  SelectionVerdict.confirming => strings.selectionConfirming,
  SelectionVerdict.failed => strings.serviceFailed,
  SelectionVerdict.consistent => strings.connected,
  SelectionVerdict.notCaptured => strings.selectionNotCaptured,
  SelectionVerdict.residentialLocked => strings.selectionResidentialLocked,
  SelectionVerdict.groupOverridden => strings.selectionGroupOverridden,
  SelectionVerdict.unknownPending => strings.selectionUnknownPending,
  SelectionVerdict.unknown => strings.selectionUnknown,
  SelectionVerdict.egressPending => strings.selectionConfirming,
  SelectionVerdict.trafficNotOnTianji => strings.businessTrafficNotOnTianji,
  SelectionVerdict.egressMismatch =>
    actual == expected
        ? strings.businessExitKindMismatch
        : strings.businessExitCountryMismatch(actual, expected),
  SelectionVerdict.egressAnomaly => strings.businessExitAnomaly,
};

class _DiagnosticCount extends StatelessWidget {
  const _DiagnosticCount({
    required this.value,
    required this.label,
    required this.result,
    required this.mobile,
  });

  final int value;
  final String label;
  final DiagnosticResult result;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final color = _resultColor(context, result);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.1),
        shape: AppShape.md,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: mobile ? 12 : 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              style: BusinessText.diagnosticsCount(
                context,
                mobile: mobile,
              ).copyWith(color: color),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: BusinessText.diagnosticsCountLabel(
                context,
                mobile: mobile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagnosticRow extends StatelessWidget {
  const _DiagnosticRow({required this.check, this.mobile = false});

  final _DiagnosticCheck check;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final strings = context.appLocalizations;
    final color = _resultColor(context, check.result);
    final glyph = switch (check.result) {
      DiagnosticResult.passed => AppGlyphs.check,
      DiagnosticResult.failed => AppGlyphs.close,
      DiagnosticResult.unverified => AppGlyphs.remove,
    };
    final status = switch (check.result) {
      DiagnosticResult.passed => strings.diagnosticsPassed,
      DiagnosticResult.failed => strings.diagnosticsFailed,
      DiagnosticResult.unverified => strings.diagnosticsUnverified,
    };
    final showDetail =
        check.detail != null &&
        check.detail != strings.servicePending &&
        check.detail != status &&
        (check.result == DiagnosticResult.unverified ||
            (check.result == DiagnosticResult.failed &&
                check.title == strings.diagnosticsSelection));
    final content = Row(
      crossAxisAlignment: mobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      spacing: 10,
      children: [
        SizedBox.square(
          dimension: 22,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(child: GlyphIcon(glyph, size: 13, color: color)),
          ),
        ),
        Expanded(
          child: Text(
            check.title,
            style: BusinessText.diagnosticsCheckTitle(context, mobile: mobile),
          ),
        ),
        Text(
          check.detailIsVerdict
              ? check.detail ?? status
              : showDetail
              ? '$status（${check.detail}）'
              : status,
          style: BusinessText.metaLabel(context).copyWith(color: color),
        ),
      ],
    );
    if (mobile) {
      return SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: content,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: content,
    );
  }
}

Color _resultColor(BuildContext context, DiagnosticResult result) =>
    switch (result) {
      DiagnosticResult.passed => context.colorScheme.success,
      DiagnosticResult.failed => context.colorScheme.error,
      DiagnosticResult.unverified => context.colorScheme.onSurfaceVariant,
    };
