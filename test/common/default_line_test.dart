import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/common/default_line.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/default_lines.dart';

void main() {
  test('choices expose manual lines alongside automatic selection', () {
    final catalog = DefaultLineCatalog(defaultLineTestGroups);
    expect(catalog.choices.map((choice) => choice.name), [
      '⚡ 自动选择',
      'Tokyo',
      'Hong Kong',
    ]);
    expect(catalog.selected({})?.name, '⚡ 自动选择');
    expect(catalog.currentNode({}), 'HK transport');
    final manual = {appName: '📍 指定节点', '📍 指定节点': 'Tokyo'};
    expect(catalog.selected(manual)?.name, 'Tokyo');
    expect(catalog.currentNode(manual), 'Tokyo transport');
  });

  test('a renamed subscription root is discovered by its route choices', () {
    final catalog = DefaultLineCatalog([
      defaultLineTestGroups.first.copyWith(name: 'Provider name'),
      ...defaultLineTestGroups.skip(1),
    ]);
    expect(catalog.root?.name, 'Provider name');
    expect(catalog.choices.length, 3);
  });

  test('unknown roots do not guess an AI selector as the default route', () {
    expect(DefaultLineCatalog([defaultLineTestGroups.last]).root, isNull);
  });

  test('cycles and missing live selections do not invent a current node', () {
    const group = Group(
      name: appName,
      type: GroupType.Selector,
      now: appName,
      all: [Proxy(name: appName, type: 'Selector')],
    );
    expect(DefaultLineCatalog([group]).currentNode({}), isNull);
    expect(
      DefaultLineCatalog([group.copyWith(now: '')]).currentNode({}),
      isNull,
    );
  });
}
