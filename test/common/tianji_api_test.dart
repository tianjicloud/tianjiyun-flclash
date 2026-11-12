import 'package:fl_clash/common/tianji_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses complete egress inventory data', () {
    final info = parseTianjiEgress('''
      {"ip":"203.0.113.42","country_code":"JP","region":"Tokyo",
       "city":"Tokyo","asn":17676,"isp":"Example ISP",
       "exit":{"kind":"residential","country_code":"JP","pool":"p1"}}
    ''');
    expect(info?.ip, '203.0.113.42');
    expect(info?.countryCode, 'JP');
    expect(info?.isp, 'Example ISP');
    expect(info?.asn, 17676);
    expect(info?.fromTianji, isTrue);
    expect(info?.exit?.kind, 'residential');
  });

  test('keeps nullable egress fields and null exit', () {
    final info = parseTianjiEgress(
      '{"ip":"203.0.113.42","country_code":null,"asn":null,'
      '"isp":null,"region":null,"city":null,"exit":null}',
    );
    expect(info?.countryCode, isNull);
    expect(info?.asn, isNull);
    expect(info?.isp, isNull);
    expect(info?.exit, isNull);
  });

  test('rejects invalid egress JSON and unknown exit kinds safely', () {
    expect(parseTianjiEgress('{'), isNull);
    expect(
      parseTianjiEgress(
        '{"ip":"203.0.113.42","exit":{"kind":"new-kind"}}',
      )?.exit?.kind,
      'unknown',
    );
  });

  test('parses nodes, fractional multiplier and absent expected exit', () {
    final catalog = parseTianjiNodes('''
      {"generated_at":"2026-11-12T03:00:00Z","categories":{"streaming":"流媒体"},
       "nodes":[{"name":"JP home","country_code":"JP","multiplier":0.5,
       "expected_exit":{"kind":"residential","country_code":"JP","pool":"jp-home"},
       "substituted_categories":["streaming"]},
       {"name":"unknown","expected_exit":null,"multiplier":1},
       {"name":"future kind","expected_exit":{"kind":"mystery"}}]}
    ''');
    expect(catalog.nodes.first.multiplier, 0.5);
    expect(catalog.nodes.first.expectedExit?.kind, 'residential');
    expect(catalog.nodes.first.substitutedCategories, ['streaming']);
    expect(catalog.nodes[1].expectedExit, isNull);
    expect(catalog.nodes[2].expectedExit?.kind, 'unknown');
    expect(catalog.categories['streaming'], '流媒体');
  });
}
