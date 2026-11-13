import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/ip_quality.dart';
import 'package:fl_clash/common/service_probe.dart'
    show directOutbound, routedOutbound;
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/ip_quality.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart';
import 'package:fl_clash/views/dashboard/widgets/current_outbound.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/glyph_finders.dart';
import '../../helpers/test_app.dart';
import 'package:prism_ui/prism_ui.dart';
import '../../helpers/host_scaffold.dart';

const _ip = '203.0.113.9';

const _profile = Profile(id: 1, autoUpdateDuration: Duration.zero);

const _residential = IpQuality(
  ip: _ip,
  source: IpQualitySource.ipLocate,
  type: IpType.residential,
  organization: 'Example Broadband',
  asn: 64500,
);

class _MockCore extends Mock implements CoreHandlerInterface {}

class _RecordingSetupAction extends SetupAction {
  final requests = <bool>[];

  @override
  Future<bool> setRunning(bool running, {bool initialize = false}) {
    requests.add(running);
    ref.read(runTimeProvider.notifier).value = running ? 1 : null;
    return Future.value(true);
  }
}

class _Ips extends OutboundIpProbe {
  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState({
    routedOutbound: ProbeEntry(
      phase: ProbePhase.fresh,
      value: IpInfo(ip: _ip, countryCode: 'GB'),
    ),
  });

  @override
  void watch(String target) {}

  @override
  void unwatch(String target) {}
}

class _FailedIps extends _Ips {
  final refreshed = <String>[];

  @override
  RoutedProbeState<String, IpInfo> build() => const RoutedProbeState({
    routedOutbound: ProbeEntry<IpInfo>(phase: ProbePhase.failed),
  });

  @override
  void refresh(Iterable<String> targets) => refreshed.addAll(targets);
}

class _RingIps extends OutboundIpProbe {
  _RingIps(this.entry);

  final ProbeEntry<IpInfo> entry;

  @override
  RoutedProbeState<String, IpInfo> build() =>
      RoutedProbeState({routedOutbound: entry});

  @override
  void watch(String target) {}

  @override
  void unwatch(String target) {}
}

OutboundIpResult _address({int coreEpoch = 1}) => OutboundIpResult(
  url: 'https://www.cloudflare.com/cdn-cgi/trace',
  body: 'ip=$_ip\nloc=GB\n',
  coreEpoch: coreEpoch,
  routeVersion: 1,
);

Widget _card({DashboardDensity density = DashboardDensity.standard}) =>
    HostScaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: density.isDesktop ? 600 : 380,
          height: density.isDesktop ? 208 : null,
          child: DashboardDensityScope(
            density: density,
            scale: 1,
            child: const CurrentOutboundCard(),
          ),
        ),
      ),
    );

Widget _app(
  Future<IpQuality> Function(Ref ref, String ip) quality, {
  DashboardDensity density = DashboardDensity.standard,
  bool root = false,
  SelectionVerdict? selection,
}) {
  return TestApp(
    locale: const Locale('en'),
    overrides: [
      if (selection != null)
        selectionCheckProvider.overrideWithBuild((_, _) => selection),
      profilesProvider.overrideWithValue(const [_profile]),
      suspendProvider.overrideWithValue(false),
      rootAccessProvider.overrideWith((_) async => root),
      outboundIpProbeProvider.overrideWithBuild(
        (_, _) => const RoutedProbeState({
          routedOutbound: ProbeEntry(
            phase: ProbePhase.fresh,
            value: IpInfo(ip: _ip, countryCode: 'GB'),
          ),
        }),
      ),
      ipQualityProvider.overrideWith(quality),
    ],
    child: _card(density: density),
  );
}

Widget _probingApp(
  CoreHandlerInterface core, {
  Future<IpQuality> Function(Ref ref, String ip)? quality,
}) {
  return TestApp(
    locale: const Locale('en'),
    overrides: [
      profilesProvider.overrideWithValue(const [_profile]),
      routeTrackerProvider.overrideWithBuild(
        (ref, _) => RouteState(
          coreEpoch: 1,
          routeVersion: 1,
          hostEpoch: 1,
          proxied: ref.watch(isStartProvider),
          synced: true,
          live: true,
        ),
      ),
      coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
      ipQualityProvider.overrideWith(quality ?? (_, _) async => _residential),
    ],
    child: _card(),
  );
}

void _useTallView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1000, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Finder _clover() => find.ancestor(
  of: find.byType(ShapeBadge),
  matching: find.byWidgetPredicate((widget) => widget is PressRegion),
);

double _cloverTurn(WidgetTester tester) => tester
    .widget<ShapeBadge>(
      find.descendant(of: _clover(), matching: find.byType(ShapeBadge)),
    )
    .rotation;

DashboardChip _chip(WidgetTester tester, String label) =>
    tester.widget<DashboardChip>(
      find.ancestor(of: find.text(label), matching: find.byType(DashboardChip)),
    );

void main() {
  group('OrbitPainter bounds', () {
    const size = Size(244, 244);

    OrbitPainter painter({double? pulse, double? loadingProgress}) =>
        OrbitPainter(
          color: const Color(0xFFFFFFFF),
          primary: const Color(0xFF0000FF),
          idleCore: const Color(0xFF000000),
          idleStroke: const Color(0xFFFFFFFF),
          idleShadow: const Color(0x00000000),
          idlePlate: const Color(0x00000000),
          focused: false,
          running: false,
          pulse: pulse,
          loadingProgress: loadingProgress,
          includePulseOverflow: true,
        );

    test('pulse and loading strokes fit the reserved paint size', () {
      final radius = (size.shortestSide / 2 - 2) / 1.3;
      for (final value in [0.0, 0.15, 0.29]) {
        final recorder = ui.PictureRecorder();
        painter(pulse: value).paint(Canvas(recorder), size);
        recorder.endRecording().dispose();
        final wave = value / 0.3;
        final waveEdge = radius * (1.08 + 0.22 * wave) + 1;
        expect(waveEdge * 2, lessThanOrEqualTo(size.shortestSide));
      }
      final recorder = ui.PictureRecorder();
      painter(loadingProgress: 0.5).paint(Canvas(recorder), size);
      recorder.endRecording().dispose();
      final tickEdge = radius * 0.95 + math.max(1.2, radius * 0.032) / 2;
      expect(tickEdge * 2, lessThanOrEqualTo(size.shortestSide));
    });
  });

  testWidgets('business health ring requires a fresh captured route', (
    tester,
  ) async {
    const stamp = RouteStamp(
      coreEpoch: 1,
      routeVersion: 2,
      hostEpoch: 3,
      proxied: true,
      hits: [RouteHit(host: 'example.com', proxy: 'Proxy', exit: 'Tokyo')],
      chains: ['Tokyo'],
    );

    Future<Color> ringColor({
      required bool running,
      required ProbePhase phase,
      required RouteState route,
      required SelectionVerdict verdict,
    }) async {
      await tester.pumpWidget(
        TestApp(
          locale: const Locale('en'),
          overrides: [
            profilesProvider.overrideWithValue(const [_profile]),
            isStartProvider.overrideWithValue(running),
            runTimeProvider.overrideWithValue(running ? 1 : null),
            suspendProvider.overrideWithValue(false),
            coreStatusProvider.overrideWithValue(
              running && phase == ProbePhase.failed
                  ? CoreStatus.connected
                  : CoreStatus.disconnected,
            ),
            networkSettingProvider.overrideWithBuild(
              (_, _) => const NetworkProps(systemProxy: true),
            ),
            routeTrackerProvider.overrideWithBuild((_, _) => route),
            selectionCheckProvider.overrideWithBuild((_, _) => verdict),
            outboundIpProbeProvider.overrideWith(
              () => _RingIps(
                ProbeEntry(
                  phase: phase,
                  value: phase == ProbePhase.failed
                      ? null
                      : const IpInfo(ip: _ip, countryCode: 'GB'),
                  stamp: phase == ProbePhase.fresh ? stamp : null,
                ),
              ),
            ),
            ipQualityProvider.overrideWith((_, _) async => _residential),
          ],
          child: const BusinessAppearance(
            child: HostScaffold(
              body: DashboardDensityScope(
                density: DashboardDensity.standard,
                scale: 1,
                child: CurrentOutboundCard(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final customPaint = tester.widget<CustomPaint>(
        find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter is OrbitPainter,
        ),
      );
      final color = (customPaint.painter! as OrbitPainter).color;
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      return color;
    }

    const freshRoute = RouteState(
      coreEpoch: 1,
      routeVersion: 2,
      hostEpoch: 3,
      proxied: true,
      synced: true,
      live: true,
    );
    expect(
      await ringColor(
        running: true,
        phase: ProbePhase.fresh,
        route: freshRoute,
        verdict: SelectionVerdict.untouched,
      ),
      BusinessPalette.connected,
    );
    expect(
      await ringColor(
        running: false,
        phase: ProbePhase.fresh,
        route: freshRoute,
        verdict: SelectionVerdict.untouched,
      ),
      const Color(0xFF98A2AD),
    );
    expect(
      await ringColor(
        running: true,
        phase: ProbePhase.fresh,
        route: freshRoute.copyWith(routeVersion: 3),
        verdict: SelectionVerdict.untouched,
      ),
      const Color(0xFF98A2AD),
    );
    expect(
      await ringColor(
        running: true,
        phase: ProbePhase.failed,
        route: freshRoute,
        verdict: SelectionVerdict.untouched,
      ),
      BusinessPalette.warning,
    );
    expect(
      await ringColor(
        running: true,
        phase: ProbePhase.probing,
        route: freshRoute,
        verdict: SelectionVerdict.untouched,
      ),
      BusinessPalette.blue,
    );
    expect(
      await ringColor(
        running: true,
        phase: ProbePhase.probing,
        route: freshRoute,
        verdict: SelectionVerdict.notCaptured,
      ),
      BusinessPalette.warning,
    );
  });

  testWidgets('stopped business desktop hides probe data and keeps selection', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1568, 1024);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      TestApp(
        locale: const Locale('en'),
        overrides: [
          profilesProvider.overrideWithValue(const [_profile]),
          isStartProvider.overrideWithValue(false),
          suspendProvider.overrideWithValue(false),
          coreStatusProvider.overrideWithValue(CoreStatus.disconnected),
          routeTrackerProvider.overrideWithBuild((_, _) => const RouteState()),
          outboundIpProbeProvider.overrideWith(_Ips.new),
          ipQualityProvider.overrideWith((_, _) async => _residential),
          selectionCheckProvider.overrideWithBuild(
            (_, _) => SelectionVerdict.confirming,
          ),
          scenePolicyProvider.overrideWithValue(
            const ScenePolicy(
              available: false,
              current: null,
              suspended: false,
            ),
          ),
          currentGroupsStateProvider.overrideWithValue(
            const GroupsState(
              value: [
                Group(
                  name: 'Lines',
                  type: GroupType.Selector,
                  all: [Proxy(name: 'Tokyo', type: 'anytls')],
                ),
              ],
            ),
          ),
          selectedProxyNameProvider('Lines').overrideWithValue('Tokyo'),
        ],
        child: const BusinessAppearance(
          child: HostScaffold(
            body: DashboardDensityScope(
              density: DashboardDensity.standard,
              scale: 1,
              child: CurrentOutboundCard(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text(_ip), findsNothing);
    expect(find.text('Example Broadband'), findsNothing);
    expect(find.text('GB'), findsNothing);
    expect(find.text('Residential'), findsNothing);
    expect(find.text('Tokyo'), findsOneWidget);
    expect(find.textContaining('Confirming'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact desktop supports 125 percent text', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      TestApp(
        locale: const Locale('en'),
        overrides: [
          profilesProvider.overrideWithValue(const [_profile]),
          isStartProvider.overrideWithValue(true),
          suspendProvider.overrideWithValue(false),
          selectionCheckProvider.overrideWithBuild(
            (_, _) => SelectionVerdict.untouched,
          ),
          outboundIpProbeProvider.overrideWith(_Ips.new),
          ipQualityProvider.overrideWith((_, _) async => _residential),
        ],
        child: const BusinessAppearance(
          child: HostScaffold(
            body: MediaQuery(
              data: MediaQueryData(
                size: Size(1064, 800),
                textScaler: TextScaler.linear(1.25),
              ),
              child: SizedBox(
                width: 996,
                child: DashboardDensityScope(
                  density: DashboardDensity.compact,
                  scale: 1.25,
                  child: CurrentOutboundCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed business desktop retries the default path', (
    tester,
  ) async {
    final probe = _FailedIps();
    tester.view.physicalSize = const Size(1568, 1024);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      TestApp(
        locale: const Locale('en'),
        overrides: [
          profilesProvider.overrideWithValue(const [_profile]),
          isStartProvider.overrideWithValue(true),
          suspendProvider.overrideWithValue(false),
          coreStatusProvider.overrideWithValue(CoreStatus.connected),
          selectionCheckProvider.overrideWithBuild(
            (_, _) => SelectionVerdict.untouched,
          ),
          outboundIpProbeProvider.overrideWith(() => probe),
        ],
        child: const BusinessAppearance(
          child: HostScaffold(
            body: DashboardDensityScope(
              density: DashboardDensity.standard,
              scale: 1,
              child: CurrentOutboundCard(),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 6));
    expect(tester.takeException(), isNull);
    expect(find.text('Connected · Exit check failed'), findsOneWidget);
    expect(find.text('Check failed'), findsOneWidget);
    expect(find.text('Check again'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Check again'), findsOneWidget);
    final orbit = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter is OrbitPainter,
      ),
    );
    expect((orbit.painter! as OrbitPainter).color, BusinessPalette.warning);
    await tester.tap(find.widgetWithText(TextButton, 'Check again'));
    expect(probe.refreshed, [routedOutbound]);
  });

  testWidgets(
    'selection errors fit the existing desktop and mobile exit cards',
    (tester) async {
      for (final density in [
        DashboardDensity.standard,
        DashboardDensity.mobile,
      ]) {
        await tester.pumpWidget(
          _app(
            (_, _) async => _residential,
            density: density,
            selection: SelectionVerdict.notCaptured,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.textContaining('Traffic is not captured'), findsOneWidget);
      }
    },
  );

  setUp(() {
    mitmFeature = true;
    addTearDown(() => mitmFeature = false);
  });

  setUpAll(() => registerFallbackValue(const OutboundIpParams(timeout: 0)));

  group('root access', () {
    testWidgets('fades in a border and names it only to a screen reader', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(_app((_, _) async => _residential, root: true));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      final midway = tester.widget<DashboardCard>(find.byType(DashboardCard));
      expect(midway.side.color.a, inExclusiveRange(0, 1));

      await tester.pump(commonDuration);

      final card = tester.widget<DashboardCard>(find.byType(DashboardCard));
      expect(card.side.color.a, closeTo(1, 0.01));
      expect(find.text('Root'), findsNothing);
      expect(find.bySemanticsLabel(RegExp('Status Root')), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('leaves the card plain without it', (tester) async {
      await tester.pumpWidget(_app((_, _) async => _residential));
      await tester.pump(commonDuration);

      final card = tester.widget<DashboardCard>(find.byType(DashboardCard));
      expect(card.side, BorderSide.none);
    });
  });

  group('the exit address', () {
    testWidgets('shows with its country, type, quality and organization', (
      tester,
    ) async {
      await tester.pumpWidget(_app((_, _) async => _residential));
      await tester.pump();

      expect(find.text(_ip), findsOneWidget);
      expect(find.text('GB'), findsOneWidget);
      expect(find.text('Residential'), findsWidgets);
      expect(_chip(tester, 'Quality Good').tone, DashboardChipTone.ok);
      expect(find.text('Example Broadband'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
      expect(find.byGlyph(AppGlyphs.refresh), findsNothing);
    });

    testWidgets('a little wider than its card shrinks to fit', (tester) async {
      await tester.pumpWidget(_app((_, _) async => _residential));
      await tester.pump();

      expect(tester.widget<Text>(find.text(_ip)).overflow, isNull);
      expect(
        find.ancestor(of: find.text(_ip), matching: find.byType(FittedBox)),
        findsOneWidget,
      );
    });

    testWidgets('a risky one shows its quality in the warning tone', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app((_, _) async => _residential.copyWith(isTor: true)),
      );
      await tester.pump();

      expect(_chip(tester, 'Quality Risky').tone, DashboardChipTone.warn);
    });

    testWidgets('says its type is unknown when no type was found', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app((_, _) async => throw const IpQualityLookupException([])),
      );
      await tester.pump();

      expect(find.text('GB'), findsOneWidget);
      expect(find.text('Not running'), findsOneWidget);
      expect(_chip(tester, 'Unknown type').tone, DashboardChipTone.idle);
      expect(find.byType(DashboardChip), findsNWidgets(2));
      expect(find.text('Example Broadband'), findsNothing);
    });

    testWidgets('holds the place of its quality while it loads', (
      tester,
    ) async {
      final quality = Completer<IpQuality>();
      await tester.pumpWidget(
        TestApp(
          locale: const Locale('en'),
          overrides: [
            profilesProvider.overrideWithValue(const [_profile]),
            suspendProvider.overrideWithValue(false),
            outboundIpProbeProvider.overrideWith(_Ips.new),
            ipQualityProvider.overrideWith((_, _) => quality.future),
          ],
          child: _card(),
        ),
      );
      await tester.pump();

      expect(find.byType(SkeletonPill), findsNWidgets(3));
      expect(find.byType(SkeletonText), findsOneWidget);
      expect(tester.widget<PressRegion>(_clover()).onTap, isNull);
      final turn = _cloverTurn(tester);
      await tester.pump(const Duration(milliseconds: 300));
      expect(_cloverTurn(tester), isNot(turn));

      quality.complete(_residential);
      await tester.pumpAndSettle();

      expect(find.byType(SkeletonPill), findsNothing);
      expect(find.text('Residential'), findsOneWidget);
      expect(_cloverTurn(tester) % (math.pi / 2), closeTo(0, 1e-9));
      expect(tester.widget<PressRegion>(_clover()).onTap, isNotNull);
    });

    testWidgets('checks a failed quality again from its clover', (
      tester,
    ) async {
      final core = _MockCore();
      when(() => core.outboundIp(any())).thenAnswer((_) async => _address());
      var calls = 0;
      await tester.pumpWidget(
        _probingApp(
          core,
          quality: (_, _) async {
            calls++;
            throw const IpQualityLookupException([]);
          },
        ),
      );
      await tester.pump();
      await tester.pump(commonDuration);
      expect(find.text('Unknown type'), findsOneWidget);

      await tester.tap(find.byTooltip('Retry'));
      await tester.pumpAndSettle();

      expect(calls, 2);
      verify(() => core.outboundIp(any())).called(2);
    });

    testWidgets('names its network by ASN when the organization is unknown', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app((_, _) async => _residential.copyWith(organization: null)),
      );
      await tester.pump();

      expect(find.text('AS64500'), findsOneWidget);
    });

    testWidgets('fits a phone', (tester) async {
      await tester.pumpWidget(
        _app((_, _) async => _residential, density: DashboardDensity.mobile),
      );
      await tester.pump();

      expect(find.text(_ip), findsOneWidget);
      expect(find.text('Residential'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('opens its details from the address, not the card', (
      tester,
    ) async {
      _useTallView(tester);
      await tester.pumpWidget(_app((_, _) async => _residential));
      await tester.pump();

      await tester.tap(find.text('Example Broadband'));
      await tester.pumpAndSettle();
      expect(find.text('iplocate.io'), findsNothing);

      await tester.tap(find.text(_ip));
      await tester.pumpAndSettle();

      expect(find.text('Good'), findsOneWidget);
      expect(find.text('Residential'), findsNWidgets(2));
      final organization = tester.widget<RichText>(
        find.descendant(
          of: find.text('Example Broadband').last,
          matching: find.byType(RichText),
        ),
      );
      expect(organization.textAlign, TextAlign.end);
      expect(find.text('AS64500'), findsOneWidget);
      expect(find.text('iplocate.io'), findsOneWidget);
    });

    testWidgets('lists every source when none found a type and checks again', (
      tester,
    ) async {
      _useTallView(tester);
      var calls = 0;
      await tester.pumpWidget(
        _app((_, _) async {
          calls++;
          throw const IpQualityLookupException([
            (
              source: IpQualitySource.identMe,
              status: IpQualitySourceStatus.ipMismatch,
            ),
            (
              source: IpQualitySource.ipLocate,
              status: IpQualitySourceStatus.rateLimited,
            ),
          ]);
        }),
      );
      await tester.pump();

      await tester.tap(find.byTooltip('Outbound IP details'));
      await tester.pumpAndSettle();

      expect(find.text("Couldn't determine the IP type"), findsOneWidget);
      expect(find.text('Different outbound IP'), findsOneWidget);
      expect(find.text('Rate limited'), findsOneWidget);

      await tester.tap(find.byTooltip('Check again'));
      await tester.pumpAndSettle();

      expect(calls, 2);
    });

    testWidgets('is masked everywhere once hidden', (tester) async {
      _useTallView(tester);
      await tester.pumpWidget(_app((_, _) async => _residential));
      await tester.pump();

      await tester.tap(find.byTooltip('Outbound IP details'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Hide IP'),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hide IP'));
      await tester.pumpAndSettle();

      expect(find.text(_ip), findsNothing);
      expect(find.text('*****'), findsNWidgets(2));
      final container = ProviderScope.containerOf(
        tester.element(find.byType(CurrentOutboundCard)),
      );
      expect(container.read(appSettingProvider).hideIp, isTrue);
    });

    ProviderContainer containerOf(WidgetTester tester) =>
        ProviderScope.containerOf(
          tester.element(find.byType(CurrentOutboundCard)),
        );

    void start(WidgetTester tester) {
      containerOf(tester).read(runTimeProvider.notifier).value = 1;
    }

    ProbePhase phaseOf(WidgetTester tester) => containerOf(
      tester,
    ).read(outboundIpProbeProvider).entryOf(routedOutbound).phase;

    testWidgets('that fails as the proxy starts shows as checking', (
      tester,
    ) async {
      final core = _MockCore();
      var epoch = 1;
      when(() => core.outboundIp(any())).thenAnswer((invocation) async {
        final params =
            invocation.positionalArguments.single as OutboundIpParams;
        final failing = params.proxyName != directOutbound && epoch == 1;
        if (failing) {
          throw TimeoutException('no answer');
        }
        return _address(coreEpoch: epoch);
      });
      await tester.pumpWidget(_probingApp(core));
      await tester.pump();
      await tester.pump(commonDuration);
      expect(find.text(_ip), findsOneWidget);

      start(tester);
      await tester.pump();
      await tester.pump(probeSettleDuration);
      expect(phaseOf(tester), ProbePhase.failed);
      expect(find.text('Check failed'), findsNothing);
      expect(find.byType(SkeletonText), findsNWidgets(2));

      epoch = 2;
      containerOf(tester)
          .read(routeTrackerProvider.notifier)
          .applySnapshot(const RouteSnapshot(coreEpoch: 2, routeVersion: 1));
      await tester.pump(probeSettleDuration);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text(_ip), findsOneWidget);
      expect(find.byType(SkeletonText), findsNothing);
    });

    testWidgets('that fails past the start is shown, then checked again', (
      tester,
    ) async {
      final core = _MockCore();
      final asked = <String>[];
      when(() => core.outboundIp(any())).thenAnswer((invocation) async {
        final params =
            invocation.positionalArguments.single as OutboundIpParams;
        asked.add(params.proxyName);
        if (params.proxyName != directOutbound) {
          throw TimeoutException('no answer');
        }
        return _address();
      });
      await tester.pumpWidget(_probingApp(core));
      await tester.pump();
      await tester.pump(commonDuration);

      start(tester);
      await tester.pump();
      await tester.pump(probeSettleDuration);
      await tester.tap(find.byTooltip('Retry'));
      await tester.pump();
      expect(phaseOf(tester), ProbePhase.failed);
      expect(find.text('Check failed'), findsNothing);
      expect(asked, [directOutbound, routedOutbound]);

      await tester.pump(const Duration(seconds: 5));
      expect(find.text('Check failed'), findsOneWidget);
      expect(find.text('Tap the icon to retry'), findsOneWidget);
      await tester.tap(find.byTooltip('Retry'));
      await tester.pump();
      expect(asked, [directOutbound, routedOutbound, routedOutbound]);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.text('Check failed'), findsOneWidget);
      expect(find.byType(SkeletonText), findsNothing);
    });
  });

  testWidgets('shows a fresh IP while TUN is unauthorized', (tester) async {
    await tester.pumpWidget(
      TestApp(
        locale: const Locale('en'),
        overrides: [
          profilesProvider.overrideWithValue(const [_profile]),
          runTimeProvider.overrideWithBuild((_, _) => 42),
          coreStatusProvider.overrideWithValue(CoreStatus.connected),
          suspendProvider.overrideWithValue(false),
          patchClashConfigProvider.overrideWithBuild(
            (_, _) => const PatchClashConfig(tun: Tun(enable: true)),
          ),
          authorizedTunEnableProvider.overrideWithBuild(
            (_, _) => TunAuthorizationState.none,
          ),
          outboundIpProbeProvider.overrideWith(
            () => _RingIps(
              const ProbeEntry(
                phase: ProbePhase.fresh,
                value: IpInfo(ip: _ip, countryCode: 'GB'),
              ),
            ),
          ),
          ipQualityProvider.overrideWith((_, _) async => _residential),
        ],
        child: const BusinessAppearance(
          child: HostScaffold(
            body: DashboardDensityScope(
              density: DashboardDensity.standard,
              scale: 1,
              child: CurrentOutboundCard(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text(_ip), findsOneWidget);
    expect(find.text('GB'), findsOneWidget);
    expect(find.text('Example Broadband'), findsOneWidget);
    expect(find.byType(SkeletonText), findsNothing);
    expect(find.byType(SkeletonPill), findsNothing);
  });

  group('the start button', () {
    late ProviderContainer container;

    ProviderContainer containerWith({
      List<Profile> profiles = const [_profile],
      bool suspended = false,
    }) => ProviderContainer(
      overrides: [
        initProvider.overrideWithBuild((_, _) => true),
        profilesProvider.overrideWithValue(profiles),
        outboundIpProbeProvider.overrideWith(_Ips.new),
        ipQualityProvider.overrideWith((_, _) async => _residential),
        setupActionProvider.overrideWith(_RecordingSetupAction.new),
        suspendProvider.overrideWithValue(suspended),
      ],
    );

    tearDown(() => container.dispose());

    Future<void> pumpCard(
      WidgetTester tester, {
      DashboardDensity? density,
      bool glass = false,
      bool business = false,
      TargetPlatform? targetPlatform,
    }) async {
      globalState.container = container;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            theme: targetPlatform == null
                ? null
                : ThemeData(platform: targetPlatform),
            child: LiquidGlassScope(
              enabled: glass,
              child: business
                  ? BusinessAppearance(
                      child: HostScaffold(
                        body: SingleChildScrollView(
                          child: SizedBox(
                            height: density?.isDesktop == true ? 236 : null,
                            child: DashboardDensityScope(
                              density: density ?? DashboardDensity.mobile,
                              scale: density?.isDesktop == true ? 1 : 1.6,
                              child: const CurrentOutboundCard(),
                            ),
                          ),
                        ),
                      ),
                    )
                  : _card(density: density ?? DashboardDensity.standard),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('live dashboard values keep the hero card rect fixed', (
      tester,
    ) async {
      for (final (viewport, density, platform) in [
        (const Size(390, 900), DashboardDensity.mobile, TargetPlatform.android),
        (
          const Size(1280, 900),
          DashboardDensity.standard,
          TargetPlatform.windows,
        ),
        (
          const Size(1280, 900),
          DashboardDensity.standard,
          TargetPlatform.macOS,
        ),
      ]) {
        tester.view.physicalSize = viewport;
        tester.view.devicePixelRatio = 1;
        container = containerWith();
        await pumpCard(
          tester,
          business: true,
          density: density,
          targetPlatform: platform,
        );

        Rect cardRect() {
          final box = tester.renderObject<RenderBox>(
            find
                .descendant(
                  of: find.byType(CurrentOutboundCard),
                  matching: find.byType(DashboardCard),
                )
                .first,
          );
          return box.localToGlobal(Offset.zero) & box.size;
        }

        final initial = cardRect();
        final probe = container.read(outboundIpProbeProvider.notifier);
        final traffic = container.read(trafficsProvider.notifier);
        final runtime = container.read(runTimeProvider.notifier);
        runtime.value = 1;
        traffic.addTraffic(const Traffic(up: 1, down: 1));
        await tester.pump();
        expect(cardRect(), initial);

        runtime.value = 445567000;
        traffic.addTraffic(const Traffic(up: 999900000, down: 999900000));
        probe.state = const RoutedProbeState({
          routedOutbound: ProbeEntry(
            phase: ProbePhase.fresh,
            value: IpInfo(ip: '255.255.255.255', countryCode: 'US'),
          ),
        });
        await tester.pump();
        expect(cardRect(), initial);

        for (final status in [
          CoreStatus.connecting,
          CoreStatus.connected,
          CoreStatus.disconnected,
        ]) {
          container.read(coreStatusProvider.notifier).value = status;
          await tester.pump();
          expect(cardRect(), initial);
        }
        probe.state = const RoutedProbeState({
          routedOutbound: ProbeEntry(phase: ProbePhase.failed),
        });
        await tester.pump();
        expect(cardRect(), initial);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      }
      container = containerWith();
      addTearDown(tester.view.reset);
    });

    Finder startButton() =>
        find.byWidgetPredicate((widget) => widget is PressRegion).last;

    testWidgets('dispatches each toggle through the shared running state', (
      tester,
    ) async {
      container = containerWith();
      container.read(runTimeProvider.notifier).value = 1;
      await pumpCard(tester);
      final action =
          container.read(setupActionProvider.notifier) as _RecordingSetupAction;

      await tester.tap(startButton());
      expect(action.requests, [false]);
      expect(container.read(isStartProvider), isFalse);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Start'), findsOneWidget);

      await tester.tap(startButton());
      expect(action.requests, [false, true]);
      expect(container.read(isStartProvider), isTrue);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Stop'), findsOneWidget);
    });

    testWidgets('the orbit preserves stop/start and reflects running state', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      container = containerWith();
      container.read(runTimeProvider.notifier).value = 1;
      await pumpCard(tester, business: true);
      OrbitPainter painter() => tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((widget) => widget.painter)
          .whereType<OrbitPainter>()
          .single;
      expect(painter().color, const Color(0xFF98A2AD));
      expect(tester.widget<Text>(find.text(_ip)).maxLines, 1);
      expect(find.text('Residential'), findsOneWidget);
      final action =
          container.read(setupActionProvider.notifier) as _RecordingSetupAction;
      await tester.tap(find.byTooltip('Connected · Click to disconnect'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(painter().color, isNot(BusinessPalette.accent));
      expect(painter().color, isNot(BusinessPalette.blue));
      await tester.pump(const Duration(milliseconds: 500));
      expect(action.requests, [false]);
      expect(painter().color, const Color(0xFF98A2AD));
      expect(painter().pulse, isNull);
      await tester.tap(find.byTooltip('Start'));
      await tester.pumpAndSettle();
      expect(action.requests, [false, true]);
      expect(painter().color, const Color(0xFF98A2AD));
      expect(tester.takeException(), isNull);
    });

    testWidgets('the orbit paint bounds stay inside the hero card', (
      tester,
    ) async {
      for (final (viewport, density) in [
        (const Size(360, 900), DashboardDensity.mobile),
        (const Size(800, 900), DashboardDensity.compact),
        (const Size(1280, 900), DashboardDensity.standard),
      ]) {
        tester.view.physicalSize = viewport;
        tester.view.devicePixelRatio = 1;
        container = containerWith();
        await pumpCard(tester, business: true, density: density);
        final card = tester.renderObject<RenderBox>(
          find
              .descendant(
                of: find.byType(CurrentOutboundCard),
                matching: find.byType(DashboardCard),
              )
              .first,
        );
        final button = tester.renderObject<RenderBox>(startButton());
        final cardBounds =
            card.localToGlobal(card.paintBounds.topLeft) &
            card.paintBounds.size;
        final buttonBounds =
            button.localToGlobal(button.paintBounds.topLeft) &
            button.paintBounds.size;
        expect(cardBounds.contains(buttonBounds.topLeft), isTrue);
        expect(cardBounds.contains(buttonBounds.bottomRight), isTrue);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      }
      container = containerWith();
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    testWidgets('mobile business shows the expanded IP and live metrics', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      container = containerWith();
      container.read(runTimeProvider.notifier).value = 7200000;
      await pumpCard(tester, business: true);
      final strings = tester
          .element(find.byType(CurrentOutboundCard))
          .appLocalizations;
      expect(find.text(_ip), findsOneWidget);
      expect(find.text(strings.delay), findsOneWidget);
      expect(find.text(strings.download), findsOneWidget);
      expect(find.text(strings.upload), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('mobile business respects the hidden IP setting', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      container = containerWith();
      container.read(runTimeProvider.notifier).value = 1;
      container
          .read(appSettingProvider.notifier)
          .update((state) => state.copyWith(hideIp: true));
      await pumpCard(tester, business: true);

      expect(find.text(_ip), findsNothing);
      expect(find.text('*****'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets('mobile business IP opens quality details', (tester) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      container = containerWith();
      container.read(runTimeProvider.notifier).value = 1;
      await pumpCard(tester, business: true);

      await tester.tap(find.text(_ip));
      await tester.pumpAndSettle();
      expect(find.text('Residential'), findsWidgets);
      Navigator.of(tester.element(find.text('Residential').last)).pop();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('a suspended tunnel swaps in the Wi-Fi off glyph and says so', (
      tester,
    ) async {
      container = containerWith(suspended: true);
      container.read(runTimeProvider.notifier).value = 1;
      await pumpCard(tester);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(CurrentOutboundCard));
      expect(
        find.byTooltip(context.appLocalizations.suspended),
        findsOneWidget,
      );
      expect(find.text(context.appLocalizations.suspended), findsOneWidget);
      expect(find.byGlyph(AppGlyphs.wifiOff), findsOneWidget);
    });

    testWidgets('swells under a press and on glass bends within its shape', (
      tester,
    ) async {
      container = containerWith();
      container.read(runTimeProvider.notifier).value = 1;
      await pumpCard(tester, glass: true);
      await tester.pumpAndSettle();
      final glass = tester.widget<LiquidGlass>(
        find.descendant(of: startButton(), matching: find.byType(LiquidGlass)),
      );
      expect(glass.clipper, isNotNull);

      final press = find.descendant(
        of: startButton(),
        matching: find.byType(ElasticPress),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(startButton()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.renderObject(press).debugLayer, isA<TransformLayer>());
      await gesture.cancel();
      await tester.pumpAndSettle();
    });

    testWidgets('is off without a profile', (tester) async {
      container = containerWith(profiles: const []);
      await pumpCard(tester, density: DashboardDensity.mobile);

      final toggle = tester.widget<PressRegion>(startButton());
      expect(toggle.onTap, isNull);
      expect(tester.takeException(), isNull);
    });
  });
}
