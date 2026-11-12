import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/common/tianji_api.dart';
import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/core.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/route_state.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

class _MockCore extends Mock implements CoreHandlerInterface {}

const _answer = OutboundIpResult(
  url: 'https://www.cloudflare.com/cdn-cgi/trace',
  body: 'ip=2.2.2.2\nloc=US\n',
  chains: ['HK-01'],
  coreEpoch: 1,
  routeVersion: 1,
);

void main() {
  setUpAll(() => registerFallbackValue(const OutboundIpParams(timeout: 0)));

  late _MockCore core;

  setUp(() => core = _MockCore());

  ProviderContainer build({
    bool proxied = true,
    Profile? profile,
    List<Group> groups = const [],
  }) {
    final container = ProviderContainer(
      overrides: [
        routeTrackerProvider.overrideWithBuild(
          (_, _) => RouteState(
            coreEpoch: 1,
            routeVersion: 1,
            hostEpoch: 1,
            proxied: proxied,
            synced: true,
            live: true,
          ),
        ),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        currentProfileProvider.overrideWithValue(profile),
        groupsProvider.overrideWithValue(groups),
      ],
    );
    addTearDown(container.dispose);
    container.listen(outboundIpProbeProvider, (_, _) {});
    return container;
  }

  Future<OutboundIpParams> asked() async {
    await pumpEventQueue();
    return verify(() => core.outboundIp(captureAny())).captured.single
        as OutboundIpParams;
  }

  test(
    'asks the Core for the address the current route exits through',
    () async {
      when(() => core.outboundIp(any())).thenAnswer((_) async => _answer);
      final container = build();

      container.read(outboundIpProbeProvider.notifier).watch(routedOutbound);

      final params = await asked();
      expect(params.proxyName, isEmpty);
      expect(params.urls, outboundIpSourceUrls());
      final entry = container
          .read(outboundIpProbeProvider)
          .entryOf(routedOutbound);
      expect(entry.phase, ProbePhase.fresh);
      expect(entry.value?.ip, '2.2.2.2');
    },
  );

  test('pins the direct outbound while the proxy is off', () async {
    when(() => core.outboundIp(any())).thenAnswer((_) async => _answer);
    final container = build(proxied: false);

    container.read(outboundIpProbeProvider.notifier).watch(routedOutbound);

    expect((await asked()).proxyName, directOutbound);
  });

  test('looks a node up through itself', () async {
    when(() => core.outboundIp(any())).thenAnswer((_) async => _answer);
    final container = build();

    container.read(outboundIpProbeProvider.notifier).watch('HK-01');

    expect((await asked()).proxyName, 'HK-01');
    expect(
      container.read(outboundIpProbeProvider).valueOf('HK-01')?.countryCode,
      'US',
    );
  });

  test('the routed answer fills in the node it left through', () async {
    when(() => core.outboundIp(any())).thenAnswer(
      (_) async => const OutboundIpResult(
        url: 'https://www.cloudflare.com/cdn-cgi/trace',
        body: 'ip=2.2.2.2\nloc=US\n',
        chains: ['HK-01', 'Balance', 'Proxy'],
        coreEpoch: 1,
        routeVersion: 1,
        hits: [RouteHit(host: 'www.cloudflare.com:443', exit: 'Balance')],
        nodeHits: [
          RouteHit(
            host: 'www.cloudflare.com:443',
            proxy: 'HK-01',
            exit: 'HK-01',
          ),
        ],
      ),
    );
    final container = build();
    final probe = container.read(outboundIpProbeProvider.notifier);

    probe.watch(routedOutbound);
    await pumpEventQueue();
    probe.watch('HK-01');
    await pumpEventQueue();

    verify(() => core.outboundIp(any())).called(1);
    final entry = container.read(outboundIpProbeProvider).entryOf('HK-01');
    expect(entry.phase, ProbePhase.fresh);
    expect(entry.value?.ip, '2.2.2.2');
    expect(entry.stamp?.hits, const [
      RouteHit(host: 'www.cloudflare.com:443', proxy: 'HK-01', exit: 'HK-01'),
    ]);
  });

  test('a Core error is a failure until it is refreshed', () async {
    when(() => core.outboundIp(any())).thenAnswer(
      (_) async => const OutboundIpResult(
        error: 'timeout',
        coreEpoch: 1,
        routeVersion: 1,
      ),
    );
    final container = build();
    final probe = container.read(outboundIpProbeProvider.notifier);

    probe.watch(routedOutbound);
    await pumpEventQueue();

    expect(
      container.read(outboundIpProbeProvider).entryOf(routedOutbound).phase,
      ProbePhase.failed,
    );
    verify(() => core.outboundIp(any())).called(1);

    probe.refresh([routedOutbound]);
    await pumpEventQueue();

    verify(() => core.outboundIp(any())).called(1);
  });

  test(
    'business probes Tianji first and falls back to third parties',
    () async {
      when(() => core.outboundIp(any())).thenAnswer((invocation) async {
        final params =
            invocation.positionalArguments.single as OutboundIpParams;
        if (params.urls.length == 1 && params.urls.single == tianjiEgressUrl) {
          return const OutboundIpResult(
            url: tianjiEgressUrl,
            body: '{invalid',
            chains: ['JP-01'],
            coreEpoch: 1,
            routeVersion: 1,
          );
        }
        return _answer;
      });
      final container = build(
        profile: const Profile(
          id: 1,
          type: ProfileType.url,
          url: 'https://sub1.tianjiyun.org/s/abcdefgh',
          autoUpdateDuration: Duration.zero,
        ),
      );

      container.read(outboundIpProbeProvider.notifier).watch('JP-01');
      await pumpEventQueue();

      final calls = verify(
        () => core.outboundIp(captureAny()),
      ).captured.cast<OutboundIpParams>();
      expect(calls.map((call) => call.urls), [
        [tianjiEgressUrl],
        outboundIpSourceUrls(),
      ]);
      expect(
        container.read(outboundIpProbeProvider).valueOf('JP-01')?.fromTianji,
        isFalse,
      );
    },
  );

  test('business Tianji failures cool down for one minute', () async {
    when(() => core.outboundIp(any())).thenAnswer((invocation) async {
      final params = invocation.positionalArguments.single as OutboundIpParams;
      return params.urls.length == 1 && params.urls.single == tianjiEgressUrl
          ? const OutboundIpResult(error: 'unavailable')
          : _answer;
    });
    final container = build(
      profile: const Profile(
        id: 1,
        type: ProfileType.url,
        url: 'https://sub1.tianjiyun.org/s/abcdefgh',
        autoUpdateDuration: Duration.zero,
      ),
    );
    final probe = container.read(outboundIpProbeProvider.notifier);
    probe.watch('JP-01');
    await pumpEventQueue();
    probe.refresh(['JP-01']);
    await pumpEventQueue();

    final calls = verify(
      () => core.outboundIp(captureAny()),
    ).captured.cast<OutboundIpParams>();
    expect(calls.map((call) => call.urls), [
      [tianjiEgressUrl],
      outboundIpSourceUrls(),
      outboundIpSourceUrls(),
    ]);
  });

  test('business routed probe keeps the routed target', () async {
    when(() => core.outboundIp(any())).thenAnswer(
      (_) async => const OutboundIpResult(
        url: tianjiEgressUrl,
        body: '{"ip":"203.0.113.42","exit":null}',
        chains: ['JP-01', 'Root'],
        coreEpoch: 1,
        routeVersion: 1,
      ),
    );
    final container = build(
      profile: const Profile(
        id: 1,
        type: ProfileType.url,
        url: 'https://sub1.tianjiyun.org/s/abcdefgh',
        autoUpdateDuration: Duration.zero,
      ),
      groups: [
        const Group(
          name: 'GLOBAL',
          type: GroupType.Selector,
          now: 'JP-01',
          all: [Proxy(name: 'JP-01', type: 'ss')],
        ),
        const Group(
          name: appName,
          type: GroupType.Selector,
          now: 'JP-01',
          all: [Proxy(name: 'JP-01', type: 'ss')],
        ),
      ],
    );
    container.read(outboundIpProbeProvider.notifier).watch(routedOutbound);
    await pumpEventQueue();

    final params =
        verify(() => core.outboundIp(captureAny())).captured.single
            as OutboundIpParams;
    expect(params.proxyName, '');
    expect(params.urls, [tianjiEgressUrl]);
  });
}
