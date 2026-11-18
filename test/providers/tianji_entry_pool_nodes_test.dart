import 'dart:convert';

import 'package:fl_clash/common/preferences.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState();

  void answer({required List<String> chains, required IpInfo info}) {
    state = RoutedProbeState({
      routedOutbound: ProbeEntry(
        phase: ProbePhase.fresh,
        value: info,
        stamp: RouteStamp(
          coreEpoch: 1,
          routeVersion: 1,
          hostEpoch: 0,
          proxied: true,
          chains: chains,
        ),
      ),
    });
  }
}

const _profile = Profile(
  id: 1,
  type: ProfileType.url,
  url: 'https://sub1.tianjiyun.org/s/abcdefgh',
  autoUpdateDuration: Duration.zero,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await preferences.rebind();
  });

  test(
    'exact catalog names still resolve before entry-pool inference',
    () async {
      await _cacheNodes([
        _node('Exit Pool', kind: 'residential', countryCode: 'JP'),
        _node('Exit Pool / sjc', kind: 'datacenter', countryCode: 'US'),
      ]);
      final group = _entryPoolGroup();
      final container = _container(groups: [group]);
      addTearDown(container.dispose);
      await container.read(tianjiNodeCatalogProvider.future);

      expect(
        container.read(tianjiNodeProvider('Exit Pool'))?.name,
        'Exit Pool',
      );
      expect(
        container.read(tianjiNodeProvider('Exit Pool / sjc'))?.expectedExit,
        const EgressExit(kind: 'datacenter', countryCode: 'US'),
      );
    },
  );

  test(
    'a complete URL-test group supplies metadata to its generated member',
    () async {
      await _cacheNodes([
        _node('Exit Pool', kind: 'residential', countryCode: 'JP'),
      ]);
      final container = _container(groups: [_entryPoolGroup()]);
      addTearDown(container.dispose);
      await container.read(tianjiNodeCatalogProvider.future);

      final node = container.read(tianjiNodeProvider('Exit Pool / sjc'));
      expect(node?.name, 'Exit Pool');
      expect(
        node?.expectedExit,
        const EgressExit(kind: 'residential', countryCode: 'JP'),
      );
    },
  );

  test(
    'missing groups, pseudo-prefixes, and incomplete groups do not infer nodes',
    () async {
      await _cacheNodes([
        _node('Exit Pool', kind: 'residential', countryCode: 'JP'),
      ]);
      const incomplete = Group(
        name: 'Exit Pool',
        type: GroupType.URLTest,
        all: [
          Proxy(name: 'Exit Pool / sjc', type: 'vless'),
          Proxy(name: 'unrelated', type: 'ss'),
        ],
      );
      final container = _container(groups: [incomplete]);
      addTearDown(container.dispose);
      await container.read(tianjiNodeCatalogProvider.future);

      expect(container.read(tianjiNodeProvider('Exit Pool / sjc')), isNull);
      expect(container.read(tianjiNodeProvider('Other Pool / sjc')), isNull);
      expect(
        container.read(tianjiNodeProvider('Exit Pool / invalid id')),
        isNull,
      );

      final noGroups = _container(groups: const []);
      addTearDown(noGroups.dispose);
      await noGroups.read(tianjiNodeCatalogProvider.future);
      expect(noGroups.read(tianjiNodeProvider('Exit Pool / sjc')), isNull);
    },
  );

  test('ambiguous parent groups do not infer a catalog node', () async {
    await _cacheNodes([
      _node('Exit Pool', kind: 'residential', countryCode: 'JP'),
    ]);
    final container = _container(
      groups: [_entryPoolGroup(), _entryPoolGroup()],
    );
    addTearDown(container.dispose);
    await container.read(tianjiNodeCatalogProvider.future);

    expect(container.read(tianjiNodeProvider('Exit Pool / sjc')), isNull);
  });

  test(
    'selection verification still reports a catalog exit mismatch',
    () async {
      await _cacheNodes([
        _node('Exit Pool', kind: 'residential', countryCode: 'JP'),
      ]);
      final profile = _profile.copyWith(
        overrides: const ProfileOverrides(
          manualSelections: {
            'GLOBAL': ManualSelection(node: 'Exit Pool', sequence: 1),
          },
        ),
      );
      final probe = _Probe();
      final groups = [
        const Group(name: 'GLOBAL', type: GroupType.Selector, now: 'Exit Pool'),
        _entryPoolGroup(now: 'Exit Pool / sjc'),
      ];
      final container = _container(
        groups: groups,
        profile: profile,
        overrides: [
          patchClashConfigProvider.overrideWithBuild(
            (_, _) => const PatchClashConfig(mode: Mode.global),
          ),
          isStartProvider.overrideWith((_) => true),
          routeTrackerProvider.overrideWith(_Route.new),
          outboundIpProbeProvider.overrideWith(() => probe),
        ],
      );
      addTearDown(container.dispose);
      await container.read(tianjiNodeCatalogProvider.future);
      container
          .read(networkSettingProvider.notifier)
          .update((state) => state.copyWith(systemProxy: true));
      container.read(outboundIpProbeProvider);
      probe.answer(
        chains: ['Exit Pool / sjc', 'Exit Pool', 'GLOBAL'],
        info: const IpInfo(
          ip: '192.0.2.1',
          countryCode: 'US',
          exit: EgressExit(kind: 'residential', countryCode: 'US'),
          fromTianji: true,
        ),
      );

      container.listen(selectionCheckProvider, (_, _) {});
      expect(
        container.read(selectionCheckProvider),
        SelectionVerdict.egressMismatch,
      );
    },
  );
}

ProviderContainer _container({
  required List<Group> groups,
  Profile profile = _profile,
  List<Override> overrides = const [],
}) => ProviderContainer(
  overrides: [
    currentProfileProvider.overrideWithValue(profile),
    groupsProvider.overrideWithBuild((_, _) => groups),
    ...overrides,
  ],
);

Group _entryPoolGroup({String now = 'Exit Pool / sjc'}) => Group(
  name: 'Exit Pool',
  type: GroupType.URLTest,
  now: now,
  all: const [
    Proxy(name: 'Exit Pool / sjc', type: 'vless'),
    Proxy(name: 'Exit Pool / lax', type: 'vless'),
  ],
);

Map<String, Object?> _node(
  String name, {
  required String kind,
  required String countryCode,
}) => {
  'name': name,
  'expected_exit': {'kind': kind, 'country_code': countryCode},
};

Future<void> _cacheNodes(List<Map<String, Object?>> nodes) =>
    preferences.saveTianjiNodesCache(
      jsonEncode({
        'fetchedAt': DateTime.now().toIso8601String(),
        'data': {'nodes': nodes, 'categories': <String, String>{}},
      }),
    );
