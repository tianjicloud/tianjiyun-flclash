import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fl_clash/common/preferences.dart';
import 'package:fl_clash/common/request.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _NodesAdapter implements HttpClientAdapter {
  int requests = 0;
  final etags = <String?>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests++;
    etags.add(options.headers['If-None-Match'] as String?);
    if (requests == 1) {
      return ResponseBody.fromString(
        jsonEncode({
          'nodes': [
            {'name': 'JP home', 'multiplier': 0.5},
          ],
          'categories': {},
        }),
        200,
        headers: {
          'etag': ['"v1"'],
        },
      );
    }
    return ResponseBody.fromString('', 304);
  }

  @override
  void close({bool force = false}) {}
}

const _profile = Profile(
  id: 1,
  type: ProfileType.url,
  url: 'https://sub1.tianjiyun.org/s/abcdefgh',
  autoUpdateDuration: Duration.zero,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HttpClientAdapter originalAdapter;

  setUp(() async {
    originalAdapter = request.dio.httpClientAdapter;
    SharedPreferences.setMockInitialValues({});
    await preferences.rebind();
  });

  tearDown(() {
    request.dio.httpClientAdapter = originalAdapter;
  });

  test(
    'ETag 304 retains data and a fresh cache avoids another request',
    () async {
      final adapter = _NodesAdapter();
      request.dio.httpClientAdapter = adapter;
      final first = ProviderContainer(
        overrides: [currentProfileProvider.overrideWithValue(_profile)],
      );
      addTearDown(first.dispose);
      final provider = tianjiNodeCatalogProvider;
      first.listen(provider, (_, _) {});
      expect(first.read(tianjiApiEnabledProvider), isTrue);

      await first.read(provider.future);
      await first.read(provider.notifier).refreshIfStale();
      final loaded = first.read(provider).value;
      expect(loaded?.nodes.single.multiplier, 0.5);
      expect(adapter.requests, 1);
      await first.read(provider.notifier).refresh();
      expect(first.read(provider).value?.nodes.single.name, 'JP home');
      expect(adapter.etags, [null, '"v1"']);
      expect(
        await preferences.getTianjiNodesCache(),
        contains('"name":"JP home"'),
      );

      final second = ProviderContainer(
        overrides: [currentProfileProvider.overrideWithValue(_profile)],
      );
      addTearDown(second.dispose);
      second.listen(provider, (_, _) {});
      expect(
        (await second.read(provider.future))?.nodes.single.name,
        'JP home',
      );
      expect(adapter.requests, 2);
    },
  );
}
