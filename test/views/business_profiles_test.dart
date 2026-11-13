import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/profiles/profiles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart' show AppBar, ThemeData;

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

  testWidgets('macOS subscription actions stay in the overflow menu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final profile = Profile.normal(
      label: 'Plan',
      url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
    );
    final container = ProviderContainer(
      overrides: [
        viewModeProvider.overrideWithValue(ViewMode.desktop),
        profilesProvider.overrideWith(
          () => TestProfiles([
            profile,
            Profile.normal(
              label: 'Other plan',
              url: 'https://sub1.tianjiyun.org/s/test_subscription_002',
            ),
          ]),
        ),
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
          theme: ThemeData(platform: TargetPlatform.macOS),
          homeBuilder: (child) => HostScaffold(body: child),
          child: const ProfilesView(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    final headerBottom = tester.getRect(find.byType(AppBar).first).bottom;
    final firstCardTop = tester
        .getRect(find.byKey(const ValueKey('macos-subscription-primary-card')))
        .top;
    expect(firstCardTop, greaterThanOrEqualTo(headerBottom));
    final otherRow = find.byKey(const ValueKey('macos-subscription-other-row'));
    expect(tester.getSize(otherRow).height, greaterThanOrEqualTo(48));
    final iconBox = find
        .descendant(
          of: otherRow,
          matching: find.byWidgetPredicate(
            (widget) => widget is SizedBox && widget.width == 32,
          ),
        )
        .first;
    expect(
      (tester.getCenter(iconBox).dy - tester.getCenter(otherRow).dy).abs(),
      lessThanOrEqualTo(1),
    );

    expect(find.text('Plan'), findsOneWidget);
    final l10n = tester.element(find.byType(ProfilesView)).appLocalizations;
    expect(find.text(l10n.immediateUpdate), findsOneWidget);
    expect(find.byTooltip(l10n.more), findsOneWidget);
    await tester.tap(find.byTooltip(l10n.more));
    await tester.pumpAndSettle();
    for (final label in [
      l10n.renewUpgrade,
      l10n.edit,
      l10n.sync,
      l10n.more,
      l10n.delete,
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    await tester.tap(find.text(l10n.more));
    await tester.pumpAndSettle();
    expect(find.text(l10n.copyLink), findsOneWidget);
    expect(find.text(l10n.qrcode), findsOneWidget);
  });
}
