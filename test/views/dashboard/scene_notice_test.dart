import 'dart:convert';

import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/widgets/scene_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';
import '../../helpers/test_profiles.dart';

void main() {
  testWidgets('dismissal persists per profile and survives serialization', (
    tester,
  ) async {
    const profile = Profile(
      id: 1,
      label: 'First',
      autoUpdateDuration: Duration(days: 1),
    );
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(
          () =>
              TestProfiles([profile, profile.copyWith(id: 2, label: 'Second')]),
        ),
        scenePolicyProvider.overrideWithValue(
          const ScenePolicy(available: false, current: null, suspended: false),
        ),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(currentProfileIdProvider.notifier).value = 1;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(
          child: Center(
            child: SizedBox(width: 320, child: SceneUnavailableCard()),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.getSize(find.byType(SceneUnavailableCard)).height, 40);
    await tester.tap(find.byTooltip('Close'));
    await tester.pump();
    expect(find.byTooltip('Close'), findsNothing);
    final saved = container.read(currentProfileProvider)!.overrides;
    expect(
      ProfileOverrides.fromJson(
        jsonDecode(jsonEncode(saved.toJson())),
      ).sceneNoticeDismissed,
      isTrue,
    );
    container.read(currentProfileIdProvider.notifier).value = 2;
    await tester.pump();
    expect(find.byTooltip('Close'), findsOneWidget);
    container.read(currentProfileIdProvider.notifier).value = 1;
    await tester.pump();
    expect(find.byTooltip('Close'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('scene availability removes the notice without dismissal', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentProfileProvider.overrideWithValue(null),
          scenePolicyProvider.overrideWithValue(
            const ScenePolicy(available: true, current: null, suspended: false),
          ),
        ],
        child: const TestApp(child: SceneUnavailableCard()),
      ),
    );
    expect(find.byTooltip('Close'), findsNothing);
  });
}
