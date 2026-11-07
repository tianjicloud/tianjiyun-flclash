import 'dart:async';
import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod/riverpod.dart';
import 'package:yaml/yaml.dart';

import '../helpers/app_paths.dart';
import '../helpers/preferences.dart';
import '../helpers/test_profiles.dart';

class _Core extends Mock implements CoreHandlerInterface {}

class _Setup extends SetupAction {
  Completer<bool>? permission;

  @override
  Future<bool> requestAdmin(bool enableTun) =>
      permission?.future ?? Future.value(true);
}

class _Groups extends ProxiesAction {
  @override
  void build() {}

  @override
  Future<void> updateGroups() async {}
}

const _profile = Profile(
  id: 7,
  type: ProfileType.url,
  url: 'https://sub1.tianjiyun.org/s/review_subscription_A',
  autoUpdateDuration: Duration(days: 1),
);

Map<String, dynamic> _config() => {
  'proxies': [
    for (final name in ['Tokyo', 'Paris', 'Ordinary'])
      {'name': name, 'type': 'socks5', 'server': '127.0.0.1', 'port': 1080},
  ],
  'proxy-groups': [
    {
      'name': tianjiResidentialRootName,
      'type': 'select',
      'proxies': ['Tokyo', 'Paris'],
    },
    {
      'name': 'Default',
      'type': 'select',
      'proxies': ['Ordinary', tianjiResidentialRootName],
    },
  ],
  'rule': ['DOMAIN-SUFFIX,example.cn,DIRECT', 'MATCH,Default'],
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(
      const SetupParams(
        selectedMap: {},
        options: CoreOptions(testUrl: ''),
      ),
    );
    registerFallbackValue(
      const PatchClashConfig().toUpdateParams(
        authentication: [],
        options: const CoreOptions(testUrl: ''),
      ),
    );
  });

  late Directory directory;
  late ProviderContainer container;
  late _Core core;
  late _Setup setup;

  setUp(() async {
    await mockPreferences();
    directory = await Directory.systemTemp.createTemp('residential_setup_');
    await useAppPaths(directory);
    await AppLocalizations.load(const Locale('en'));
    globalState.packageInfo = PackageInfo(
      appName: 'TianjiCloud',
      packageName: 'test',
      version: '0.0.0',
      buildNumber: '0',
    );
    globalState.lastConfigMd5 = null;
    globalState.lastConfigCounts = null;
    final file = File(await appPath.getProfilePath('${_profile.id}'));
    await file.create(recursive: true);
    await file.writeAsString('rules: [MATCH,DIRECT]\n');
    core = _Core();
    setup = _Setup();
    when(() => core.readConfig(any())).thenAnswer((_) async => _config());
    when(() => core.setupConfig(any())).thenAnswer((_) async {});
    when(() => core.updateConfig(any())).thenAnswer((_) async {});
    when(() => core.stopListener()).thenAnswer((_) async {});
    when(() => core.resetTraffic()).thenAnswer((_) async {});
    when(() => core.getExternalProviders()).thenAnswer((_) async => []);
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles(const [_profile])),
        setupActionProvider.overrideWith(() => setup),
        proxiesActionProvider.overrideWith(_Groups.new),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        setupStateProvider.overrideWith((ref, id) {
          final profile = ref.watch(currentProfileProvider);
          final active = isResidentialPolicyActive(profile);
          return SetupState(
            profileId: id,
            profileLastUpdateDate: null,
            profileType: ProfileType.url,
            extendType: ExtendType.standard,
            rules: const [],
            proxyGroups: const [],
            addedRules: const [],
            script: null,
            overrides: const ProfileOverrides(),
            residentialActive: active,
            residentialExit: active ? profile?.overrides.residentialExit : null,
          );
        }),
      ],
    );
    globalState.container = container;
    container.listen(currentProfileProvider, (_, _) {});
    container.read(currentProfileIdProvider.notifier).value = _profile.id;
    container.read(setupActionProvider.notifier);
  });

  tearDown(() async {
    container.dispose();
    globalState.lastConfigMd5 = null;
    globalState.lastConfigCounts = null;
    await directory.delete(recursive: true);
  });

  void choose(String? exit) {
    container
        .read(profilesProvider.notifier)
        .updateProfile(
          _profile.id,
          (profile) => profile.copyWith(
            overrides: profile.overrides.copyWith(
              residentialExit: exit,
              residentialSubscriptionFingerprint: exit == null
                  ? null
                  : resolveTianjiProfile(profile)!.fingerprint,
            ),
          ),
        );
  }

  test(
    'the applied config contains the full locked residential route',
    () async {
      choose('Tokyo');
      final state = await container.read(
        setupStateProvider(_profile.id).future,
      );
      final built = await setup.getProfile(
        setupState: state,
        patchConfig: const PatchClashConfig(mode: Mode.global),
      );
      final yaml = loadYaml(built.yaml) as YamlMap;

      expect(built.base, isNull);
      expect(yaml['mode'], 'rule');
      expect((yaml['proxy-groups'] as List).last['proxies'], ['Tokyo']);
      expect(yaml['rules'], [
        'DOMAIN-SUFFIX,example.cn,DIRECT',
        'MATCH,$tianjiResidentialLockedGroupName',
      ]);
      verifyNever(() => core.getProfileBase(any()));
    },
  );

  test(
    'live updates force rule mode and restore the stored mode on clear',
    () async {
      container
          .read(patchClashConfigProvider.notifier)
          .update((config) => config.copyWith(mode: Mode.global));
      choose('Tokyo');
      await setup.updateConfig();
      choose(null);
      await setup.updateConfig();
      final updates = verify(
        () => core.updateConfig(captureAny()),
      ).captured.cast<UpdateParams>();

      expect(updates.map((update) => update.mode), [Mode.rule, Mode.global]);
      expect(container.read(patchClashConfigProvider).mode, Mode.global);
    },
  );

  test(
    'a choice made during the permission wait governs the live update',
    () async {
      container
          .read(patchClashConfigProvider.notifier)
          .update((config) => config.copyWith(mode: Mode.global));
      setup.permission = Completer<bool>();
      final pending = setup.updateConfig();
      choose('Tokyo');
      setup.permission!.complete(true);
      await pending;

      final update =
          verify(() => core.updateConfig(captureAny())).captured.single
              as UpdateParams;
      expect(update.mode, Mode.rule);
    },
  );

  test(
    'a choice changed while reading config is rebuilt before applying',
    () async {
      choose('Tokyo');
      final entered = Completer<void>();
      final reading = Completer<Map<String, dynamic>>();
      var reads = 0;
      when(() => core.readConfig(any())).thenAnswer((_) {
        if (++reads == 1) {
          entered.complete();
          return reading.future;
        }
        return Future.value(_config());
      });
      final pending = setup.applyProfile(force: true, silence: true);
      await entered.future;
      choose('Paris');
      reading.complete(_config());

      expect(await pending, isTrue);
      final written =
          loadYaml(await File(await appPath.configFilePath).readAsString())
              as YamlMap;
      expect((written['proxy-groups'] as List).last['proxies'], ['Paris']);
      verify(() => core.setupConfig(any())).called(1);
    },
  );

  test(
    'a failed residential build stops instead of loading direct defaults',
    () async {
      choose('Tokyo');
      when(() => core.readConfig(any())).thenThrow(StateError('unreadable'));

      expect(await setup.applyProfile(force: true, silence: true), isFalse);
      verifyNever(() => core.setupConfig(any()));
      verify(() => core.stopListener()).called(1);
      expect(container.read(isStartProvider), isFalse);
    },
  );

  test(
    'a rejected residential config stops through the existing owner',
    () async {
      choose('Tokyo');
      when(() => core.setupConfig(any())).thenThrow(
        const CoreMethodException(code: 'config_rejected', message: 'rejected'),
      );

      expect(await setup.applyProfile(force: true, silence: true), isFalse);
      verify(() => core.stopListener()).called(1);
      expect(container.read(isStartProvider), isFalse);
    },
  );
}
