import 'dart:async';
import 'package:fl_clash/common/default_line.dart';
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
import '../../helpers/default_lines.dart';
import '../../helpers/test_app.dart';

class _TestResidentialAction extends ResidentialAction {
  _TestResidentialAction(this.initial);

  final ResidentialApplyState initial;

  @override
  ResidentialApplyState build() => initial;
}

const _profile = Profile(
  id: 1,
  type: ProfileType.url,
  url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
  autoUpdateDuration: Duration.zero,
);

class _TestGroupsSource extends GroupsSourceProfile {
  @override
  GroupsCatalogSource build() =>
      GroupsCatalogSource(profileId: 1, url: _profile.url, loaded: true);
}

class _TestProxiesAction extends ProxiesAction {
  final choices = <DefaultLineChoice>[];
  Future<bool> Function()? handle;
  @override
  void build() {}
  @override
  Future<bool> changeDefaultLine(DefaultLineChoice choice) {
    choices.add(choice);
    return handle?.call() ?? Future.value(true);
  }
}

ResidentialPolicy _policy({
  bool catalogReady = true,
  bool active = false,
  bool rootAvailable = true,
  bool bulkBypass = false,
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
    bulkBypass: bulkBypass,
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
  Map<String, String> selections = const {appName: 'Auto'},
  _TestProxiesAction? proxies,
  Mode mode = Mode.rule,
}) {
  return TestApp(
    locale: const Locale('en'),
    overrides: [
      residentialPolicyProvider.overrideWithValue(policy),
      groupsProvider.overrideWithBuild((_, _) => groups),
      selectedMapProvider.overrideWith((_) => selections),
      currentProfileProvider.overrideWithValue(_profile),
      groupsSourceProfileProvider.overrideWith(_TestGroupsSource.new),
      patchClashConfigProvider.overrideWithBuild(
        (_, _) => defaultClashConfig.copyWith(mode: mode),
      ),
      if (proxies != null) proxiesActionProvider.overrideWith(() => proxies),
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
  testWidgets('bulk notice appears only when the applied group is present', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_policy(active: true)));
    expect(find.textContaining('Listed video'), findsNothing);
    await tester.pumpWidget(_app(_policy(active: true, bulkBypass: true)));
    expect(find.textContaining('Listed video'), findsOneWidget);
    await tester.pumpWidget(_app(_policy(bulkBypass: true)));
    expect(find.textContaining('Listed video'), findsNothing);
  });

  testWidgets('manual default line and its resolved node are both visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        _policy(rootAvailable: false, choices: const []),
        adaptive: true,
        groups: defaultLineTestGroups,
        selections: const {appName: '📍 指定节点', '📍 指定节点': 'Tokyo'},
      ),
    );
    expect(find.text('Tokyo'), findsOneWidget);
    expect(find.text('Tokyo transport'), findsOneWidget);
    expect(find.text('📍 指定节点'), findsNothing);
  });

  testWidgets(
    'ordinary picker exposes node names and submits the chosen line',
    (tester) async {
      final action = _TestProxiesAction();
      await tester.pumpWidget(
        _app(
          _policy(rootAvailable: false, choices: const []),
          adaptive: true,
          groups: defaultLineTestGroups,
          selections: const {},
          proxies: action,
        ),
      );
      await tester.tap(find.text('Change line'));
      await tester.pumpAndSettle();
      expect(find.text('Tokyo'), findsOneWidget);
      expect(find.text('Hong Kong'), findsOneWidget);
      expect(find.text('📍 指定节点'), findsNothing);
      await tester.tap(find.text('Tokyo'));
      await tester.pumpAndSettle();
      expect(action.choices.single.name, 'Tokyo');
      expect(find.text('Hong Kong'), findsNothing);
    },
  );

  testWidgets(
    'pending selection prevents double submission and failure keeps picker open',
    (tester) async {
      final pending = Completer<bool>();
      final action = _TestProxiesAction()..handle = () => pending.future;
      await tester.pumpWidget(
        _app(
          _policy(rootAvailable: false, choices: const []),
          adaptive: true,
          groups: defaultLineTestGroups,
          selections: const {},
          proxies: action,
        ),
      );
      await tester.tap(find.text('Change line'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo'));
      await tester.pump();
      await tester.tap(find.text('Hong Kong'));
      expect(action.choices.length, 1);
      pending.complete(false);
      await tester.pumpAndSettle();
      expect(
        find.text('Could not finish switching lines. Retry.'),
        findsOneWidget,
      );
      expect(find.text('Tokyo'), findsOneWidget);
    },
  );

  testWidgets(
    'an unexpected selection error releases the pending state for retry',
    (tester) async {
      final action = _TestProxiesAction()
        ..handle = () async => throw StateError('unavailable');
      await tester.pumpWidget(
        _app(
          _policy(rootAvailable: false, choices: const []),
          adaptive: true,
          groups: defaultLineTestGroups,
          selections: const {},
          proxies: action,
        ),
      );
      await tester.tap(find.text('Change line'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo'));
      await tester.pumpAndSettle();
      expect(
        find.text('Could not finish switching lines. Retry.'),
        findsOneWidget,
      );
      action.handle = () async => true;
      await tester.tap(find.text('Tokyo'));
      await tester.pumpAndSettle();
      expect(action.choices.length, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('long node names wrap in the picker instead of being ellipsized', (
    tester,
  ) async {
    const name =
        'Tokyo premium route with a deliberately long descriptive node name and transport information';
    final groups = [...defaultLineTestGroups];
    groups[2] = groups[2].copyWith(
      all: const [Proxy(name: name, type: 'ss')],
    );
    await tester.pumpWidget(
      _app(
        _policy(rootAvailable: false, choices: const []),
        adaptive: true,
        groups: groups,
        selections: const {},
        proxies: _TestProxiesAction(),
      ),
    );
    await tester.tap(find.text('Change line'));
    await tester.pumpAndSettle();
    final text = tester
        .widgetList<RichText>(find.byType(RichText))
        .singleWhere((text) => text.text.toPlainText() == name);
    expect(text.maxLines, isNull);
    expect(text.overflow, isNot(TextOverflow.ellipsis));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'closing the picker during selection leaves no disposed widget callbacks',
    (tester) async {
      final pending = Completer<bool>();
      final action = _TestProxiesAction()..handle = () => pending.future;
      await tester.pumpWidget(
        _app(
          _policy(rootAvailable: false, choices: const []),
          adaptive: true,
          groups: defaultLineTestGroups,
          selections: const {},
          proxies: action,
        ),
      );
      await tester.tap(find.text('Change line'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo'));
      await tester.pumpWidget(const SizedBox.shrink());
      pending.complete(true);
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  for (final mode in [Mode.global, Mode.direct]) {
    testWidgets('$mode explains why the default line is not in effect', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _policy(rootAvailable: false, choices: const []),
          adaptive: true,
          groups: defaultLineTestGroups,
          mode: mode,
        ),
      );
      expect(find.text('Change line'), findsNothing);
      expect(find.text('Enable smart routing'), findsOneWidget);
      await tester.tap(find.text('Enable smart routing'));
      await tester.pump();
      expect(find.text('Change line'), findsOneWidget);
    });
  }

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
      expect(find.text('Default line'), findsOneWidget);
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
