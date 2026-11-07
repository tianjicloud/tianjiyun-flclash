import 'package:fl_clash/core/residential.dart';

const residentialBulkGroup = '🎬 天机大流量';
const _ordinaryGroup = '⚡ 自动选择';

const residentialBulkDomains = [
  'youtube.com',
  'googlevideo.com',
  'ytimg.com',
  'youtube-nocookie.com',
  'netflix.com',
  'nflxvideo.net',
  'nflximg.net',
  'nflxso.net',
  'tiktok.com',
  'tiktokcdn.com',
  'byteoversea.com',
  'ibytedtos.com',
  'disneyplus.com',
  'dssott.com',
  'bamgrid.com',
  'max.com',
  'hbo.com',
  'hbomax.com',
  'twitch.tv',
  'ttvnw.net',
  'vimeo.com',
  'dailymotion.com',
  'steamcontent.com',
  'steamstatic.com',
  'download.microsoft.com',
  'windowsupdate.com',
  'mesu.apple.com',
];

Map<String, dynamic> applyResidentialBulkBypass({
  required Map<String, dynamic> original,
  required ResidentialTransformResult residential,
}) {
  final config = residential.config;
  if (!residential.applied || !_ordinaryGroupIsSafe(original)) return config;
  final groups = List<dynamic>.from(config['proxy-groups'] as List);
  if (groups.any((g) => g['name'] == residentialBulkGroup) ||
      (config['proxies'] as List? ?? const []).any(
        (p) => p['name'] == residentialBulkGroup,
      )) {
    throw const ResidentialConfigException(
      'the bulk routing group name is already in use',
    );
  }
  final rules = List<String>.from(config['rules'] as List);
  final originalRules = List<String>.from(original['rules'] ?? const []);
  final existingSubRules = Map<String, dynamic>.from(
    config['sub-rules'] ?? const {},
  );
  // Opaque rule sets need a server-side equivalence contract before injection.
  if (existingSubRules.isNotEmpty ||
      rules.any(
        (r) => {
          'RULE-SET',
          'SUB-RULE',
        }.contains(r.split(',').first.trim().toUpperCase()),
      )) {
    return config;
  }
  final supplied = <int>{};
  for (var i = 0; i < originalRules.length; i++) {
    final fields = originalRules[i].split(',').map((s) => s.trim()).toList();
    if (fields.length == 3 &&
        {'DOMAIN', 'DOMAIN-SUFFIX'}.contains(fields[0].toUpperCase()) &&
        residentialBulkDomains.contains(fields[1].toLowerCase()) &&
        fields[2] == _ordinaryGroup) {
      supplied.add(i);
    }
  }
  if (supplied.isNotEmpty) {
    for (final index in supplied) {
      rules[index] = originalRules[index];
    }
    return {...config, 'rules': rules};
  }
  final predicate = residentialBulkDomains
      .map((domain) => '(DOMAIN-SUFFIX,$domain)')
      .join(',');
  final bypass = <String>[];
  for (final rule in rules) {
    final guarded = _bulkTarget(rule, predicate);
    if (guarded != null) bypass.add(guarded);
    bypass.add(rule);
  }
  groups.add({
    'name': residentialBulkGroup,
    'type': 'select',
    'hidden': true,
    'proxies': [_ordinaryGroup],
  });
  return {...config, 'proxy-groups': groups, 'rules': bypass};
}

String? _bulkTarget(String rule, String predicate) {
  final fields = rule.split(',');
  final action = fields.first.trim().toUpperCase();
  final index = switch (action) {
    'MATCH' => 1,
    'AND' ||
    'OR' ||
    'NOT' ||
    'DOMAIN-REGEX' ||
    'PROCESS-NAME-REGEX' ||
    'PROCESS-PATH-REGEX' => fields.length - 1,
    _ => 2,
  };
  if (fields[index].trim() != tianjiResidentialLockedGroupName) return null;
  if (action == 'DOMAIN' || action == 'DOMAIN-SUFFIX') {
    final host = fields[1].trim().toLowerCase();
    final within = residentialBulkDomains.any(
      (domain) => host == domain || host.endsWith('.$domain'),
    );
    if (within) {
      fields[index] = residentialBulkGroup;
      return fields.join(',');
    }
    if (action == 'DOMAIN' ||
        !residentialBulkDomains.any((domain) => domain.endsWith('.$host'))) {
      return null;
    }
  }
  if (action == 'MATCH') return 'OR,($predicate),$residentialBulkGroup';
  fields.removeAt(index);
  return 'AND,((OR,($predicate)),(${fields.join(',')})),$residentialBulkGroup';
}

bool _ordinaryGroupIsSafe(Map<String, dynamic> config) {
  final graph = ResidentialGraph.fromConfig(config);
  if (!graph.hasRoot || !graph.safeGroup(_ordinaryGroup)) return false;
  final groups = {
    for (final group in config['proxy-groups'] as List)
      group['name'] as String: group,
  };
  if (groups[_ordinaryGroup]?['type'] != 'url-test') return false;
  if ((groups[tianjiResidentialRootName]['proxies'] as List).length !=
      graph.choices.length) {
    return false;
  }
  Set<String> leaves(String name, Set<String> visiting) {
    if (visiting.contains(name)) return {tianjiResidentialRootName};
    final group = groups[name];
    if (group == null) return {name};
    if (group['empty-fallback'] case final String fallback
        when fallback != 'REJECT') {
      return {tianjiResidentialRootName};
    }
    return {
      for (final child in group['proxies'] as List)
        ...leaves(child as String, {...visiting, name}),
    };
  }

  final ordinary = leaves(_ordinaryGroup, {});
  final residential = leaves(tianjiResidentialRootName, {});
  return ordinary.isNotEmpty &&
      !ordinary.contains(tianjiResidentialRootName) &&
      ordinary.intersection(residential).isEmpty;
}
