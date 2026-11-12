import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/common/app_localizations.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/app_ports.dart';
import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/common/l10n_labels.dart';
import 'package:fl_clash/common/tray.dart';
import 'package:fl_clash/common/service_probe.dart' show routedOutbound;
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tray/tray.dart';

import '../helpers/app_paths.dart';

const _channel = MethodChannel('tray');
final _menuReports = <String>[];

const _proxyGroup = Group(
  name: 'Proxy',
  type: GroupType.Selector,
  all: [
    Proxy(name: 'A', type: 'Direct'),
    Proxy(name: 'B', type: 'Direct'),
    Proxy(name: 'C', type: 'Direct'),
  ],
);

HotKeyAction _bind(HotAction action, PhysicalKeyboardKey key) {
  return HotKeyAction(
    action: action,
    key: key.usbHidUsage,
    modifiers: const {KeyboardModifier.control, KeyboardModifier.shift},
  );
}

TrayState _trayState({
  bool isStart = false,
  bool tunEnable = false,
  bool systemProxy = false,
  bool autoLaunch = false,
  bool showTrayTitle = false,
  bool monochromeTrayIcon = true,
  bool safeMode = false,
  Mode mode = Mode.rule,
  List<Group> groups = const [],
  Map<HotAction, HotKeyAction> hotKeys = const {},
}) {
  return TrayState(
    mode: mode,
    port: 7890,
    autoLaunch: autoLaunch,
    systemProxy: systemProxy,
    tunEnable: tunEnable,
    isStart: isStart,
    groups: groups,
    selectedMap: const {},
    showTrayTitle: showTrayTitle,
    monochromeTrayIcon: monochromeTrayIcon,
    safeMode: safeMode,
    hotKeys: hotKeys,
  );
}

List<Map<Object?, Object?>> _items(MethodCall? call) {
  final menu = (call?.arguments as Map?)?['menu'] as List?;
  return menu?.cast<Map<Object?, Object?>>() ?? const [];
}

Map<Object?, Object?> _item(MethodCall? call, String label) {
  return _items(call).firstWhere((item) => item['label'] == label);
}

List<String> _labels(MethodCall? call) {
  return _items(call).map((item) => item['label']).whereType<String>().toList();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> calls;
  late ProviderContainer container;
  late AppTray tray;

  late Directory root;

  setUpAll(() async {
    root = Directory.systemTemp.createTempSync('tray_menu_test');
    await useAppPaths(root);
    await AppLocalizations.load(const Locale('en'));
  });

  tearDownAll(() {
    final reportPath = Platform.environment['TRAY_MENU_REPORT'];
    if (reportPath != null) {
      File(reportPath).writeAsStringSync(_menuReports.join('\n\n'));
    }
    // The shared system temp dir is not exclusively ours; another suite running
    // alongside this one can take the tree out from under the teardown, either
    // before the check or between the check and the delete.
    try {
      if (root.existsSync()) {
        root.deleteSync(recursive: true);
      }
    } on FileSystemException {
      return;
    }
  });

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    calls = [];
    tray = AppTray.forPlatform(isMacOS: true, isWindows: false);
    container = ProviderContainer();
    Tray.instance.resetForTesting();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call);
          return true;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
    container.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  MethodCall? showCall() {
    for (final call in calls.reversed) {
      if (call.method == 'show') {
        return call;
      }
    }
    return null;
  }

  String menuReport(String platform, MethodCall? call) {
    final buffer = StringBuffer('$platform\n');
    void writeItems(List<Map<Object?, Object?>> items, int depth) {
      for (final item in items) {
        final type = item['type'];
        if (type == 'separator') {
          buffer.writeln('${'  ' * depth}—');
          continue;
        }
        buffer.write('${'  ' * depth}${item['label']}');
        for (final field in ['detail', 'checked', 'enabled']) {
          if (item.containsKey(field)) buffer.write(' | $field=${item[field]}');
        }
        buffer.writeln();
        if (type == 'submenu') {
          writeItems(
            (item['items'] as List).cast<Map<Object?, Object?>>(),
            depth + 1,
          );
        }
      }
    }

    writeItems(_items(call), 0);
    return buffer.toString().trimRight();
  }

  Future<List<Group>> useBusinessFixture({required bool connected}) async {
    container.dispose();
    const profile = Profile(
      id: 1,
      type: ProfileType.url,
      label: '天机云',
      url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
      autoUpdateDuration: Duration(days: 1),
    );
    const groups = [
      Group(
        name: 'Proxy',
        type: GroupType.Selector,
        hidden: false,
        all: [
          Proxy(name: 'JP · 东京家宽 · 04', type: 'ss'),
          Proxy(name: 'HK · 香港 · 家宽', type: 'ss'),
          Proxy(name: 'US · 洛杉矶住宅 02', type: 'ss'),
        ],
      ),
    ];
    final catalog = connected ? groups : const <Group>[];
    const route = 'JP · 东京家宽 · 04';
    container = ProviderContainer(
      overrides: [
        tianjiApiEnabledProvider.overrideWithValue(false),
        currentProfileProvider.overrideWithValue(profile),
        coreStatusProvider.overrideWithValue(
          connected ? CoreStatus.connected : CoreStatus.disconnected,
        ),
        groupsProvider.overrideWithValue(catalog),
        currentGroupsStateProvider.overrideWithValue(
          GroupsState(value: catalog),
        ),
        selectedProxyNameProvider('Proxy').overrideWithValue(route),
        residentialPolicyProvider.overrideWithValue(
          ResidentialPolicy(
            profileId: profile.id,
            fingerprint: null,
            configuredExit: null,
            selectedExit: null,
            active: false,
            rootAvailable: false,
            choices: const [],
            catalogReady: connected,
          ),
        ),
        scenePolicyProvider.overrideWithValue(
          const ScenePolicy(
            available: true,
            current: SceneKind.daily,
            suspended: false,
          ),
        ),
        delaysAtLastTestBatchProvider.overrideWithValue({
          'https://delay.test': {route: 37},
        }),
        realTestUrlProvider().overrideWithValue('https://delay.test'),
        outboundIpProbeProvider.overrideWithValue(
          RoutedProbeState<String, IpInfo>(
            connected
                ? {
                    routedOutbound: const ProbeEntry(
                      phase: ProbePhase.fresh,
                      value: IpInfo(ip: '203.0.113.42', countryCode: 'JP'),
                    ),
                  }
                : const {},
          ),
        ),
      ],
    );
    if (connected) {
      container
          .read(trafficsProvider.notifier)
          .addTraffic(const Traffic(down: 2.4 * 1024 * 1024, up: 312 * 1024));
    }
    return catalog;
  }

  Future<void> update(TrayState trayState, {AppTray? on}) {
    return (on ?? tray).update(
      trayState: trayState,
      traffic: const Traffic(),
      read: container.read,
    );
  }

  test(
    'SystemAction.updateTray builds the menu without reading itself',
    () async {
      globalState.container = container;
      trayPort = tray;
      addTearDown(() => trayPort = null);

      await container.read(systemActionProvider.notifier).updateTray();

      expect(showCall(), isNotNull);
      expect(_labels(showCall()), contains(currentAppLocalizations.exit));
    },
  );

  test('builds the stopped menu without the running-only toggles', () async {
    await update(_trayState());

    final labels = _labels(showCall());
    final l10n = currentAppLocalizations;
    expect(labels, contains(l10n.show));
    expect(labels, contains(l10n.start));
    expect(labels, contains(l10n.autoLaunch));
    expect(labels, contains(l10n.copyEnvVar));
    expect(labels, contains(l10n.exit));
    expect(labels, isNot(contains(l10n.tun)));
    expect(labels, isNot(contains(l10n.systemProxy)));
  });

  test('uses the Tianji macOS menu hierarchy for business profiles', () async {
    container.dispose();
    container = ProviderContainer(
      overrides: [
        currentProfileProvider.overrideWithValue(
          const Profile(
            id: 1,
            type: ProfileType.url,
            label: 'Tianji',
            url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
            autoUpdateDuration: Duration(days: 1),
          ),
        ),
      ],
    );
    await update(_trayState(isStart: true));

    final labels = _labels(showCall());
    expect(labels.first, currentAppLocalizations.trayNotConnected);
    expect(labels, contains(currentAppLocalizations.scene));
    expect(labels, contains(currentAppLocalizations.outboundMode));
    expect(labels, contains(currentAppLocalizations.diagnosticsTitle));
    expect(labels, contains(currentAppLocalizations.trayPreferences));
    expect(labels, isNot(contains(currentAppLocalizations.autoLaunch)));
    expect(labels.last, currentAppLocalizations.exit);
  });

  test('adds TUN and system proxy toggles once the core is running', () async {
    await update(_trayState(isStart: true));

    final labels = _labels(showCall());
    final l10n = currentAppLocalizations;
    expect(labels, contains(l10n.stop), reason: 'start flips to stop');
    expect(labels, contains(l10n.tun));
    expect(labels, contains(l10n.systemProxy));
  });

  group('safe mode', () {
    test('keeps the full menu', () async {
      await update(_trayState(isStart: true, safeMode: true));

      final labels = _labels(showCall());
      final l10n = currentAppLocalizations;
      expect(labels, contains(l10n.stop));
      expect(labels, contains(l10n.tun));
      expect(labels, contains(l10n.systemProxy));
      expect(labels, contains(l10n.copyEnvVar));
    });

    test('names the mode in the tooltip and ships the safe icon', () async {
      await update(_trayState(isStart: true, safeMode: true));

      final arguments = showCall()!.arguments as Map;
      final l10n = currentAppLocalizations;
      expect(arguments['toolTip'], '$appName (${l10n.safeMode})');
      final reps = ((arguments['icon'] as Map)['reps'] as List).cast<Map>();
      final base = reps.firstWhere((rep) => rep['scale'] == 1.0);
      expect(
        base['bytes'],
        base64Encode(
          File('assets/images/tray/macos/status_4.png').readAsBytesSync(),
        ),
      );
    });
  });

  test('offers every outbound mode as a menu entry', () async {
    await update(_trayState(mode: Mode.global));

    final checkedModes = _items(showCall())
        .where((item) => item['checked'] == true)
        .map((item) => item['label'])
        .toList();
    expect(checkedModes, contains(Intl.message(Mode.global.name)));
  });

  test('sends icon, tooltip and menu in a single show call', () async {
    await update(_trayState(isStart: true, tunEnable: true));

    final showCalls = calls.where((call) => call.method == 'show').toList();
    expect(showCalls, hasLength(1));

    final arguments = showCalls.single.arguments as Map;
    expect(arguments['toolTip'], appName);
    expect(arguments['menu'], isNotEmpty);
    final reps = ((arguments['icon'] as Map)['reps'] as List).cast<Map>();
    expect(reps.map((rep) => rep['scale']), containsAll([1.0, 2.0, 3.0, 4.0]));
    expect(reps.map((rep) => rep['bytes']), everyElement(isNotEmpty));
    expect((arguments['icon'] as Map)['isTemplate'], isTrue);
  });

  test('ships the color status icon once monochrome is off', () async {
    await update(
      _trayState(isStart: true, tunEnable: true, monochromeTrayIcon: false),
    );

    final arguments = showCall()!.arguments as Map;
    expect((arguments['icon'] as Map)['isTemplate'], isFalse);
    final reps = ((arguments['icon'] as Map)['reps'] as List).cast<Map>();
    final base = reps.firstWhere((rep) => rep['scale'] == 1.0);
    expect(
      base['bytes'],
      base64Encode(
        File('assets/images/tray/macos/color/status_3.png').readAsBytesSync(),
      ),
    );
    expect(
      _item(showCall(), currentAppLocalizations.monochromeIcon)['checked'],
      isFalse,
    );
  });

  test('skips the platform call when the tray state is unchanged', () async {
    await update(_trayState(isStart: true));
    await update(_trayState(isStart: true));

    expect(calls.where((call) => call.method == 'show'), hasLength(1));
  });

  test('menu item ids are stable across identical rebuilds', () async {
    await update(_trayState());
    final first = _items(showCall()).map((item) => item['id']).toList();

    Tray.instance.resetForTesting();
    calls.clear();

    await update(_trayState());
    final second = _items(showCall()).map((item) => item['id']).toList();

    expect(second, first);
    expect(first.first, 1024);
  });

  test('group submenus carry their proxies as nested items', () async {
    await update(
      _trayState(
        groups: [
          const Group(
            name: 'Proxy',
            type: GroupType.Selector,
            all: [Proxy(name: 'A', type: 'Direct')],
          ),
        ],
      ),
    );

    final submenu = _items(
      showCall(),
    ).firstWhere((item) => item['type'] == 'submenu');
    expect(submenu['label'], 'Proxy');
    final children = (submenu['items'] as List).cast<Map<Object?, Object?>>();
    expect(children.map((item) => item['label']), contains('A'));
  });

  test('shows each bound hotkey dimmed beside its entry', () async {
    await update(
      _trayState(
        isStart: true,
        hotKeys: {
          HotAction.view: _bind(HotAction.view, PhysicalKeyboardKey.keyV),
          HotAction.globalMode: _bind(
            HotAction.globalMode,
            PhysicalKeyboardKey.keyG,
          ),
          HotAction.tun: _bind(HotAction.tun, PhysicalKeyboardKey.keyT),
        },
      ),
    );

    final l10n = currentAppLocalizations;
    final call = showCall();
    expect(_item(call, l10n.show)['detail'], '⌃⇧V');
    expect(_item(call, Mode.global.label)['detail'], '⌃⇧G');
    expect(_item(call, l10n.tun)['detail'], '⌃⇧T');
    expect(_item(call, l10n.exit), isNot(contains('detail')));
    expect(_item(call, Mode.rule.label), isNot(contains('detail')));
  });

  test(
    'group submenus show the delay of the selection and of each proxy',
    () async {
      container.dispose();
      container = ProviderContainer(
        overrides: [
          selectedProxyNameProvider('Proxy').overrideWithValue('A'),
          trayDelaysProvider.overrideWithValue({
            'Proxy': {'A': 120, 'B': -1, 'C': -2},
          }),
        ],
      );
      const group = Group(
        name: 'Proxy',
        type: GroupType.Selector,
        all: [
          Proxy(name: 'A', type: 'Direct'),
          Proxy(name: 'B', type: 'Direct'),
          Proxy(name: 'C', type: 'Direct'),
          Proxy(name: 'D', type: 'Direct'),
        ],
      );
      await update(_trayState(groups: [group]));

      final submenu = _item(showCall(), 'Proxy');
      expect(submenu['detail'], '120');
      final children = (submenu['items'] as List).cast<Map<Object?, Object?>>();
      expect(children.map((item) => item['detail']), [
        '120',
        currentAppLocalizations.timeout,
        currentAppLocalizations.delayFailed,
        null,
      ]);
    },
  );

  test('a delay test entry follows the groups', () async {
    await update(
      _trayState(
        groups: [_proxyGroup],
        hotKeys: {
          HotAction.delayTest: _bind(
            HotAction.delayTest,
            PhysicalKeyboardKey.keyD,
          ),
        },
      ),
    );

    final items = _items(showCall());
    final index = items.indexWhere((item) => item['type'] == 'submenu');
    expect(items[index + 1]['label'], HotAction.delayTest.label);
    expect(items[index + 1]['detail'], '⌃⇧D');
  });

  group('a platform that is not macOS', () {
    late AppTray windows;

    setUp(() {
      windows = AppTray.forPlatform(isMacOS: false, isWindows: true);
    });

    test('gets a plain icon, no group submenus and no speed toggle', () async {
      await update(
        _trayState(
          isStart: true,
          groups: [
            const Group(
              name: 'Proxy',
              type: GroupType.Selector,
              all: [Proxy(name: 'A', type: 'Direct')],
            ),
          ],
        ),
        on: windows,
      );

      final arguments = showCall()!.arguments as Map;
      expect((arguments['icon'] as Map)['isTemplate'], isFalse);
      expect(
        _items(showCall()).where((item) => item['type'] == 'submenu'),
        isEmpty,
      );
      expect(
        _labels(showCall()),
        isNot(contains(currentAppLocalizations.speedStatistics)),
      );
      expect(
        _labels(showCall()),
        isNot(contains(currentAppLocalizations.monochromeIcon)),
      );
      expect(_labels(showCall()), isNot(contains(HotAction.delayTest.label)));
    });

    test(
      'uses the Tianji Windows menu hierarchy for business profiles',
      () async {
        container.dispose();
        container = ProviderContainer(
          overrides: [
            currentProfileProvider.overrideWithValue(
              const Profile(
                id: 1,
                type: ProfileType.url,
                label: 'Tianji',
                url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
                autoUpdateDuration: Duration(days: 1),
              ),
            ),
          ],
        );
        await update(_trayState(), on: windows);

        final items = _items(showCall());
        final labels = _labels(showCall());
        expect(items.first['enabled'], isFalse);
        expect(items.first['label'], currentAppLocalizations.trayNotConnected);
        expect(labels, contains(currentAppLocalizations.outboundMode));
        expect(labels, contains(currentAppLocalizations.systemProxy));
        expect(labels, contains(currentAppLocalizations.trayTun));
        expect(labels, contains(currentAppLocalizations.autoLaunch));
        expect(items.last['label'], currentAppLocalizations.exit);
        expect(
          labels,
          isNot(contains(currentAppLocalizations.diagnosticsTitle)),
        );
      },
    );

    test('Linux omits the menu-open rate row', () async {
      container.dispose();
      container = ProviderContainer(
        overrides: [
          currentProfileProvider.overrideWithValue(
            const Profile(
              id: 1,
              type: ProfileType.url,
              label: 'Tianji',
              url: 'https://sub1.tianjiyun.org/s/test_subscription_001',
              autoUpdateDuration: Duration(days: 1),
            ),
          ),
        ],
      );
      final linux = AppTray.forPlatform(isMacOS: false, isWindows: false);
      await update(_trayState(), on: linux);

      final labels = _labels(showCall());
      expect(labels.first, currentAppLocalizations.trayNotConnected);
      expect(labels, isNot(contains(currentAppLocalizations.download)));
    });

    test('joins modifiers with + in the hotkey hints', () async {
      await update(
        _trayState(
          hotKeys: {
            HotAction.view: _bind(HotAction.view, PhysicalKeyboardKey.keyV),
          },
        ),
        on: windows,
      );

      expect(
        _item(showCall(), currentAppLocalizations.show)['detail'],
        'Ctrl+Shift+V',
      );
    });

    test('never pushes a tray title', () async {
      await windows.updateTitle(showTrayTitle: true, traffic: const Traffic());

      expect(calls.where((call) => call.method == 'setTitle'), isEmpty);
    });
  });

  test(
    'writes six zh_CN platform menus from disconnected and connected fakes',
    () async {
      await AppLocalizations.load(const Locale('zh', 'CN'));
      addTearDown(() => AppLocalizations.load(const Locale('en')));
      final platforms = [
        (name: 'Windows', target: TargetPlatform.windows),
        (name: 'macOS', target: TargetPlatform.macOS),
        (name: 'Linux', target: TargetPlatform.linux),
      ];
      for (final platform in platforms) {
        for (final connected in [false, true]) {
          debugDefaultTargetPlatformOverride = platform.target;
          final groups = await useBusinessFixture(connected: connected);
          calls.clear();
          Tray.instance.resetForTesting();
          final target = AppTray.forPlatform(
            isMacOS: platform.target == TargetPlatform.macOS,
            isWindows: platform.target == TargetPlatform.windows,
          );
          await update(
            _trayState(isStart: connected, groups: groups),
            on: target,
          );
          final call = showCall();
          final labels = _labels(call);
          final stateLabel = connected ? '已连接（含线路数据）' : '未连接';
          _menuReports.add(menuReport('${platform.name}｜$stateLabel', call));

          if (!connected) {
            expect(labels.first, currentAppLocalizations.trayNotConnected);
            expect(labels, isNot(contains('↓ 2.4 MB/s　↑ 312 KB/s')));
            expect(
              labels,
              isNot(contains('下载 2.4 MB/s · 上传 312 KB/s · 延迟 37 ms')),
            );
            if (platform.target == TargetPlatform.macOS) {
              expect(
                _item(call, currentAppLocalizations.sceneDaily)['enabled'],
                isTrue,
              );
            }
            continue;
          }

          if (platform.target == TargetPlatform.windows) {
            expect(labels.first, '已连接 · 东京家宽 · 04');
            expect(labels[1], '↓ 2.4 MB/s　↑ 312 KB/s');
            expect(labels, contains('断开连接'));
            expect(labels, contains('显示主窗口'));
            final quickLines = _item(call, currentAppLocalizations.quickLines);
            expect(quickLines['type'], 'submenu');
            expect(quickLines['items'], hasLength(3));
          } else if (platform.target == TargetPlatform.macOS) {
            expect(labels.take(3), [
              '已连接',
              '东京家宽 · 04 · 203.0.113.42',
              '下载 2.4 MB/s · 上传 312 KB/s · 延迟 37 ms',
            ]);
            expect(labels, contains('打开天机云…'));
            expect(labels, contains('一键诊断'));
            expect(labels.where((label) => label == '东京家宽 · 04'), hasLength(1));
            expect(labels.where((label) => label == '香港 · 家宽'), hasLength(1));
            expect(labels.where((label) => label == '洛杉矶住宅 02'), hasLength(1));
          } else {
            expect(labels.first, '已连接 · 东京家宽 · 04');
            expect(labels, isNot(contains('↓ 2.4 MB/s　↑ 312 KB/s')));
            expect(
              _item(call, currentAppLocalizations.quickLines)['type'],
              'submenu',
            );
          }
        }
      }
    },
  );
}
