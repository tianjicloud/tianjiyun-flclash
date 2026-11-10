import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/diagnostics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

void main() {
  const route = RouteState(
    coreEpoch: 2,
    routeVersion: 5,
    hostEpoch: 3,
    proxied: true,
    synced: true,
    live: true,
  );
  const freshStamp = RouteStamp(
    coreEpoch: 2,
    routeVersion: 5,
    hostEpoch: 3,
    proxied: true,
  );

  test('a cached success is unverified while stopped', () {
    const entry = ProbeEntry<ServiceCheck>(
      phase: ProbePhase.fresh,
      value: ServiceCheck(ServiceProbeStatus.available),
      stamp: freshStamp,
    );

    expect(
      serviceDiagnosticResult(active: false, entry: entry, route: route),
      DiagnosticResult.unverified,
    );
  });

  test('a success from an old route epoch is unverified', () {
    const entry = ProbeEntry<ServiceCheck>(
      phase: ProbePhase.fresh,
      value: ServiceCheck(ServiceProbeStatus.available),
      stamp: RouteStamp(
        coreEpoch: 1,
        routeVersion: 5,
        hostEpoch: 3,
        proxied: true,
      ),
    );

    expect(
      serviceDiagnosticResult(active: true, entry: entry, route: route),
      DiagnosticResult.unverified,
    );
  });

  test('a fresh timeout is a failed check', () {
    const entry = ProbeEntry<ServiceCheck>(
      phase: ProbePhase.fresh,
      value: ServiceCheck(ServiceProbeStatus.timeout),
      stamp: freshStamp,
    );

    expect(
      serviceDiagnosticResult(active: true, entry: entry, route: route),
      DiagnosticResult.failed,
    );
  });

  test('an active failed probe is reported as failed', () {
    const entry = ProbeEntry<ServiceCheck>(phase: ProbePhase.failed);

    expect(
      serviceDiagnosticResult(active: true, entry: entry, route: route),
      DiagnosticResult.failed,
    );
  });

  test('a stamped service failure from an old route is unverified', () {
    const entry = ProbeEntry<ServiceCheck>(
      phase: ProbePhase.failed,
      stamp: RouteStamp(
        coreEpoch: 1,
        routeVersion: 5,
        hostEpoch: 3,
        proxied: true,
      ),
    );

    expect(
      serviceDiagnosticResult(active: true, entry: entry, route: route),
      DiagnosticResult.unverified,
    );
  });

  test('an unstamped outbound failure is reported as failed', () {
    const entry = ProbeEntry<IpInfo>(phase: ProbePhase.failed);

    expect(
      outboundDiagnosticResult(active: true, entry: entry, route: route),
      DiagnosticResult.failed,
    );
  });

  test('a stamped outbound failure from an old route is unverified', () {
    const entry = ProbeEntry<IpInfo>(
      phase: ProbePhase.failed,
      stamp: RouteStamp(
        coreEpoch: 1,
        routeVersion: 5,
        hostEpoch: 3,
        proxied: true,
      ),
    );

    expect(
      outboundDiagnosticResult(active: true, entry: entry, route: route),
      DiagnosticResult.unverified,
    );
  });

  testWidgets('shows real checks without unsupported-check notices', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [profilesProvider.overrideWith(TestProfiles.new)],
    );
    addTearDown(container.dispose);
    globalState.container = container;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: DiagnosticsView()),
      ),
    );

    expect(find.text('Default route exit verification'), findsOneWidget);
    expect(
      find.text('DNS exit, browser WebRTC and NTP checks are not available.'),
      findsNothing,
    );
    expect(find.text('Start'), findsOneWidget);
  });
}
