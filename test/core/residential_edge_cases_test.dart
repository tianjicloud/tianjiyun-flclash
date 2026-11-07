import 'package:fl_clash/core/residential.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _profile({List<String>? rules}) => {
  'mode': 'global',
  'proxies': [
    {'name': 'home-a', 'type': 'socks5'},
    {'name': 'home-b', 'type': 'socks5'},
    {'name': 'ordinary', 'type': 'socks5'},
  ],
  'proxy-groups': [
    {
      'name': tianjiResidentialRootName,
      'type': 'select',
      'proxies': ['Tokyo'],
    },
    {
      'name': 'Tokyo',
      'type': 'url-test',
      'proxies': ['home-a', 'home-b'],
    },
    {
      'name': 'Default',
      'type': 'select',
      'proxies': ['ordinary', tianjiResidentialRootName],
    },
    {
      'name': 'AI',
      'type': 'select',
      'proxies': ['Default', 'DIRECT'],
    },
  ],
  'rules': ?rules,
};

Map<String, dynamic> _apply(Map<String, dynamic> source) =>
    applyResidentialEgress(config: source, selectedExit: 'Tokyo').config;

void main() {
  for (final rules in <List<String>?>[
    null,
    [],
    ['DOMAIN-SUFFIX,example.cn,DIRECT'],
  ]) {
    test('unmatched traffic uses chosen exit with rules $rules', () {
      final result = _apply(_profile(rules: rules));

      expect(result['mode'], 'rule');
      expect(
        (result['rules'] as List).last,
        'MATCH,$tianjiResidentialLockedGroupName',
      );
    });
  }

  test('complex payloads retain commas and rule parameters', () {
    final result = _apply(
      _profile(
        rules: [
          'DOMAIN-REGEX,^foo[0-9]{1,3}\\.test\$,AI',
          'AND,((NETWORK,tcp),(OR,((DST-PORT,443),(DST-PORT,8443)))),AI',
          'IP-CIDR,192.0.2.0/24,Default,no-resolve,src',
          'MATCH,Default',
        ],
      ),
    );

    expect(result['rules'], [
      'DOMAIN-REGEX,^foo[0-9]{1,3}\\.test\$,$tianjiResidentialLockedGroupName',
      'AND,((NETWORK,tcp),(OR,((DST-PORT,443),(DST-PORT,8443)))),$tianjiResidentialLockedGroupName',
      'IP-CIDR,192.0.2.0/24,$tianjiResidentialLockedGroupName,no-resolve,src',
      'MATCH,$tianjiResidentialLockedGroupName',
    ]);
  });

  test('sub-rule jumps stay jumps while nested outbound rules follow exit', () {
    final source =
        _profile(
            rules: [
              'DOMAIN-SUFFIX,example.cn,DIRECT',
              'SUB-RULE,(NETWORK,tcp),children',
              'MATCH,Default',
            ],
          )
          ..['sub-rules'] = {
            'children': [
              'DOMAIN,blocked.test,REJECT',
              'DOMAIN,ignored.test,PASS',
              'DOMAIN,ai.test,AI',
            ],
          };

    final result = _apply(source);

    expect(result['rules'], [
      'DOMAIN-SUFFIX,example.cn,DIRECT',
      'SUB-RULE,(NETWORK,tcp),children',
      'MATCH,$tianjiResidentialLockedGroupName',
    ]);
    expect((result['sub-rules'] as Map)['children'], [
      'DOMAIN,blocked.test,REJECT',
      'DOMAIN,ignored.test,PASS',
      'DOMAIN,ai.test,$tianjiResidentialLockedGroupName',
    ]);
    expect((source['proxy-groups'] as List).length, 4);
    expect(source['mode'], 'global');
  });

  test('a removed root member cannot survive through an old group name', () {
    final source = _profile(rules: ['MATCH,Default']);
    ((source['proxy-groups'] as List).first as Map)['proxies'] = ['REJECT'];

    final result = applyResidentialEgress(
      config: source,
      selectedExit: 'Tokyo',
    );

    expect(result.missingExit, isTrue);
    expect(((result.config['proxy-groups'] as List).last as Map)['proxies'], [
      'REJECT',
    ]);
    expect(result.config['rules'], ['MATCH,$tianjiResidentialLockedGroupName']);
  });

  test('residential choices exclude cycles and direct fallbacks', () {
    final source = _profile();
    final groups = source['proxy-groups'] as List;
    (groups[1] as Map)['proxies'] = ['home-a', 'DIRECT'];
    expect(residentialChoices(source), isEmpty);

    (groups[1] as Map)['proxies'] = [tianjiResidentialRootName];
    expect(residentialChoices(source), isEmpty);
  });

  test('undeclared dynamic members cannot silently expand a chosen exit', () {
    final source = _profile(rules: ['MATCH,Default']);
    final selected = (source['proxy-groups'] as List)[1] as Map;
    selected['include-all'] = true;

    expect(residentialChoices(source), isEmpty);
    expect(((_apply(source)['proxy-groups'] as List).last as Map)['proxies'], [
      'REJECT',
    ]);
  });
}
