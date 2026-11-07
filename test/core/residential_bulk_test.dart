import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/core/residential_bulk.dart';
import 'package:fl_clash/common/task.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

Map<String, dynamic> _config() => {
  'proxies': [
    {'name': 'home', 'type': 'socks5'},
    {'name': 'ordinary', 'type': 'socks5'},
  ],
  'proxy-groups': [
    {
      'name': tianjiResidentialRootName,
      'type': 'select',
      'proxies': ['home'],
    },
    {
      'name': '⚡ 自动选择',
      'type': 'url-test',
      'proxies': ['ordinary'],
    },
    {
      'name': 'Main',
      'type': 'select',
      'proxies': ['home', 'ordinary'],
    },
  ],
  'rules': [
    'DOMAIN-SUFFIX,windowsupdate.com,DIRECT',
    'DOMAIN-SUFFIX,googlevideo.com,Main',
    'DOMAIN-SUFFIX,chatgpt.com,Main',
    'GEOIP,CN,DIRECT',
    'MATCH,Main',
  ],
};

Map<String, dynamic> _apply(
  Map<String, dynamic> config, {
  String exit = 'home',
}) {
  return applyResidentialBulkBypass(
    original: config,
    residential: applyResidentialEgress(config: config, selectedExit: exit),
  );
}

void main() {
  test(
    'assembly enables bypass only with an active residential choice',
    () async {
      for (final active in [false, true]) {
        final result = await makeRealProfileTask(
          MakeRealProfileState(
            profilesPath: '/profiles',
            profileId: 1,
            rawConfig: _config(),
            realPatchConfig: const PatchClashConfig(),
            appendSystemDns: false,
            proxyGroups: const [],
            rules: const [],
            addedRules: const [],
            defaultUA: 'Test',
            residentialExit: active ? 'home' : null,
          ),
        );
        final output = loadYaml(result.yaml) as YamlMap;
        expect(
          (output['proxy-groups'] as List).any(
            (g) => g['name'] == residentialBulkGroup,
          ),
          active,
        );
        if (!active) expect(output['rules'], _config()['rules']);
      }
    },
  );

  test(
    'bulk dispatch preserves rule order and ordinary residential routing',
    () {
      final input = _config();
      final output = _apply(input);
      final rules = List<String>.from(output['rules']);
      expect(rules.first, 'DOMAIN-SUFFIX,windowsupdate.com,DIRECT');
      expect(rules[1], 'DOMAIN-SUFFIX,googlevideo.com,$residentialBulkGroup');
      expect(
        rules[2],
        'DOMAIN-SUFFIX,googlevideo.com,$tianjiResidentialLockedGroupName',
      );
      expect(
        rules[3],
        'DOMAIN-SUFFIX,chatgpt.com,$tianjiResidentialLockedGroupName',
      );
      expect(rules[4], 'GEOIP,CN,DIRECT');
      expect(rules[5], startsWith('OR,('));
      expect(rules[5], contains('(DOMAIN-SUFFIX,googlevideo.com)'));
      expect(rules[5], isNot(contains('chatgpt.com')));
      expect(rules.last, 'MATCH,$tianjiResidentialLockedGroupName');
      expect(input, _config());
    },
  );

  test('invalid residential selection keeps REJECT without bypass', () {
    final input = _config();
    final locked = applyResidentialEgress(
      config: input,
      selectedExit: 'missing',
    );
    final output = applyResidentialBulkBypass(
      original: input,
      residential: locked,
    );
    expect(identical(output, locked.config), isTrue);
    expect((output['proxy-groups'] as List).last['proxies'], ['REJECT']);
  });

  test('mixed or unrecognized ordinary groups do not enable bypass', () {
    for (final member in ['home', tianjiResidentialRootName, 'missing']) {
      final input = _config();
      input['proxy-groups'][1]['proxies'] = [member];
      final output = _apply(input);
      expect((output['proxy-groups'] as List).length, 4);
    }
  });

  test('provider-backed ordinary group cannot prove residential exclusion', () {
    final input = _config();
    input['proxy-groups'][1]['use'] = ['remote'];
    expect((_apply(input)['proxy-groups'] as List).length, 4);
  });

  test('server video rule is preserved with zero fallback injection', () {
    final input = _config();
    input['rules'][1] = 'DOMAIN-SUFFIX,googlevideo.com,⚡ 自动选择';
    final output = _apply(input);
    expect(output['rules'][1], input['rules'][1]);
    expect((output['proxy-groups'] as List).length, 4);
    expect((output['rules'] as List).length, (input['rules'] as List).length);
  });

  test('opaque rule sets and existing sub-rules are left unchanged', () {
    for (final rule in [
      'RULE-SET,remote,Main',
      'SUB-RULE,(DOMAIN,a.test),inner',
    ]) {
      final input = _config();
      (input['rules'] as List).insert(0, rule);
      final locked = applyResidentialEgress(
        config: input,
        selectedExit: 'home',
      );
      expect(
        identical(
          applyResidentialBulkBypass(original: input, residential: locked),
          locked.config,
        ),
        isTrue,
      );
    }
  });
}
