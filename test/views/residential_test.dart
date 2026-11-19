import 'package:fl_clash/common/service_probe.dart' show routedOutbound;
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/residential.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';

import '../helpers/host_scaffold.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

const _url = 'https://sub1.tianjiyun.org/s/test_subscription_001';
const _exit = 'Tokyo home';
const _exitGroup = Group(
  name: _exit,
  type: GroupType.Selector,
  hidden: false,
  all: [Proxy(name: 'Tokyo home', type: 'ss')],
);

class _MutableProbe extends OutboundIpProbe {
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState();

  @override
  void watch(String target) {}

  @override
  void unwatch(String target) {}
}

void main() {
  testWidgets(
    'residential exit card keeps its rect through probe, verdict, and delay states',
    (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final profile = Profile.normal(url: _url).copyWith(
        currentGroupName: tianjiResidentialRootName,
        selectedMap: const {tianjiResidentialRootName: _exit},
      );
      final container = ProviderContainer(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([profile])),
          currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
          groupsProvider.overrideWithValue([
            const Group(
              name: tianjiResidentialRootName,
              type: GroupType.Selector,
              hidden: false,
              now: _exit,
              all: [Proxy(name: _exit, type: 'ss')],
            ),
            _exitGroup,
          ]),
          currentGroupsStateProvider.overrideWithValue(
            const GroupsState(value: [_exitGroup]),
          ),
          groupsSourceProfileProvider.overrideWith(_ReadyGroups.new),
          residentialPolicyProvider.overrideWithValue(
            const ResidentialPolicy(
              profileId: 1,
              fingerprint: 'fingerprint',
              configuredExit: _exit,
              selectedExit: _exit,
              active: true,
              rootAvailable: true,
              choices: [_exit],
              catalogReady: true,
            ),
          ),
          outboundIpProbeProvider.overrideWith(_MutableProbe.new),
          selectionCheckProvider.overrideWithBuild(
            (_, _) => SelectionVerdict.confirming,
          ),
        ],
      );
      addTearDown(container.dispose);
      globalState.container = container;
      container.read(viewSizeProvider.notifier).value = const Size(1920, 1080);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            homeBuilder: (child) => HostScaffold(body: child),
            child: const ResidentialView(),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'initial layout');

      final exitCards = find.ancestor(
        of: find.text(_exit),
        matching: find.byType(Card),
      );
      expect(exitCards, findsWidgets);
      final initial = tester.getRect(exitCards.first);
      void expectExitCardRect() {
        expect(exitCards, findsWidgets);
        expect(tester.getRect(exitCards.first), initial);
      }

      container
          .read(outboundIpProbeProvider.notifier)
          .state = const RoutedProbeState({
        routedOutbound: ProbeEntry(phase: ProbePhase.fresh),
      });
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'probe pending');
      expectExitCardRect();
      container
          .read(outboundIpProbeProvider.notifier)
          .state = const RoutedProbeState({
        routedOutbound: ProbeEntry(
          phase: ProbePhase.fresh,
          value: IpInfo(ip: '203.0.113.9', isp: 'Example Fiber'),
        ),
      });
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'ISP returned');
      expectExitCardRect();

      for (final verdict in [
        SelectionVerdict.consistent,
        SelectionVerdict.egressMismatch,
      ]) {
        container.read(selectionCheckProvider.notifier).state = verdict;
        await tester.pump();
        expect(tester.takeException(), isNull, reason: 'verdict $verdict');
        expectExitCardRect();
      }

      final testUrl = container.read(realTestUrlProvider());
      final key = '$testUrl\u0000$_exit';
      container
          .read(pendingDelayTestsProvider.notifier)
          .apply(acquired: [key], started: [key]);
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'delay running');
      expect(find.text('…'), findsOneWidget);
      expectExitCardRect();
      container.read(pendingDelayTestsProvider.notifier).apply(finished: [key]);
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'delay cleared');
      expect(find.text('—'), findsOneWidget);
      expectExitCardRect();
      container
          .read(delayDataSourceProvider.notifier)
          .setDelay(Delay(name: _exit, url: testUrl, value: 123));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'delay result');
      expect(find.text('123 ms'), findsOneWidget);
      expectExitCardRect();
      expect(tester.takeException(), isNull);
    },
  );
}

class _ReadyGroups extends GroupsSourceProfile {
  @override
  GroupsCatalogSource build() =>
      const GroupsCatalogSource(profileId: 1, url: _url, loaded: true);
}
