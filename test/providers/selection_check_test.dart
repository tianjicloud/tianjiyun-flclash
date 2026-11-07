import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import '../helpers/test_profiles.dart';

class _Route extends RouteTracker {
  @override
  RouteState build() => const RouteState(
    coreEpoch: 1,
    routeVersion: 1,
    proxied: true,
    synced: true,
  );
}

class _Probe extends OutboundIpProbe {
  int retries = 0;
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState();

  void answer(List<String> chains) => state = RoutedProbeState({
    routedOutbound: ProbeEntry(
      phase: ProbePhase.fresh,
      value: const IpInfo(ip: '192.0.2.1', countryCode: 'JP'),
      stamp: RouteStamp(
        coreEpoch: 1,
        routeVersion: 1,
        hostEpoch: 0,
        proxied: true,
        chains: chains,
      ),
    ),
  });

  @override
  void recheck(String target) {
    retries++;
    state = const RoutedProbeState({
      routedOutbound: ProbeEntry(phase: ProbePhase.probing),
    });
  }
}

void main() {
  late ProviderContainer container;
  late _Probe probe;
  const profile = Profile(
    id: 1,
    autoUpdateDuration: Duration.zero,
    overrides: ProfileOverrides(
      manualSelections: {
        'Manual': ManualSelection(node: 'A', sequence: 1),
        'AI': ManualSelection(node: 'B', sequence: 2),
      },
    ),
  );

  setUp(() {
    probe = _Probe();
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles(const [profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => 1),
        isStartProvider.overrideWith((_) => true),
        routeTrackerProvider.overrideWith(_Route.new),
        outboundIpProbeProvider.overrideWith(() => probe),
        groupsProvider.overrideWithBuild(
          (_, _) => const [
            Group(name: appName, type: GroupType.Selector, now: 'Manual'),
            Group(name: 'Manual', type: GroupType.Selector, now: 'A'),
            Group(name: 'AI', type: GroupType.Selector, now: 'B'),
          ],
        ),
      ],
    );
    container
        .read(networkSettingProvider.notifier)
        .update((state) => state.copyWith(systemProxy: true));
    container.read(outboundIpProbeProvider);
    container.listen(selectionCheckProvider, (_, _) {});
  });
  tearDown(() => container.dispose());

  test(
    'a newer selection outside the sampled route cannot cause a mismatch',
    () {
      probe.answer(['A', 'Manual', appName]);
      expect(
        container.read(selectionCheckProvider),
        SelectionVerdict.consistent,
      );
      expect(probe.retries, 0);
    },
  );

  test(
    'a route that bypasses the default root does not validate that root',
    () {
      probe.answer(['C', 'Other']);
      expect(
        container.read(selectionCheckProvider),
        SelectionVerdict.untouched,
      );
    },
  );

  test(
    'unattributed mismatch retries once then remains honestly unknown',
    () async {
      probe.answer(['C', 'Manual', appName]);
      expect(
        container.read(selectionCheckProvider),
        SelectionVerdict.unknownPending,
      );
      await container.pump();
      expect(probe.retries, 1);
      expect(
        container.read(selectionCheckProvider),
        SelectionVerdict.confirming,
      );
      probe.answer(['C', 'Manual', appName]);
      expect(container.read(selectionCheckProvider), SelectionVerdict.unknown);
      await container.pump();
      expect(probe.retries, 1);
    },
  );

  test(
    'a pending switch cannot flash a mismatch against the previous answer',
    () {
      container
          .read(manualSelectionPendingProvider.notifier)
          .begin('Manual', 1);
      probe.answer(['C', 'Manual', appName]);
      expect(
        container.read(selectionCheckProvider),
        SelectionVerdict.confirming,
      );
      expect(probe.retries, 0);
    },
  );
}
