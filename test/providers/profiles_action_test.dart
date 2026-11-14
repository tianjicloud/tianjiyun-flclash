import 'dart:io';
import 'dart:typed_data';

import 'package:fl_clash/common/common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:cross_file/cross_file.dart';
import 'package:fl_clash/database/database.dart' as db;
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/action.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/core.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/providers/database.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yaml/yaml.dart';

import '../helpers/app_paths.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

class _MockCoreHandlerInterface extends Mock implements CoreHandlerInterface {}

base class _TestPlatformFile extends PlatformFile {
  _TestPlatformFile(this.name, this.bytes);

  @override
  final String name;
  final Uint8List bytes;

  @override
  Uri get uri => Uri.dataFromBytes(bytes);

  @override
  XFile get xFile => XFile.fromData(bytes, name: name);

  @override
  int lengthSync() => bytes.length;

  @override
  Future<int> length() async => bytes.length;

  @override
  Future<Uint8List> readAsBytes() async => bytes;

  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(bytes);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory home;
  late _MockCoreHandlerInterface core;
  late ProviderContainer container;
  var downloadBody = 'proxies: []\nrules: []\n';
  Object? downloadError;
  String? failedDownloadUrl;
  PlatformFile? selectedFile;

  setUpAll(() async {
    await AppLocalizations.load(const Locale('en'));
    home = Directory.systemTemp.createTempSync('flclash-profiles-action-');
    await useAppPaths(home);
  });

  tearDownAll(() {
    if (home.existsSync()) home.deleteSync(recursive: true);
  });

  setUp(() {
    downloadBody = 'proxies: []\nrules: []\n';
    downloadError = null;
    failedDownloadUrl = null;
    selectedFile = null;
    globalState.packageInfo = PackageInfo(
      appName: 'Test',
      packageName: 'test',
      version: '1.0',
      buildNumber: '1',
    );
    core = _MockCoreHandlerInterface();
    when(() => core.validateConfig(any())).thenAnswer((_) async => null);
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(TestProfiles.new),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        profileDownloaderProvider.overrideWith(
          (ref) => (profile) async {
            if (downloadError case final error?) {
              throw StateError(error.toString());
            }
            if (profile.url == failedDownloadUrl) {
              throw const FormatException('subscription is invalid');
            }
            final file = await profile.file;
            await file.writeAsString(downloadBody);
            return profile.copyWith(lastUpdateDate: DateTime.now());
          },
        ),
        profileFilePickerProvider.overrideWith(
          (ref) =>
              () async => selectedFile,
        ),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
  });

  void decodesTo(String link, List<Map<String, dynamic>> proxies) {
    when(
      () => core.decodeShareLinks([link]),
    ).thenAnswer((_) async => [proxies]);
  }

  Future<void> pumpHost(WidgetTester tester) async {
    const size = Size(1200, 1000);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    container.read(viewSizeProvider.notifier).value = size;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: SizedBox()),
      ),
    );
  }

  Future<List<Map>> savedProxies(Profile profile) async {
    final config = loadYaml(await (await profile.file).readAsString()) as Map;
    return [for (final proxy in config['proxies'] as List) proxy as Map];
  }

  test('imports a valid selected file and reports success', () async {
    selectedFile = _TestPlatformFile(
      'local.yaml',
      Uint8List.fromList('proxies: []\nrules: []\n'.codeUnits),
    );
    await container.read(profilesActionProvider.notifier).addProfileFormFile();

    final profile = container.read(profilesProvider).single;
    expect(profile.label, 'local.yaml');
    expect(
      await (await profile.file).readAsString(),
      'proxies: []\nrules: []\n',
    );
  });

  test('shows an error and does not save an invalid selected file', () async {
    selectedFile = _TestPlatformFile(
      'invalid.yaml',
      Uint8List.fromList('bad'.codeUnits),
    );
    when(
      () => core.validateConfig(any()),
    ).thenAnswer((_) async => 'invalid profile');
    when(() => core.convertProxies(any())).thenThrow(Exception('invalid yaml'));

    final error = await container
        .read(profilesActionProvider.notifier)
        .addProfileFormFile();

    expect(container.read(profilesProvider), isEmpty);
    expect(error, isNotNull);
  });

  group('addProfileFromLink with a share link', () {
    test('saves a file profile named after the proxy it holds', () async {
      const link = 'vless://id@hk.example.com:443#HK';
      decodesTo(link, [
        {'name': 'HK', 'type': 'vless', 'server': 'hk.example.com'},
      ]);

      await container
          .read(profilesActionProvider.notifier)
          .addProfileFromLink(link);

      final profile = container.read(profilesProvider).single;
      expect(profile.type, ProfileType.file);
      expect(profile.url, isEmpty);
      expect(profile.label, 'HK');
      expect(await savedProxies(profile), [
        {'name': 'HK', 'type': 'vless', 'server': 'hk.example.com'},
      ]);
      verify(() => core.validateConfig(any())).called(1);
    });

    test('names an unnamed proxy after its server', () async {
      const link = 'ss://YWVzLTEyOC1nY206cGFzcw@ss.example.com:8388';
      decodesTo(link, [
        {'name': '', 'type': 'ss', 'server': 'ss.example.com'},
      ]);

      await container
          .read(profilesActionProvider.notifier)
          .addProfileFromLink(link, label: 'Mine');

      final profile = container.read(profilesProvider).single;
      expect(profile.label, 'Mine');
      expect((await savedProxies(profile)).single['name'], 'ss.example.com');
    });

    test('moves a proxy off a name mihomo reserves', () async {
      const link = 'trojan://pass@t.example.com:443#DIRECT';
      decodesTo(link, [
        {'name': 'DIRECT', 'type': 'trojan', 'server': 't.example.com'},
      ]);

      await container
          .read(profilesActionProvider.notifier)
          .addProfileFromLink(link);

      final profile = container.read(profilesProvider).single;
      expect((await savedProxies(profile)).single['name'], 'DIRECT-01');
    });

    testWidgets('reports a link no proxy can be read from and adds nothing', (
      tester,
    ) async {
      const link = 'vmess://not-base64';
      decodesTo(link, const []);
      await pumpHost(tester);

      await container
          .read(profilesActionProvider.notifier)
          .addProfileFromLink(link);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text(currentAppLocalizations.shareLinksInvalid), findsOne);
      expect(container.read(profilesProvider), isEmpty);
      verifyNever(() => core.validateConfig(any()));
    });
  });

  group('URL subscription imports', () {
    const link = 'https://sub.example.com/feed';

    testWidgets('writes a new subscription and reports success', (
      tester,
    ) async {
      await pumpHost(tester);
      final currentProfileSubscription = container.listen(
        currentProfileIdProvider,
        (_, _) {},
      );
      addTearDown(currentProfileSubscription.close);

      await tester.runAsync(
        () => container
            .read(profilesActionProvider.notifier)
            .addProfileFromLink(link),
      );
      await tester.pump(const Duration(seconds: 2));

      final profile = container.read(profilesProvider).single;
      expect(profile.url, link);
      expect(container.read(currentProfileIdProvider), profile.id);
      expect(
        await tester.runAsync(() async => (await profile.file).exists()),
        isTrue,
      );
      expect(find.text(currentAppLocalizations.profileImportSuccess), findsOne);
    });

    testWidgets('shows a visible error when the subscription download fails', (
      tester,
    ) async {
      downloadError = const FormatException('subscription is invalid');
      await pumpHost(tester);

      await tester.runAsync(
        () => container
            .read(profilesActionProvider.notifier)
            .addProfileFromLink(link),
      );
      await tester.pump(const Duration(seconds: 1));

      expect(container.read(profilesProvider), isEmpty);
      expect(find.textContaining('subscription is invalid'), findsOne);
    });

    testWidgets('reimport updates in place and keeps id and ordering', (
      tester,
    ) async {
      downloadBody = 'proxies: []\nrules: [MATCH,DIRECT]\n';
      await pumpHost(tester);
      final first = Profile.normal(
        label: 'Subscription',
        url: link,
      ).copyWith(order: 4);
      final other = Profile.normal(label: 'Other').copyWith(order: 5);
      container.read(profilesProvider.notifier)
        ..put(first)
        ..put(other);
      await tester.runAsync(pumpEventQueue);
      final before = container.read(profilesProvider).map((item) => item.id);

      downloadBody = 'proxies: []\nrules: [MATCH,REJECT]\n';
      await tester.runAsync(
        () => container
            .read(profilesActionProvider.notifier)
            .addProfileFromLink(' $link '),
      );
      await tester.pumpAndSettle();

      final after = container.read(profilesProvider);
      expect(after, hasLength(2));
      expect(after.map((item) => item.id), before);
      expect(after.first.id, first.id);
      expect(after.first.order, 4);
      expect(
        await tester.runAsync(
          () async => (await after.first.file).readAsString(),
        ),
        contains('REJECT'),
      );
      expect(
        find.text(currentAppLocalizations.profileAlreadyExistsUpdated),
        findsOne,
      );
    });

    testWidgets('a recovered row with the same URL is updated in place', (
      tester,
    ) async {
      final previousDatabase = db.database;
      final previousWarningSetting =
          driftRuntimeOptions.dontWarnAboutMultipleDatabases;
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final damagedDatabase = db.Database(NativeDatabase.memory());
      db.database = damagedDatabase;
      addTearDown(() async {
        db.database = previousDatabase;
        driftRuntimeOptions.dontWarnAboutMultipleDatabases =
            previousWarningSetting;
        await damagedDatabase.close();
      });
      await damagedDatabase.profilesDao.query().get();
      await damagedDatabase.customStatement('''
        INSERT INTO profiles (
          id, type, label, current_group_name, url, age_secret_key,
          last_update_date, extend_type, script_id, match_target,
          auto_update_duration_millis, subscription_info, auto_update,
          selected_map, unfold_set, "order", overrides
        ) VALUES (
          90, 'url', 'Previously hidden', NULL, '$link', NULL,
          NULL, 'legacy-extend-type', NULL, NULL, 3600000, NULL,
          1, '{}', '[]', 7, NULL
        )
      ''');
      final recovered =
          (await damagedDatabase.profilesDao.query().get()).single;
      await pumpHost(tester);
      (container.read(profilesProvider.notifier) as TestProfiles).replace([
        recovered,
      ]);

      downloadBody = 'proxies: []\nrules: [MATCH,REJECT]\n';
      await tester.runAsync(
        () => container
            .read(profilesActionProvider.notifier)
            .addProfileFromLink(link),
      );
      await tester.pumpAndSettle();

      final state = container.read(profilesProvider);
      expect(state, hasLength(1));
      expect(state.single.id, 90);
      expect(state.single.order, 7);
      expect((await damagedDatabase.profilesDao.query().get()).single.id, 90);
      expect(
        await tester.runAsync(
          () async => (await state.single.file).readAsString(),
        ),
        contains('REJECT'),
      );
      expect(
        find.text(currentAppLocalizations.profileAlreadyExistsUpdated),
        findsOne,
      );
    });
  });

  group('addProfilesFromLinks with share links', () {
    const links = [
      'vless://id@hk.example.com:443#HK',
      'trojan://pass@hk2.example.com:443#HK',
      'ss://YWVzLTEyOC1nY206cGFzcw@ss.example.com:8388',
    ];

    test('makes one profile of all their proxies', () async {
      when(() => core.decodeShareLinks(links)).thenAnswer(
        (_) async => [
          [
            {'name': 'HK', 'type': 'vless', 'server': 'hk.example.com'},
          ],
          [
            {'name': 'HK', 'type': 'trojan', 'server': 'hk2.example.com'},
          ],
          [
            {'name': '', 'type': 'ss', 'server': 'ss.example.com'},
          ],
        ],
      );

      await container
          .read(profilesActionProvider.notifier)
          .addProfilesFromLinks(links);

      final profile = container.read(profilesProvider).single;
      expect(profile.type, ProfileType.file);
      expect(
        profile.label,
        currentAppLocalizations.proxiesProfileLabel('HK', 3),
      );
      expect(
        [for (final proxy in await savedProxies(profile)) proxy['name']],
        ['HK', 'HK-01', 'ss.example.com'],
      );
      verify(() => core.decodeShareLinks(links)).called(1);
    });

    testWidgets('names the link no proxy can be read from and adds nothing', (
      tester,
    ) async {
      when(() => core.decodeShareLinks(links)).thenAnswer(
        (_) async => [
          [
            {'name': 'HK', 'type': 'vless', 'server': 'hk.example.com'},
          ],
          const [],
          [
            {'name': '', 'type': 'ss', 'server': 'ss.example.com'},
          ],
        ],
      );
      await pumpHost(tester);

      await container
          .read(profilesActionProvider.notifier)
          .addProfilesFromLinks(links);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      final l10n = currentAppLocalizations;
      expect(
        find.text(
          l10n.profileBatchImportSummary(
            0,
            0,
            1,
            l10n.shareLinkUnreadable(links[1]),
          ),
        ),
        findsOne,
      );
      expect(container.read(profilesProvider), isEmpty);
      verifyNever(() => core.validateConfig(any()));
    });
  });

  test(
    'batch imports persist each result and summarize mixed results',
    () async {
      const existingUrl = 'https://example.com/existing';
      const failedUrl = 'https://example.com/invalid';
      failedDownloadUrl = failedUrl;
      final existing = Profile.normal(label: 'Existing', url: existingUrl);
      container.read(profilesProvider.notifier).put(existing);
      await pumpEventQueue();

      await container
          .read(profilesActionProvider.notifier)
          .addProfilesFromLinks([
            'https://example.com/new',
            existingUrl,
            failedUrl,
          ]);

      final profiles = container.read(profilesProvider);
      expect(profiles, hasLength(2));
      expect(profiles.map((profile) => profile.id), contains(existing.id));
      expect(
        profiles.singleWhere((profile) => profile.id == existing.id).url,
        existingUrl,
      );
    },
  );
}
