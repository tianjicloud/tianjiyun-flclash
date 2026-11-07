import 'package:fl_clash/models/models.dart';

Map<String, dynamic> applyManualSelections(
  Map<String, dynamic> config,
  Map<String, ManualSelection> selections,
) {
  if (!selections.values.any((selection) => selection.node.isNotEmpty)) {
    return config;
  }
  final groups = config['proxy-groups'] ?? const [];
  if (groups is! List) return config;
  final global = selections['GLOBAL'];
  return {
    ...config,
    'proxy-groups': [
      for (final group in groups)
        if (group is Map && selections[group['name']]?.node.isNotEmpty == true)
          _pinGroup(
            Map<String, dynamic>.from(group),
            selections[group['name']]!.node,
          )
        else
          group,
      if (global != null &&
          global.node.isNotEmpty &&
          !groups.any((group) => group is Map && group['name'] == 'GLOBAL'))
        _pinGroup({
          'name': 'GLOBAL',
          'proxies': [
            'DIRECT',
            'REJECT',
            for (final proxy in config['proxies'] as List? ?? const [])
              if (proxy is Map && proxy['name'] is String) proxy['name'],
            for (final group in groups)
              if (group is Map && group['name'] is String) group['name'],
          ],
        }, global.node),
    ],
  };
}

Map<String, dynamic> _pinGroup(Map<String, dynamic> group, String node) {
  final members = group['proxies'] as List? ?? const [];
  final filter = group['filter'] as String? ?? '';
  final exclude = group['exclude-filter'] as String? ?? '';
  final excludeTypes = group['exclude-type'] as String? ?? '';
  final positions = group['use-position'] as Map?;
  return {
    ...group,
    'type': 'select',
    'default-selected': node,
    // Selector falls back to its first member when a provider drops the pick.
    'proxies': ['REJECT', ...members.where((member) => member != 'REJECT')],
    'empty-fallback': 'REJECT',
    if (positions != null)
      'use-position': {
        for (final entry in positions.entries)
          entry.key: (entry.value as int).clamp(0, members.length) + 1,
      },
    if (filter.isNotEmpty) 'filter': '^REJECT\$`$filter',
    if (exclude.isNotEmpty)
      'exclude-filter': exclude
          .split('`')
          .map((pattern) => '\\A(?!REJECT\\z)(?:$pattern)')
          .join('`'),
    if (excludeTypes.isNotEmpty)
      'exclude-type': excludeTypes
          .split('|')
          .where((type) => type.toLowerCase() != 'reject')
          .join('|'),
  };
}
