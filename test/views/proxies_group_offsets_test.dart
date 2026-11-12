import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/views/proxies/common.dart';
import 'package:flutter_test/flutter_test.dart';

Group _group(String name) => Group(type: GroupType.Selector, name: name);

void main() {
  test('an offset is looked up in the very list it was measured from', () {
    const offsets = GroupOffsets([], []);

    expect(offsets.isEmpty, isTrue);
    expect(offsets.offsetOf('anything'), 0);
  });

  test('a filtered list resolves its own indexes', () {
    final offsets = GroupOffsets([_group('b'), _group('d')], const [0, 120]);

    expect(offsets.offsetOf('b'), 0);
    expect(offsets.offsetOf('d'), 120);
  });

  test('a group the measured list does not carry falls back to the top', () {
    final offsets = GroupOffsets([_group('b')], const [0]);

    expect(offsets.offsetOf('a'), 0);
  });

  test('proxy set health waits for a result and excludes timeouts', () {
    const proxies = [
      Proxy(name: 'fast', type: 'ss'),
      Proxy(name: 'slow', type: 'ss'),
      Proxy(name: 'down', type: 'ss'),
    ];

    expect(proxySetHealth(proxies, null), isNull);
    expect(proxySetHealth(proxies, {'fast': null}), isNull);
    expect(proxySetHealth(proxies, {'fast': 120, 'down': -1}), (
      available: 1,
      total: 3,
    ));
  });
}
