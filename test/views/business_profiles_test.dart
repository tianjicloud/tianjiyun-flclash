import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/profiles/profiles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart' show AppBar, Card, ThemeData;
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;

import '../helpers/host_scaffold.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

Future<void> _pumpBusinessProfiles(
  WidgetTester tester,
  Size size, {
  bool macOS = false,
  bool mobile = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final profile = Profile.normal(
    label: 'Plan',
    url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
  );
  final container = ProviderContainer(
    overrides: [
      viewModeProvider.overrideWithValue(
        mobile ? ViewMode.mobile : ViewMode.desktop,
      ),
      profilesProvider.overrideWith(
        () => TestProfiles([
          profile,
          Profile.normal(
            label: 'Backup',
            url: 'https://example.com/profile.yaml',
          ),
        ]),
      ),
      currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
    ],
  );
  addTearDown(container.dispose);
  globalState.container = container;
  container.read(viewSizeProvider.notifier).value = size;

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: TestApp(
        theme: ThemeData(
          platform: mobile
              ? TargetPlatform.android
              : macOS
              ? TargetPlatform.macOS
              : TargetPlatform.windows,
        ),
        homeBuilder: (child) => HostScaffold(body: child),
        child: const ProfilesView(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

({List<double> left, List<double> right, List<double> gaps})
_subscriptionContentGeometry(WidgetTester tester, {required bool macOS}) {
  final l10n = currentAppLocalizations;
  final primaryTitle = find.text('Plan', findRichText: true);
  final otherTitle = find.text(l10n.otherProfilesTitle);
  final hintText = find.byWidgetPredicate(
    (widget) =>
        widget is Text &&
        (widget.textSpan?.toPlainText().contains('tianji://') ?? false),
  );
  final primaryCard = find
      .ancestor(of: primaryTitle, matching: find.byType(Card))
      .first;
  final otherCard = find
      .ancestor(of: otherTitle, matching: find.byType(Card))
      .first;
  final hintCard = find
      .ancestor(
        of: hintText,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is DecoratedBox && widget.decoration is ShapeDecoration,
        ),
      )
      .first;
  final hintPadding = find
      .ancestor(of: hintText, matching: find.byType(Padding))
      .first;
  final hintPaddingData = tester.widget<Padding>(hintPadding);
  final primaryTail = macOS
      ? find.descendant(of: primaryCard, matching: find.byTooltip(l10n.more))
      : find.ancestor(
          of: find.text(l10n.edit),
          matching: find.byType(BusinessSecondaryButton),
        );
  final otherTail = macOS
      ? find.ancestor(
          of: find.text(l10n.switchProfileShort),
          matching: find.byType(BusinessSecondaryButton),
        )
      : find.ancestor(
          of: find.text(l10n.sort),
          matching: find.byType(BusinessSecondaryButton),
        );
  final primaryRect = tester.getRect(primaryCard);
  final otherRect = tester.getRect(otherCard);
  final hintRect = tester.getRect(hintCard);

  return (
    left: [
      tester.getTopLeft(primaryTitle).dx,
      tester.getTopLeft(otherTitle).dx,
      tester.getTopLeft(hintText).dx,
    ],
    right: [
      tester.getRect(primaryTail.first).right,
      tester.getRect(otherTail.first).right,
      hintRect.right - hintPaddingData.padding.horizontal / 2,
    ],
    gaps: [otherRect.top - primaryRect.bottom, hintRect.top - otherRect.bottom],
  );
}

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

  testWidgets('Windows subscription content geometry', (tester) async {
    await _pumpBusinessProfiles(tester, const Size(1280, 900));
    final geometry = _subscriptionContentGeometry(tester, macOS: false);
    expect(geometry.left[1], closeTo(geometry.left[0], 0.5));
    expect(geometry.left[2], closeTo(geometry.left[0], 0.5));
    expect(geometry.right[1], closeTo(geometry.right[0], 0.5));
    expect(geometry.right[2], closeTo(geometry.right[0], 0.5));
    expect(geometry.gaps, [16, 16]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('macOS subscription content geometry', (tester) async {
    await _pumpBusinessProfiles(tester, const Size(1280, 900), macOS: true);
    final geometry = _subscriptionContentGeometry(tester, macOS: true);
    expect(geometry.left[1], closeTo(geometry.left[0], 0.5));
    expect(geometry.left[2], closeTo(geometry.left[0], 0.5));
    expect(geometry.right[1], closeTo(geometry.right[0], 0.5));
    expect(geometry.right[2], closeTo(geometry.right[0], 0.5));
    expect(geometry.gaps, [16, 16]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop subscription content aligns at 820 pixels', (
    tester,
  ) async {
    await _pumpBusinessProfiles(tester, const Size(820, 900));
    final l10n = currentAppLocalizations;
    final primaryTitle = find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          (widget.data == 'Plan' ||
              (widget.textSpan?.toPlainText().startsWith('Plan') ?? false)),
    );
    final otherTitle = find.text(l10n.otherProfilesTitle);
    final hintText = find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          (widget.textSpan?.toPlainText().contains('tianji://') ?? false),
    );
    final primaryLeft = tester.getTopLeft(primaryTitle).dx;
    expect(tester.getTopLeft(otherTitle).dx, closeTo(primaryLeft, 0.5));
    expect(tester.getTopLeft(hintText).dx, closeTo(primaryLeft, 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile subscription cards align their titles', (tester) async {
    await _pumpBusinessProfiles(tester, const Size(390, 844), mobile: true);
    final l10n = currentAppLocalizations;
    final primaryTitle = find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          (widget.data == 'Plan' ||
              (widget.textSpan?.toPlainText().startsWith('Plan') ?? false)),
    );
    final otherTitle = find.text(l10n.otherProfilesTitle);
    expect(
      tester.getTopLeft(otherTitle).dx,
      closeTo(tester.getTopLeft(primaryTitle).dx, 0.5),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop subscription keeps import actions in the add form', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
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
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(viewSizeProvider.notifier).value = const Size(1400, 1000);

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

    final l10n = tester.element(find.byType(ProfilesView)).appLocalizations;
    expect(find.textContaining('tianji://'), findsOneWidget);
    expect(find.text(l10n.pasteFromClipboardImport), findsNothing);
    expect(find.text(l10n.chooseFile), findsNothing);

    await tester.tap(find.text('＋ ${l10n.importSubscription}'));
    await tester.pumpAndSettle();
    for (final source in [
      l10n.businessProfileAddLinkDescription,
      l10n.businessProfileAddFileDescription,
      l10n.businessProfileAddCustomDescription,
    ]) {
      expect(find.text(source), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop subscription add form fits an 820 by 600 window', (
    tester,
  ) async {
    const size = Size(820, 600);
    tester.view.physicalSize = size;
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
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(viewSizeProvider.notifier).value = size;

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

    final l10n = tester.element(find.byType(ProfilesView)).appLocalizations;
    await tester.tap(find.text('＋ ${l10n.importSubscription}'));
    await tester.pumpAndSettle();

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
