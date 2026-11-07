import 'dart:convert';

import 'package:fl_clash/core/manual_selection.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final config = <String, dynamic>{
    'proxy-groups': [
      {
        'name': 'Auto',
        'type': 'url-test',
        'proxies': ['A', 'B'],
      },
      {
        'name': 'AI',
        'type': 'fallback',
        'proxies': ['B', 'A'],
      },
    ],
    'rules': ['GEOIP,CN,DIRECT', 'DOMAIN,ai.example,AI', 'MATCH,Auto'],
  };
  const selections = {'Auto': ManualSelection(node: 'B', sequence: 1)};

  test('pins only the selected group and preserves routing and the source', () {
    final result = applyManualSelections(config, selections);
    final groups = result['proxy-groups'] as List;
    expect(groups.first, {
      'name': 'Auto',
      'type': 'select',
      'proxies': ['REJECT', 'A', 'B'],
      'default-selected': 'B',
      'empty-fallback': 'REJECT',
    });
    expect(groups.last, (config['proxy-groups'] as List).last);
    expect(result['rules'], same(config['rules']));
    expect((config['proxy-groups'] as List).first['type'], 'url-test');
  });

  test('an automatic choice restores the original definition', () {
    expect(
      applyManualSelections(config, {
        'Auto': const ManualSelection(
          node: '',
          sequence: 2,
          automaticGroup: true,
        ),
      }),
      same(config),
    );
    expect(applyManualSelections(config, const {}), same(config));
  });

  test('a missing saved node falls back to REJECT before any other member', () {
    final result = applyManualSelections(config, {
      'Auto': const ManualSelection(node: 'Removed', sequence: 2),
    });
    final group = (result['proxy-groups'] as List).first as Map;
    expect(group['default-selected'], 'Removed');
    expect((group['proxies'] as List).first, 'REJECT');
  });

  test('provider filters cannot remove or reorder the rejection guard', () {
    final result = applyManualSelections({
      'proxy-groups': [
        {
          'name': 'Auto',
          'type': 'fallback',
          'use': ['Remote'],
          'filter': 'HK`JP',
          'exclude-filter': 'bad`.*REJECT.*',
          'exclude-type': 'reject|ss',
          'use-position': {'Remote': 0},
        },
      ],
    }, selections);
    final group = (result['proxy-groups'] as List).first as Map;
    expect(group['use'], ['Remote']);
    expect(group['use-position'], {'Remote': 1});
    expect(group['filter'], '^REJECT\$`HK`JP');
    expect(group['exclude-type'], 'ss');
    expect(
      group['exclude-filter'],
      '\\A(?!REJECT\\z)(?:bad)`\\A(?!REJECT\\z)(?:.*REJECT.*)',
    );
    expect(group['proxies'], ['REJECT']);
  });

  test('manual facts survive JSON and old profiles invent no manual facts', () {
    const overrides = ProfileOverrides(manualSelections: selections);
    expect(
      ProfileOverrides.fromJson(jsonDecode(jsonEncode(overrides))),
      overrides,
    );
    expect(ProfileOverrides.fromJson(const {}).manualSelections, isEmpty);
  });

  test('the implicit GLOBAL selector gets the same fail-closed guard', () {
    final result = applyManualSelections(config, const {
      'GLOBAL': ManualSelection(node: 'Auto', sequence: 1),
    });
    final groups = result['proxy-groups'] as List;
    expect(groups.take(2).toList(), config['proxy-groups']);
    expect(groups.last['name'], 'GLOBAL');
    expect(groups.last['proxies'], ['REJECT', 'DIRECT', 'Auto', 'AI']);
    expect(groups.last['default-selected'], 'Auto');
    expect(result['rules'], same(config['rules']));
  });
}
