import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/misc.dart' show ProviderListenable;

class DashboardLine {
  const DashboardLine({
    required this.groupName,
    required this.name,
    required this.displayName,
    this.countryCode,
    required this.type,
    required this.delay,
    required this.current,
    required this.rate,
    this.residential = false,
  });

  final bool residential;
  final String groupName;
  final String name;
  final String displayName;
  final String? countryCode;
  final String type;
  final int? delay;
  final bool current;
  final double? rate;
}

final _ratePatterns = [
  RegExp(r'倍率\s*(\d+(?:\.\d+)?)\s*[x×]?'),
  RegExp(r'(\d+(?:\.\d+)?)\s*[x×](?![0-9a-zA-Z])'),
  RegExp(r'[x×]\s*(\d+(?:\.\d+)?)(?![0-9a-zA-Z])', caseSensitive: false),
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

String stripBusinessMultiplierSuffix(String name) => name
    .replaceFirst(
      RegExp(
        r'\s*(?:(?:倍率\s*)?\d+(?:\.\d+)?\s*[x×]|[x×]\s*\d+(?:\.\d+)?)\s*$',
        caseSensitive: false,
      ),
      '',
    )
    .trimRight();

double? businessMultiplierFromName(String name) => _rateOf(name)?.rate;

bool isInternalLineGroup(Group group) {
  const internalNames = {
    sceneGroupName,
    sceneRootGroupName,
    sceneDailyGroupName,
    sceneAiGroupName,
    sceneWatchGroupName,
    sceneAiDomainGroupName,
    sceneWatchDomainGroupName,
    tianjiResidentialLockedGroupName,
    '⚡ 自动选择',
    '自动选择',
  };
  return internalNames.contains(group.name) ||
      (group.type == GroupType.URLTest && group.all.length == 1);
}

Group? _hostOf(
  T Function<T>(ProviderListenable<T> provider) read,
  List<Group> groups,
) {
  final byName = {for (final group in groups) group.name: group};
  Group? selectorNamed(String? name) {
    final group = name == null ? null : byName[name];
    return group != null && group.type == GroupType.Selector ? group : null;
  }

  final scene = read(scenePolicyProvider).current;
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
  T watch<T>(ProviderListenable<T> provider) => ref.watch(provider);
  return dashboardLinesFrom(
    watch,
    limit: limit,
    useTianji: ref.watch(tianjiApiEnabledProvider),
  );
}

List<DashboardLine> dashboardLinesFrom(
  T Function<T>(ProviderListenable<T> provider) read, {
  int limit = 4,
  bool useTianji = false,
}) {
  TianjiNode? nodeFor(String name) =>
      useTianji ? read(tianjiNodeProvider(name)) : null;
  final groups = read(currentGroupsStateProvider).value;
  if (groups.isEmpty) return const [];
  final policy = read(residentialPolicyProvider);
  final byName = {for (final group in groups) group.name: group};
  final delays = read(delaysAtLastTestBatchProvider);
  final testUrl = read(realTestUrlProvider());
  final host = policy.active
      ? groups.getGroup(tianjiResidentialRootName) ?? _hostOf(read, groups)
      : _hostOf(read, groups);
  if (host == null) return const [];
  final selected = read(selectedProxyNameProvider(host.name));
  final lines = <DashboardLine>[];
  for (final member in host.all) {
    if (lines.length >= limit) break;
    final target = byName[member.name];
    final resolved = target == null
        ? member.name
        : target.getCurrentSelectedName(
            read(selectedProxyNameProvider(target.name)) ?? '',
          );
    final leaf = byName[resolved];
    final leafProxy = leaf?.all.firstOrNull;
    final type = leafProxy?.type ?? member.type;
    if (type.isEmpty) continue;
    final residentialGroup =
        member.name == tianjiResidentialRootName ||
        member.name == tianjiResidentialLockedGroupName;
    final residential =
        residentialGroup || policy.choices.contains(member.name);
    final ownRate = _rateOf(member.name);
    final parsed = ownRate ?? _rateOf(resolved);
    final rate = _multiplierFor(nodeFor(member.name), parsed?.rate);
    final name = ownRate?.name ?? member.name;
    final countryCode = _countryCodeOf(name);
    lines.add(
      DashboardLine(
        groupName: host.name,
        name: member.name,
        displayName: _displayNameOf(name),
        countryCode: countryCode,
        type: type,
        delay: delays[testUrl]?[resolved],
        residential: residential,
        current: residential
            ? policy.active &&
                  (residentialGroup || policy.selectedExit == member.name)
            : !policy.active && selected == member.name,
        rate: rate,
      ),
    );
  }
  return lines;
}

DashboardLine? currentDashboardLine(WidgetRef ref) => currentDashboardLineFrom(
  ref.watch,
  useTianji: ref.watch(tianjiApiEnabledProvider),
);

DashboardLine? currentDashboardLineFrom(
  T Function<T>(ProviderListenable<T> provider) watch, {
  bool useTianji = false,
}) {
  TianjiNode? nodeFor(String name) =>
      useTianji ? watch(tianjiNodeProvider(name)) : null;
  final groups = watch(currentGroupsStateProvider).value;
  if (groups.isEmpty) return null;
  final policy = watch(residentialPolicyProvider);
  final byName = {for (final group in groups) group.name: group};
  final delays = watch(delaysAtLastTestBatchProvider);
  final testUrl = watch(realTestUrlProvider());
  final host = _hostOf(watch, groups);
  if (!policy.active && host == null) return null;
  final selected = policy.active
      ? policy.selectedExit
      : watch(selectedProxyNameProvider(host!.name));
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
                watch(selectedProxyNameProvider(target.name)) ?? '',
              );
        final leaf = byName[resolved];
        final type = leaf?.all.firstOrNull?.type ?? member.type;
        if (type.isEmpty) return null;
        final ownRate = _rateOf(member.name);
        final parsed = ownRate ?? _rateOf(resolved);
        final rate = _multiplierFor(nodeFor(member.name), parsed?.rate);
        final name = ownRate?.name ?? member.name;
        return DashboardLine(
          groupName: group.name,
          name: member.name,
          displayName: _displayNameOf(name),
          countryCode: _countryCodeOf(name),
          type: type,
          delay: delays[testUrl]?[resolved],
          current: true,
          rate: rate,
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
              watch(selectedProxyNameProvider(target.name)) ?? '',
            );
      final leaf = byName[resolved];
      final type = leaf?.all.firstOrNull?.type ?? member.type;
      if (type.isEmpty) return null;
      final ownRate = _rateOf(member.name);
      final parsed = ownRate ?? _rateOf(resolved);
      final rate = _multiplierFor(nodeFor(member.name), parsed?.rate);
      final name = ownRate?.name ?? member.name;
      return DashboardLine(
        groupName: group.name,
        name: member.name,
        displayName: _displayNameOf(name),
        countryCode: _countryCodeOf(name),
        type: type,
        delay: delays[testUrl]?[resolved],
        current: true,
        rate: rate,
      );
    }
  }
  return null;
}

String? _countryCodeOf(String name) =>
    RegExp(r'^([A-Z]{2})\s*[·|—-]\s*').firstMatch(name)?.group(1);

double? _multiplierFor(TianjiNode? node, double? parsedRate) =>
    node?.multiplier ?? parsedRate;

String _displayNameOf(String name) =>
    name.replaceFirst(RegExp(r'^[A-Z]{2}\s*[·|—-]\s*'), '');
