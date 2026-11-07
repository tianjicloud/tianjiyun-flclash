import 'dart:async';

import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/test_profiles.dart';

class _MockCore extends Mock implements CoreHandlerInterface {}

class _ControlledSetupAction extends SetupAction {
  final calls = <({bool silence, bool force})>[];
  Future<bool> Function() handler = () async => true;

  @override
  Future<bool> applyProfile({
    bool silence = false,
    bool force = false,
    Future<void> Function()? preloadInvoke,
  }) {
    calls.add((silence: silence, force: force));
    return handler();
  }
}

Profile _profile(int id, String token) => Profile(
  id: id,
  type: ProfileType.url,
  label: 'Tianji $id',
  url: 'https://sub1.tianjiyun.org/s/$token',
  autoUpdateDuration: Duration.zero,
);

void main() {
  late ProviderContainer container;
  late _MockCore core;
  late _ControlledSetupAction setup;
  late Profile first;
  late Profile second;

  setUp(() {
    first = _profile(1, 'test_subscription_001');
    second = _profile(2, 'test_subscription_002');
    core = _MockCore();
    when(() => core.closeConnections()).thenAnswer((_) async {});
    when(() => core.resetConnections()).thenAnswer((_) async {});
    setup = _ControlledSetupAction();
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(
          () => TestProfiles([first, second]),
        ),
        setupActionProvider.overrideWith(() => setup),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(currentProfileIdProvider, (_, _) {});
    container.read(currentProfileIdProvider.notifier).value = first.id;
  });

  ResidentialAction action() =>
      container.read(residentialActionProvider.notifier);

  Profile profile(int id) => container.read(profilesProvider).getProfile(id)!;

  test('select persists the identity choice and closes old connections', () async {
    final applied = await action().select('Tokyo');

    expect(applied, isTrue);
    final current = profile(first.id);
    expect(current.overrides.residentialExit, 'Tokyo');
    expect(
      current.overrides.residentialSubscriptionFingerprint,
      resolveTianjiProfile(first)!.fingerprint,
    );
    final state = container.read(residentialActionProvider);
    expect(state.applying, isFalse);
    expect(state.failed, isFalse);
    verify(() => core.closeConnections()).called(1);
    verify(() => core.resetConnections()).called(1);
    expect(setup.calls.single.force, isTrue);
  });

  test('a failed apply keeps the attempted target for retry', () async {
    var attempts = 0;
    setup.handler = () async => ++attempts > 1;

    expect(await action().select('Tokyo'), isFalse);
    var state = container.read(residentialActionProvider);
    expect(state.failed, isTrue);
    expect(state.attempted, isTrue);
    expect(state.attemptedExit, 'Tokyo');
    expect(profile(first.id).overrides.residentialExit, 'Tokyo');
    verifyNever(() => core.closeConnections());

    expect(await action().retry(), isTrue);
    state = container.read(residentialActionProvider);
    expect(state.failed, isFalse);
    expect(setup.calls.length, 2);
    expect(profile(first.id).overrides.residentialExit, 'Tokyo');
    verify(() => core.closeConnections()).called(1);
  });

  test('retry remembers a failed clear instead of the old target', () async {
    final fingerprint = resolveTianjiProfile(first)!.fingerprint;
    container.read(profilesProvider.notifier).put(
      first.copyWith(
        overrides: ProfileOverrides(
          residentialExit: 'Tokyo',
          residentialSubscriptionFingerprint: fingerprint,
        ),
      ),
    );
    var attempts = 0;
    setup.handler = () async => ++attempts > 1;

    expect(await action().clear(), isFalse);
    var state = container.read(residentialActionProvider);
    expect(state.failed, isTrue);
    expect(state.attempted, isTrue);
    expect(state.attemptedExit, isNull);
    expect(profile(first.id).overrides.residentialExit, isNull);

    expect(await action().retry(), isTrue);
    state = container.read(residentialActionProvider);
    expect(state.failed, isFalse);
    expect(setup.calls.length, 2);
    expect(profile(first.id).overrides.residentialExit, isNull);
  });

  test('a newer selection owns the state when callers overlap', () async {
    final firstApply = Completer<bool>();
    final secondApply = Completer<bool>();
    setup.handler = () =>
        setup.calls.length == 1 ? firstApply.future : secondApply.future;

    final older = action().select('Tokyo');
    final newer = action().select('Hong Kong');
    secondApply.complete(true);
    expect(await newer, isTrue);
    expect(container.read(residentialActionProvider).attemptedExit, 'Hong Kong');

    firstApply.complete(true);
    expect(await older, isFalse);
    final state = container.read(residentialActionProvider);
    expect(state.attemptedExit, 'Hong Kong');
    expect(state.applying, isFalse);
    expect(profile(first.id).overrides.residentialExit, 'Hong Kong');
    verify(() => core.closeConnections()).called(1);
  });

  test('switching profile during apply writes only the original profile', () async {
    final apply = Completer<bool>();
    setup.handler = () => apply.future;

    final future = action().select('Tokyo');
    container.read(currentProfileIdProvider.notifier).value = second.id;
    apply.complete(true);
    expect(await future, isFalse);

    expect(profile(first.id).overrides.residentialExit, 'Tokyo');
    expect(profile(second.id).overrides.residentialExit, isNull);
    final state = container.read(residentialActionProvider);
    expect(state.profileId, first.id);
    verifyNever(() => core.closeConnections());
  });
}
