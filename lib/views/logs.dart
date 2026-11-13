import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/views/diagnostics.dart';
import 'package:fl_clash/views/dashboard/widgets/segmented.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;
import 'package:fl_clash/views/dns_queries.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogListController extends ValueNotifier<LogsState> {
  LogListController() : super(const LogsState());

  void search(String query) {
    value = value.copyWith(query: query);
  }

  void setLogs(List<Log> logs) {
    if (identical(logs, value.logs)) {
      return;
    }
    value = value.copyWith(
      logs: value.autoScrollToEnd
          ? logs
          : retainTrimmedHead(value.logs, logs, pausedMaxLogsLength),
    );
  }

  void setAutoScrollToEnd(bool autoScrollToEnd) {
    value = value.copyWith(autoScrollToEnd: autoScrollToEnd);
  }

  void resumeAutoScrollToEnd(List<Log> logs) {
    value = value.copyWith(autoScrollToEnd: true, logs: logs);
  }
}

class LogsView extends ConsumerStatefulWidget {
  const LogsView({super.key});

  @override
  ConsumerState<LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends ConsumerState<LogsView>
    with RouteMotionHoldMixin<LogsView> {
  var _showDns = false;
  final _listController = LogListController();
  final _filters = RecordFilterController<Log>(facets: logFacets);
  late final ScrollController _scrollController;
  late final _physics = FollowEndScrollPhysics(
    isFollowing: () => _listController.value.autoScrollToEnd,
  );

  LogLevel? get _selectedLevel {
    for (final filter in _filters.filters) {
      if (filter.kind != RecordFacetKind.level) continue;
      for (final level in LogLevel.values) {
        if (filter.value == level.name) return level;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = sheetScrollController(
      context,
      initialScrollOffset: double.maxFinite,
    );
    _setLogs(ref.read(logsProvider).list);
    ref.listenManual(logsProvider.select((state) => state.revision), (_, _) {
      updateLogsThrottler();
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    _filters.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleExport() async {
    final appLocalizations = context.appLocalizations;
    final res = await globalState.safeRun<bool>(() async {
      return ref.read(logsProvider.notifier).exportLogs();
    }, title: appLocalizations.exportLogs);
    if (res != true) return;
    unawaited(
      dialogs.showAlert(
        title: appLocalizations.tip,
        message: TextSpan(text: appLocalizations.exportSuccess),
      ),
    );
  }

  void _setLogs(List<Log> logs) {
    _listController.setLogs(logs);
    _filters.offer(_listController.value.logs);
  }

  void updateLogsThrottler() {
    throttler.call(FunctionTag.logs, () {
      if (!mounted) {
        return;
      }
      updateWhenRouteSettled(() => _setLogs(ref.read(logsProvider).list));
    }, duration: renderThrottleDuration);
  }

  @override
  Widget build(BuildContext context) {
    final body = RecordFilterScope(
      onFilter: _filters.add,
      child: _buildBody(context),
    );
    return ListenableBuilder(
      listenable: Listenable.merge([_filters, _filters.options]),
      child: body,
      builder: (context, body) {
        final pinned = !ViewScope.isMobileOf(context);
        return Scaffold(
          businessTitleInset: true,
          keywords: pinned ? null : _filters.keywordsOf(pinned: false),
          menuItems: _filters.menuItems(context, pinned: pinned),
          searchState: AppBarSearchState(onSearch: _listController.search),
          title: context.appLocalizations.logsAndDiagnostics,
          body: body!,
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return ListenableBuilder(
      listenable: Listenable.merge([_listController, _filters]),
      builder: (context, _) {
        final state = _listController.value;
        final logs = _filters.apply(state.list);
        final feed = NullStatusSwitcher(
          isEmpty: logs.isEmpty,
          isSearching: state.isSearching || _filters.isFiltering,
          nullStatus: NullStatus(
            illustration: NullStatusIllustration.logs,
            label: appLocalizations.nullTip(appLocalizations.logs),
          ),
          child: _buildList(context, state, logs),
        );
        return LayoutBuilder(
          builder: (context, constraints) {
            if (!system.isDesktop || constraints.maxWidth < 1000) {
              if (MacOSStyle.of(context)) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MacOSMetrics.pageContentInset(
                          context,
                          fallback: 16,
                        ),
                        vertical: 8,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          appLocalizations.itemsCount(logs.length),
                          style: BusinessText.metaLabel(context),
                        ),
                      ),
                    ),
                    Expanded(child: feed),
                  ],
                );
              }
              return feed;
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(
                MacOSMetrics.pageMargin(context, fallback: 28),
                context.contentTopPadding,
                MacOSMetrics.pageMargin(context, fallback: 28),
                MacOSMetrics.pageMargin(context, fallback: 24) +
                    context.bottomInset,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 14,
                children: [
                  SizedBox(
                    width: 430,
                    child: DiagnosticsPanel(
                      onRun: () => refreshDiagnostics(ref),
                    ),
                  ),
                  Expanded(child: _logCard(context, feed, logs.length)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _logCard(BuildContext context, Widget feed, int count) {
    final appLocalizations = context.appLocalizations;
    return Card(
      radius: MacOSMetrics.cardRadius(context, fallback: AppCorner.xl),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 12, 10),
            child: Row(
              children: [
                if (MacOSStyle.of(context))
                  Text(
                    appLocalizations.itemsCount(count),
                    style: BusinessText.metaLabel(context),
                  ),
                if (MacOSStyle.of(context)) const SizedBox(width: 8),
                BusinessSegmented<bool>(
                  height: MacOSMetrics.segmentedHeight(context, fallback: 30),
                  items: [
                    BusinessSegment(
                      value: false,
                      label: appLocalizations.logsRunning,
                    ),
                    BusinessSegment(
                      value: true,
                      label: appLocalizations.dnsQueries,
                    ),
                  ],
                  selected: _showDns,
                  onSelected: (value) {
                    if (value) {
                      BaseNavigator.push(context, const DnsQueriesView());
                    }
                    setState(() => _showDns = value);
                  },
                ),
                const Spacer(),
                BusinessSegmented<LogLevel?>(
                  height: MacOSMetrics.segmentedHeight(context, fallback: 30),
                  items: [
                    BusinessSegment(value: null, label: appLocalizations.all),
                    BusinessSegment(
                      value: LogLevel.info,
                      label: appLocalizations.logFilterInfo,
                    ),
                    BusinessSegment(
                      value: LogLevel.warning,
                      label: appLocalizations.logFilterWarning,
                    ),
                    BusinessSegment(
                      value: LogLevel.error,
                      label: appLocalizations.logFilterError,
                    ),
                  ],
                  selected: _selectedLevel,
                  onSelected: (level) {
                    for (final item in LogLevel.values) {
                      _filters.remove(
                        RecordFilter(RecordFacetKind.level, item.name),
                      );
                    }
                    if (level != null) {
                      _filters.add(
                        RecordFilter(RecordFacetKind.level, level.name),
                      );
                    }
                  },
                ),
                const SizedBox(width: 4),
                BusinessSecondaryButton(
                  label: appLocalizations.exportShort,
                  width: 62,
                  height: MacOSMetrics.buttonHeight(context, fallback: 30),
                  onPressed: _handleExport,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: Text(
              appLocalizations.logRedactionNotice,
              style: AppTextStyle.caption2
                  .of(context)
                  .copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(child: feed),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, LogsState state, List<Log> logs) {
    final padding = EdgeInsets.only(
      top: system.isDesktop && MediaQuery.sizeOf(context).width >= 1000
          ? 8
          : context.contentTopPadding,
      bottom: 16 + context.bottomInset,
    );
    return Align(
      alignment: Alignment.topCenter,
      child: FloatingScrollbar(
        controller: _scrollController,
        hintBuilder: (fraction) {
          final index = (fraction * (logs.length - 1)).round();
          return logs[index].dateTime;
        },
        child: ScrollToEndBox(
          onCancelToEnd: () {
            _listController.setAutoScrollToEnd(false);
          },
          onResumeToEnd: () {
            _listController.resumeAutoScrollToEnd(ref.read(logsProvider).list);
            _filters.offer(_listController.value.logs);
          },
          controller: _scrollController,
          enable: state.autoScrollToEnd,
          child: RecordFeedList<Log>(
            physics: _physics,
            reverse: true,
            shrinkWrap: true,
            controller: _scrollController,
            padding: padding,
            items: logs,
            keyOf: ObjectKey.new,
            gap: system.isDesktop && MediaQuery.sizeOf(context).width >= 1000
                ? 1
                : recordListGap,
            estimatedItemExtent: recordListEstimatedExtent,
            itemBuilder: (log, _, _) => MemoBuilder(
              inputs: [log],
              builder: (_) => LogItem(log: log),
            ),
          ),
        ),
      ),
    );
  }
}

class LogItem extends StatelessWidget {
  final Log log;

  const LogItem({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final warning = log.logLevel == LogLevel.warning;
    final error = log.logLevel == LogLevel.error;
    final brightness = context.colorScheme.brightness;
    final background = warning
        ? brightness == Brightness.dark
              ? Color.alphaBlend(
                  BusinessPalette.warning.withValues(alpha: 0.12),
                  context.colorScheme.surfaceContainer,
                )
              : BusinessPalette.warningContainerFor(brightness)
        : error
        ? brightness == Brightness.dark
              ? Color.alphaBlend(
                  context.colorScheme.error.withValues(alpha: 0.12),
                  context.colorScheme.surfaceContainer,
                )
              : context.colorScheme.errorContainer.withValues(alpha: 0.28)
        : null;
    final levelColor = warning
        ? BusinessPalette.warningForegroundFor(brightness)
        : error
        ? context.colorScheme.error
        : BusinessPalette.residentialChipText;
    final level = switch (log.logLevel) {
      LogLevel.warning => 'WARN',
      _ => log.logLevel.name.toUpperCase(),
    };
    return DecoratedBox(
      decoration: ShapeDecoration(color: background, shape: AppShape.sm),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 10, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            SizedBox(
              width: 64,
              child: Text(
                log.dateTime,
                style: BusinessText.logTimestamp(context),
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: 44,
              child: GestureDetector(
                onTap: () => RecordFilterScope.add(
                  context,
                  RecordFilter(RecordFacetKind.level, log.logLevel.name),
                ),
                child: Text(
                  level,
                  style: BusinessText.logLevel(
                    context,
                  ).copyWith(color: levelColor),
                ),
              ),
            ),
            Expanded(
              child: Text(
                log.payload,
                style: BusinessText.logBody(context),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
