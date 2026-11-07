import 'package:fl_clash/core/residential.dart';

/// The scene switch's contract with the subscription: a select group named
/// [sceneGroupName] whose members are the scene groups, a root select named
/// [sceneRootGroupName] that can point at it, and domain groups whose rules
/// a scene retargets. Subscriptions without the pivot group simply have no
/// scenes; nothing is invented for them.
const sceneGroupName = '场景模式';
const sceneRootGroupName = '总出口';
const sceneDailyGroupName = '日常';
const sceneAiGroupName = 'AI模式';
const sceneWatchGroupName = '观影模式';
const sceneAiDomainGroupName = 'AI服务';
const sceneWatchDomainGroupName = '流媒体';

enum SceneKind { daily, ai, watch }

extension SceneKindMembers on SceneKind {
  String get groupName => switch (this) {
    SceneKind.daily => sceneDailyGroupName,
    SceneKind.ai => sceneAiGroupName,
    SceneKind.watch => sceneWatchGroupName,
  };

  String get storageValue => groupName;
}

/// The member of the scene pivot the scene points at, following nested
/// selects through the graph like a manual selection would resolve.
SceneKind? sceneKindOfSelection(String? selected) {
  return switch (selected) {
    sceneDailyGroupName => SceneKind.daily,
    sceneAiGroupName => SceneKind.ai,
    sceneWatchGroupName => SceneKind.watch,
    _ => null,
  };
}

class SceneApplication {
  const SceneApplication({
    required this.config,
    required this.applied,
    required this.unconfirmed,
  });

  final Map<String, dynamic> config;

  /// The pivot now selects the scene's group.
  final bool applied;

  /// Domain rules still end at a group the scene cannot speak for, or the
  /// config carries constructs (rule sets, sub-rules) whose targets cannot
  /// be rewritten safely; the UI must say the steering is unconfirmed,
  /// mirroring the residential bulk bypass contract.
  final bool unconfirmed;
}

/// Points the profile at [scene]: the pivot group selects the scene's
/// group, the root group selects the pivot, and every rule that targeted a
/// scene-steerable domain group is retargeted to the scene's own group, so
/// the switch moves traffic instead of only renaming a selection.
///
/// Residential mode owns the whole profile while a residential exit is
/// active, so the caller skips this transform then, exactly as it skips
/// manual selections. A config whose pivot or scene group is missing, or
/// whose graph is unsafe, comes back unapplied rather than half-rewritten.
SceneApplication applyScene({
  required Map<String, dynamic> config,
  required SceneKind scene,
}) {
  SceneApplication fail({bool unconfirmed = false}) => SceneApplication(
    config: config,
    applied: false,
    unconfirmed: unconfirmed,
  );
  final graph = ResidentialGraph.fromConfig(config);
  if (!graph.safeGroup(sceneGroupName) || !graph.safeGroup(scene.groupName)) {
    return fail();
  }
  final groups = config['proxy-groups'];
  if (groups is! List) return fail();
  final byName = <String, Map<String, dynamic>>{};
  for (final item in groups) {
    if (item is Map<String, dynamic>) byName[item['name'] as String] = item;
  }
  final pivot = byName[sceneGroupName];
  if (pivot == null || pivot['type'] != 'select') return fail();
  final members = pivot['proxies'];
  if (members is! List || !members.contains(scene.groupName)) return fail();

  final next = Map<String, dynamic>.from(config);
  final nextGroups = <Map<String, dynamic>>[];
  for (final item in groups) {
    final group = Map<String, dynamic>.from(item as Map);
    if (group['name'] == sceneGroupName) {
      group['default-selected'] = scene.groupName;
    } else if (group['name'] == sceneRootGroupName &&
        group['type'] == 'select' &&
        (group['proxies'] as List? ?? const []).contains(sceneGroupName)) {
      group['default-selected'] = sceneGroupName;
    }
    nextGroups.add(group);
  }
  next['proxy-groups'] = nextGroups;

  final domainTargets = {
    sceneAiDomainGroupName: sceneAiGroupName,
    sceneWatchDomainGroupName: sceneWatchGroupName,
  };
  final wanted = {
    sceneAiDomainGroupName: scene == SceneKind.ai
        ? sceneAiGroupName
        : sceneDailyGroupName,
    sceneWatchDomainGroupName: scene == SceneKind.watch
        ? sceneWatchGroupName
        : sceneDailyGroupName,
  };
  var unconfirmed = false;
  final subRules = config['sub-rules'];
  if (subRules is Map && subRules.isNotEmpty) unconfirmed = true;
  final rules = config['rules'];
  if (rules is List) {
    final nextRules = <String>[];
    for (final raw in rules) {
      final rule = raw.toString();
      final action = rule.split(',').first.trim().toUpperCase();
      if (action == 'RULE-SET' || action == 'SUB-RULE') {
        unconfirmed = true;
        nextRules.add(rule);
        continue;
      }
      final retargeted = _retargetRule(rule, domainTargets, wanted);
      if (retargeted == null) {
        unconfirmed = true;
        nextRules.add(rule);
      } else {
        nextRules.add(retargeted);
      }
    }
    next['rules'] = nextRules;
  }
  // The domain groups' own memberships stay as delivered; only rule
  // targets move. A group the wanted target does not exist for leaves the
  // steering unconfirmed rather than silently partial.
  for (final entry in wanted.entries) {
    if (!byName.containsKey(entry.key) && _rulesTarget(rules, entry.key)) {
      unconfirmed = true;
    }
    if (!graph.safeGroup(entry.value)) unconfirmed = true;
  }
  return SceneApplication(
    config: next,
    applied: true,
    unconfirmed: unconfirmed,
  );
}

bool _rulesTarget(Object? rules, String target) {
  if (rules is! List) return false;
  for (final raw in rules) {
    final fields = raw.toString().split(',');
    if (fields.length >= 2 && fields.last.trim() == target) return true;
  }
  return false;
}

/// Rewrites [rule]'s target when it is a scene-steerable domain group.
/// Returns null when the rule's shape cannot be rewritten safely (a logic
/// rule whose payload mentions the group), so the caller can flag the
/// steering unconfirmed instead of guessing.
String? _retargetRule(
  String rule,
  Map<String, String> domainTargets,
  Map<String, String> wanted,
) {
  final fields = rule.split(',');
  final action = fields.first.trim().toUpperCase();
  const payloadActions = {
    'AND',
    'OR',
    'NOT',
    'DOMAIN-REGEX',
    'PROCESS-NAME-REGEX',
    'PROCESS-PATH-REGEX',
  };
  if (payloadActions.contains(action)) {
    final target = fields.last.trim();
    if (domainTargets.containsKey(target)) return null;
    return rule;
  }
  final index = action == 'MATCH' ? 1 : 2;
  if (fields.length <= index) return rule;
  final target = fields[index].trim();
  final destination = wanted[target];
  if (destination == null) return rule;
  fields[index] = destination;
  return fields.join(',');
}
