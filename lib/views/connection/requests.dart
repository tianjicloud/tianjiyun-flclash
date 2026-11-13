import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/features.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/segmented.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ShapeBorder _connectionCardShape(BuildContext context) =>
    AppShape.all(MacOSMetrics.cardRadius(context, fallback: 18));

class RequestsView extends ConsumerStatefulWidget {
  final ScrollController? scrollController;
  final RequestFeed? initialFeed;
  final Future<List<TrackerInfo>> Function()? connectionsReader;

  const RequestsView({
    super.key,
    this.scrollController,
    this.initialFeed,
    @visibleForTesting this.connectionsReader,
  });

  @override
  ConsumerState<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends ConsumerState<RequestsView>
    with RouteMotionHoldMixin<RequestsView> {
  final _recent = TrackerInfoListController();
  final _live = TrackerInfoListController();
  final _liveFeed = GlobalKey<_LiveFeedState>();
  late final _filters = trackerInfoFilterController(ref, 'requests');
  late var _feed =
      widget.initialFeed ?? ref.read(appSettingProvider).requestFeed;

  @override
  void initState() {
    super.initState();
    if (_feed == RequestFeed.recent) {
      _showLatestRequests();
    }
    ref.listenManual(requestsProvider.select((state) => state.revision), (
      _,
      _,
    ) {
      updateRequestsThrottler();
    });
  }

  @override
  void dispose() {
    _recent.dispose();
    _live.dispose();
    _filters.dispose();
    super.dispose();
  }

  void _setRequests(List<TrackerInfo> requests) {
    _recent.setTrackerInfos(requests);
    _filters.offer(_recent.value.trackerInfos);
  }

  void _showLatestRequests() {
    _recent.resumeAutoScrollToEnd(ref.read(requestsProvider).list);
    _filters.offer(_recent.value.trackerInfos);
  }

  void updateRequestsThrottler() {
    throttler.call(FunctionTag.requests, () {
      if (!mounted || _feed != RequestFeed.recent) {
        return;
      }
      updateWhenRouteSettled(
        () => _setRequests(ref.read(requestsProvider).list),
      );
    }, duration: renderThrottleDuration);
  }

  void _search(String query) {
    _recent.search(query);
    _live.search(query);
  }

  void _selectFeed(RequestFeed feed) {
    if (feed == _feed) {
      return;
    }
    // Offered before the feed mounts: a build below this page can't notify it.
    if (feed == RequestFeed.recent) {
      _showLatestRequests();
    }
    setState(() => _feed = feed);
    if (widget.initialFeed == null) {
      ref
          .read(appSettingProvider.notifier)
          .update((state) => state.copyWith(requestFeed: feed));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusiness =
        BusinessTheme.of(context) ||
        isTianjiSubscriptionProfile(ref.watch(currentProfileProvider));
    final body = RecordFilterScope(
      onFilter: _filters.add,
      child: ListenableBuilder(
        listenable: _filters,
        builder: (_, _) => _buildBody(isBusiness: isBusiness),
      ),
    );
    return ListenableBuilder(
      listenable: Listenable.merge([_filters, _filters.options]),
      child: body,
      builder: (context, body) {
        final pinned = !ViewScope.isMobileOf(context);
        final businessMobile = isBusiness && !pinned;
        return Scaffold(
          businessTitleInset: isBusiness,
          title: pinned || businessMobile ? null : _labelOf(_feed),
          titleWidget: pinned
              ? _buildTitleWidget(context)
              : businessMobile
              ? Text(
                  context.appLocalizations.connectionsAndRequests,
                  style: AppTextStyle.pageTitle.of(context, emphasized: true),
                )
              : null,
          searchState: pinned || businessMobile
              ? null
              : AppBarSearchState(onSearch: _search),
          keywords: pinned ? null : _filters.keywordsOf(pinned: false),
          actions: _feed == RequestFeed.live && (pinned || businessMobile)
              ? [
                  TonalButton(
                    size: TonalButtonSize.compact,
                    label: businessMobile
                        ? context.appLocalizations.businessCloseAllConnections
                        : context.appLocalizations.closeAllConnections,
                    onPressed: () => _liveFeed.currentState?.closeAll(),
                  ),
                ]
              : const [],
          iconActions: !pinned && !businessMobile ? _buildActions() : const [],
          menuItems: _filters.menuItems(context, pinned: pinned),
          body: AppBarClearance(
            child: Column(
              children: [
                if (pinned)
                  _buildControls(
                    context,
                    horizontalInset: isBusiness
                        ? MacOSMetrics.pageMargin(context, fallback: 28)
                        : 16,
                  )
                else if (businessMobile)
                  _buildBusinessMobileControls(context)
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    child: _buildMobileFeedSelector(context),
                  ),
                if (pinned &&
                    isBusiness &&
                    MacOSStyle.of(context) &&
                    _feed == RequestFeed.live)
                  ValueListenableBuilder<TrackerInfosState>(
                    valueListenable: _live,
                    builder: (context, _, _) => _buildLiveSummary(context, 28),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: pinned && isBusiness && _feed == RequestFeed.live
                          ? MacOSMetrics.pageMargin(context, fallback: 28)
                          : 0,
                      right: pinned && isBusiness && _feed == RequestFeed.live
                          ? MacOSMetrics.pageMargin(context, fallback: 28)
                          : 0,
                      bottom: pinned && isBusiness && _feed == RequestFeed.live
                          ? MacOSMetrics.pageMargin(context, fallback: 12)
                          : 0,
                    ),
                    child: body!,
                  ),
                ),
                if (_feed == RequestFeed.live &&
                    (pinned || !isBusiness) &&
                    !(pinned && isBusiness && MacOSStyle.of(context)))
                  ValueListenableBuilder<TrackerInfosState>(
                    valueListenable: _live,
                    builder: (context, _, _) => _buildLiveSummary(
                      context,
                      pinned && isBusiness ? 28 : 16,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<IconButtonData> _buildActions() {
    if (_feed != RequestFeed.live) {
      return const [];
    }
    return [
      IconButtonData(
        glyph: AppGlyphs.clearAll,
        tooltip: context.appLocalizations.closeConnections,
        onPressed: () => _liveFeed.currentState?.closeAll(),
      ),
    ];
  }

  Widget _buildBusinessMobileControls(BuildContext context) {
    final options = _filters.options.value;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          ValueListenableBuilder<TrackerInfosState>(
            valueListenable: _live,
            builder: (context, state, _) => BusinessSegmented<RequestFeed>(
              key: const ValueKey('requestFeedSelector'),
              selected: _feed,
              height: 32,
              expand: true,
              mobile: true,
              items: [
                BusinessSegment(
                  value: RequestFeed.live,
                  label:
                      '${context.appLocalizations.connectionsLiveShort} · ${state.trackerInfos.length}',
                ),
                BusinessSegment(
                  value: RequestFeed.recent,
                  label: context.appLocalizations.recentRequests,
                ),
              ],
              onSelected: _selectFeed,
            ),
          ),
          _filterBar(
            context,
            options[RecordFacetKind.network] ?? const [],
            options[RecordFacetKind.rule] ?? const [],
            options[RecordFacetKind.proxy] ?? const [],
            mobile: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFeedSelector(BuildContext context) {
    return ValueListenableBuilder<TrackerInfosState>(
      valueListenable: _live,
      builder: (context, _, _) => SegmentedControl<RequestFeed>(
        key: const ValueKey('requestFeedSelector'),
        segments: [
          (RequestFeed.live, context.appLocalizations.running),
          (RequestFeed.recent, context.appLocalizations.recentRequests),
        ],
        value: _feed,
        onChanged: _selectFeed,
      ),
    );
  }

  String _labelOf(RequestFeed feed) => switch (feed) {
    RequestFeed.recent => context.appLocalizations.recentRequests,
    RequestFeed.live => context.appLocalizations.running,
  };

  Widget _buildTitleWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Text(
          context.appLocalizations.connections,
          style: AppTextStyle.pageTitle.of(context, emphasized: true),
        ),
        ValueListenableBuilder<TrackerInfosState>(
          valueListenable: _live,
          builder: (context, state, _) {
            final count = state.trackerInfos.length;
            return _RequestFeedSelector(
              value: _feed,
              liveLabel: '${context.appLocalizations.liveConnections} · $count',
              recentLabel: context.appLocalizations.recentRequests,
              onChanged: _selectFeed,
            );
          },
        ),
      ],
    );
  }

  Widget _buildControls(
    BuildContext context, {
    required double horizontalInset,
  }) {
    final options = _filters.options.value;
    final networkOptions = options[RecordFacetKind.network] ?? const <String>[];
    final ruleOptions = options[RecordFacetKind.rule] ?? const <String>[];
    final proxyOptions = options[RecordFacetKind.proxy] ?? const <String>[];
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: EdgeInsets.fromLTRB(horizontalInset, 8, horizontalInset, 10),
        child: constraints.maxWidth < 760
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  _searchField(context, width: double.infinity),
                  _filterBar(
                    context,
                    networkOptions,
                    ruleOptions,
                    proxyOptions,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 8,
                    children: [
                      Text(
                        context.appLocalizations.groupBy,
                        style: AppTextStyle.footnote
                            .of(context)
                            .copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                      ),
                      _groupingSelector(),
                    ],
                  ),
                ],
              )
            : Row(
                spacing: 8,
                children: [
                  _searchField(context, width: 280),
                  Expanded(
                    child: _filterBar(
                      context,
                      networkOptions,
                      ruleOptions,
                      proxyOptions,
                    ),
                  ),
                  Text(
                    context.appLocalizations.groupBy,
                    style: AppTextStyle.footnote
                        .of(context)
                        .copyWith(color: context.colorScheme.onSurfaceVariant),
                  ),
                  _groupingSelector(),
                ],
              ),
      ),
    );
  }

  Widget _searchField(BuildContext context, {required double width}) {
    final height = MacOSMetrics.inputHeight(context, fallback: 34);
    return SizedBox(
      width: width,
      height: height,
      child: SearchField(
        height: height,
        fill: context.raisedSurfaceLevel.colorOf(context.colorScheme),
        hintText: context.appLocalizations.connectionSearchHint,
        onChanged: _search,
      ),
    );
  }

  Widget _filterBar(
    BuildContext context,
    List<String> networkOptions,
    List<String> ruleOptions,
    List<String> proxyOptions, {
    bool mobile = false,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ValueListenableBuilder<RecordFilterState>(
        valueListenable: _filters,
        builder: (context, state, _) => Row(
          spacing: 6,
          children: [
            _filterChip(
              context.appLocalizations.all,
              selected: state.filters.isEmpty,
              mobile: mobile,
              onPressed: () {
                for (final filter in [..._filters.filters]) {
                  _filters.remove(filter);
                }
              },
            ),
            for (final network in networkOptions)
              _filterChip(
                _filters.facetOf(RecordFacetKind.network)?.label(network) ??
                    network,
                selected: state.filters.contains(
                  RecordFilter(RecordFacetKind.network, network),
                ),
                mobile: mobile,
                onPressed: () => _filters.toggle(
                  RecordFilter(RecordFacetKind.network, network),
                ),
              ),
            for (final rule in ruleOptions)
              _filterChip(
                _filters.facetOf(RecordFacetKind.rule)?.label(rule) ?? rule,
                selected: state.filters.contains(
                  RecordFilter(RecordFacetKind.rule, rule),
                ),
                mobile: mobile,
                onPressed: () =>
                    _filters.toggle(RecordFilter(RecordFacetKind.rule, rule)),
              ),
            for (final proxy in proxyOptions)
              _filterChip(
                _filters.facetOf(RecordFacetKind.proxy)?.label(proxy) ?? proxy,
                selected: state.filters.contains(
                  RecordFilter(RecordFacetKind.proxy, proxy),
                ),
                mobile: mobile,
                onPressed: () =>
                    _filters.toggle(RecordFilter(RecordFacetKind.proxy, proxy)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _groupingSelector() => _RequestGroupingSelector(
    value: _filters.value.grouping ?? RecordGrouping.app,
    onChanged: _filters.setGrouping,
  );

  Widget _filterChip(
    String label, {
    required bool selected,
    required VoidCallback onPressed,
    bool mobile = false,
  }) {
    final colorScheme = context.colorScheme;
    return PressSurface(
      fill: selected
          ? colorScheme.onSurface
          : context.raisedSurfaceLevel.colorOf(colorScheme),
      shape: AppShape.full,
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: MacOSMetrics.chipHeight(context, fallback: mobile ? 34 : 30),
        child: Center(
          child: Text(
            label,
            style: (mobile ? AppTextStyle.caption1 : AppTextStyle.footnote)
                .of(context, emphasized: true)
                .copyWith(
                  color: selected ? colorScheme.surface : colorScheme.onSurface,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveSummary(BuildContext context, double horizontalInset) {
    final connections = _live.value.trackerInfos;
    var download = 0;
    var upload = 0;
    for (final connection in connections) {
      download += connection.downloadSpeed ?? 0;
      upload += connection.uploadSpeed ?? 0;
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalInset,
        6,
        horizontalInset,
        12 + context.bottomInset,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          context.appLocalizations.connectionSummary(
            connections.length,
            '${trackerTrafficText(download)}/s',
            '${trackerTrafficText(upload)}/s',
          ),
          style: AppTextStyle.footnote
              .of(context)
              .copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }

  Widget _buildBody({required bool isBusiness}) {
    return switch (_feed) {
      RequestFeed.recent => _RecentFeed(
        listController: _recent,
        filters: _filters,
        scrollController: widget.scrollController,
        onResumeToEnd: _showLatestRequests,
      ),
      RequestFeed.live => _LiveFeed(
        key: _liveFeed,
        listController: _live,
        filters: _filters,
        scrollController: widget.scrollController,
        connectionsReader: widget.connectionsReader,
        isBusiness: isBusiness,
      ),
    };
  }
}

class _RequestFeedSelector extends StatelessWidget {
  final RequestFeed value;
  final String liveLabel;
  final String recentLabel;
  final ValueChanged<RequestFeed> onChanged;

  const _RequestFeedSelector({
    required this.value,
    required this.liveLabel,
    required this.recentLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BusinessSegmented<RequestFeed>(
      selected: value,
      height: 28,
      items: [
        BusinessSegment(value: RequestFeed.live, label: liveLabel),
        BusinessSegment(value: RequestFeed.recent, label: recentLabel),
      ],
      onSelected: onChanged,
      key: const ValueKey('requestFeedSelector'),
    );
  }
}

class _RequestGroupingSelector extends StatelessWidget {
  final RecordGrouping value;
  final ValueChanged<RecordGrouping?> onChanged;

  const _RequestGroupingSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BusinessSegmented<RecordGrouping>(
      selected: value,
      height: 28,
      items: [
        for (final grouping in RecordGrouping.values)
          BusinessSegment(
            value: grouping,
            label: grouping == RecordGrouping.host
                ? context.appLocalizations.domain
                : grouping.label,
          ),
      ],
      onSelected: onChanged,
    );
  }
}

class _RecentFeed extends StatefulWidget {
  final TrackerInfoListController listController;
  final RecordFilterController<TrackerInfo> filters;
  final ScrollController? scrollController;
  final VoidCallback onResumeToEnd;

  const _RecentFeed({
    required this.listController,
    required this.filters,
    required this.scrollController,
    required this.onResumeToEnd,
  });

  @override
  State<_RecentFeed> createState() => _RecentFeedState();
}

class _RecentFeedState extends State<_RecentFeed> {
  late final ScrollController _scrollController;
  late final _physics = FollowEndScrollPhysics(
    isFollowing: () => widget.listController.value.autoScrollToEnd,
  );

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.scrollController ??
        sheetScrollController(context, initialScrollOffset: double.maxFinite);
    // A sheet's one controller may have been left where the live feed reads.
    if (widget.scrollController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return ValueListenableBuilder<TrackerInfosState>(
      valueListenable: widget.listController,
      builder: (context, state, _) {
        final requests = widget.filters.apply(state.list);
        return NullStatusSwitcher(
          isEmpty: requests.isEmpty,
          isSearching: state.isSearching || widget.filters.isFiltering,
          nullStatus: NullStatus(
            label: appLocalizations.nullTip(appLocalizations.requests),
            illustration: NullStatusIllustration.requests,
          ),
          child: RecordTableFrame<TrackerInfo>(
            tableId: 'requests',
            items: requests,
            reverse: true,
            columnsOf: (width) =>
                trackerInfoColumns(context, width: width, isLive: false),
            builder: (context, table, requests) {
              final padding = EdgeInsets.only(
                top: context.contentTopPadding,
                bottom: 16 + context.bottomInset,
              );
              final detailTitle = appLocalizations.details(
                appLocalizations.request,
              );
              final groups = widget.filters.groupsOf(requests, reverse: true);
              if (groups != null) {
                return FloatingScrollbar(
                  controller: _scrollController,
                  hintBuilder: (fraction) {
                    final index = (fraction * (groups.length - 1)).round();
                    return groups[index].items.first.start.showFull;
                  },
                  child: TrackerInfoGroupedList(
                    groups: groups,
                    grouping: widget.filters.value.grouping!,
                    isLive: false,
                    controller: _scrollController,
                    padding: padding,
                    table: table,
                    detailTitle: detailTitle,
                  ),
                );
              }
              return Align(
                alignment: Alignment.topCenter,
                child: FloatingScrollbar(
                  controller: _scrollController,
                  hintBuilder: (fraction) {
                    final index = (fraction * (requests.length - 1)).round();
                    return requests[index].start.showFull;
                  },
                  child: ScrollToEndBox(
                    controller: _scrollController,
                    enable: state.autoScrollToEnd,
                    onCancelToEnd: () {
                      widget.listController.setAutoScrollToEnd(false);
                    },
                    onResumeToEnd: () {
                      widget.onResumeToEnd();
                    },
                    child: TrackerInfoList(
                      reverse: true,
                      shrinkWrap: true,
                      physics: _physics,
                      controller: _scrollController,
                      padding: padding,
                      trackerInfos: requests,
                      table: table,
                      detailTitle: detailTitle,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _LiveFeed extends ConsumerStatefulWidget {
  final TrackerInfoListController listController;
  final RecordFilterController<TrackerInfo> filters;
  final ScrollController? scrollController;
  final Future<List<TrackerInfo>> Function()? connectionsReader;
  final bool isBusiness;

  const _LiveFeed({
    super.key,
    required this.listController,
    required this.filters,
    required this.scrollController,
    required this.connectionsReader,
    required this.isBusiness,
  });

  @override
  ConsumerState<_LiveFeed> createState() => _LiveFeedState();
}

class _LiveFeedState extends ConsumerState<_LiveFeed>
    with
        WidgetsBindingObserver,
        ActivePollingMixin<_LiveFeed>,
        RouteMotionHoldMixin<_LiveFeed> {
  CoreController get _core => ref.read(coreHandlerProvider);

  final _speedRanker = TrackerSpeedRanker();
  late final ScrollController _scrollController;
  var _loaded = false;
  // A sheet's one controller opens where the recent feed reads, its far end.
  late var _startsAtFarEnd = widget.scrollController != null;

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.scrollController ?? sheetScrollController(context);
  }

  @override
  Duration get pollInterval => const Duration(seconds: 1);

  Future<void> closeAll() => _close(_core.closeConnections);

  @override
  Future<void> poll(PollGuard isCurrent) async {
    final trackerInfos = await _readConnections();
    if (!isCurrent()) {
      return;
    }
    _showConnections(trackerInfos);
  }

  Future<void> _refreshConnections() async {
    final trackerInfos = await _readConnections();
    if (!mounted) {
      return;
    }
    _showConnections(trackerInfos);
  }

  Future<List<TrackerInfo>?> _readConnections() async {
    try {
      final connectionsReader = widget.connectionsReader;
      if (connectionsReader != null) {
        return await connectionsReader();
      }
      return ref.read(coreStatusProvider) == CoreStatus.connected
          ? await _core.getConnections()
          : const [];
    } catch (error) {
      commonPrint.log(
        'updateConnections error: $error',
        logLevel: coreFailureLogLevel(error),
      );
      return null;
    }
  }

  void _showConnections(List<TrackerInfo>? trackerInfos) {
    final readAt = DateTime.now();
    if (!_loaded) {
      showFirstContent(() {
        setState(() => _loaded = true);
        // A failed read must not leave the controller's list from the last visit.
        _applyConnections(trackerInfos ?? const [], readAt);
      });
      return;
    }
    updateWhenRouteSettled(() => _applyConnections(trackerInfos, readAt));
  }

  void _applyConnections(List<TrackerInfo>? trackerInfos, DateTime readAt) {
    if (trackerInfos == null) {
      return;
    }
    widget.listController.setTrackerInfos(
      _speedRanker.rank(trackerInfos, readAt),
    );
    widget.filters.offer(widget.listController.value.trackerInfos);
    if (_startsAtFarEnd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _startsAtFarEnd && _scrollController.hasClients) {
          _startsAtFarEnd = false;
          _scrollController.jumpTo(0);
        }
      });
    }
  }

  Future<void> _closeConnection(TrackerInfo trackerInfo) =>
      _close(() => _core.closeConnection(trackerInfo.id));

  Future<void> _close(Future<void> Function() close) async {
    await globalState.safeRun(close, title: 'close connections');
    if (mounted) {
      await _refreshConnections();
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return ValueListenableBuilder<TrackerInfosState>(
      valueListenable: widget.listController,
      builder: (context, state, _) {
        final connections = widget.filters.apply(state.list);
        return NullStatusSwitcher(
          isLoading: !_loaded,
          loadingStatus: const Center(child: ActivityIndicator.page()),
          isEmpty: connections.isEmpty,
          isSearching: state.isSearching || widget.filters.isFiltering,
          nullStatus: NullStatus(
            label: appLocalizations.nullTip(appLocalizations.connections),
            illustration: NullStatusIllustration.connections,
          ),
          child: RecordTableFrame<TrackerInfo>(
            tableId: 'connections',
            items: connections,
            cardSurface: widget.isBusiness,
            cardShape: widget.isBusiness ? _connectionCardShape(context) : null,
            columnsOf: (width) => trackerInfoColumns(
              context,
              width: width,
              isLive: true,
              isBusiness: widget.isBusiness,
            ),
            builder: (context, table, connections) {
              final padding = EdgeInsets.only(
                top: table?.cardSurface == true ? 0 : context.contentTopPadding,
                bottom: 16 + context.bottomInset,
              );
              final detailTitle = appLocalizations.details(
                appLocalizations.connection,
              );
              final businessMobile =
                  widget.isBusiness && ViewScope.isMobileOf(context);
              final groups = businessMobile
                  ? null
                  : widget.filters.groupsOf(connections);
              if (groups != null) {
                return TrackerInfoGroupedList(
                  groups: groups,
                  grouping: widget.filters.value.grouping!,
                  isLive: true,
                  controller: _scrollController,
                  padding: padding,
                  table: table,
                  detailTitle: detailTitle,
                  onClose: _closeConnection,
                );
              }
              final list = TrackerInfoAnimatedList(
                controller: _scrollController,
                padding: padding,
                trackerInfos: connections,
                table: table,
                detailTitle: detailTitle,
                onClose: _closeConnection,
                businessMobile: businessMobile,
              );
              if (!businessMobile) {
                return list;
              }
              return ColoredBox(
                color: context.colorScheme.surface,
                child: list,
              );
            },
          ),
        );
      },
    );
  }
}
