import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/route_state.dart';
import 'package:fl_clash/providers/routed_probe.dart';

enum SelectionVerdict {
  untouched,
  confirming,
  consistent,
  notCaptured,
  residentialLocked,
  groupOverridden,
  unknownPending,
  unknown,
}

SelectionVerdict verifySelection({
  required String? expected,
  required ProbeEntry<IpInfo> entry,
  required RouteState route,
  required bool running,
  required bool captured,
  bool residentialLocked = false,
  bool automaticGroup = false,
  bool retried = false,
}) {
  if (expected == null && !residentialLocked) return SelectionVerdict.untouched;
  if (running && !captured) return SelectionVerdict.notCaptured;
  if (residentialLocked) return SelectionVerdict.residentialLocked;
  final stamp = entry.stamp;
  if (!running ||
      entry.phase != ProbePhase.fresh ||
      entry.value == null ||
      stamp == null ||
      !route.isFresh(stamp) ||
      stamp.chains.isEmpty) {
    return SelectionVerdict.confirming;
  }
  if (stamp.chains.first == expected) return SelectionVerdict.consistent;
  if (automaticGroup) return SelectionVerdict.groupOverridden;
  return retried ? SelectionVerdict.unknown : SelectionVerdict.unknownPending;
}

({String? expected, int sequence, bool automatic}) selectionOnPath({
  required List<String> path,
  required List<Group> groups,
  required Map<String, ManualSelection> selections,
}) {
  String? selected;
  var sequence = 0;
  var automatic = false;
  for (final name in path) {
    final pick = selections[name];
    if (pick == null || pick.node.isEmpty || pick.sequence <= sequence) {
      continue;
    }
    selected = pick.node;
    sequence = pick.sequence;
    automatic = groups.getGroup(name)?.type.isComputedSelected == true;
  }
  final visited = <String>{};
  while (selected != null && visited.add(selected)) {
    final group = groups.getGroup(selected);
    if (group == null) {
      return (expected: selected, sequence: sequence, automatic: automatic);
    }
    final manual = selections[selected];
    selected = manual != null && manual.node.isNotEmpty
        ? manual.node
        : group.now;
  }
  return (expected: null, sequence: sequence, automatic: automatic);
}
