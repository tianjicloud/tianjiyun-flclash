import 'dart:async';

import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/action.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/providers/database.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import '../helpers/test_profiles.dart';

class _Setup extends SetupAction {
  bool result = true;
  Completer<bool>? pending;

  @override
  Future<bool> applyProfile({
    bool silence = false,
    bool force = false,
    Future<void> Function()? preloadInvoke,
  }) => pending?.future ?? Future.value(result);
}

class _Proxies extends ProxiesAction {
  final changes = <(String, String)>[];
  Future<bool> Function(String groupName, String proxyName)? handler;

  @override
  void build() {}

  @override
  Future<bool> changeProxy({
    required String groupName,
    required String proxyName,
  }) {
    changes.add((groupName, proxyName));
    return handler?.call(groupName, proxyName) ?? Future.value(true);
  }
}

const _profile = Profile(
  id: 1,
  url: 'https://example.com/profile',
  type: ProfileType.url,
  autoUpdateDuration: Duration.zero,
);

const _nextProfile = Profile(
  id: 2,
  url: 'https://example.com/next',
  type: ProfileType.url,
  autoUpdateDuration: Duration.zero,
);

const _sceneGroups = [
  Group(
    name: sceneGroupName,
    type: GroupType.Selector,
    all: [Proxy(name: sceneAiGroupName, type: 'Selector')],
  ),
  Group(
    name: sceneRootGroupName,
    type: GroupType.Selector,
    all: [Proxy(name: sceneGroupName, type: 'Selector')],
  ),
];

void main() {
  late ProviderContainer container;
  late _Setup setup;
  late _Proxies proxies;

  ProviderContainer createContainer({
    List<Profile> profiles = const [_profile],
  }) {
    setup = _Setup();
    proxies = _Proxies();
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles(profiles)),
        currentProfileIdProvider.overrideWithBuild((_, _) => _profile.id),
        groupsProvider.overrideWithBuild((_, _) => _sceneGroups),
        setupActionProvider.overrideWith(() => setup),
        proxiesActionProvider.overrideWith(() => proxies),
      ],
    );
    return container;
  }

  tearDown(() => container.dispose());

  test(
    'applies the pivot and then the root after both selections succeed',
    () async {
      createContainer();

      final applied = await container
          .read(sceneActionProvider.notifier)
          .select(SceneKind.ai);

      expect(applied, isTrue);
      expect(proxies.changes, [
        (sceneGroupName, sceneAiGroupName),
        (sceneRootGroupName, sceneGroupName),
      ]);
      expect(
        container
            .read(profilesProvider)
            .getProfile(_profile.id)
            ?.overrides
            .scene,
        sceneAiGroupName,
      );
    },
  );

  test('does not switch the root when the pivot selection fails', () async {
    createContainer();
    proxies.handler = (_, _) async => false;

    final action = container.read(sceneActionProvider.notifier);
    expect(await action.select(SceneKind.ai), isFalse);
    expect(proxies.changes, [(sceneGroupName, sceneAiGroupName)]);
    expect(container.read(sceneActionProvider).failed, isTrue);
  });

  test('reports a failed root selection after the pivot succeeds', () async {
    createContainer();
    var count = 0;
    proxies.handler = (_, _) async => ++count == 1;

    final action = container.read(sceneActionProvider.notifier);
    expect(await action.select(SceneKind.ai), isFalse);
    expect(proxies.changes, [
      (sceneGroupName, sceneAiGroupName),
      (sceneRootGroupName, sceneGroupName),
    ]);
    expect(container.read(sceneActionProvider).failed, isTrue);
  });

  test('does not switch the new profile root after a profile change', () async {
    createContainer(profiles: const [_profile, _nextProfile]);
    final pivot = Completer<bool>();
    proxies.handler = (_, _) => pivot.future;

    final result = container
        .read(sceneActionProvider.notifier)
        .select(SceneKind.ai);
    await Future<void>.delayed(Duration.zero);
    container.read(currentProfileIdProvider.notifier).value = _nextProfile.id;
    pivot.complete(true);

    expect(await result, isFalse);
    expect(proxies.changes, [(sceneGroupName, sceneAiGroupName)]);
  });

  test('stops after the profile changes while the apply is pending', () async {
    createContainer(profiles: const [_profile, _nextProfile]);
    setup.pending = Completer<bool>();

    final result = container
        .read(sceneActionProvider.notifier)
        .select(SceneKind.ai);
    await Future<void>.delayed(Duration.zero);
    container.read(currentProfileIdProvider.notifier).value = _nextProfile.id;
    setup.pending!.complete(true);

    expect(await result, isFalse);
    expect(proxies.changes, isEmpty);
  });

  test(
    'stops when the same profile URL changes while apply is pending',
    () async {
      createContainer();
      setup.pending = Completer<bool>();

      final result = container
          .read(sceneActionProvider.notifier)
          .select(SceneKind.ai);
      await Future<void>.delayed(Duration.zero);
      container
          .read(profilesProvider.notifier)
          .put(
            container
                .read(currentProfileProvider)!
                .copyWith(url: 'https://example.com/replaced'),
          );
      setup.pending!.complete(true);

      expect(await result, isFalse);
      expect(proxies.changes, isEmpty);
    },
  );
}
