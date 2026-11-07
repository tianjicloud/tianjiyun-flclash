import 'dart:async';

import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import '../helpers/preferences.dart';
import '../helpers/test_profiles.dart';

class _Core extends Mock implements CoreHandlerInterface {}

class _Setup extends SetupAction {
  final requests = <Completer<bool>>[];

  @override
  void build() {}

  @override
  Future<bool> applyProfile({
    bool silence = false,
    bool force = false,
    Future<void> Function()? preloadInvoke,
  }) {
    final pending = Completer<bool>();
    requests.add(pending);
    return pending.future;
  }
}

const _profile = Profile(
  id: 7,
  type: ProfileType.url,
  url: 'https://sub1.tianjiyun.org/s/review_subscription_A',
  autoUpdateDuration: Duration(days: 1),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late _Core core;
  late _Setup setup;
  late ResidentialAction action;

  setUp(() async {
    await mockPreferences();
    core = _Core();
    setup = _Setup();
    when(() => core.closeConnections()).thenAnswer((_) async {});
    when(() => core.resetConnections()).thenAnswer((_) async {});
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles(const [_profile])),
        setupActionProvider.overrideWith(() => setup),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
      ],
    );
    globalState.container = container;
    container.read(currentProfileIdProvider.notifier).value = _profile.id;
    action = container.read(residentialActionProvider.notifier);
  });

  tearDown(() => container.dispose());

  test(
    'switch closes old sockets even when normal switching keeps them',
    () async {
      container
          .read(appSettingProvider.notifier)
          .update((value) => value.copyWith(closeConnections: false));
      final pending = action.select('Tokyo');
      expect(container.read(residentialActionProvider).applying, isTrue);
      setup.requests.single.complete(true);

      expect(await pending, isTrue);
      verifyInOrder([
        () => core.closeConnections(),
        () => core.resetConnections(),
      ]);
      expect(container.read(residentialActionProvider).applying, isFalse);
      expect(
        isResidentialPolicyActive(container.read(currentProfileProvider)),
        isTrue,
      );
    },
  );

  test(
    'a completion from a replaced subscription cannot report success',
    () async {
      final pending = action.select('Tokyo');
      container
          .read(profilesProvider.notifier)
          .updateProfile(
            _profile.id,
            (value) => value.copyWith(
              url: 'https://sub1.tianjiyun.org/s/review_subscription_B',
            ),
          );
      setup.requests.single.complete(true);

      expect(await pending, isFalse);
      expect(
        isResidentialPolicyActive(container.read(currentProfileProvider)),
        isFalse,
      );
      verifyNever(() => core.closeConnections());
    },
  );

  test('a superseded selection cannot finish the newer selection', () async {
    final first = action.select('Tokyo');
    final second = action.select('Paris');
    setup.requests[0].complete(true);

    expect(await first, isFalse);
    expect(container.read(residentialActionProvider).applying, isTrue);
    expect(container.read(residentialActionProvider).attemptedExit, 'Paris');
    verifyNever(() => core.closeConnections());
    setup.requests[1].complete(true);
    expect(await second, isTrue);
    expect(
      container.read(currentProfileProvider)?.overrides.residentialExit,
      'Paris',
    );
  });

  test('old socket close failure does not report a complete switch', () async {
    when(() => core.closeConnections()).thenThrow(StateError('close failed'));
    final pending = action.select('Tokyo');
    setup.requests.single.complete(true);

    expect(await pending, isFalse);
    expect(container.read(residentialActionProvider).resetFailed, isTrue);
    expect(container.read(residentialActionProvider).applying, isFalse);
  });

  test(
    'a subscription change during socket close skips the later reset',
    () async {
      final closing = Completer<void>();
      when(() => core.closeConnections()).thenAnswer((_) => closing.future);
      final pending = action.select('Tokyo');
      setup.requests.single.complete(true);
      await Future<void>.delayed(Duration.zero);
      container
          .read(profilesProvider.notifier)
          .updateProfile(
            _profile.id,
            (value) => value.copyWith(
              url: 'https://sub1.tianjiyun.org/s/review_subscription_B',
            ),
          );
      closing.complete();

      expect(await pending, isFalse);
      verifyNever(() => core.resetConnections());
      expect(container.read(residentialActionProvider).applying, isFalse);
    },
  );
}
