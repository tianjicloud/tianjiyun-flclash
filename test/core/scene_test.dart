import 'package:fl_clash/common/task.dart';
import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

Map<String, dynamic> _config() => {
  'proxies': [
    {'name': 'hk', 'type': 'ss'},
    {'name': 'jp', 'type': 'ss'},
    {'name': 'ai-home', 'type': 'ss'},
    {'name': 'watch-jp', 'type': 'ss'},
  ],
  'proxy-groups': [
    {
      'name': sceneRootGroupName,
      'type': 'select',
      'proxies': [sceneGroupName, '节点选择'],
    },
    {
      'name': sceneGroupName,
      'type': 'select',
      'proxies': [sceneDailyGroupName, sceneAiGroupName, sceneWatchGroupName],
    },
    {
      'name': sceneDailyGroupName,
      'type': 'url-test',
      'proxies': ['hk', 'jp'],
    },
    {
      'name': sceneAiGroupName,
      'type': 'select',
      'proxies': ['ai-home'],
    },
    {
      'name': sceneWatchGroupName,
      'type': 'select',
      'proxies': ['watch-jp', 'jp'],
    },
    {
      'name': '节点选择',
      'type': 'select',
      'proxies': ['hk', 'jp'],
    },
    {
      'name': sceneAiDomainGroupName,
      'type': 'select',
      'proxies': ['ai-home'],
    },
    {
      'name': sceneWatchDomainGroupName,
      'type': 'select',
      'proxies': ['watch-jp'],
    },
  ],
  'rules': [
    'DOMAIN-SUFFIX,openai.com,$sceneAiDomainGroupName',
    'DOMAIN-SUFFIX,claude.ai,$sceneAiDomainGroupName',
    'DOMAIN-SUFFIX,netflix.com,$sceneWatchDomainGroupName',
    'DOMAIN-SUFFIX,youtube.com,$sceneWatchDomainGroupName',
    'GEOIP,CN,DIRECT',
    'MATCH,$sceneRootGroupName',
  ],
};

Map<String, dynamic> _group(Map<String, dynamic> config, String name) =>
    (config['proxy-groups'] as List).cast<Map<String, dynamic>>().firstWhere(
      (group) => group['name'] == name,
    );

void main() {
  test('ai scene pins the pivot and retargets ai rules only', () {
    final result = applyScene(config: _config(), scene: SceneKind.ai);
    expect(result.applied, isTrue);
    expect(result.unconfirmed, isFalse);
    expect(
      _group(result.config, sceneGroupName)['default-selected'],
      sceneAiGroupName,
    );
    expect(
      _group(result.config, sceneRootGroupName)['default-selected'],
      sceneGroupName,
    );
    expect(result.config['rules'], [
      'DOMAIN-SUFFIX,openai.com,$sceneAiGroupName',
      'DOMAIN-SUFFIX,claude.ai,$sceneAiGroupName',
      'DOMAIN-SUFFIX,netflix.com,$sceneDailyGroupName',
      'DOMAIN-SUFFIX,youtube.com,$sceneDailyGroupName',
      'GEOIP,CN,DIRECT',
      'MATCH,$sceneRootGroupName',
    ]);
  });

  test('watch scene sends streaming to the watch group, ai back to daily', () {
    final result = applyScene(config: _config(), scene: SceneKind.watch);
    expect(result.applied, isTrue);
    expect(result.config['rules'], [
      'DOMAIN-SUFFIX,openai.com,$sceneDailyGroupName',
      'DOMAIN-SUFFIX,claude.ai,$sceneDailyGroupName',
      'DOMAIN-SUFFIX,netflix.com,$sceneWatchGroupName',
      'DOMAIN-SUFFIX,youtube.com,$sceneWatchGroupName',
      'GEOIP,CN,DIRECT',
      'MATCH,$sceneRootGroupName',
    ]);
  });

  test('daily scene leaves both domain groups on the daily group', () {
    final result = applyScene(config: _config(), scene: SceneKind.daily);
    expect(result.applied, isTrue);
    expect(result.unconfirmed, isFalse);
    final rules = result.config['rules'] as List;
    expect(
      rules.where((rule) => rule.toString().endsWith(sceneAiGroupName)),
      isEmpty,
    );
    expect(
      rules.where((rule) => rule.toString().endsWith(sceneWatchGroupName)),
      isEmpty,
    );
  });

  test('a subscription without the pivot has no scenes to apply', () {
    final config = _config();
    (config['proxy-groups'] as List).removeWhere(
      (group) => group['name'] == sceneGroupName,
    );
    final result = applyScene(config: config, scene: SceneKind.ai);
    expect(result.applied, isFalse);
    expect(result.config, same(config));
  });

  test('rule sets make the steering unconfirmed, never silently partial', () {
    final config = _config();
    (config['rules'] as List).insert(
      0,
      'RULE-SET,ai-domains,$sceneAiDomainGroupName',
    );
    final result = applyScene(config: config, scene: SceneKind.daily);
    expect(result.applied, isTrue);
    expect(result.unconfirmed, isTrue);
    expect(
      (result.config['rules'] as List).first,
      'RULE-SET,ai-domains,$sceneAiDomainGroupName',
    );
  });

  test('selection names map back to scene kinds', () {
    expect(sceneKindOfSelection(sceneDailyGroupName), SceneKind.daily);
    expect(sceneKindOfSelection(sceneAiGroupName), SceneKind.ai);
    expect(sceneKindOfSelection(sceneWatchGroupName), SceneKind.watch);
    expect(sceneKindOfSelection('节点选择'), isNull);
    expect(sceneKindOfSelection(null), isNull);
  });

  test('assembly injects the stored scene into the built profile', () async {
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
        scene: sceneWatchGroupName,
      ),
    );
    final built = loadYaml(result.yaml) as YamlMap;
    final groups = (built['proxy-groups'] as YamlList)
        .cast<YamlMap>()
        .map((group) => Map<String, dynamic>.from(group))
        .toList();
    final pivot = groups.firstWhere((group) => group['name'] == sceneGroupName);
    expect(pivot['default-selected'], sceneWatchGroupName);
    final rules = (built['rules'] as YamlList).cast<String>();
    expect(rules, contains('DOMAIN-SUFFIX,netflix.com,$sceneWatchGroupName'));
    expect(rules, contains('DOMAIN-SUFFIX,openai.com,$sceneDailyGroupName'));
  });

  test('assembly without a scene leaves the delivered config alone', () async {
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
      ),
    );
    final built = loadYaml(result.yaml) as YamlMap;
    final groups = (built['proxy-groups'] as YamlList).cast<YamlMap>();
    final pivot = groups.firstWhere((group) => group['name'] == sceneGroupName);
    expect(pivot['default-selected'], isNull);
    final rules = (built['rules'] as YamlList).cast<String>();
    expect(rules, contains('DOMAIN-SUFFIX,openai.com,$sceneAiDomainGroupName'));
  });
}
