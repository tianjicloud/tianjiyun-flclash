import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/profiles/profiles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/host_scaffold.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

void main() {
  testWidgets('desktop profile leaves unknown quota and expiry unknown', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final profile = Profile.normal(
      label: 'Unknown plan',
      url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
    );
    final container = ProviderContainer(
      overrides: [
        viewModeProvider.overrideWithValue(ViewMode.desktop),
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(viewSizeProvider.notifier).value = const Size(1280, 800);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          homeBuilder: (child) => HostScaffold(body: child),
          child: const ProfilesView(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Unknown plan'), findsOneWidget);
    expect(find.text('—'), findsNWidgets(2));
    expect(
      find.text(
        tester.element(find.byType(ProfilesView)).appLocalizations.infiniteTime,
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });
}
