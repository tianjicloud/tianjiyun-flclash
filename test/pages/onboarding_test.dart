import 'dart:async';
import 'dart:io';

import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/common/onboarding.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/pages/home.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/navigation.dart';
import 'package:fl_clash/views/onboarding/onboarding.dart';
import 'package:fl_clash/views/onboarding/plan_card.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/app_paths.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';
import '../helpers/traffic_stats_store.dart';

class _MockCore extends Mock implements CoreHandlerInterface {}

class _PendingProfileImport extends ProfilesAction {
  final result = Completer<Profile>();
  final deleted = <int>[];

  @override
  Future<Profile> importForOnboarding(String url) async {
    final profile = await result.future;
    ref.read(profilesProvider.notifier).put(profile);
    return profile;
  }

  @override
  Future<void> deleteProfile(int id) async {
    deleted.add(id);
    await ref.read(profilesProvider.notifier).del(id);
  }
}

void main() {
  setUp(() {
    navigationPort = navigation;
    addTearDown(() => navigationPort = null);
  });

  ProviderContainer homeContainer({
    List<Profile> profiles = const [],
    ProfilesAction? importer,
    CoreHandlerInterface? core,
  }) {
    final container = ProviderContainer(
      overrides: [
        idleTrafficStatsOverride(),
        profilesProvider.overrideWith(() => TestProfiles(profiles)),
        if (importer != null)
          profilesActionProvider.overrideWith(() => importer),
        if (core != null)
          coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(viewSizeProvider.notifier).value = const Size(1200, 800);
    return container;
  }

  Future<void> pumpHome(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(includeNavigatorKey: false, child: HomePage()),
      ),
    );
    await tester.pump();
  }

  testWidgets('an empty subscription list shows the welcome page', (
    tester,
  ) async {
    final container = homeContainer();
    await pumpHome(tester, container);

    expect(find.byType(OnboardingView), findsOneWidget);
    expect(find.text(AppLocalizations.current.onboardingTitle), findsOneWidget);
    expect(find.byType(HomeBackScopeContainer), findsNothing);
  });

  testWidgets('short desktop with large text scrolls instead of overflowing', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 500);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = homeContainer();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          locale: const Locale('en'),
          homeBuilder: (child) => Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.4)),
              child: child,
            ),
          ),
          child: const OnboardingView(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(OnboardingView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('onboarding stays visible until it finishes', (tester) async {
    final profile = Profile.normal(url: 'https://example.com/s/example');
    final container = homeContainer(profiles: [profile]);
    container
        .read(onboardingProvider.notifier)
        .imported(profileId: profile.id, proxyCount: 3);
    await pumpHome(tester, container);

    expect(find.byType(OnboardingView), findsOneWidget);

    container.read(onboardingProvider.notifier).finish();
    await tester.pump();

    expect(find.byType(OnboardingView), findsNothing);
    expect(find.byType(HomeBackScopeContainer), findsOneWidget);
  });

  testWidgets('pasting text that is not a subscription fails the flow', (
    tester,
  ) async {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.getData') {
        return <String, dynamic>{'text': 'plain text'};
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final container = homeContainer();
    await pumpHome(tester, container);
    await tester.tap(
      find.text(AppLocalizations.current.onboardingPasteFromClipboard),
    );
    await tester.pump();

    final state = container.read(onboardingProvider);
    expect(state, isA<OnboardingFailed>());
    expect((state as OnboardingFailed).failure, ImportFailure.notSubscription);
    expect(find.byType(OnboardingView), findsOneWidget);
  });

  testWidgets('confirmation shows the complete selectable subscription URL', (
    tester,
  ) async {
    const url = 'https://example.com/s/secret-token?token=example';
    final container = homeContainer();
    container.read(onboardingProvider.notifier).confirm(url);
    await pumpHome(tester, container);

    expect(find.text(url), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);
  });

  group('asynchronous import', () {
    setUp(() async {
      await useAppPaths(Directory.systemTemp);
    });

    for (final proxyCount in [0, 2]) {
      testWidgets(
        'completes with $proxyCount nodes after confirmation unmounts',
        (tester) async {
          final importer = _PendingProfileImport();
          final core = _MockCore();
          when(() => core.readConfig(any())).thenAnswer(
            (_) async => {
              'proxies': List.generate(proxyCount, (i) => {'name': 'Node $i'}),
            },
          );
          final container = homeContainer(importer: importer, core: core);
          final profile = Profile.normal(url: 'https://example.com/s/example');
          container.read(onboardingProvider.notifier).confirm(profile.url);
          await pumpHome(tester, container);

          await tester.tap(find.text(AppLocalizations.current.import));
          await tester.pump();
          expect(
            container.read(onboardingProvider),
            isA<OnboardingImporting>(),
          );
          expect(find.byType(SelectableText), findsNothing);

          importer.result.complete(profile);
          await tester.pump();
          await tester.pump();

          final state = container.read(onboardingProvider);
          if (proxyCount == 0) {
            expect(state, isA<OnboardingFailed>());
            expect((state as OnboardingFailed).failure, ImportFailure.empty);
            expect(importer.deleted, [profile.id]);
            expect(container.read(profilesProvider), isEmpty);
          } else {
            expect(state, isA<OnboardingImported>());
            expect((state as OnboardingImported).proxyCount, proxyCount);
            expect(state.profileId, profile.id);
            expect(importer.deleted, isEmpty);
            expect(container.read(profilesProvider), [profile]);
          }
          verify(() => core.readConfig(any())).called(1);
          expect(tester.takeException(), isNull);
        },
      );
    }
  });

  group('OnboardingPlanCard', () {
    Future<void> pumpCard(WidgetTester tester, SubscriptionInfo info) async {
      await tester.pumpWidget(TestApp(child: OnboardingPlanCard(info: info)));
      await tester.pump();
    }

    testWidgets('shows neither row when both values are zero', (tester) async {
      await pumpCard(tester, const SubscriptionInfo(total: 0, expire: 0));
      final appLocalizations = AppLocalizations.current;
      expect(
        find.text(appLocalizations.onboardingRemainingTraffic),
        findsNothing,
      );
      expect(find.text(appLocalizations.onboardingExpireDate), findsNothing);
    });

    testWidgets('shows remaining traffic without a zero expiry', (
      tester,
    ) async {
      await pumpCard(
        tester,
        const SubscriptionInfo(upload: 100, download: 200, total: 1000),
      );
      final appLocalizations = AppLocalizations.current;
      expect(
        find.text(appLocalizations.onboardingRemainingTraffic),
        findsOneWidget,
      );
      expect(find.text(appLocalizations.onboardingExpireDate), findsNothing);
    });

    testWidgets('shows expiry without a zero total', (tester) async {
      await pumpCard(
        tester,
        const SubscriptionInfo(total: 0, expire: 1700000000),
      );
      final appLocalizations = AppLocalizations.current;
      expect(
        find.text(appLocalizations.onboardingRemainingTraffic),
        findsNothing,
      );
      expect(find.text(appLocalizations.onboardingExpireDate), findsOneWidget);
    });
  });
}
