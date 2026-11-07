import 'dart:async';

import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/common/default_line.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/default_lines.dart';
import '../helpers/test_profiles.dart';

class _Core extends Mock implements CoreHandlerInterface {}

class _Setup extends SetupAction {
  bool success = true;
  @override
  Future<bool> applyProfile({
    bool silence = false,
    bool force = false,
    Future<void> Function()? preloadInvoke,
  }) async => success;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late _Core core;
  late ProxiesAction action;
  final calls = <ChangeProxyParams>[];
  final catalog = DefaultLineCatalog(defaultLineTestGroups);
  final tokyo = catalog.choices.firstWhere((choice) => choice.name == 'Tokyo');
  const profile = Profile(
    id: 1,
    type: ProfileType.url,
    url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
    autoUpdateDuration: Duration.zero,
    selectedMap: {'AI': 'AI auto'},
  );

  setUpAll(
    () => registerFallbackValue(
      const ChangeProxyParams(groupName: '', proxyName: ''),
    ),
  );
  setUp(() async {
    await AppLocalizations.load(const Locale('en'));
    calls.clear();
    core = _Core();
    when(() => core.changeProxy(any())).thenAnswer((invocation) async {
      calls.add(invocation.positionalArguments.single as ChangeProxyParams);
      return const ChangeProxyResult(changed: true);
    });
    when(() => core.closeConnections()).thenAnswer((_) async {});
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        groupsProvider.overrideWithBuild((_, _) => defaultLineTestGroups),
        setupActionProvider.overrideWith(_Setup.new),
      ],
    );
    container.listen(currentProfileProvider, (_, _) {});
    action = container.read(proxiesActionProvider.notifier);
    container
        .read(groupsSourceProfileProvider.notifier)
        .set(profileId: profile.id, url: profile.url);
  });
  tearDown(() => container.dispose());

  test(
    'manual choice sets its node then the root without changing AI or rules',
    () async {
      final config = container.read(patchClashConfigProvider);
      expect(await action.changeDefaultLine(tokyo), isTrue);
      expect(calls.map((call) => (call.groupName, call.proxyName)), [
        ('📍 指定节点', 'Tokyo'),
        (appName, '📍 指定节点'),
      ]);
      expect(container.read(currentProfileProvider)!.selectedMap, {
        'AI': 'AI auto',
        '📍 指定节点': 'Tokyo',
        appName: '📍 指定节点',
      });
      expect(container.read(patchClashConfigProvider), config);
      verify(() => core.closeConnections()).called(1);
    },
  );

  test('automatic choice changes only the default selector', () async {
    expect(await action.changeDefaultLine(catalog.choices.first), isTrue);
    expect(calls.single.groupName, appName);
    expect(calls.single.proxyName, '⚡ 自动选择');
  });

  test(
    'a failed config apply is not reported as a completed default switch',
    () async {
      (container.read(setupActionProvider.notifier) as _Setup).success = false;
      expect(await action.changeDefaultLine(tokyo), isFalse);
      verifyNever(() => core.closeConnections());
    },
  );

  test('choosing automatic clears a saved automatic-group pin', () async {
    container
        .read(profilesProvider.notifier)
        .put(
          profile.copyWith(
            overrides: const ProfileOverrides(
              manualSelections: {
                '⚡ 自动选择': ManualSelection(
                  node: 'HK transport',
                  sequence: 1,
                  automaticGroup: true,
                ),
              },
            ),
          ),
        );
    expect(await action.changeDefaultLine(catalog.choices.first), isTrue);
    expect(
      container
          .read(currentProfileProvider)!
          .overrides
          .manualSelections['⚡ 自动选择']!
          .node,
      '',
    );
  });

  test('a rejected manual selection never changes the root', () async {
    when(
      () => core.changeProxy(any()),
    ).thenAnswer((_) async => const ChangeProxyResult(message: 'missing node'));
    expect(await action.changeDefaultLine(tokyo), isFalse);
    expect(
      container.read(currentProfileProvider)!.selectedMap,
      profile.selectedMap,
    );
    verify(() => core.changeProxy(any())).called(1);
    verifyNever(() => core.closeConnections());
  });

  test(
    'a root rejection preserves its previous route and reports incomplete selection',
    () async {
      when(() => core.changeProxy(any())).thenAnswer((invocation) async {
        final params =
            invocation.positionalArguments.single as ChangeProxyParams;
        calls.add(params);
        return params.groupName == appName
            ? const ChangeProxyResult(message: 'root unavailable')
            : const ChangeProxyResult(changed: true);
      });
      expect(await action.changeDefaultLine(tokyo), isFalse);
      final selections = container.read(currentProfileProvider)!.selectedMap;
      expect(selections[appName], isNull);
      expect(catalog.selected(selections)?.name, '⚡ 自动选择');
      expect(selections['📍 指定节点'], 'Tokyo');
      verifyNever(() => core.closeConnections());
    },
  );

  test(
    'subscription replacement during a change prevents subsequent writes',
    () async {
      final pending = Completer<ChangeProxyResult>();
      when(() => core.changeProxy(any())).thenAnswer((_) => pending.future);
      final future = action.changeDefaultLine(tokyo);
      container
          .read(profilesProvider.notifier)
          .put(
            profile.copyWith(
              url: 'https://sub1.tianjiyun.org/s/test_subscription_002',
            ),
          );
      pending.complete(const ChangeProxyResult(changed: true));
      expect(await future, isFalse);
      expect(
        container.read(currentProfileProvider)!.selectedMap,
        profile.selectedMap,
      );
      verify(() => core.changeProxy(any())).called(1);
      verifyNever(() => core.closeConnections());
    },
  );

  test(
    'global and direct modes cannot present a default selection as applied',
    () async {
      for (final mode in [Mode.global, Mode.direct]) {
        container
            .read(patchClashConfigProvider.notifier)
            .update((state) => state.copyWith(mode: mode));
        expect(await action.changeDefaultLine(tokyo), isFalse);
      }
      verifyNever(() => core.changeProxy(any()));
    },
  );

  test(
    'stale choices and reset failures are not reported as success',
    () async {
      expect(
        await action.changeDefaultLine((
          name: 'Removed',
          rootTarget: '📍 指定节点',
          selector: '📍 指定节点',
        )),
        isFalse,
      );
      verifyNever(() => core.changeProxy(any()));
      when(() => core.closeConnections()).thenThrow(StateError('reset failed'));
      expect(await action.changeDefaultLine(tokyo), isFalse);
    },
  );
}
