import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/core/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/dashboard/line_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _emptyPolicy = ResidentialPolicy(
  profileId: 1,
  fingerprint: 'fingerprint',
  configuredExit: null,
  selectedExit: null,
  active: false,
  rootAvailable: true,
  choices: [],
  catalogReady: true,
);

const _inactiveScene = ScenePolicy(
  available: false,
  current: null,
  suspended: false,
);

Widget _lineView({
  required List<Group> groups,
  required String? selected,
  ResidentialPolicy policy = _emptyPolicy,
  Map<String, String?> nestedSelections = const {},
}) {
  return ProviderScope(
    overrides: [
      tianjiApiEnabledProvider.overrideWithValue(false),
      currentGroupsStateProvider.overrideWithValue(GroupsState(value: groups)),
      residentialPolicyProvider.overrideWithValue(policy),
      scenePolicyProvider.overrideWithValue(_inactiveScene),
      delaysAtLastTestBatchProvider.overrideWithValue(const {}),
      realTestUrlProvider().overrideWithValue('https://probe.invalid'),
      for (final group in groups)
        selectedProxyNameProvider(
          group.name,
        ).overrideWithValue(nestedSelections[group.name] ?? selected),
    ],
    child: const Directionality(
      textDirection: TextDirection.ltr,
      child: _CurrentLineText(),
    ),
  );
}

void main() {
  testWidgets('exact selected member beats an earlier alias', (tester) async {
    const groups = [
      Group(
        name: '线路',
        type: GroupType.Selector,
        all: [
          Proxy(name: '自动选择', type: 'URLTest'),
          Proxy(name: '东京 02', type: 'anytls'),
        ],
      ),
      Group(
        name: '自动选择',
        type: GroupType.URLTest,
        now: '东京 02',
        all: [Proxy(name: '东京 02', type: 'anytls')],
      ),
    ];
    await tester.pumpWidget(
      _lineView(
        groups: groups,
        selected: '东京 02',
        nestedSelections: {'自动选择': '东京 02'},
      ),
    );
    expect(find.text('东京 02'), findsOneWidget);
  });

  testWidgets('current line remains visible after the first four choices', (
    tester,
  ) async {
    const groups = [
      Group(
        name: '线路',
        type: GroupType.Selector,
        all: [
          Proxy(name: '线路 1', type: 'anytls'),
          Proxy(name: '线路 2', type: 'anytls'),
          Proxy(name: '线路 3', type: 'anytls'),
          Proxy(name: '线路 4', type: 'anytls'),
          Proxy(name: '线路 5', type: 'anytls'),
        ],
      ),
    ];

    await tester.pumpWidget(_lineView(groups: groups, selected: '线路 5'));

    expect(find.text('线路 5'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('missing selected line does not fall back to the first choice', (
    tester,
  ) async {
    const groups = [
      Group(
        name: '线路',
        type: GroupType.Selector,
        all: [Proxy(name: '线路 1', type: 'anytls')],
      ),
    ];

    await tester.pumpWidget(_lineView(groups: groups, selected: '已移除线路'));

    expect(find.text('—'), findsOneWidget);
    expect(find.text('线路 1'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('active residential line displays the resolved exit name', (
    tester,
  ) async {
    const resolvedName = '东京家宽 02';
    const lockedName = tianjiResidentialLockedGroupName;
    const groups = [
      Group(
        name: tianjiResidentialRootName,
        type: GroupType.Selector,
        all: [
          Proxy(name: lockedName, type: 'Selector'),
          Proxy(name: resolvedName, type: 'anytls'),
        ],
      ),
      Group(
        name: lockedName,
        type: GroupType.Selector,
        now: resolvedName,
        all: [Proxy(name: resolvedName, type: 'anytls')],
      ),
    ];
    const policy = ResidentialPolicy(
      profileId: 1,
      fingerprint: 'fingerprint',
      configuredExit: resolvedName,
      selectedExit: resolvedName,
      active: true,
      rootAvailable: true,
      choices: [resolvedName],
      catalogReady: true,
    );

    await tester.pumpWidget(
      _lineView(
        groups: groups,
        selected: null,
        policy: policy,
        nestedSelections: {lockedName: resolvedName},
      ),
    );

    expect(find.text(resolvedName), findsOneWidget);
    expect(find.text(lockedName), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _CurrentLineText extends ConsumerWidget {
  const _CurrentLineText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final line = currentDashboardLine(ref);
    return Text(line?.displayName ?? '—');
  }
}
