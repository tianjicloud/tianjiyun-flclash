import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/common/onboarding.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/pages/home.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/navigation.dart';
import 'package:fl_clash/views/onboarding/onboarding.dart';
import 'package:fl_clash/views/onboarding/plan_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

void main() {
  setUp(() {
    navigationPort = navigation;
    addTearDown(() => navigationPort = null);
  });

  ProviderContainer homeContainer({List<Profile> profiles = const []}) {
    final container = ProviderContainer(
      overrides: [profilesProvider.overrideWith(() => TestProfiles(profiles))],
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
