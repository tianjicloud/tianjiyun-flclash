import 'dart:async';

import 'package:fl_clash/common/common.dart';

import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import '../helpers/test_profiles.dart';

class _Core extends Mock implements CoreHandlerInterface {}

class _Setup extends SetupAction {
  bool success = true;
  Completer<bool>? pending;
  final choices = <Map<String, ManualSelection>>[];

  @override
  Future<bool> applyProfile({
    bool silence = false,
    bool force = false,
    Future<void> Function()? preloadInvoke,
  }) {
    choices.add(ref.read(currentProfileProvider)!.overrides.manualSelections);
    return pending?.future ?? Future.value(success);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late _Setup setup;
  late _Core core;
  const profile = Profile(
    id: 1,
    autoUpdateDuration: Duration.zero,
    selectedMap: {'Auto': 'A'},
  );

  setUp(() async {
    await AppLocalizations.load(const Locale('en'));
    core = _Core();
    when(core.closeConnections).thenAnswer((_) async {});
    when(core.resetConnections).thenAnswer((_) async {});
    setup = _Setup();
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles(const [profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => 1),
        groupsProvider.overrideWithBuild(
          (_, _) => const [
            Group(
              name: 'Auto',
              type: GroupType.URLTest,
              now: 'A',
              all: [
                Proxy(name: 'A', type: 'ss'),
                Proxy(name: 'B', type: 'ss'),
              ],
            ),
          ],
        ),
        setupActionProvider.overrideWith(() => setup),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
      ],
    );
    container.listen(currentProfileProvider, (_, _) {});
  });
  tearDown(() => container.dispose());

  Future<void> select(String node) => container
      .read(proxiesActionProvider.notifier)
      .changeProxy(groupName: 'Auto', proxyName: node);
  ManualSelection pick() => container
      .read(currentProfileProvider)!
      .overrides
      .manualSelections['Auto']!;

  test(
    'each manual action records intent, including repeat and auto reset',
    () async {
      await select('B');
      expect(
        pick(),
        const ManualSelection(node: 'B', sequence: 1, automaticGroup: true),
      );
      await select('B');
      expect(pick().sequence, 2);
      await select('');
      expect(pick().node, '');
      expect(pick().sequence, 3);
      expect(setup.choices.length, 3);
      expect(container.read(manualSelectionPendingProvider), isEmpty);
    },
  );

  test(
    'debounced clicks each get a sequence but apply only the latest intent',
    () async {
      final action = container.read(proxiesActionProvider.notifier);
      action.changeProxyDebounce('Auto', 'B');
      expect(pick().sequence, 1);
      action.changeProxyDebounce('Auto', 'A');
      expect(pick().sequence, 2);
      expect(setup.choices, isEmpty);
      debouncer.flush((FunctionTag.changeProxy, 'Auto'));
      await Future<void>.delayed(Duration.zero);
      expect(setup.choices.length, 1);
      expect(pick().sequence, 2);
      expect(pick().node, 'A');
      debouncer.cancel(FunctionTag.updateGroups);
    },
  );

  test('automatic state updates never create manual facts', () {
    container
        .read(profilesActionProvider.notifier)
        .updateCurrentSelectedMap('Auto', 'B');
    expect(
      container.read(currentProfileProvider)!.overrides.manualSelections,
      isEmpty,
    );
  });

  test(
    'apply failure rolls back display but retains the explicit failed intent',
    () async {
      setup.success = false;
      await select('B');
      expect(container.read(currentProfileProvider)!.selectedMap['Auto'], 'A');
      expect(pick().node, 'B');
      expect(container.read(manualSelectionPendingProvider), isEmpty);
      verifyNever(core.closeConnections);
      verifyNever(core.resetConnections);
    },
  );

  test('a late failure cannot roll back a newer selection', () async {
    final first = Completer<bool>();
    setup.pending = first;
    final old = select('B');
    setup.pending = null;
    await select('A');
    first.complete(false);
    await old;
    expect(pick().node, 'A');
    expect(pick().sequence, 2);
    expect(container.read(currentProfileProvider)!.selectedMap['Auto'], 'A');
    expect(container.read(manualSelectionPendingProvider), isEmpty);
  });

  test(
    'subscription replacement prevents stale rollback and connection resets',
    () async {
      final first = Completer<bool>();
      setup.pending = first;
      final old = select('B');
      container
          .read(profilesProvider.notifier)
          .put(profile.copyWith(url: 'https://example.test/new'));
      first.complete(false);
      await old;
      expect(
        container.read(currentProfileProvider)!.overrides.manualSelections,
        isEmpty,
      );
      expect(container.read(manualSelectionPendingProvider), isEmpty);
      verifyNever(core.closeConnections);
      verifyNever(core.resetConnections);
    },
  );
}
