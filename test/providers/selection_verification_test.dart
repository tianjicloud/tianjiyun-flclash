import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/route_state.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const route = RouteState(
    coreEpoch: 3,
    routeVersion: 7,
    proxied: true,
    synced: true,
  );
  ProbeEntry<IpInfo> answer({
    int epoch = 3,
    int version = 7,
    String exit = 'A',
    ProbePhase phase = ProbePhase.fresh,
  }) => ProbeEntry(
    phase: phase,
    value: const IpInfo(ip: '192.0.2.1', countryCode: 'JP'),
    stamp: RouteStamp(
      coreEpoch: epoch,
      routeVersion: version,
      hostEpoch: 0,
      proxied: true,
      chains: [exit, 'Root'],
    ),
  );
  SelectionVerdict verify({
    String? expected = 'A',
    ProbeEntry<IpInfo>? entry,
    bool captured = true,
    bool locked = false,
    bool auto = false,
    bool retry = false,
    TianjiNode? node,
  }) => verifySelection(
    expected: expected,
    entry: entry ?? answer(),
    route: route,
    running: true,
    captured: captured,
    residentialLocked: locked,
    automaticGroup: auto,
    retried: retry,
    node: node,
  );

  test('pure automatic history makes no consistency assertion', () {
    expect(verify(expected: null), SelectionVerdict.untouched);
  });
  test('matching fresh exit is consistent', () {
    expect(verify(), SelectionVerdict.consistent);
  });
  test('old epoch and route version are never proof', () {
    expect(verify(entry: answer(epoch: 2)), SelectionVerdict.confirming);
    expect(verify(entry: answer(version: 6)), SelectionVerdict.confirming);
  });
  test('pending and failed probes never pass', () {
    for (final phase in [ProbePhase.empty, ProbePhase.probing]) {
      expect(verify(entry: answer(phase: phase)), SelectionVerdict.confirming);
    }
  });
  test('a failed probe is a retryable failure, not pending', () {
    expect(
      verify(entry: answer(phase: ProbePhase.failed)),
      SelectionVerdict.failed,
    );
  });
  test('capture and residential rejection use explicit signals', () {
    expect(verify(captured: false), SelectionVerdict.notCaptured);
    expect(verify(locked: true), SelectionVerdict.residentialLocked);
  });
  test('automatic override is attributed only with the group signal', () {
    expect(
      verify(entry: answer(exit: 'B'), auto: true),
      SelectionVerdict.groupOverridden,
    );
  });
  test('unknown gets one retry and never guesses a server cause', () {
    expect(verify(entry: answer(exit: 'B')), SelectionVerdict.unknownPending);
    expect(
      verify(entry: answer(exit: 'B'), retry: true),
      SelectionVerdict.unknown,
    );
  });
  test('Tianji egress is checked only for listed expected exits', () {
    const node = TianjiNode(
      name: 'JP home',
      expectedExit: EgressExit(kind: 'residential', countryCode: 'JP'),
    );
    ProbeEntry<IpInfo> tianji({EgressExit? exit}) => ProbeEntry(
      phase: ProbePhase.fresh,
      value: IpInfo(
        ip: '192.0.2.1',
        countryCode: 'JP',
        exit: exit,
        fromTianji: true,
      ),
      stamp: answer().stamp,
    );
    expect(verify(node: null, entry: tianji()), SelectionVerdict.consistent);
    expect(
      verify(
        node: const TianjiNode(name: 'unknown'),
        entry: tianji(),
      ),
      SelectionVerdict.consistent,
    );
    expect(
      verify(node: node, entry: tianji(), retry: false),
      SelectionVerdict.egressPending,
    );
    expect(
      verify(node: node, entry: tianji(), retry: true),
      SelectionVerdict.trafficNotOnTianji,
    );
    expect(
      verify(
        node: node,
        entry: tianji(
          exit: const EgressExit(kind: 'residential', countryCode: 'US'),
        ),
      ),
      SelectionVerdict.egressMismatch,
    );
    expect(
      verify(
        node: node,
        entry: tianji(
          exit: const EgressExit(kind: 'datacenter', countryCode: 'JP'),
        ),
      ),
      SelectionVerdict.egressAnomaly,
    );
    expect(verify(node: node, entry: answer()), SelectionVerdict.consistent);
  });
  test(
    'a more recent off-path selection never changes the default expectation',
    () {
      const picks = {
        'Root': ManualSelection(node: 'Manual', sequence: 1),
        'Manual': ManualSelection(node: 'A', sequence: 2),
        'AI': ManualSelection(node: 'B', sequence: 3),
      };
      const groups = [
        Group(name: 'Manual', type: GroupType.Selector, now: 'A'),
      ];
      expect(
        selectionOnPath(
          path: ['Root', 'Manual', 'A'],
          groups: groups,
          selections: picks,
        ),
        (expected: 'A', sequence: 2, automatic: false),
      );
      expect(
        selectionOnPath(
          path: ['Other'],
          groups: groups,
          selections: picks,
        ).expected,
        isNull,
      );
    },
  );
  test('cycles and a return to automatic do not invent expected exits', () {
    const groups = [Group(name: 'Loop', type: GroupType.Selector, now: 'Loop')];
    expect(
      selectionOnPath(
        path: ['Root'],
        groups: groups,
        selections: const {'Root': ManualSelection(node: 'Loop', sequence: 1)},
      ).expected,
      isNull,
    );
    expect(
      selectionOnPath(
        path: ['Root'],
        groups: groups,
        selections: const {'Root': ManualSelection(node: '', sequence: 2)},
      ).expected,
      isNull,
    );
  });
}
