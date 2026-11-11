import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DnsQueryListController extends ValueNotifier<DnsQueriesState> {
  DnsQueryListController() : super(const DnsQueriesState());

  void search(String query) {
    value = value.copyWith(query: query);
  }

  void setDnsQueries(List<DnsQuery> dnsQueries) {
    if (identical(dnsQueries, value.dnsQueries)) {
      return;
    }
    value = value.copyWith(
      dnsQueries: value.autoScrollToEnd
          ? dnsQueries
          : retainTrimmedHead(
              value.dnsQueries,
              dnsQueries,
              pausedMaxDnsQueriesLength,
            ),
    );
  }

  void setAutoScrollToEnd(bool autoScrollToEnd) {
    value = value.copyWith(autoScrollToEnd: autoScrollToEnd);
  }

  void resumeAutoScrollToEnd(List<DnsQuery> dnsQueries) {
    value = value.copyWith(autoScrollToEnd: true, dnsQueries: dnsQueries);
  }
}

class DnsQueriesView extends ConsumerStatefulWidget {
  final ScrollController? scrollController;
  final bool embedded;

  const DnsQueriesView({
    super.key,
    this.scrollController,
    this.embedded = false,
  });

  @override
  ConsumerState<DnsQueriesView> createState() => _DnsQueriesViewState();
}

class _DnsQueriesViewState extends ConsumerState<DnsQueriesView>
    with RouteMotionHoldMixin<DnsQueriesView> {
  final _listController = DnsQueryListController();
  final _filters = RecordFilterController<DnsQuery>(facets: dnsQueryFacets);
  late final ScrollController _scrollController;
  late final _physics = FollowEndScrollPhysics(
    isFollowing: () => _listController.value.autoScrollToEnd,
  );

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.scrollController ??
        sheetScrollController(context, initialScrollOffset: double.maxFinite);
    _setDnsQueries(ref.read(dnsQueriesProvider).list);
    ref.listenManual(dnsQueriesProvider.select((state) => state.revision), (
      _,
      _,
    ) {
      _updateDnsQueriesThrottler();
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    _filters.dispose();
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _setDnsQueries(List<DnsQuery> dnsQueries) {
    _listController.setDnsQueries(dnsQueries);
    _filters.offer(_listController.value.dnsQueries);
  }

  void _updateDnsQueriesThrottler() {
    throttler.call(FunctionTag.dnsQueries, () {
      if (!mounted) {
        return;
      }
      updateWhenRouteSettled(
        () => _setDnsQueries(ref.read(dnsQueriesProvider).list),
      );
    }, duration: renderThrottleDuration);
  }

  Future<void> _clearDnsCache() async {
    final appLocalizations = context.appLocalizations;
    var cleared = false;
    try {
      await ref.read(coreHandlerProvider).clearDnsCache();
      cleared = true;
    } catch (error) {
      commonPrint.log(
        'clearDnsCache error: $error',
        logLevel: coreFailureLogLevel(error),
      );
    }
    if (!mounted) {
      return;
    }
    dialogs.showBanner(
      cleared
          ? appLocalizations.dnsCacheCleared
          : appLocalizations.clearDnsCacheFailed,
      level: cleared ? BannerLevel.success : BannerLevel.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final body = RecordFilterScope(
      onFilter: _filters.add,
      child: _buildBody(context),
    );
    return ListenableBuilder(
      listenable: Listenable.merge([_filters, _filters.options]),
      child: body,
      builder: (context, body) {
        if (widget.embedded) {
          return body!;
        }
        final pinned = !ViewScope.isMobileOf(context);
        return Scaffold(
          title: PageLabel.dns.label,
          searchState: AppBarSearchState(onSearch: _listController.search),
          keywords: _filters.keywordsOf(pinned: pinned),
          menuItems: _filters.menuItems(context, pinned: pinned),
          iconActions: [
            IconButtonData(
              glyph: AppGlyphs.broom,
              tooltip: appLocalizations.clearDnsCache,
              onPressed: _clearDnsCache,
            ),
          ],
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
        final dnsQueries = _filters.apply(state.list);
        return NullStatusSwitcher(
          isEmpty: dnsQueries.isEmpty,
          isSearching: state.isSearching || _filters.isFiltering,
          nullStatus: NullStatus(
            label: appLocalizations.nullTip(appLocalizations.dnsQueries),
            illustration: NullStatusIllustration.dns,
          ),
          child: RecordTableFrame<DnsQuery>(
            tableId: 'dns',
            items: dnsQueries,
            reverse: true,
            columnsOf: (width) =>
                _dnsQueryColumns(context, wide: width >= recordWideTableWidth),
            builder: (context, table, dnsQueries) => Align(
              alignment: Alignment.topCenter,
              child: FloatingScrollbar(
                controller: _scrollController,
                hintBuilder: (fraction) {
                  final index = (fraction * (dnsQueries.length - 1)).round();
                  return dnsQueries[index].time.showFull;
                },
                child: ScrollToEndBox(
                  controller: _scrollController,
                  enable: state.autoScrollToEnd,
                  onCancelToEnd: () {
                    _listController.setAutoScrollToEnd(false);
                  },
                  onResumeToEnd: () {
                    _listController.resumeAutoScrollToEnd(
                      ref.read(dnsQueriesProvider).list,
                    );
                    _filters.offer(_listController.value.dnsQueries);
                  },
                  child: RecordFeedList<DnsQuery>(
                    reverse: true,
                    shrinkWrap: true,
                    physics: _physics,
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      top: context.contentTopPadding,
                      bottom: 16 + context.bottomInset,
                    ),
                    items: dnsQueries,
                    keyOf: ObjectKey.new,
                    gap: table == null ? recordListGap : 0,
                    estimatedItemExtent:
                        table?.rowHeight ?? recordListEstimatedExtent,
                    itemBuilder: (dnsQuery, striped, _) => MemoBuilder(
                      inputs: [
                        dnsQuery,
                        if (table != null) ...[table, striped],
                      ],
                      builder: (_) => table == null
                          ? DnsQueryItem(dnsQuery: dnsQuery)
                          : _DnsQueryTableRow(
                              dnsQuery: dnsQuery,
                              table: table,
                              striped: striped,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showDnsQueryDetail(BuildContext context, DnsQuery dnsQuery) {
  final business = BusinessTheme.of(context) && system.isDesktop;
  showSheet<void>(
    context: context,
    builder: (_) => Scaffold(
      body: DnsQueryDetailView(dnsQuery: dnsQuery, business: business),
      title: context.appLocalizations.details('DNS'),
    ),
  );
}

List<RecordColumn<DnsQuery>> _dnsQueryColumns(
  BuildContext context, {
  required bool wide,
}) {
  final appLocalizations = context.appLocalizations;
  return [
    RecordColumn(
      TableColumn('time', appLocalizations.time, width: 80),
      cell: (_, query) =>
          RecordCellText(query.time.showTime.trim(), muted: true),
      sortKey: (query) => query.time,
      descendingFirst: true,
    ),
    RecordColumn(
      TableColumn('domain', appLocalizations.domain, flex: 1.3),
      cell: (_, query) => RecordCellText(query.domain),
      sortKey: (query) => query.domain.toLowerCase(),
    ),
    RecordColumn(
      TableColumn('type', appLocalizations.ipType, width: 72),
      cell: (_, query) =>
          _DnsKeyword(RecordFilter(RecordFacetKind.type, query.type)),
      sortKey: (query) => query.type,
    ),
    RecordColumn(
      TableColumn('initiator', appLocalizations.initiatorShort, width: 72),
      cell: (_, query) => switch (query.initiator) {
        final initiator? => _DnsKeyword(
          RecordFilter(RecordFacetKind.initiator, initiator.label),
        ),
        null => const RecordCellText(''),
      },
      sortKey: (query) => query.initiator?.label ?? '',
    ),
    RecordColumn(
      TableColumn('result', appLocalizations.result, flex: 1),
      cell: (_, query) => _DnsResult(query),
      sortKey: (query) => query.summary.toLowerCase(),
    ),
    if (wide)
      RecordColumn(
        TableColumn('upstream', appLocalizations.source, flex: 0.8),
        cell: (_, query) => RecordCellText(query.upstream, muted: true),
        sortKey: (query) => query.upstream.toLowerCase(),
      ),
    RecordColumn(
      TableColumn('elapsed', appLocalizations.elapsed, width: 76, end: true),
      cell: (_, query) => RecordCellText('${query.delay} ms', muted: true),
      sortKey: (query) => query.delay,
      descendingFirst: true,
    ),
  ];
}

class _DnsKeyword extends StatelessWidget {
  final RecordFilter filter;
  final RecordTone tone;

  const _DnsKeyword(this.filter, {this.tone = RecordTone.neutral});

  @override
  Widget build(BuildContext context) {
    return RecordLabel(
      label: filter.value,
      tone: tone,
      onPressed: () => RecordFilterScope.add(context, filter),
    );
  }
}

class _DnsResult extends StatelessWidget {
  final DnsQuery dnsQuery;

  const _DnsResult(this.dnsQuery);

  @override
  Widget build(BuildContext context) {
    final summary = dnsQuery.summary;
    return Row(
      spacing: 6,
      children: [
        for (final filter in dnsQuery.resultFilters)
          if (filter.kind != RecordFacetKind.initiator)
            _DnsKeyword(
              filter,
              tone: filter.kind == RecordFacetKind.rcode
                  ? RecordTone.error
                  : RecordTone.neutral,
            ),
        if (summary.isNotEmpty)
          Flexible(
            child: Text(
              summary,
              style: TextStyle(
                color: dnsQuery.isFailed
                    ? context.colorScheme.error
                    : context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

class _DnsQueryTableRow extends StatelessWidget {
  final DnsQuery dnsQuery;
  final RecordTable<DnsQuery> table;
  final bool striped;

  const _DnsQueryTableRow({
    required this.dnsQuery,
    required this.table,
    required this.striped,
  });

  @override
  Widget build(BuildContext context) {
    return RecordTableRow(
      table: table,
      striped: striped,
      onTap: () => _showDnsQueryDetail(context, dnsQuery),
      cells: table.cellsOf(context, dnsQuery),
    );
  }
}

class DnsQueryItem extends StatelessWidget {
  final DnsQuery dnsQuery;

  const DnsQueryItem({super.key, required this.dnsQuery});

  @override
  Widget build(BuildContext context) {
    final styles = RecordTextStyles.of(context);
    final tone = dnsQuery.isFailed ? RecordTone.error : RecordTone.neutral;
    final summary = dnsQuery.summary;
    return RecordListItem(
      onTap: () => _showDnsQueryDetail(context, dnsQuery),
      header: RecordHeader(
        trailing: Text('${dnsQuery.delay} ms'),
        children: [
          RecordTimestamp(dnsQuery.time.showFull),
          _DnsKeyword(RecordFilter(RecordFacetKind.type, dnsQuery.type)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(dnsQuery.domain, style: styles.title),
          if (summary.isNotEmpty)
            Text(
              summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: styles.secondary.copyWith(
                color: tone.accentColor(context),
              ),
            ),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final filter in dnsQuery.resultFilters)
                _DnsKeyword(
                  filter,
                  tone: filter.kind == RecordFacetKind.rcode
                      ? RecordTone.error
                      : RecordTone.neutral,
                ),
              if (dnsQuery.upstream.isNotEmpty)
                Text(dnsQuery.upstream, style: styles.secondary),
            ],
          ),
        ],
      ),
    );
  }
}

class DnsQueryDetailView extends StatelessWidget {
  final DnsQuery dnsQuery;
  final bool business;

  const DnsQueryDetailView({
    super.key,
    required this.dnsQuery,
    this.business = false,
  });

  @override
  Widget build(BuildContext context) {
    if (business) return _buildBusinessDetail(context);
    final appLocalizations = context.appLocalizations;
    final entries = [
      (appLocalizations.time, dnsQuery.time.showFull),
      (appLocalizations.domain, dnsQuery.domain),
      (appLocalizations.recordType, dnsQuery.type),
      (appLocalizations.initiator, dnsQuery.initiator?.label ?? ''),
      (appLocalizations.source, dnsQuery.upstream),
      (
        appLocalizations.cache,
        dnsQuery.cached ? appLocalizations.yes : appLocalizations.no,
      ),
      (appLocalizations.responseCode, dnsQuery.rcode),
      (appLocalizations.delay, '${dnsQuery.delay} ms'),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(bottom: 16, top: context.sectionsTopPadding),
            children: [
              _DnsQueryHeading(dnsQuery: dnsQuery),
              generateSection(
                title: appLocalizations.basicInfo,
                items: [
                  for (final (title, value) in entries)
                    if (value.isNotEmpty)
                      DetailRow.text(title: title, value: value),
                ],
              ),
              if (dnsQuery.error.isNotEmpty)
                generateSection(
                  title: appLocalizations.error,
                  items: [_ErrorRow(error: dnsQuery.error)],
                ),
              if (dnsQuery.answers.isNotEmpty)
                generateSection(
                  title: appLocalizations.answers,
                  items: [
                    for (final answer in dnsQuery.answers)
                      DetailRow(title: answer, copyText: answer),
                  ],
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + context.bottomInset),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _copy(context, dnsQuery.domain),
              child: Text(appLocalizations.copyHost),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessDetail(BuildContext context) {
    final l = context.appLocalizations;
    final rows = <(String, String)>[
      (l.time, dnsQuery.time.showFull),
      (l.elapsed, '${dnsQuery.delay} ms'),
      if (dnsQuery.upstream.isNotEmpty) (l.source, dnsQuery.upstream),
      if (dnsQuery.rcode.isNotEmpty) (l.responseCode, dnsQuery.rcode),
      if (dnsQuery.cached) (l.cache, l.yes),
      for (var index = 0; index < dnsQuery.answers.length; index++)
        ('${l.answers} ${index + 1}', dnsQuery.answers[index]),
      if (dnsQuery.error.isNotEmpty) (l.error, dnsQuery.error),
    ];
    final brightness = context.colorScheme.brightness;
    final statusColor = dnsQuery.isFailed
        ? BusinessPalette.error
        : BusinessPalette.connectedForegroundFor(brightness);
    final statusBackground = dnsQuery.isFailed
        ? context.colorScheme.errorContainer
        : BusinessPalette.connectedContainerFor(brightness);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        BusinessSettingsCard(
          title: '',
          items: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      dnsQuery.domain,
                      style: BusinessText.customEditorTitle(context)
                          .toJetBrainsMono
                          .copyWith(color: context.colorScheme.onSurface),
                    ),
                  ),
                  _DnsDetailBadge(
                    label: dnsQuery.type,
                    color: context.colorScheme.surfaceContainerHighest,
                    foreground: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  _DnsDetailBadge(
                    label: dnsQuery.isFailed
                        ? l.businessDnsFailed
                        : l.businessDnsSucceeded,
                    color: statusBackground,
                    foreground: statusColor,
                  ),
                ],
              ),
            ),
            for (var index = 0; index < rows.length; index++) ...[
              if (index > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ColoredBox(
                    color: context.colorScheme.outlineVariant.withValues(
                      alpha: 0.45,
                    ),
                    child: const SizedBox(height: 1),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        rows[index].$1,
                        style: BusinessText.metaLabel(
                          context,
                        ).copyWith(color: context.colorScheme.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: SelectableText(
                        rows[index].$2,
                        textAlign: TextAlign.end,
                        style: BusinessText.customRuleContent(context).copyWith(
                          color: rows[index].$1 == l.error
                              ? context.colorScheme.error
                              : context.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DnsDetailBadge extends StatelessWidget {
  const _DnsDetailBadge({
    required this.label,
    required this.color,
    required this.foreground,
  });

  final String label;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(color: color, shape: AppShape.full),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      child: Text(
        label,
        style: BusinessText.metaLabel(context).copyWith(color: foreground),
      ),
    ),
  );
}

class _DnsQueryHeading extends StatelessWidget {
  const _DnsQueryHeading({required this.dnsQuery});

  final DnsQuery dnsQuery;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return Card(
      radius: AppCorner.lg,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            appLocalizations.dnsQueries,
            style: AppTextStyle.footnote
                .of(context)
                .copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
          SelectableText(
            dnsQuery.domain,
            style: AppTextStyle.title3.of(context, emphasized: true),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _DnsKeyword(
                RecordFilter(RecordFacetKind.type, dnsQuery.type),
                tone: dnsQuery.isFailed ? RecordTone.error : RecordTone.neutral,
              ),
              if (dnsQuery.initiator case final initiator?)
                _DnsKeyword(
                  RecordFilter(RecordFacetKind.initiator, initiator.label),
                ),
              if (dnsQuery.rcode.isNotEmpty)
                _DnsKeyword(
                  RecordFilter(RecordFacetKind.rcode, dnsQuery.rcode),
                  tone: dnsQuery.hasFailureRcode
                      ? RecordTone.error
                      : RecordTone.neutral,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _copy(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  dialogs.showBanner(context.appLocalizations.copySuccess);
}

class _ErrorRow extends StatelessWidget {
  final String error;

  const _ErrorRow({required this.error});

  @override
  Widget build(BuildContext context) {
    return DecorationListItem(
      onPressed: () => _copy(context, error),
      minVerticalPadding: 14,
      title: Text(
        error,
        style: AppTextStyle.subheadline
            .of(context)
            .copyWith(color: context.colorScheme.error),
      ),
    );
  }
}
