import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/dashboard/business.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/host_scaffold.dart';
import '../../helpers/test_app.dart';

class _TestResidentialAction extends ResidentialAction {
  _TestResidentialAction(this.initial);

  final ResidentialApplyState initial;

  @override
  ResidentialApplyState build() => initial;
}

ResidentialPolicy _policy({
  bool catalogReady = true,
  bool active = false,
  bool rootAvailable = true,
  List<String> choices = const ['Tokyo'],
  String? configured,
}) {
  return ResidentialPolicy(
    profileId: 1,
    fingerprint: 'fingerprint',
    configuredExit: configured ?? (active ? 'Tokyo' : null),
    selectedExit: active ? 'Tokyo' : null,
    active: active,
    rootAvailable: rootAvailable,
    choices: choices,
    catalogReady: catalogReady,
  );
}

Widget _app(
  ResidentialPolicy policy, {
  ResidentialApplyState action = const ResidentialApplyState(
    profileId: 1,
    fingerprint: 'fingerprint',
  ),
  double width = 380,
  bool adaptive = false,
  List<Group> groups = const [],
}) {
  return TestApp(
    locale: const Locale('en'),
    overrides: [
      residentialPolicyProvider.overrideWithValue(policy),
      groupsProvider.overrideWithBuild((_, _) => groups),
      selectedProxyNameProvider(appName).overrideWith((_) => 'Auto'),
      residentialActionProvider.overrideWith(
        () => _TestResidentialAction(action),
      ),
    ],
    child: HostScaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: DashboardDensityScope(
            density: DashboardDensity.mobile,
            scale: 1,
            child: adaptive
                ? const BusinessLineCard()
                : const ResidentialExitCard(),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'ordinary subscriptions get line controls without residential prompts',
    (tester) async {
      await tester.pumpWidget(
        _app(
          _policy(rootAvailable: false, choices: const []),
          adaptive: true,
          groups: const [
            Group(
              name: appName,
              type: GroupType.Selector,
              all: [Proxy(name: 'Auto', type: 'URLTest')],
            ),
          ],
        ),
      );
      await tester.pump();
      expect(find.text('Connection line'), findsOneWidget);
      expect(find.text('Auto'), findsOneWidget);
      expect(find.text('Change line'), findsOneWidget);
      expect(find.text('No residential lines available'), findsNothing);
      expect(
        find.textContaining('service-side alternative exit'),
        findsNothing,
      );
    },
  );

  testWidgets('unknown subscription capability uses neutral loading copy', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_policy(catalogReady: false), adaptive: true));
    expect(find.text('Loading available lines…'), findsOneWidget);
    expect(find.text('Loading residential lines…'), findsNothing);
  });

  testWidgets(
    'ordinary empty catalog points to subscription without an upsell',
    (tester) async {
      await tester.pumpWidget(
        _app(_policy(rootAvailable: false, choices: const []), adaptive: true),
      );
      expect(
        find.text('No lines loaded yet. Check your subscription.'),
        findsOneWidget,
      );
      expect(find.text('Manage subscription'), findsOneWidget);
      expect(find.text('Change line'), findsNothing);
    },
  );

  testWidgets(
    'an unavailable selected residential exit keeps recovery controls',
    (tester) async {
      await tester.pumpWidget(
        _app(
          _policy(active: true, rootAvailable: false, choices: const []),
          adaptive: true,
        ),
      );
      expect(find.textContaining('Proxy traffic is blocked'), findsOneWidget);
      expect(find.text('Use subscription policy'), findsOneWidget);
    },
  );

  testWidgets('loading is not mistaken for an empty plan', (tester) async {
    await tester.pumpWidget(_app(_policy(catalogReady: false)));
    await tester.pump();

    expect(find.text('Loading residential lines…'), findsOneWidget);
    expect(find.text('No residential lines available'), findsNothing);
  });

  testWidgets('an empty plan points at the subscription', (tester) async {
    await tester.pumpWidget(
      _app(_policy(rootAvailable: false, choices: const [])),
    );
    await tester.pump();

    expect(find.text('No residential lines available'), findsOneWidget);
    expect(find.text('Manage subscription'), findsOneWidget);
    expect(find.text('Choose exit'), findsNothing);
  });

  testWidgets('the selected exit explains the business route', (tester) async {
    await tester.pumpWidget(_app(_policy(active: true)));
    await tester.pump();

    expect(find.text('Tokyo'), findsOneWidget);
    expect(find.text('Change exit'), findsOneWidget);
    expect(find.text('Use subscription policy'), findsOneWidget);
    expect(
      find.textContaining('service-side alternative exit'),
      findsOneWidget,
    );
    expect(find.textContaining('current check destination'), findsOneWidget);
  });

  testWidgets('a missing exit fails closed and says so', (tester) async {
    await tester.pumpWidget(
      _app(_policy(active: true, choices: const [], configured: 'Tokyo')),
    );
    await tester.pump();

    expect(
      find.text(
        'The selected residential exit is no longer in this subscription.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Proxy traffic is blocked'), findsOneWidget);
  });

  testWidgets('a failed apply is visible and offers a retry', (tester) async {
    await tester.pumpWidget(
      _app(
        _policy(active: true),
        action: const ResidentialApplyState(
          profileId: 1,
          fingerprint: 'fingerprint',
          failed: true,
          attempted: true,
          attemptedExit: 'Tokyo',
        ),
      ),
    );
    await tester.pump();

    expect(
      find.text(
        'This line could not be applied. Retry or choose another line.',
      ),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('an apply in flight says so without a spinner', (tester) async {
    await tester.pumpWidget(
      _app(
        _policy(active: true),
        action: const ResidentialApplyState(
          profileId: 1,
          fingerprint: 'fingerprint',
          applying: true,
          attempted: true,
          attemptedExit: 'Tokyo',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Switching lines. Please wait.'), findsOneWidget);
  });

  testWidgets('the sheet offers direct exit lines, not transport nodes', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(_policy(choices: const ['Tokyo', 'Hong Kong'])),
    );
    await tester.pump();
    await tester.tap(find.text('Choose exit'));
    await tester.pumpAndSettle();

    expect(find.text('Tokyo'), findsOneWidget);
    expect(find.text('Hong Kong'), findsOneWidget);
    expect(find.text('home-a'), findsNothing);
  });
}
