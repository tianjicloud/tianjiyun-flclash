import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/tianji_api.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/tianji_nodes.g.dart';

@Riverpod(keepAlive: true)
bool tianjiApiEnabled(Ref ref) =>
    isTianjiSubscriptionProfile(ref.watch(currentProfileProvider));

@Riverpod(keepAlive: true)
class TianjiNodeCatalog extends _$TianjiNodeCatalog {
  String? _etag;
  DateTime? _fetchedAt;
  Future<void>? _refreshing;
  Map<String, TianjiNode> _nodesByName = const {};

  @override
  Future<TianjiNodes?> build() async {
    _nodesByName = const {};
    if (!ref.watch(tianjiApiEnabledProvider)) return null;
    ref.listen(
      currentProfileProvider.select((profile) => profile?.lastUpdateDate),
      (previous, next) {
        if (previous != next) unawaited(refreshIfStale());
      },
    );
    final raw = await preferences.getTianjiNodesCache();
    if (raw != null) {
      try {
        final cache = jsonDecode(raw) as Map<String, dynamic>;
        _etag = cache['etag'] as String?;
        _fetchedAt = DateTime.tryParse(cache['fetchedAt'] as String? ?? '');
        final cached = TianjiNodes.fromJson(
          cache['data'] as Map<String, Object?>,
        );
        _index(cached);
        unawaited(Future<void>.microtask(refreshIfStale));
        return cached;
      } on Object catch (error) {
        commonPrint.log('tianji nodes cache: $error');
      }
    }
    unawaited(Future<void>.microtask(refreshIfStale));
    return null;
  }

  TianjiNode? nodeFor(String name) => _nodesByName[name];

  Map<String, String> get categories => state.value?.categories ?? const {};

  Future<void> refreshIfStale() async {
    if (!ref.mounted || !ref.read(tianjiApiEnabledProvider)) return;
    final pending = _refreshing;
    if (pending != null) {
      await pending;
      return;
    }
    if (_fetchedAt != null &&
        DateTime.now().difference(_fetchedAt!) < const Duration(minutes: 10)) {
      return;
    }
    final future = refresh();
    _refreshing = future;
    try {
      await future;
    } finally {
      _refreshing = null;
    }
  }

  Future<void> refresh() async {
    if (!ref.mounted || !ref.read(tianjiApiEnabledProvider)) return;
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    try {
      final response = await request.dio.get<String>(
        tianjiNodesUrl,
        cancelToken: cancelToken,
        options: Options(
          headers: {if (_etag != null) 'If-None-Match': _etag},
          validateStatus: (status) => status == 200 || status == 304,
        ),
      );
      if (!ref.mounted) return;
      if (response.statusCode == 304) {
        _fetchedAt = DateTime.now();
      } else if (response.data != null) {
        final data = parseTianjiNodes(response.data!);
        _etag = response.headers.value('etag');
        _fetchedAt = DateTime.now();
        _index(data);
        state = AsyncData(data);
      }
      final data = state.value;
      if (data != null) {
        await preferences.saveTianjiNodesCache(
          jsonEncode({
            'etag': _etag,
            'fetchedAt': _fetchedAt?.toIso8601String(),
            'data': data.toJson(),
          }),
        );
      }
    } on DioException catch (error) {
      commonPrint.log('tianji nodes request: ${error.message}');
    } on Object catch (error) {
      commonPrint.log('tianji nodes parse: $error');
    }
  }

  void _index(TianjiNodes data) {
    _nodesByName = {for (final node in data.nodes) node.name: node};
  }
}

@riverpod
TianjiNode? tianjiNode(Ref ref, String name) {
  if (!ref.watch(tianjiApiEnabledProvider)) return null;
  ref.watch(tianjiNodeCatalogProvider);
  return ref.read(tianjiNodeCatalogProvider.notifier).nodeFor(name);
}

@riverpod
Map<String, String> tianjiCategories(Ref ref) {
  if (!ref.watch(tianjiApiEnabledProvider)) return const {};
  ref.watch(tianjiNodeCatalogProvider);
  return ref.read(tianjiNodeCatalogProvider.notifier).categories;
}
