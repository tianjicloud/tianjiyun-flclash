import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/views/dashboard/line_data.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/widgets/quick_lines.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';

import '../../helpers/host_scaffold.dart';
import '../../helpers/test_app.dart';
import '../../helpers/test_profiles.dart';

const _names = [
  '🇭🇰 香港 · 家宽 · 三网优化 · 超长线路名称',
  '🇸🇬 新加坡 · 家宽',
  '🇹🇼 台湾 · 家宽',
  '🇺🇸 美国 · 洛杉矶',
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUp(() {
    const profile = Profile(
      id: 1,
      type: ProfileType.url,
      label: 'Tianji',
      url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
      autoUpdateDuration: Duration(days: 1),
    );
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
      ],
    );
    globalState.container = container;
    container.read(currentProfileIdProvider.notifier).value = 1;
    container.read(groupsProvider.notifier).value = const [
      Group(
        name: '线路',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: '🇭🇰 香港 · 家宽 · 三网优化 · 超长线路名称', type: 'anytls'),
          Proxy(name: '🇸🇬 新加坡 · 家宽', type: 'anytls'),
          Proxy(name: '🇹🇼 台湾 · 家宽', type: 'anytls'),
          Proxy(name: '🇺🇸 美国 · 洛杉矶', type: 'anytls'),
        ],
      ),
      Group(
        name: '备用 A',
        type: GroupType.Selector,
        hidden: false,
        all: [Proxy(name: 'a', type: 'ss')],
      ),
      Group(
        name: '备用 B',
        type: GroupType.Selector,
        hidden: false,
        all: [Proxy(name: 'b', type: 'ss')],
      ),
      Group(
        name: '备用 C',
        type: GroupType.Selector,
        hidden: false,
        all: [Proxy(name: 'c', type: 'ss')],
      ),
    ];
    container
        .read(groupsSourceProfileProvider.notifier)
        .set(profileId: profile.id, url: profile.url);
  });

  tearDown(() => container.dispose());

  for (final active in [false, true]) {
    testWidgets('residential shortcut uses residential state: $active', (
      tester,
    ) async {
      var opened = 0;
      late List<DashboardLine> lines;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentGroupsStateProvider.overrideWithValue(
              const GroupsState(
                value: [
                  Group(
                    name: '线路',
                    type: GroupType.Selector,
                    all: [
                      Proxy(name: tianjiResidentialRootName, type: 'Selector'),
                      Proxy(name: 'ordinary', type: 'ss'),
                    ],
                  ),
                ],
              ),
            ),
            selectedProxyNameProvider('线路').overrideWithValue(
              active ? 'ordinary' : tianjiResidentialRootName,
            ),
            residentialPolicyProvider.overrideWithValue(
              ResidentialPolicy(
                profileId: 1,
                fingerprint: 'test',
                configuredExit: active ? 'home' : null,
                selectedExit: active ? 'home' : null,
                active: active,
                rootAvailable: true,
                choices: const ['home'],
                catalogReady: true,
              ),
            ),
            scenePolicyProvider.overrideWithValue(
              const ScenePolicy(
                available: false,
                current: null,
                suspended: false,
              ),
            ),
            delaysAtLastTestBatchProvider.overrideWithValue(const {}),
            realTestUrlProvider().overrideWithValue('https://probe.invalid'),
          ],
          child: TestApp(
            child: Consumer(
              builder: (context, ref, child) {
                lines = dashboardLines(ref);
                return QuickLines(onChooseResidential: () => opened++);
              },
            ),
          ),
        ),
      );
      await tester.pump();
      expect(lines.first.residential, isTrue);
      expect(lines.first.current, active);
      expect(lines.last.current, isFalse);
      await tester.tap(
        find
            .textContaining(tianjiResidentialRootName, findRichText: true)
            .first,
      );
      await tester.pump();
      expect(opened, 1);
      expect(tester.takeException(), isNull);
    });
  }

  for (final (width, scale, columns) in [
    (390.0, 1.0, 2),
    (320.0, 1.0, 1),
    (390.0, 1.6, 1),
  ]) {
    testWidgets('quick lines keep four real names at $width / $scale', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      container.read(viewSizeProvider.notifier).value = Size(width, 900);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            locale: const Locale('zh', 'CN'),
            child: HostScaffold(
              body: SizedBox(
                width: width,
                child: DashboardDensityScope(
                  density: DashboardDensity.mobile,
                  scale: scale,
                  child: QuickLines(onChooseResidential: () {}),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      for (final name in _names) {
        expect(
          find.textContaining(name, findRichText: true),
          findsWidgets,
          reason: name,
        );
      }
      final long = tester.widget<EmojiText>(
        find.byWidgetPredicate(
          (widget) => widget is EmojiText && widget.text == _names.first,
        ),
      );
      expect(long.maxLines, 2);

      final first = tester.getTopLeft(
        find.textContaining(_names[0], findRichText: true),
      );
      final second = tester.getTopLeft(
        find.textContaining(_names[1], findRichText: true),
      );
      if (columns == 2) {
        expect(second.dy, moreOrLessEquals(first.dy, epsilon: 1));
      } else {
        expect(second.dy, greaterThan(first.dy));
      }
    });
  }
}
