import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardLine {
  const DashboardLine({
    required this.groupName,
    required this.name,
    required this.displayName,
    required this.type,
    required this.delay,
    required this.current,
    required this.rate,
  });

  final String groupName;
  final String name;
  final String displayName;
  final String type;
  final int? delay;
  final bool current;
  final double? rate;
}

final _ratePatterns = [
  RegExp(r'倍率\s*(\d+(?:\.\d+)?)\s*[x×]?'),
  RegExp(r'(\d+(?:\.\d+)?)\s*[x×](?![0-9a-zA-Z])'),
];

({double rate, String name})? _rateOf(String name) {
  for (final pattern in _ratePatterns) {
    final match = pattern.firstMatch(name);
    if (match == null) continue;
    final rate = double.tryParse(match.group(1)!);
    if (rate == null || rate <= 0) continue;
    final stripped = (name.replaceRange(match.start, match.end, ''))
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^[\s·|/—-]+|[\s·|/—-]+$'), '')
        .trim();
    return (rate: rate, name: stripped.isEmpty ? name : stripped);
  }
  return null;
}

Group? _hostOf(WidgetRef ref, List<Group> groups) {
  final byName = {for (final group in groups) group.name: group};
  Group? selectorNamed(String? name) {
    final group = name == null ? null : byName[name];
    return group != null && group.type == GroupType.Selector ? group : null;
  }

  final scene = ref.watch(scenePolicyProvider).current;
  Group? host;
  for (final candidate in [
    scene?.groupName,
    sceneGroupName,
    sceneRootGroupName,
  ]) {
    host = selectorNamed(candidate);
    if (host != null) break;
  }
  host ??= groups
      .where((group) => group.type == GroupType.Selector)
      .firstOrNull;
  return host;
}

List<DashboardLine> dashboardLines(WidgetRef ref, {int limit = 4}) {
  final groups = ref.watch(currentGroupsStateProvider).value;
  if (groups.isEmpty) return const [];
  final byName = {for (final group in groups) group.name: group};
  final delays = ref.watch(delaysAtLastTestBatchProvider);
  final testUrl = ref.watch(realTestUrlProvider());
  final host = _hostOf(ref, groups);
  if (host == null) return const [];
  final selected = ref.watch(selectedProxyNameProvider(host.name));
  final lines = <DashboardLine>[];
  for (final member in host.all) {
    if (lines.length >= limit) break;
    final target = byName[member.name];
    final resolved = target == null
        ? member.name
        : target.getCurrentSelectedName(
            ref.watch(selectedProxyNameProvider(target.name)) ?? '',
          );
    final leaf = byName[resolved];
    final leafProxy = leaf?.all.firstOrNull;
    final type = leafProxy?.type ?? member.type;
    if (type.isEmpty) continue;
    final ownRate = _rateOf(member.name);
    final parsed = ownRate ?? _rateOf(resolved);
    lines.add(
      DashboardLine(
        groupName: host.name,
        name: member.name,
        displayName: ownRate?.name ?? member.name,
        type: type,
        delay: delays[testUrl]?[resolved],
        current: selected == member.name,
        rate: parsed?.rate,
      ),
    );
  }
  return lines;
}

DashboardLine? currentDashboardLine(WidgetRef ref) {
  final groups = ref.watch(currentGroupsStateProvider).value;
  if (groups.isEmpty) return null;
  final policy = ref.watch(residentialPolicyProvider);
  final byName = {for (final group in groups) group.name: group};
  final delays = ref.watch(delaysAtLastTestBatchProvider);
  final testUrl = ref.watch(realTestUrlProvider());
  final host = _hostOf(ref, groups);
  if (!policy.active && host == null) return null;
  final selected = policy.active
      ? policy.selectedExit
      : ref.watch(selectedProxyNameProvider(host!.name));
  if (selected == null || selected.isEmpty) return null;

  final selectionGroups = policy.active
      ? groups.where((group) => group.type == GroupType.Selector)
      : [host!];
  if (policy.active) {
    for (final group in selectionGroups) {
      for (final member in group.all.where((proxy) => proxy.name == selected)) {
        final target = byName[member.name];
        final resolved = target == null
            ? member.name
            : target.getCurrentSelectedName(
                ref.watch(selectedProxyNameProvider(target.name)) ?? '',
              );
        final leaf = byName[resolved];
        final type = leaf?.all.firstOrNull?.type ?? member.type;
        if (type.isEmpty) return null;
        final ownRate = _rateOf(member.name);
        final parsed = ownRate ?? _rateOf(resolved);
        return DashboardLine(
          groupName: group.name,
          name: member.name,
          displayName: ownRate?.name ?? member.name,
          type: type,
          delay: delays[testUrl]?[resolved],
          current: true,
          rate: parsed?.rate,
        );
      }
    }
    return null;
  }
  for (final group in selectionGroups) {
    for (final member in group.all.where((proxy) => proxy.name == selected)) {
      final target = byName[member.name];
      final resolved = target == null
          ? member.name
          : target.getCurrentSelectedName(
              ref.watch(selectedProxyNameProvider(target.name)) ?? '',
            );
      final leaf = byName[resolved];
      final type = leaf?.all.firstOrNull?.type ?? member.type;
      if (type.isEmpty) return null;
      final ownRate = _rateOf(member.name);
      final parsed = ownRate ?? _rateOf(resolved);
      return DashboardLine(
        groupName: group.name,
        name: member.name,
        displayName: ownRate?.name ?? member.name,
        type: type,
        delay: delays[testUrl]?[resolved],
        current: true,
        rate: parsed?.rate,
      );
    }
  }
  return null;
}
