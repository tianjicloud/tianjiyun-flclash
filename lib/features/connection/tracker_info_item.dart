import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'detail_tabs.dart';
import 'mitm_exchanges.dart';

String _endpointText(String ip, String port) {
  if (ip.isEmpty) {
    return '';
  }
  if (port.isNotEmpty) {
    return '$ip:$port';
  }
  return ip;
}

void showTrackerInfoDetail(
  BuildContext context,
  TrackerInfo trackerInfo,
  String title, {
  ValueChanged<TrackerInfo>? onClose,
}) {
  showSheet<void>(
    context: context,
    props: nestedPagedSheetProps,
    builder: (_) => NestedPagedSheet(
      builder: (sheetContext) {
        final business =
            BusinessTheme.of(sheetContext) ||
            isTianjiSubscriptionProfile(
              ProviderScope.containerOf(
                sheetContext,
                listen: false,
              ).read(currentProfileProvider),
            );
        final detail = TrackerInfoDetailView(
          trackerInfo: trackerInfo,
          onClose: onClose,
          isBusiness: business,
        );
        if (!business) return Scaffold(body: detail, title: title);
        final macOS = MacOSStyle.of(sheetContext);
        return Scaffold(
          body: macOS
              ? Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MacOSMetrics.narrowPageWidth(
                        sheetContext,
                        fallback: double.infinity,
                      ),
                    ),
                    child: detail,
                  ),
                )
              : detail,
          title: title,
          businessTitleInset: macOS,
          headerMaxWidth: macOS
              ? MacOSMetrics.narrowPageWidth(
                  sheetContext,
                  fallback: double.infinity,
                )
              : null,
          backAction: macOS ? () => sheetContext.safeNestedPop() : null,
          preferBackButton: macOS,
        );
      },
    ),
  );
}

List<PopupMenuItem> trackerInfoMenuItems(
  BuildContext context,
  TrackerInfo trackerInfo, {
  ValueChanged<TrackerInfo>? onClose,
}) {
  final appLocalizations = context.appLocalizations;
  final metadata = trackerInfo.metadata;
  final destination = _endpointText(
    metadata.destinationIP,
    metadata.destinationPort,
  );
  Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    dialogs.showBanner(currentAppLocalizations.copySuccess);
  }

  return [
    if (metadata.host.isNotEmpty)
      PopupMenuItem(
        glyph: AppGlyphs.copy,
        label: appLocalizations.copyHost,
        onPressed: () => copy(metadata.host),
      ),
    if (destination.isNotEmpty)
      PopupMenuItem(
        glyph: AppGlyphs.copy,
        label: appLocalizations.copyDestination,
        onPressed: () => copy(destination),
      ),
    if (onClose != null)
      PopupMenuItem(
        glyph: AppGlyphs.block,
        label: appLocalizations.closeConnection,
        section: const PopupMenuSection(),
        onPressed: () => onClose(trackerInfo),
      ),
  ];
}

class TrackerInfoItem extends ConsumerWidget {
  final TrackerInfo trackerInfo;
  final bool isLive;
  final ValueChanged<TrackerInfo>? onClose;
  final String detailTitle;

  /// What the detail opens on, where a memoized row outlives its traffic.
  final ValueGetter<TrackerInfo>? latest;

  const TrackerInfoItem({
    super.key,
    required this.trackerInfo,
    this.isLive = false,
    this.onClose,
    required this.detailTitle,
    this.latest,
  });

  @override
  Widget build(BuildContext context, ref) {
    final showIcon = ref.watch(
      patchClashConfigProvider.select(
        (state) =>
            state.findProcessMode == FindProcessMode.always && system.isAndroid,
      ),
    );
    return ContextMenuRegion(
      menuItems: trackerInfoMenuItems(context, trackerInfo, onClose: onClose),
      child: RecordListItem(
        onTap: () => showTrackerInfoDetail(
          context,
          latest?.call() ?? trackerInfo,
          detailTitle,
          onClose: onClose,
        ),
        header: _buildHeader(context),
        body: _TrackerInfoBody(trackerInfo: trackerInfo, showIcon: showIcon),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final network = Text(
      trackerInfo.metadata.network.toUpperCase(),
      style: AppTextStyle.caption1
          .of(context, emphasized: true)
          .copyWith(color: context.colorScheme.onSurfaceVariant),
    );
    final mitm = trackerInfo.metadata.mitm;
    if (!isLive) {
      return RecordHeader(
        children: [
          RecordTimestamp(trackerInfo.start.showFull),
          network,
          if (mitm) const RecordLabel(label: 'MITM'),
        ],
      );
    }
    final color = context.colorScheme.onSurfaceVariant;
    WidgetSpan arrow(Glyph glyph) => WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: GlyphIcon(glyph, size: 12, color: color),
    );
    return RecordHeader(
      trailing: Text.rich(
        TextSpan(
          children: [
            arrow(AppGlyphs.arrowUp),
            TextSpan(
              text: ' ${(trackerInfo.uploadSpeed ?? 0).traffic.show}/s   ',
            ),
            arrow(AppGlyphs.arrowDown),
            TextSpan(
              text: ' ${(trackerInfo.downloadSpeed ?? 0).traffic.show}/s',
            ),
          ],
        ),
      ),
      children: [
        Text(trackerInfo.start.getLastUpdateTimeDesc(context, compact: true)),
        network,
        if (mitm) const RecordLabel(label: 'MITM'),
      ],
    );
  }
}

class _TrackerInfoBody extends StatelessWidget {
  final TrackerInfo trackerInfo;
  final bool showIcon;

  const _TrackerInfoBody({required this.trackerInfo, required this.showIcon});

  Widget _buildTitle(BuildContext context, RecordTextStyles styles) {
    final metadata = trackerInfo.metadata;
    final title = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: _endpointText(trackerInfo.title, metadata.destinationPort),
            style: styles.title,
          ),
          if (metadata.host.isNotEmpty && metadata.destinationIP.isNotEmpty)
            TextSpan(
              text: '  ${metadata.destinationIP}',
              style: styles.secondary,
            ),
        ],
      ),
    );
    final process = metadata.process;
    if (!showIcon || process.isEmpty) {
      return title;
    }
    return Row(
      spacing: 8,
      children: [
        GestureDetector(
          onTap: () => RecordFilterScope.add(
            context,
            RecordFilter(RecordFacetKind.app, process),
          ),
          child: PackageIcon(packageName: process, size: 24),
        ),
        Flexible(child: title),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final styles = RecordTextStyles.of(context);
    final metadata = trackerInfo.metadata;
    final rule = trackerInfo.ruleText;
    final source = [
      trackerInfo.progressText,
      _endpointText(metadata.sourceIP, metadata.sourcePort),
    ].where((text) => text.isNotEmpty).join('  ·  ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        _buildTitle(context, styles),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (rule.isNotEmpty) Text(rule, style: styles.secondary),
            for (final (index, chain) in trackerInfo.chains.reversed.indexed)
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  if (index > 0 || rule.isNotEmpty) const RecordArrow(),
                  Flexible(
                    child: TonalChip(
                      label: chain,
                      color: context.raisedSurfaceLevel.colorOf(colorScheme),
                      foregroundColor: colorScheme.onSurfaceVariant,
                      onPressed: () => RecordFilterScope.add(
                        context,
                        RecordFilter(RecordFacetKind.proxy, chain),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        if (source.isNotEmpty) Text(source, style: styles.secondary),
      ],
    );
  }
}

/// Adds the host of a connection to the hostnames or excludes it, so that the
/// list can be filled from what the apps really connect to.
class _MitmHostSection extends ConsumerWidget {
  final Metadata metadata;

  const _MitmHostSection({required this.metadata});

  Future<void> _confirm(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String tip,
    required Mitm Function(Mitm) update,
  }) async {
    final res = await dialogs.showMessage(
      title: title,
      message: TextSpan(text: tip),
    );
    if (res != true) {
      return;
    }
    ref
        .read(patchClashConfigProvider.notifier)
        .update((state) => state.copyWith(mitm: update(state.mitm)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host = metadata.host;
    final (enable, hostname) = ref.watch(
      patchClashConfigProvider.select(
        (state) => (state.mitm.enable, state.mitm.hostname),
      ),
    );
    if (!enable || host.isEmpty || metadata.network.toLowerCase() != 'tcp') {
      return const SizedBox.shrink();
    }
    final appLocalizations = context.appLocalizations;
    final decrypted = metadata.mitm || metadata.mitmRefused;
    final excludes =
        !hostname.contains('-$host') && (decrypted || hostname.contains(host));
    final title = excludes
        ? appLocalizations.mitmExcludeHost
        : appLocalizations.mitmDecryptHost;
    return generateSection(
      title: appLocalizations.mitm,
      items: [
        ListItem(
          title: Text(title),
          onTap: () => _confirm(
            context,
            ref,
            title: title,
            tip: excludes
                ? appLocalizations.mitmExcludeHostTip(host)
                : appLocalizations.mitmDecryptHostTip(host),
            update: (mitm) =>
                excludes ? mitm.excludingHost(host) : mitm.decryptingHost(host),
          ),
        ),
      ],
      footer: metadata.mitmRefused
          ? appLocalizations.mitmClientRefusedCertificate
          : null,
    );
  }
}

class TrackerInfoDetailView extends ConsumerWidget {
  final TrackerInfo trackerInfo;
  final ValueChanged<TrackerInfo>? onClose;
  final bool isBusiness;

  const TrackerInfoDetailView({
    super.key,
    required this.trackerInfo,
    this.onClose,
    this.isBusiness = false,
  });

  Widget _buildChains(BuildContext context) {
    return DetailRow(
      title: context.appLocalizations.proxyChains,
      value: Wrap(
        spacing: 6,
        runSpacing: 4,
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final (index, chain) in trackerInfo.chains.reversed.indexed)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                if (index > 0) const RecordArrow(),
                Flexible(child: MetaChip(label: chain)),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRows(List<(String, String)> entries) {
    return [
      for (final (title, value) in entries)
        if (value.isNotEmpty) DetailRow.text(title: title, value: value),
    ];
  }

  Widget _buildOverview(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final metadata = trackerInfo.metadata;
    final route = <(String, String)>[
      if (trackerInfo.progressText.isNotEmpty)
        (appLocalizations.process, trackerInfo.progressText),
      if (trackerInfo.ruleText.isNotEmpty)
        (appLocalizations.rule, trackerInfo.ruleText),
      for (final chain in trackerInfo.chains.reversed)
        (appLocalizations.outboundExit, chain),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
              bottom: onClose == null ? 20 + context.bottomInset : 12,
              top: context.sectionsTopPadding,
            ),
            children: [
              _ConnectionHeading(trackerInfo: trackerInfo),
              if (route.isNotEmpty) _ConnectionRouteCard(route: route),
              generateSection(
                title: appLocalizations.basicInfo,
                items: _buildRows([
                  (appLocalizations.creationTime, trackerInfo.start.showFull),
                  (appLocalizations.networkType, metadata.network),
                  (appLocalizations.rule, trackerInfo.ruleText),
                  (appLocalizations.upload, trackerInfo.upload.traffic.show),
                  (
                    appLocalizations.download,
                    trackerInfo.download.traffic.show,
                  ),
                ]),
              ),
              generateSection(
                title: appLocalizations.address,
                items: _buildRows([
                  (
                    appLocalizations.destinationGeoIP,
                    metadata.destinationGeoIP.join(' '),
                  ),
                  (
                    appLocalizations.destinationIPASN,
                    metadata.destinationIPASN,
                  ),
                  (
                    appLocalizations.remoteDestination,
                    metadata.remoteDestination,
                  ),
                ]),
              ),
              generateSection(
                title: appLocalizations.proxies,
                items: [
                  ..._buildRows([
                    (appLocalizations.specialProxy, metadata.specialProxy),
                    (appLocalizations.specialRules, metadata.specialRules),
                    (appLocalizations.dnsMode, metadata.dnsMode?.name ?? ''),
                  ]),
                  _buildChains(context),
                ],
              ),
              if (mitmFeature) _MitmHostSection(metadata: metadata),
            ],
          ),
        ),
        if (onClose != null)
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + context.bottomInset),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => onClose!(trackerInfo),
                child: Text(appLocalizations.closeConnection),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isBusiness) {
      return _BusinessTrackerInfoDetailView(
        trackerInfo: trackerInfo,
        onClose: onClose,
      );
    }
    final appLocalizations = context.appLocalizations;
    final capturing =
        trackerInfo.metadata.mitm &&
        ref.watch(
          patchClashConfigProvider.select(
            (state) => state.mitm.enable && state.mitm.capture,
          ),
        );
    return DetailTabs(
      tabs: [
        (appLocalizations.overview, _buildOverview),
        if (capturing)
          (
            appLocalizations.httpRequests,
            (_) => MitmExchangesView(trackerInfo: trackerInfo),
          ),
      ],
    );
  }
}

class _BusinessTrackerInfoDetailView extends ConsumerWidget {
  const _BusinessTrackerInfoDetailView({
    required this.trackerInfo,
    required this.onClose,
  });

  final TrackerInfo trackerInfo;
  final ValueChanged<TrackerInfo>? onClose;

  Future<void> _addDomainRule(BuildContext context, WidgetRef ref) async {
    final profile = ref.read(currentProfileProvider);
    final host = trackerInfo.metadata.host;
    if (profile == null || host.isEmpty) return;
    final rule = await showFormSheet<Rule>(
      context: context,
      builder: (_) => RuleForm(rule: Rule.init().copyWith(content: host)),
    );
    if (rule != null) {
      ref.read(profileRulesProvider(profile.id).notifier).put(rule);
    }
  }

  String _duration() {
    if (trackerInfo.rule.toUpperCase() == RuleTarget.REJECT.value ||
        trackerInfo.start.millisecondsSinceEpoch <= 0) {
      return '—';
    }
    final elapsed = DateTime.now().difference(trackerInfo.start);
    if (elapsed.isNegative) return '—';
    final seconds = elapsed.inSeconds;
    final minutes = seconds ~/ 60;
    if (seconds >= 3600) {
      return '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  String _traffic(int bytes) {
    final value = bytes.traffic.show;
    final match = RegExp(r'^([\d.]+)(.*)$').firstMatch(value);
    if (match == null || match.group(2)!.isEmpty) return value;
    return '${match.group(1)} ${match.group(2)}';
  }

  Widget _header(BuildContext context) {
    final metadata = trackerInfo.metadata;
    final process = trackerInfo.progressText;
    final endpoint = _endpointText(
      metadata.host.isNotEmpty ? metadata.host : metadata.destinationIP,
      metadata.destinationPort,
    );
    final network = metadata.network.toUpperCase();
    final secondary = context.colorScheme.onSurfaceVariant;
    final initials = process.isEmpty ? '•' : process.characters.first;
    return Row(
      spacing: 12,
      children: [
        SizedBox.square(
          dimension: 40,
          child: ClipRSuperellipse(
            borderRadius: AppRadius.all(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: BusinessPalette.blue,
                  child: Center(
                    child: Text(
                      initials.toUpperCase(),
                      style: AppTextStyle.subheadline
                          .of(context, emphasized: true)
                          .copyWith(color: BusinessPalette.onBlue),
                    ),
                  ),
                ),
                if (process.isNotEmpty)
                  PackageIcon(packageName: process, size: 40),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                process.isEmpty ? endpoint : process,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: BusinessText.metaValue(context),
              ),
              Text(
                '$endpoint · $network',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.footnote
                    .of(context)
                    .toJetBrainsMono
                    .copyWith(color: secondary),
              ),
            ],
          ),
        ),
        if (!MacOSStyle.of(context))
          SizedBox.square(
            dimension: 32,
            child: IconButton(
              tooltip: context.appLocalizations.close,
              padding: EdgeInsets.zero,
              onPressed: context.safeNestedPop,
              icon: GlyphIcon(AppGlyphs.close, color: secondary, size: 16),
              style: ButtonStyle.from(
                shape: AppShape.circle,
                backgroundColor: context.colorScheme.surfaceContainerHigh,
              ),
            ),
          ),
      ],
    );
  }

  Widget _pathCard(BuildContext context) {
    final chains = trackerInfo.chains;
    final groups = chains.length > 1
        ? chains.take(chains.length - 1)
        : const <String>[];
    final exit = chains.isEmpty ? '' : chains.last;
    final rule = [
      trackerInfo.rule,
      trackerInfo.rulePayload,
    ].where((value) => value.isNotEmpty).join(' ');
    final ruleTarget = trackerInfo.metadata.specialProxy;
    final ruleText = ruleTarget.isEmpty ? rule : '$ruleTarget · $rule';
    final scheme = context.colorScheme;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: scheme.brightness == Brightness.light
            ? BusinessPalette.sidebarLight
            : scheme.surfaceContainerHigh,
        shape: AppShape.md,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.appLocalizations.connectionTrafficPath,
              style: AppTextStyle.footnote
                  .of(context)
                  .copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            _PathLine(
              label: context.appLocalizations.connectionLocalDevice,
              value: trackerInfo.progressText,
            ),
            _PathLine(
              label: context.appLocalizations.connectionMatchedRule,
              value: ruleText,
              highlighted: true,
            ),
            if (groups.isNotEmpty)
              _PathLine(
                label: context.appLocalizations.connectionGroup,
                value: groups.join(' → '),
              ),
            if (exit.isNotEmpty) _PathLine(value: exit, finalStep: true),
          ],
        ),
      ),
    );
  }

  Widget _detailRows(BuildContext context) {
    final metadata = trackerInfo.metadata;
    final source = _endpointText(metadata.sourceIP, metadata.sourcePort);
    final destination = metadata.destinationIP;
    final target = destination.isEmpty
        ? ''
        : metadata.dnsMode == DnsMode.fakeIp
        ? '$destination (fake-ip)'
        : destination;
    final traffic =
        '${_traffic(trackerInfo.download)} / ${_traffic(trackerInfo.upload)}';
    final entries = <(String, String)>[
      (
        context.appLocalizations.connectionStartTime,
        trackerInfo.start.showTime.trim(),
      ),
      (context.appLocalizations.connectionSustained, _duration()),
      (
        '${context.appLocalizations.download} / ${context.appLocalizations.upload}',
        traffic,
      ),
      (context.appLocalizations.connectionSourceAddress, source),
      (context.appLocalizations.connectionTargetIp, target),
      (context.appLocalizations.connectionProcessPath, metadata.processPath),
      (context.appLocalizations.connectionSniffedDomain, metadata.host),
    ];
    final visible = entries.where((entry) => entry.$2.isNotEmpty).toList();
    final secondary = context.colorScheme.onSurfaceVariant;
    return Column(
      children: [
        for (final (index, entry) in visible.indexed)
          Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 40),
                child: Row(
                  spacing: 12,
                  children: [
                    Text(
                      entry.$1,
                      style: BusinessText.actionLabel(
                        context,
                      ).copyWith(color: secondary),
                    ),
                    Expanded(
                      child: Text(
                        entry.$2,
                        textAlign: TextAlign.end,
                        maxLines:
                            entry.$1 ==
                                context.appLocalizations.connectionProcessPath
                            ? 2
                            : 1,
                        overflow: TextOverflow.ellipsis,
                        style: BusinessText.actionLabel(
                          context,
                        ).toJetBrainsMono,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < visible.length - 1)
                ColoredBox(
                  color: context.colorScheme.outlineVariant.withValues(
                    alpha: 0.35,
                  ),
                  child: const SizedBox(height: 1, width: double.infinity),
                ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final canAddRule = profile != null && trackerInfo.metadata.host.isNotEmpty;
    final scheme = context.colorScheme;
    return ColoredBox(
      color: scheme.brightness == Brightness.light
          ? scheme.surfaceBright
          : scheme.surface,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 14),
                  _pathCard(context),
                  _detailRows(context),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 24 + context.bottomInset),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final count = (canAddRule ? 1 : 0) + (onClose != null ? 1 : 0);
                final width = count == 0
                    ? 0.0
                    : (constraints.maxWidth - 8 * (count - 1)) / count;
                return Row(
                  spacing: 8,
                  children: [
                    if (canAddRule)
                      BusinessSecondaryButton(
                        label: context.appLocalizations.connectionAddDomainRule,
                        width: width,
                        height: 40,
                        onPressed: () => _addDomainRule(context, ref),
                      ),
                    if (onClose != null)
                      BusinessSecondaryButton(
                        label: context.appLocalizations.connectionCloseThis,
                        width: width,
                        height: 40,
                        labelColor: scheme.error,
                        onPressed: () => onClose!(trackerInfo),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PathLine extends StatelessWidget {
  const _PathLine({
    this.label,
    required this.value,
    this.highlighted = false,
    this.finalStep = false,
  });

  final String? label;
  final String value;
  final bool highlighted;
  final bool finalStep;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final labelStyle = BusinessText.connectionPath(context);
    final valueStyle = BusinessText.connectionPath(
      context,
      emphasized: finalStep,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          SizedBox(
            width: 12,
            height: 28,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (!finalStep)
                  Positioned(
                    top: 14,
                    bottom: 0,
                    child: ColoredBox(
                      color: scheme.brightness == Brightness.light
                          ? BusinessPalette.timelineLine
                          : BusinessPalette.blue.withValues(alpha: 0.34),
                      child: const SizedBox(width: 1.5),
                    ),
                  ),
                Positioned(
                  top: 2,
                  child: SizedBox.square(
                    dimension: 12,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: finalStep
                            ? BusinessPalette.blue
                            : scheme.brightness == Brightness.light
                            ? BusinessPalette.sidebarLight
                            : scheme.surfaceContainerHigh,
                        shape: AppShape.circle.copyWith(
                          side: BorderSide(
                            color: BusinessPalette.blue,
                            width: finalStep ? 0 : 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: label == null
                  ? Text(value, style: valueStyle)
                  : highlighted
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Text(label!, style: labelStyle),
                        Flexible(
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: scheme.primaryContainer,
                              shape: AppShape.full,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyle.caption1
                                    .of(context)
                                    .copyWith(color: scheme.onPrimaryContainer),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '${label!} ', style: labelStyle),
                          TextSpan(text: value, style: valueStyle),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionHeading extends StatelessWidget {
  const _ConnectionHeading({required this.trackerInfo});

  final TrackerInfo trackerInfo;

  @override
  Widget build(BuildContext context) {
    final metadata = trackerInfo.metadata;
    final process = trackerInfo.progressText;
    final target = _endpointText(trackerInfo.title, metadata.destinationPort);
    final source = _endpointText(metadata.sourceIP, metadata.sourcePort);
    final destination = _endpointText(
      metadata.destinationIP,
      metadata.destinationPort,
    );
    return Card(
      radius: AppCorner.lg,
      padding: const EdgeInsets.all(14),
      child: Row(
        spacing: 12,
        children: [
          if (process.isNotEmpty)
            PackageIcon(packageName: process, size: 40)
          else
            SizedBox.square(
              dimension: 40,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: context.raisedSurfaceLevel.colorOf(
                    context.colorScheme,
                  ),
                  shape: AppShape.md,
                ),
                child: Center(
                  child: GlyphIcon(
                    AppGlyphs.connections,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                if (process.isNotEmpty)
                  Text(
                    process,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.title3.of(context, emphasized: true),
                  ),
                Text(
                  target,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.subheadline.of(context),
                ),
                if (metadata.host.isNotEmpty)
                  Text(
                    metadata.host,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.footnote.of(context),
                  ),
                Text(
                  '${metadata.network.toUpperCase()} · ${trackerInfo.start.showFull}',
                  style: AppTextStyle.footnote
                      .of(context)
                      .copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
                if (source.isNotEmpty)
                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        '${context.appLocalizations.source} ·',
                        style: AppTextStyle.footnote
                            .of(context)
                            .copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Flexible(
                        child: Text(
                          source,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.footnote.of(context),
                        ),
                      ),
                    ],
                  ),
                if (destination.isNotEmpty)
                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        '${context.appLocalizations.destination} ·',
                        style: AppTextStyle.footnote
                            .of(context)
                            .copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Flexible(
                        child: Text(
                          destination,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.footnote.of(context),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionRouteCard extends StatelessWidget {
  const _ConnectionRouteCard({required this.route});

  final List<(String, String)> route;

  @override
  Widget build(BuildContext context) {
    return Card(
      radius: AppCorner.lg,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            context.appLocalizations.proxyChains,
            style: AppTextStyle.subheadline.of(context, emphasized: true),
          ),
          for (final (index, (label, value)) in route.indexed)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: ShapeDecoration(
                        color: index == route.length - 1
                            ? context.colorScheme.primary
                            : context.colorScheme.surfaceContainerHighest,
                        shape: const CircleBorder(),
                      ),
                    ),
                    if (index < route.length - 1)
                      Container(
                        width: 2,
                        height: 16,
                        color: context.colorScheme.surfaceContainerHighest,
                      ),
                  ],
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$label · ',
                          style: TextStyle(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextSpan(text: value),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
