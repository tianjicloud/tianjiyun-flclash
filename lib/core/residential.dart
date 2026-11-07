const tianjiResidentialRootName = '🏠 家宽';
const tianjiResidentialLockedGroupName = '🔒 天机家宽出口';

const _builtinRuleTargets = {
  'DIRECT',
  'REJECT',
  'REJECT-DROP',
  'PASS',
  'PASS-RULE',
  'COMPATIBLE',
};

const _nonProxyTypes = {'direct', 'reject', 'dns', 'rematch'};

const _commaPayloadActions = {
  'AND',
  'OR',
  'NOT',
  'SUB-RULE',
  'DOMAIN-REGEX',
  'PROCESS-NAME-REGEX',
  'PROCESS-PATH-REGEX',
};

enum ResidentialExitState { applied, missingExit }

class ResidentialTransformResult {
  const ResidentialTransformResult({
    required this.config,
    required this.state,
  });

  final Map<String, dynamic> config;
  final ResidentialExitState state;

  bool get applied => state == ResidentialExitState.applied;

  bool get missingExit => state == ResidentialExitState.missingExit;
}

class ResidentialConfigException implements Exception {
  const ResidentialConfigException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The direct members of [tianjiResidentialRootName] that resolve only through
/// proxies. Everything is read from one graph so the transform and the UI
/// cannot disagree about which children are selectable.
class ResidentialGraph {
  ResidentialGraph({
    required Map<String, List<String>> groups,
    required Map<String, String> proxies,
    Set<String> dynamicGroups = const {},
  }) : _groups = groups,
       _proxies = proxies,
       _dynamicGroups = dynamicGroups;

  factory ResidentialGraph.fromConfig(Map<String, dynamic> config) {
    final groups = <String, List<String>>{};
    final dynamicGroups = <String>{};
    final rawGroups = config['proxy-groups'];
    if (rawGroups != null) {
      if (rawGroups is! List) {
        throw const ResidentialConfigException('proxy-groups is not a list');
      }
      for (final item in rawGroups) {
        if (item is! Map) {
          throw const ResidentialConfigException('a proxy group is not a map');
        }
        final name = item['name'];
        if (name is! String || name.isEmpty) {
          throw const ResidentialConfigException('a proxy group has no name');
        }
        if (groups.containsKey(name)) {
          throw ResidentialConfigException('duplicate proxy group "$name"');
        }
        groups[name] = _stringList(
          item['proxies'] ?? const <String>[],
          'group $name',
        );
        if (_canIncludeUndeclared(item)) {
          dynamicGroups.add(name);
        }
      }
    }
    final proxies = <String, String>{};
    final rawProxies = config['proxies'];
    if (rawProxies != null) {
      if (rawProxies is! List) {
        throw const ResidentialConfigException('proxies is not a list');
      }
      for (final item in rawProxies) {
        if (item is! Map) {
          throw const ResidentialConfigException('a proxy is not a map');
        }
        final name = item['name'];
        if (name is! String || name.isEmpty) {
          throw const ResidentialConfigException('a proxy has no name');
        }
        proxies[name] = item['type']?.toString() ?? '';
      }
    }
    return ResidentialGraph(
      groups: groups,
      proxies: proxies,
      dynamicGroups: dynamicGroups,
    );
  }

  final Map<String, List<String>> _groups;
  final Map<String, String> _proxies;
  final Set<String> _dynamicGroups;
  final _safeGroups = <String, bool>{};
  final _proxyGroups = <String, bool>{};

  bool get hasRoot => _groups.containsKey(tianjiResidentialRootName);

  bool get hasLockedName =>
      _groups.containsKey(tianjiResidentialLockedGroupName) ||
      _proxies.containsKey(tianjiResidentialLockedGroupName);

  List<String> get choices {
    final root = _groups[tianjiResidentialRootName];
    if (root == null) {
      return const [];
    }
    final choices = <String>[];
    for (final name in root) {
      if (_builtinRuleTargets.contains(name.toUpperCase())) {
        continue;
      }
      if (_groups.containsKey(name)) {
        if (safeGroup(name)) {
          choices.add(name);
        }
        continue;
      }
      final type = _proxies[name];
      if (type != null && !_nonProxyTypes.contains(type.toLowerCase())) {
        choices.add(name);
      }
    }
    return choices;
  }

  bool safeGroup(String name) {
    return _safeGroups.putIfAbsent(
      name,
      () => _safeGroup(name, <String>{}),
    );
  }

  bool isProxyTarget(String target) {
    if (_builtinRuleTargets.contains(target.toUpperCase())) {
      return false;
    }
    if (target == 'GLOBAL') {
      return true;
    }
    if (_groups.containsKey(target)) {
      return _proxyGroups.putIfAbsent(
        target,
        () => _canSelectProxy(target, <String>{}),
      );
    }
    final type = _proxies[target];
    if (type == null) {
      throw ResidentialConfigException(
        'rule target "$target" is not defined in this profile',
      );
    }
    return !_nonProxyTypes.contains(type.toLowerCase());
  }

  bool _safeGroup(String name, Set<String> visiting) {
    if (name == tianjiResidentialRootName || !visiting.add(name)) {
      return false;
    }
    try {
      final members = _groups[name];
      if (members == null || _dynamicGroups.contains(name)) {
        return false;
      }
      for (final member in members) {
        if (_builtinRuleTargets.contains(member.toUpperCase())) {
          return false;
        }
        if (_groups.containsKey(member)) {
          if (!_safeGroup(member, visiting)) {
            return false;
          }
          continue;
        }
        final type = _proxies[member];
        if (type == null || _nonProxyTypes.contains(type.toLowerCase())) {
          return false;
        }
      }
      return members.isNotEmpty;
    } finally {
      visiting.remove(name);
    }
  }

  bool _canSelectProxy(String name, Set<String> visiting) {
    if (!visiting.add(name)) {
      return true;
    }
    try {
      final members = _groups[name];
      if (members == null) {
        return true;
      }
      if (_dynamicGroups.contains(name)) {
        return true;
      }
      for (final member in members) {
        if (_builtinRuleTargets.contains(member.toUpperCase())) {
          continue;
        }
        if (_groups.containsKey(member)) {
          if (_canSelectProxy(member, visiting)) {
            return true;
          }
          continue;
        }
        final type = _proxies[member];
        if (type == null) {
          throw ResidentialConfigException(
            'group "$name" references unknown target "$member"',
          );
        }
        if (!_nonProxyTypes.contains(type.toLowerCase())) {
          return true;
        }
      }
      return false;
    } finally {
      visiting.remove(name);
    }
  }
}

List<String> residentialChoices(Map<String, dynamic> config) {
  return ResidentialGraph.fromConfig(config).choices;
}

/// Rewrites every proxy-targeted rule to one reserved group that selects only
/// [selectedExit]. A target that is not a direct member of the residential root
/// keeps the locked group on REJECT instead of falling back to another exit.
ResidentialTransformResult applyResidentialEgress({
  required Map<String, dynamic> config,
  required String selectedExit,
}) {
  final graph = ResidentialGraph.fromConfig(config);
  if (graph.hasLockedName) {
    throw const ResidentialConfigException(
      'the residential lock group name is already in use',
    );
  }
  final safe = selectedExit.isNotEmpty && graph.choices.contains(selectedExit);
  final locked = <String, dynamic>{
    'name': tianjiResidentialLockedGroupName,
    'type': 'select',
    'proxies': [safe ? selectedExit : 'REJECT'],
    'hidden': true,
  };
  final groupList = config['proxy-groups'] == null
      ? <dynamic>[]
      : List<dynamic>.from(config['proxy-groups'] as List);
  groupList.add(locked);
  final output = Map<String, dynamic>.from(config)
    ..['proxy-groups'] = groupList
    ..['mode'] = 'rule';

  final rulesRaw = config['rules'];
  if (rulesRaw != null && rulesRaw is! List) {
    throw const ResidentialConfigException('rules is not a list');
  }
  final rules = _rewriteRules(rulesRaw ?? const [], graph);
  if (!rules.any((rule) => _actionOf(rule) == 'MATCH')) {
    rules.add('MATCH,$tianjiResidentialLockedGroupName');
  }
  output['rules'] = rules;

  final subRules = config['sub-rules'];
  if (subRules != null) {
    if (subRules is! Map) {
      throw const ResidentialConfigException('sub-rules is not a map');
    }
    output['sub-rules'] = {
      for (final entry in subRules.entries)
        entry.key.toString(): _rewriteRules(
          _stringList(entry.value, 'sub-rule ${entry.key}'),
          graph,
        ),
    };
  }
  return ResidentialTransformResult(
    config: output,
    state: safe
        ? ResidentialExitState.applied
        : ResidentialExitState.missingExit,
  );
}

List<String> _rewriteRules(Iterable<dynamic> rules, ResidentialGraph graph) {
  final output = <String>[];
  for (final rule in rules) {
    if (rule is! String) {
      throw const ResidentialConfigException('a rule is not a string');
    }
    output.add(_rewriteRule(rule, graph));
  }
  return output;
}

String _rewriteRule(String rule, ResidentialGraph graph) {
  final fields = rule.split(',');
  if (fields.length < 2) {
    throw ResidentialConfigException('unsupported rule "$rule"');
  }
  final action = _actionOf(rule);
  if (action == 'SUB-RULE') {
    return rule;
  }
  final index = _targetIndex(action, fields.length, rule);
  final target = fields[index].trim();
  if (target.isEmpty) {
    throw ResidentialConfigException('rule "$rule" has no target');
  }
  if (!graph.isProxyTarget(target)) {
    return rule;
  }
  fields[index] = tianjiResidentialLockedGroupName;
  return fields.join(',');
}

String _actionOf(String rule) => rule.split(',').first.trim().toUpperCase();

int _targetIndex(String action, int length, String rule) {
  if (action == 'MATCH') {
    if (length < 2) {
      throw ResidentialConfigException('unsupported rule "$rule"');
    }
    return 1;
  }
  if (_commaPayloadActions.contains(action)) {
    return length - 1;
  }
  if (length < 3) {
    throw ResidentialConfigException('unsupported rule "$rule"');
  }
  return 2;
}

bool _canIncludeUndeclared(Map<Object?, Object?> group) {
  return group['include-all'] == true ||
      group['include-all-proxies'] == true ||
      group['include-all-providers'] == true ||
      group['use'] is List && (group['use'] as List).isNotEmpty;
}

List<String> _stringList(Object? raw, String label) {
  if (raw is! List) {
    throw ResidentialConfigException('$label is not a list');
  }
  final values = <String>[];
  for (final item in raw) {
    if (item is! String || item.isEmpty) {
      throw ResidentialConfigException('$label has a non-string member');
    }
    values.add(item);
  }
  return values;
}
