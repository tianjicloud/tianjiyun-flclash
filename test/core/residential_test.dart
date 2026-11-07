import 'package:fl_clash/core/residential.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _config({List<String>? rules}) => {
  'mode': 'global',
  'proxies': [
    {'name': 'home-a', 'type': 'socks5'},
    {'name': 'home-b', 'type': 'socks5'},
    {'name': 'home-hk', 'type': 'socks5'},
    {'name': 'ordinary', 'type': 'socks5'},
    {'name': 'upgrade-placeholder', 'type': 'reject'},
  ],
  'proxy-groups': [
    {
      'name': tianjiResidentialRootName,
      'type': 'select',
      'proxies': ['Tokyo', 'Hong Kong'],
    },
    {
      'name': 'Tokyo',
      'type': 'url-test',
      'proxies': ['Tokyo transport'],
    },
    {
      'name': 'Tokyo transport',
      'type': 'fallback',
      'proxies': ['home-a', 'home-b'],
    },
    {
      'name': 'Hong Kong',
      'type': 'url-test',
      'proxies': ['home-hk'],
    },
    {
      'name': 'Default',
      'type': 'select',
      'proxies': ['ordinary', tianjiResidentialRootName],
    },
    {
      'name': 'AI',
      'type': 'select',
      'proxies': ['Default', tianjiResidentialRootName],
    },
    {
      'name': 'Ads',
      'type': 'select',
      'proxies': ['REJECT', 'PASS'],
    },
    {
      'name': 'Broken',
      'type': 'select',
      'proxies': ['upgrade-placeholder'],
    },
  ],
  'rules': rules,
};

void main() {
  test('rewrites foreign groups but keeps direct and reject policies', () {
    final source = _config(
      rules: [
        'DOMAIN-SUFFIX,example.cn,DIRECT',
        'DOMAIN-SUFFIX,ads.test,Ads',
        'IP-CIDR,192.0.2.0/24,Default,no-resolve',
        'AND,((NETWORK,tcp),(DST-PORT,443)),AI',
        'MATCH,Default',
      ],
    );

    final result = applyResidentialEgress(
      config: source,
      selectedExit: 'Tokyo',
    );
    final rules = result.config['rules'] as List;

    expect(result.applied, isTrue);
    expect(result.config['mode'], 'rule');
    expect(rules, [
      'DOMAIN-SUFFIX,example.cn,DIRECT',
      'DOMAIN-SUFFIX,ads.test,Ads',
      'IP-CIDR,192.0.2.0/24,$tianjiResidentialLockedGroupName,no-resolve',
      'AND,((NETWORK,tcp),(DST-PORT,443)),$tianjiResidentialLockedGroupName',
      'MATCH,$tianjiResidentialLockedGroupName',
    ]);

    final groups = result.config['proxy-groups'] as List;
    final locked = groups.last as Map;
    expect(locked['name'], tianjiResidentialLockedGroupName);
    expect(locked['proxies'], ['Tokyo']);
    expect(locked['hidden'], isTrue);
    expect(
      (groups.firstWhere((group) => (group as Map)['name'] == 'Tokyo')
              as Map)['proxies'],
      ['Tokyo transport'],
    );
    expect(source['mode'], 'global');
    expect(source['rules'], isNotNull);
  });

  test('adds a terminal match when rules end without one', () {
    for (final rules in <List<String>?>[
      null,
      [],
      ['DOMAIN-SUFFIX,example.cn,DIRECT'],
    ]) {
      final result = applyResidentialEgress(
        config: _config(rules: rules),
        selectedExit: 'Hong Kong',
      );
      expect((result.config['rules'] as List).last,
          'MATCH,$tianjiResidentialLockedGroupName');
    }
  });

  test('sub-rule jumps stay jumps and their targets follow the exit', () {
    final source = _config(
      rules: [
        'SUB-RULE,(NETWORK,tcp),children',
        'MATCH,Default',
      ],
    )..['sub-rules'] = {
      'children': [
        'DOMAIN,blocked.test,REJECT',
        'DOMAIN,direct.test,DIRECT',
        'DOMAIN,ai.test,AI',
        'SUB-RULE,(DST-PORT,53),other',
      ],
      'other': ['DOMAIN,dns.test,Default'],
    };

    final result = applyResidentialEgress(
      config: source,
      selectedExit: 'Tokyo',
    );

    expect(result.config['rules'], [
      'SUB-RULE,(NETWORK,tcp),children',
      'MATCH,$tianjiResidentialLockedGroupName',
    ]);
    final subRules = result.config['sub-rules'] as Map;
    expect(subRules['children'], [
      'DOMAIN,blocked.test,REJECT',
      'DOMAIN,direct.test,DIRECT',
      'DOMAIN,ai.test,$tianjiResidentialLockedGroupName',
      'SUB-RULE,(DST-PORT,53),other',
    ]);
    expect(subRules['other'], [
      'DOMAIN,dns.test,$tianjiResidentialLockedGroupName',
    ]);
  });

  test('a missing target yields a reject-only locked group', () {
    final result = applyResidentialEgress(
      config: _config(rules: ['MATCH,Default']),
      selectedExit: 'Nowhere',
    );

    expect(result.missingExit, isTrue);
    final locked = (result.config['proxy-groups'] as List).last as Map;
    expect(locked['proxies'], ['REJECT']);
    expect(result.config['rules'],
        ['MATCH,$tianjiResidentialLockedGroupName']);
  });

  test('choices are direct root members on safe proxy chains', () {
    expect(residentialChoices(_config()), ['Tokyo', 'Hong Kong']);

    final unsafe = _config();
    final groups = unsafe['proxy-groups'] as List;
    (groups[1] as Map)['proxies'] = ['home-a', 'DIRECT'];
    expect(residentialChoices(unsafe), ['Hong Kong']);

    (groups[1] as Map)['proxies'] = [tianjiResidentialRootName];
    expect(residentialChoices(unsafe), ['Hong Kong']);
  });

  test('unsupported shapes and reserved name collisions are refused', () {
    final badRules = _config()..['rules'] = 'MATCH,Default';
    expect(
      () => applyResidentialEgress(
        config: badRules,
        selectedExit: 'Tokyo',
      ),
      throwsA(isA<ResidentialConfigException>()),
    );

    final unknownTarget = _config(rules: ['DOMAIN,a.test,Missing']);
    expect(
      () => applyResidentialEgress(
        config: unknownTarget,
        selectedExit: 'Tokyo',
      ),
      throwsA(isA<ResidentialConfigException>()),
    );

    final collision = _config();
    (collision['proxy-groups'] as List).add({
      'name': tianjiResidentialLockedGroupName,
      'type': 'select',
      'proxies': ['home-a'],
    });
    expect(
      () => applyResidentialEgress(
        config: collision,
        selectedExit: 'Tokyo',
      ),
      throwsA(isA<ResidentialConfigException>()),
    );
  });
}
