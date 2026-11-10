import 'dart:math';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';

import 'tracker_info_item.dart';

const _fullLiveTableWidth = 1200.0;

List<RecordColumn<TrackerInfo>> trackerInfoColumns(
  BuildContext context, {
  required double width,
  required bool isLive,
  bool isBusiness = false,
}) {
  final appLocalizations = context.appLocalizations;
  final wide = width >= recordWideTableWidth;
  if (isLive && isBusiness) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return [
      RecordColumn(
        TableColumn('process', appLocalizations.app, width: 120),
        cell: (_, info) => RecordCellText(info.metadata.process),
        sortKey: (info) => info.metadata.process.toLowerCase(),
      ),
      RecordColumn(
        TableColumn('target', appLocalizations.target, flex: 1.9),
        cell: (_, info) => TrackerTargetText(info, mono: true),
        sortKey: (info) => info.title.toLowerCase(),
      ),
      RecordColumn(
        TableColumn('rule', appLocalizations.rule, flex: 1),
        cell: (context, info) => TrackerRuleChip(trackerInfo: info),
        sortKey: (info) => '${info.rule} ${info.rulePayload}'.toLowerCase(),
      ),
      RecordColumn(
        TableColumn('exit', appLocalizations.outboundExit, width: 140),
        cell: (context, info) => _ExitText(
          exit: _isRejected(info)
              ? appLocalizations.connectionBlockedLabel
              : info.chains.lastOrNull ?? '',
        ),
        sortKey: (info) => (info.chains.lastOrNull ?? '').toLowerCase(),
      ),
      _amountColumn(
        'download',
        appLocalizations.download,
        (info) => info.download,
        width: 104 * textScale,
        speedOf: (info) => info.downloadSpeed ?? 0,
      ),
      _amountColumn(
        'upload',
        appLocalizations.upload,
        (info) => info.upload,
        width: 96 * textScale,
        speedOf: (info) => info.uploadSpeed ?? 0,
      ),
      RecordColumn(
        TableColumn(
          'duration',
          appLocalizations.duration,
          width: 84 * textScale,
          end: true,
        ),
        cell: (_, info) =>
            RecordCellText(_connectionDuration(info), mono: true),
        sortKey: (info) => -info.start.microsecondsSinceEpoch,
        descendingFirst: true,
      ),
    ];
  }
  // A live table spends its first extra width on the totals.
  final detailed = wide && (!isLive || width >= _fullLiveTableWidth);
  double totalWidth(String label) => max(88, recordHeaderWidth(context, label));
  return [
    if (!isLive)
      RecordColumn(
        TableColumn('time', appLocalizations.time, width: 80),
        cell: (_, info) =>
            RecordCellText(info.start.showTime.trim(), muted: true),
        sortKey: (info) => info.start,
        descendingFirst: true,
      ),
    RecordColumn(
      TableColumn('process', appLocalizations.process, width: wide ? 160 : 140),
      cell: (_, info) => RecordCellText(info.progressText),
      sortKey: (info) => info.progressText.toLowerCase(),
    ),
    RecordColumn(
      TableColumn('target', appLocalizations.target, flex: wide ? 1.4 : 1.3),
      cell: (_, info) => TrackerTargetText(info),
      sortKey: (info) => info.title.toLowerCase(),
    ),
    if (detailed)
      RecordColumn(
        TableColumn(
          'protocol',
          appLocalizations.protocol,
          width: max(56, recordHeaderWidth(context, appLocalizations.protocol)),
        ),
        cell: (_, info) =>
            RecordCellText(info.metadata.network.toUpperCase(), muted: true),
        sortKey: (info) => info.metadata.network.toLowerCase(),
      ),
    if (wide || !isLive)
      RecordColumn(
        TableColumn('rule', appLocalizations.rule, flex: 1),
        cell: (_, info) => TrackerRuleText(info),
        sortKey: (info) => '${info.rule} ${info.rulePayload}'.toLowerCase(),
      ),
    RecordColumn(
      TableColumn('exit', appLocalizations.outboundExit, width: 120),
      cell: (_, info) => _ExitChip(exit: info.chains.firstOrNull ?? ''),
      sortKey: (info) => (info.chains.firstOrNull ?? '').toLowerCase(),
    ),
    if (isLive) ...[
      _amountColumn(
        'downloadSpeed',
        appLocalizations.download,
        (info) => info.downloadSpeed ?? 0,
        perSecond: true,
      ),
      _amountColumn(
        'uploadSpeed',
        appLocalizations.upload,
        (info) => info.uploadSpeed ?? 0,
        perSecond: true,
      ),
    ],
    if (isLive && wide) ...[
      _amountColumn(
        'download',
        appLocalizations.totalDownload,
        (info) => info.download,
        width: totalWidth(appLocalizations.totalDownload),
      ),
      _amountColumn(
        'upload',
        appLocalizations.totalUpload,
        (info) => info.upload,
        width: totalWidth(appLocalizations.totalUpload),
      ),
    ] else if (wide) ...[
      _amountColumn(
        'download',
        appLocalizations.download,
        (info) => info.download,
      ),
      _amountColumn('upload', appLocalizations.upload, (info) => info.upload),
    ] else
      _amountColumn(
        'traffic',
        appLocalizations.traffic,
        (info) => info.upload + info.download,
        width: 88,
      ),
    if (isLive && detailed)
      RecordColumn(
        TableColumn(
          'duration',
          appLocalizations.duration,
          width: 80,
          end: true,
        ),
        cell: (_, info) => RecordCellText(
          trackerDurationText(DateTime.now().difference(info.start)),
          muted: true,
        ),
        sortKey: (info) => -info.start.microsecondsSinceEpoch,
        descendingFirst: true,
      ),
  ];
}

RecordColumn<TrackerInfo> _amountColumn(
  String id,
  String label,
  int Function(TrackerInfo info) amountOf, {
  double width = 100,
  bool perSecond = false,
  int Function(TrackerInfo info)? speedOf,
}) {
  return RecordColumn(
    TableColumn(id, label, width: width, end: true),
    cell: (_, info) {
      final amount = amountOf(info);
      final value = speedOf == null
          ? amount.traffic.show
          : trackerTrafficText(amount);
      final cell = RecordCellText(
        perSecond ? '$value/s' : value,
        muted: perSecond && amount == 0,
        mono: speedOf != null,
      );
      final speed = speedOf?.call(info);
      return speed == null
          ? cell
          : Tooltip(message: '${trackerTrafficText(speed)}/s', child: cell);
    },
    sortKey: amountOf,
    descendingFirst: true,
  );
}

String trackerTrafficText(int amount) {
  final value = amount.traffic.show;
  final match = RegExp(r'^([\d.]+)(.*)$').firstMatch(value);
  if (match == null || match.group(2)!.isEmpty) {
    return value;
  }
  return '${match.group(1)} ${match.group(2)}';
}

bool _isRejected(TrackerInfo trackerInfo) =>
    trackerInfo.rule.toUpperCase() == 'REJECT';

String _connectionDuration(TrackerInfo trackerInfo) {
  if (_isRejected(trackerInfo) ||
      trackerInfo.start.millisecondsSinceEpoch == 0) {
    return '—';
  }
  final duration = DateTime.now().difference(trackerInfo.start);
  if (duration.isNegative) {
    return '00:00';
  }
  String twoDigits(int value) => value.toString().padLeft(2, '0');
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  if (duration.inHours > 0) {
    return '${duration.inHours}:${twoDigits(minutes % 60)}:${twoDigits(seconds)}';
  }
  return '${twoDigits(minutes)}:${twoDigits(seconds)}';
}

String trackerDurationText(Duration duration) {
  final seconds = duration.inSeconds;
  if (seconds < 60) {
    return '${seconds < 0 ? 0 : seconds} s';
  }
  final minutes = seconds / 60;
  if (minutes < 60) {
    return '${minutes < 10 ? minutes.toStringAsFixed(1) : minutes.round()} min';
  }
  return '${(minutes / 60).toStringAsFixed(1)} h';
}

class TrackerInfoTableRow extends StatelessWidget {
  final TrackerInfo trackerInfo;
  final RecordTable<TrackerInfo> table;
  final bool striped;
  final String detailTitle;
  final ValueChanged<TrackerInfo>? onClose;

  const TrackerInfoTableRow({
    super.key,
    required this.trackerInfo,
    required this.table,
    required this.striped,
    required this.detailTitle,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      menuItems: trackerInfoMenuItems(context, trackerInfo, onClose: onClose),
      child: RecordTableRow(
        table: table,
        striped: striped,
        onTap: () => showTrackerInfoDetail(
          context,
          trackerInfo,
          detailTitle,
          onClose: onClose,
        ),
        cells: table.cellsOf(context, trackerInfo),
      ),
    );
  }
}

class _ExitText extends StatelessWidget {
  final String exit;

  const _ExitText({required this.exit});

  @override
  Widget build(BuildContext context) {
    return PressRegion(
      onTap:
          exit.isEmpty ||
              exit == context.appLocalizations.connectionBlockedLabel
          ? null
          : () => RecordFilterScope.add(
              context,
              RecordFilter(RecordFacetKind.proxy, exit),
            ),
      child: RecordCellText(exit),
    );
  }
}

class _ExitChip extends StatelessWidget {
  final String exit;

  const _ExitChip({required this.exit});

  @override
  Widget build(BuildContext context) {
    if (exit.isEmpty) {
      return const RecordCellText('');
    }
    final colorScheme = context.colorScheme;
    return TonalChip(
      label: exit,
      color: context.raisedSurfaceLevel.colorOf(colorScheme),
      foregroundColor: colorScheme.onSurfaceVariant,
      onPressed: () => RecordFilterScope.add(
        context,
        RecordFilter(RecordFacetKind.proxy, exit),
      ),
    );
  }
}

class TrackerRuleChip extends StatelessWidget {
  final TrackerInfo trackerInfo;

  const TrackerRuleChip({super.key, required this.trackerInfo});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final strings = context.appLocalizations;
    final (
      label,
      fill,
      foreground,
    ) = trackerInfo.rule == strings.businessAiServiceLabel
        ? (
            strings.businessAiServiceLabel,
            colors.primaryContainer,
            colors.onPrimaryContainer,
          )
        : trackerInfo.rule == strings.businessMainlandDirect
        ? (
            strings.businessMainlandDirect,
            BusinessPalette.connectedContainerFor(colors.brightness),
            BusinessPalette.connectedForegroundFor(colors.brightness),
          )
        : _isRejected(trackerInfo)
        ? (
            strings.connectionBlockedLabel,
            colors.errorContainer,
            colors.onErrorContainer,
          )
        : (
            trackerInfo.rule,
            context.raisedSurfaceLevel.colorOf(colors),
            colors.onSurfaceVariant,
          );
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(color: fill, shape: AppShape.full),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.caption1
            .of(context, emphasized: true)
            .copyWith(color: foreground),
      ),
    );
  }
}

class TrackerTargetText extends StatelessWidget {
  final TrackerInfo trackerInfo;
  final bool mono;

  const TrackerTargetText(this.trackerInfo, {super.key, this.mono = false});

  @override
  Widget build(BuildContext context) {
    final port = trackerInfo.metadata.destinationPort;
    final target = port.isEmpty
        ? trackerInfo.title
        : '${trackerInfo.title}:$port';
    final text = mono
        ? Text(
            target,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.footnote
                .of(context)
                .toJetBrainsMono
                .copyWith(color: context.colorScheme.onSurface),
          )
        : Text.rich(
            TextSpan(
              children: [
                TextSpan(text: trackerInfo.title),
                if (port.isNotEmpty)
                  TextSpan(
                    text: ':$port',
                    style: TextStyle(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
    if (!trackerInfo.metadata.mitm) {
      return text;
    }
    return Row(
      spacing: 6,
      children: [
        Flexible(child: text),
        const RecordLabel(label: 'MITM'),
      ],
    );
  }
}

class TrackerRuleText extends StatelessWidget {
  final TrackerInfo trackerInfo;

  const TrackerRuleText(this.trackerInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: trackerInfo.rule,
            style: TextStyle(color: context.colorScheme.onSurfaceVariant),
          ),
          if (trackerInfo.rulePayload.isNotEmpty)
            TextSpan(text: ' ${trackerInfo.rulePayload}'),
        ],
      ),
    );
  }
}
