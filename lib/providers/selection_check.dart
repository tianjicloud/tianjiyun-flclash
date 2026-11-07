import 'dart:async';

import 'package:fl_clash/common/default_line.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config.dart';
import 'app.dart';
import 'outbound_ip.dart';
import 'residential.dart';
import 'route_state.dart';
import 'selection_verification.dart';
import 'state.dart';

class ManualSelectionPending extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() {
    ref.watch(
      currentProfileProvider.select((profile) => (profile?.id, profile?.url)),
    );
    return const {};
  }

  void begin(String group, int sequence) => state = {...state, group: sequence};

  void finish(int? sequence) {
    if (state.containsValue(sequence)) {
      state = Map.of(state)..removeWhere((_, value) => value == sequence);
    }
  }
}

final manualSelectionPendingProvider =
    NotifierProvider<ManualSelectionPending, Map<String, int>>(
      ManualSelectionPending.new,
    );

class ResidentialSelectionRejection extends Notifier<bool> {
  @override
  bool build() {
    ref.watch(
      currentProfileProvider.select(
        (profile) =>
            (profile?.id, profile?.url, profile?.overrides.residentialExit),
      ),
    );
    return false;
  }

  void reject() => state = true;
}

final residentialSelectionRejectionProvider =
    NotifierProvider<ResidentialSelectionRejection, bool>(
      ResidentialSelectionRejection.new,
    );

class SelectionCheck extends Notifier<SelectionVerdict> {
  Object? _retried;

  @override
  SelectionVerdict build() {
    final profile = ref.watch(currentProfileProvider);
    final groups = ref.watch(groupsProvider);
    final picks =
        profile?.overrides.manualSelections ??
        const <String, ManualSelection>{};
    final entry = ref.watch(outboundIpProbeProvider).entryOf(routedOutbound);
    final route = ref.watch(routeTrackerProvider);
    final mode = ref.watch(
      patchClashConfigProvider.select((value) => value.mode),
    );
    final root = mode == Mode.global
        ? 'GLOBAL'
        : defaultLineRootOf(groups)?.name;
    final path = <String>[];
    var name = root;
    final visited = <String>{};
    while (name != null && visited.add(name)) {
      path.add(name);
      final group = groups.getGroup(name);
      final pick = picks[name];
      name = pick != null && pick.node.isNotEmpty ? pick.node : group?.now;
    }
    final stamp = entry.stamp;
    if (stamp != null &&
        route.isFresh(stamp) &&
        stamp.proxied &&
        stamp.chains.isNotEmpty) {
      path
        ..clear()
        ..addAll(stamp.chains);
    }
    final choice = selectionOnPath(
      path: path,
      groups: groups,
      selections: picks,
    );
    final pending = ref.watch(manualSelectionPendingProvider);
    final residential = ref.watch(residentialPolicyProvider);
    final rejected = ref.watch(residentialSelectionRejectionProvider);
    final key = (
      profile?.id,
      profile?.url,
      choice.sequence,
      residential.selectedExit,
      route.coreEpoch,
      route.routeVersion,
      route.hostEpoch,
    );
    final verdict = verifySelection(
      expected: residential.active ? residential.selectedExit : choice.expected,
      entry: entry,
      route: route,
      running: ref.watch(isStartProvider),
      captured:
          ref.watch(
            networkSettingProvider.select((value) => value.systemProxy),
          ) ||
          ref.watch(
            patchClashConfigProvider.select((value) => value.tun.enable),
          ),
      residentialLocked: residential.active && rejected,
      automaticGroup: !residential.active && choice.automatic,
      retried: _retried == key,
    );
    if (!residential.active &&
        (pending.containsValue(choice.sequence) ||
            (choice.sequence > 0 && choice.expected == null))) {
      return SelectionVerdict.confirming;
    }
    if (verdict == SelectionVerdict.unknownPending && _retried != key) {
      _retried = key;
      scheduleMicrotask(() {
        if (ref.mounted && _retried == key) {
          ref.read(outboundIpProbeProvider.notifier).recheck(routedOutbound);
        }
      });
    }
    return verdict;
  }
}

final selectionCheckProvider =
    NotifierProvider<SelectionCheck, SelectionVerdict>(SelectionCheck.new);
