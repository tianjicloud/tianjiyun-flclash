import 'package:fl_clash/enum/enum.dart';
import 'package:collection/collection.dart';
import 'package:fl_clash/common/num.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/service_probe.dart' show routedOutbound;
import 'package:fl_clash/core/scene.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/dashboard_lines.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:tray/tray.dart';

import 'app_localizations.dart';
import 'l10n_labels.dart';
import 'app_ports.dart';
import 'constant.dart';
import 'keyboard.dart';
import 'provider_reader.dart';
import 'system.dart';
import 'window.dart';

class AppTray implements TrayPort {
  static AppTray? _instance;

  final bool isMacOS;
  final bool isWindows;

  bool _isShutDown = false;

  AppTray._internal({required this.isMacOS, required this.isWindows});

  factory AppTray() {
    _instance ??= AppTray._internal(
      isMacOS: system.isMacOS,
      isWindows: system.isWindows,
    );
    return _instance!;
  }

  @visibleForTesting
  factory AppTray.forPlatform({
    required bool isMacOS,
    required bool isWindows,
  }) {
    return AppTray._internal(isMacOS: isMacOS, isWindows: isWindows);
  }

  String get _trayIconSuffix {
    return isWindows ? 'ico' : 'png';
  }

  bool _isTemplate(bool monochrome) => isMacOS && monochrome;

  String _trayIconDir(bool monochrome, int status) {
    if (isWindows) {
      return 'assets/images/tray/windows';
    }
    if (!isMacOS) {
      return 'assets/images/tray/unix';
    }
    if (_isTemplate(monochrome)) {
      return 'assets/images/tray/macos';
    }
    return status == 4
        ? 'assets/images/tray/unix'
        : 'assets/images/tray/macos/color';
  }

  String getTrayIcon({
    required bool isStart,
    required bool tunEnable,
    required bool safeMode,
    bool monochrome = true,
  }) {
    final status = switch ((
      safeMode,
      _isTemplate(monochrome) || !isStart,
      tunEnable,
    )) {
      (true, _, _) => 4,
      (false, true, _) => 1,
      (false, false, false) => 2,
      (false, false, true) => 3,
    };
    return '${_trayIconDir(monochrome, status)}/status_$status.$_trayIconSuffix';
  }

  @override
  Future<void> shutdown() async {
    _isShutDown = true;
    // Removing a status item makes macOS forget where the user dragged it in
    // the menu bar; one that goes away with the process keeps its place.
    if (isMacOS) {
      return;
    }
    await Tray.instance.hide();
  }

  @override
  Future<void> update({
    required TrayState trayState,
    required Traffic traffic,
    required ProviderReader read,
  }) async {
    if (_isShutDown) {
      return;
    }
    await Tray.instance.show(
      TraySpec(
        icon: TrayIcon.asset(
          getTrayIcon(
            isStart: trayState.isStart && !trayState.suspended,
            tunEnable: trayState.tunEnable,
            safeMode: trayState.safeMode,
            monochrome: trayState.monochromeTrayIcon,
          ),
          isTemplate: _isTemplate(trayState.monochromeTrayIcon),
          size: isMacOS ? 18 : 16,
        ),
        toolTip: trayState.safeMode
            ? currentAppLocalizations.safeModeAppTitle(appName)
            : appName,
        menu: _buildMenu(trayState: trayState, read: read),
      ),
    );
    await updateTitle(showTrayTitle: trayState.showTrayTitle, traffic: traffic);
  }

  Future<void> updateTitle({
    required bool showTrayTitle,
    required Traffic traffic,
  }) async {
    if (_isShutDown || !isMacOS) {
      return;
    }
    await Tray.instance.setTitle(showTrayTitle ? traffic.trayTitle : '');
  }

  List<TrayMenuItem> _buildMenu({
    required TrayState trayState,
    required ProviderReader read,
  }) {
    final commonAction = read(commonActionProvider.notifier);
    final systemAction = read(systemActionProvider.notifier);
    final setupAction = read(setupActionProvider.notifier);
    final appLocalizations = currentAppLocalizations;
    String? shortcut(HotAction action) => _shortcut(trayState, action);
    final showItem = TrayMenuAction(
      label: appLocalizations.show,
      detail: shortcut(HotAction.view),
      onSelected: () {
        window?.show();
      },
    );
    final exitItem = TrayMenuAction(
      label: appLocalizations.exit,
      detail: shortcut(HotAction.exit),
      onSelected: () {
        systemAction.handleExit();
      },
    );

    if (!trayState.safeMode &&
        isTianjiSubscriptionProfile(read(currentProfileProvider))) {
      return _buildBusinessMenu(
        trayState: trayState,
        read: read,
        showItem: showItem,
        exitItem: exitItem,
        commonAction: commonAction,
        systemAction: systemAction,
        setupAction: setupAction,
        shortcut: shortcut,
      );
    }

    return [
      showItem,
      TrayMenuCheckbox(
        label: trayState.isStart
            ? appLocalizations.stop
            : appLocalizations.start,
        checked: false,
        detail: shortcut(HotAction.start),
        onSelected: commonAction.toggleRunning,
      ),
      if (isMacOS) ...[
        TrayMenuCheckbox(
          label: appLocalizations.speedStatistics,
          checked: trayState.showTrayTitle,
          onSelected: commonAction.updateSpeedStatistics,
        ),
        TrayMenuCheckbox(
          label: appLocalizations.monochromeIcon,
          checked: trayState.monochromeTrayIcon,
          onSelected: commonAction.updateMonochromeTrayIcon,
        ),
      ],
      const TrayMenuSeparator(),
      for (final mode in Mode.values)
        TrayMenuCheckbox(
          label: mode.label,
          checked: mode == trayState.mode,
          detail: shortcut(switch (mode) {
            Mode.rule => HotAction.ruleMode,
            Mode.global => HotAction.globalMode,
            Mode.direct => HotAction.directMode,
          }),
          onSelected: () {
            setupAction.changeMode(mode);
          },
        ),
      const TrayMenuSeparator(),
      if (isMacOS) ..._buildGroupMenu(trayState: trayState, read: read),
      if (trayState.isStart) ...[
        TrayMenuCheckbox(
          label: appLocalizations.tun,
          checked: trayState.tunEnable,
          detail: shortcut(HotAction.tun),
          onSelected: systemAction.updateTun,
        ),
        TrayMenuCheckbox(
          label: appLocalizations.systemProxy,
          checked: trayState.systemProxy,
          detail: shortcut(HotAction.proxy),
          onSelected: systemAction.updateSystemProxy,
        ),
        const TrayMenuSeparator(),
      ],
      TrayMenuCheckbox(
        label: appLocalizations.autoLaunch,
        checked: trayState.autoLaunch,
        onSelected: systemAction.updateAutoLaunch,
      ),
      TrayMenuAction(
        label: appLocalizations.copyEnvVar,
        detail: shortcut(HotAction.copyEnv),
        onSelected: systemAction.copyProxyEnv,
      ),
      const TrayMenuSeparator(),
      exitItem,
    ];
  }

  List<TrayMenuItem> _buildBusinessMenu({
    required TrayState trayState,
    required ProviderReader read,
    required TrayMenuAction showItem,
    required TrayMenuAction exitItem,
    required dynamic commonAction,
    required dynamic systemAction,
    required dynamic setupAction,
    required String? Function(HotAction) shortcut,
  }) {
    final l10n = currentAppLocalizations;
    final running = trayState.isStart && !trayState.suspended;
    final coreStatus = read(coreStatusProvider);
    final connected = coreStatus == CoreStatus.connected && running;
    final lines = dashboardLinesFrom(read, limit: isMacOS ? 3 : 4);
    final currentLine = lines.where((line) => line.current).firstOrNull;
    final traffic = read(trafficsProvider).list.lastOrNull ?? const Traffic();
    final speed = TrayMenuAction(
      label: isMacOS
          ? '${l10n.download} ${_trafficRate(traffic.down)} · ${l10n.upload} ${_trafficRate(traffic.up)} · ${l10n.delay} ${currentLine?.delay == null ? '—' : '${currentLine!.delay} ms'}'
          : '↓ ${_trafficRate(traffic.down)}　↑ ${_trafficRate(traffic.up)}',
      enabled: false,
    );
    final macMetrics = TrayMenuMetrics(
      metrics: [
        TrayMenuMetric(label: l10n.download, value: _trafficRate(traffic.down)),
        TrayMenuMetric(label: l10n.upload, value: _trafficRate(traffic.up)),
        TrayMenuMetric(
          label: l10n.delay,
          value: currentLine?.delay == null ? '—' : '${currentLine!.delay} ms',
        ),
      ],
    );
    final modes = [
      for (final mode in Mode.values)
        TrayMenuCheckbox(
          label: mode.label,
          checked: mode == trayState.mode,
          onSelected: () => setupAction.changeMode(mode),
        ),
    ];
    final menu = <TrayMenuItem>[];
    if (!isMacOS) {
      menu.add(
        TrayMenuAction(
          label: switch (coreStatus) {
            CoreStatus.connecting => l10n.connecting,
            CoreStatus.connected when connected && currentLine != null =>
              '${l10n.connected} · ${currentLine.displayName}',
            CoreStatus.connected when connected => l10n.connected,
            _ => l10n.trayNotConnected,
          },
          enabled: false,
        ),
      );
      if (isWindows && connected) menu.add(speed);
    } else {
      final ip = read(outboundIpProbeProvider).entryOf(routedOutbound);
      menu.add(
        TrayMenuAction(
          label: switch (coreStatus) {
            CoreStatus.connecting => l10n.connecting,
            CoreStatus.connected when connected => l10n.connected,
            _ => l10n.trayNotConnected,
          },
          enabled: false,
        ),
      );
      final routeDetails = connected
          ? [
              if (currentLine != null) currentLine.displayName,
              if (ip.phase == ProbePhase.fresh && ip.value != null)
                ip.value!.ip,
            ]
          : const <String>[];
      if (routeDetails.isNotEmpty) {
        menu.add(
          TrayMenuAction(label: routeDetails.join(' · '), enabled: false),
        );
      }
      if (connected) menu.add(macMetrics);
    }
    if (!isMacOS) {
      menu.add(
        TrayMenuCheckbox(
          label: running ? l10n.trayDisconnect : l10n.connection,
          checked: false,
          detail: shortcut(HotAction.start),
          onSelected: commonAction.toggleRunning,
        ),
      );
      menu.add(
        TrayMenuAction(
          label: l10n.trayShowMainWindow,
          detail: shortcut(HotAction.view),
          onSelected: showItem.onSelected,
        ),
      );
    }
    menu.add(const TrayMenuSeparator());
    if (isMacOS) {
      final policy = read(scenePolicyProvider);
      final profileId = read(currentProfileProvider)?.id;
      final sceneState = read(sceneActionProvider);
      final sceneApplying =
          sceneState.applying && sceneState.matches(profileId);
      menu.add(
        TrayMenuSegmented(
          label: l10n.scene,
          options: [
            for (final scene in SceneKind.values)
              TrayMenuSegmentOption(
                id: scene.name,
                label: switch (scene) {
                  SceneKind.daily => l10n.sceneDaily,
                  SceneKind.ai => l10n.sceneAi,
                  SceneKind.watch => l10n.sceneWatch,
                },
                selected: policy.current == scene,
                enabled:
                    policy.available && !sceneApplying && !policy.suspended,
                onSelected: () =>
                    read(sceneActionProvider.notifier).select(scene),
              ),
          ],
        ),
      );
      menu.add(
        TrayMenuSegmented(
          label: l10n.outboundMode,
          options: [
            for (final mode in Mode.values)
              TrayMenuSegmentOption(
                id: mode.name,
                label: mode.label,
                selected: mode == trayState.mode,
                onSelected: () => setupAction.changeMode(mode),
              ),
          ],
        ),
      );
      if (lines.isNotEmpty) {
        menu.add(const TrayMenuSeparator());
        menu.add(TrayMenuAction(label: l10n.quickLines, enabled: false));
        for (final line in lines) {
          menu.add(
            TrayMenuCheckbox(
              label: line.displayName,
              checked: line.current,
              onSelected: () {
                if (line.residential) {
                  read(residentialActionProvider.notifier).select(line.name);
                } else {
                  read(proxiesActionProvider.notifier).changeProxy(
                    groupName: line.groupName,
                    proxyName: line.name,
                  );
                }
              },
            ),
          );
        }
      }
      if (trayState.groups.isNotEmpty) {
        menu.add(
          TrayMenuSubmenu(
            label: l10n.businessAllLines,
            items: _buildGroupMenu(
              trayState: trayState,
              read: read,
            ).where((item) => item is! TrayMenuSeparator).toList(),
          ),
        );
      }
      menu.add(const TrayMenuSeparator());
      menu.add(
        TrayMenuAction(
          label: l10n.trayOpenApp,
          detail: shortcut(HotAction.view),
          onSelected: showItem.onSelected,
        ),
      );
      menu.add(
        TrayMenuAction(
          label: l10n.diagnosticsTitle,
          onSelected: () =>
              read(currentPageLabelProvider.notifier).toPage(PageLabel.logs),
        ),
      );
      menu.add(
        TrayMenuAction(
          label: l10n.trayCopyProxyCommand,
          onSelected: systemAction.copyProxyEnv,
        ),
      );
      menu.add(const TrayMenuSeparator());
      menu.add(
        TrayMenuSubmenu(
          label: l10n.trayPreferences,
          items: [
            TrayMenuCheckbox(
              label: l10n.speedStatistics,
              checked: trayState.showTrayTitle,
              onSelected: commonAction.updateSpeedStatistics,
            ),
            TrayMenuCheckbox(
              label: l10n.monochromeIcon,
              checked: trayState.monochromeTrayIcon,
              onSelected: commonAction.updateMonochromeTrayIcon,
            ),
          ],
        ),
      );
    } else {
      menu.add(TrayMenuAction(label: l10n.outboundMode, enabled: false));
      menu.addAll(modes);
      menu.add(const TrayMenuSeparator());
      menu.add(
        TrayMenuCheckbox(
          label: l10n.systemProxy,
          checked: trayState.systemProxy,
          detail: shortcut(HotAction.proxy),
          onSelected: systemAction.updateSystemProxy,
        ),
      );
      menu.add(
        TrayMenuCheckbox(
          label: l10n.trayTun,
          checked: trayState.tunEnable,
          detail: shortcut(HotAction.tun),
          onSelected: systemAction.updateTun,
        ),
      );
      if (connected && lines.isNotEmpty) {
        menu.add(
          TrayMenuSubmenu(
            label: l10n.quickLines,
            items: [
              for (final line in lines)
                TrayMenuCheckbox(
                  label: line.displayName,
                  checked: line.current,
                  onSelected: () =>
                      read(proxiesActionProvider.notifier).changeProxy(
                        groupName: line.groupName,
                        proxyName: line.name,
                      ),
                ),
            ],
          ),
        );
      }
      menu.add(
        TrayMenuAction(
          label: l10n.trayCopyProxyCommand,
          detail: shortcut(HotAction.copyEnv),
          onSelected: systemAction.copyProxyEnv,
        ),
      );
      menu.add(const TrayMenuSeparator());
      menu.add(
        TrayMenuCheckbox(
          label: l10n.autoLaunch,
          checked: trayState.autoLaunch,
          onSelected: systemAction.updateAutoLaunch,
        ),
      );
    }
    menu.add(exitItem);
    return menu;
  }

  String _trafficRate(num bytes) {
    final traffic = bytes.traffic;
    final value = traffic.value.endsWith('.0')
        ? traffic.value.substring(0, traffic.value.length - 2)
        : traffic.value;
    return '$value ${traffic.unit}/s';
  }

  String? _shortcut(TrayState trayState, HotAction action) {
    final hotKey = trayState.hotKeys[action];
    final key = hotKey?.key;
    if (hotKey == null || key == null) {
      return null;
    }
    return ShortcutLabels(
      isMacOS: isMacOS,
      isWindows: isWindows,
    ).text(hotKey.modifiers, key);
  }

  String? _delayText(int? delay) {
    if (delay == null) {
      return null;
    }
    return delay > 0
        ? '$delay'
        : delayFailureText(delay, currentAppLocalizations);
  }

  List<TrayMenuItem> _buildGroupMenu({
    required TrayState trayState,
    required ProviderReader read,
  }) {
    if (trayState.groups.isEmpty) {
      return const [];
    }
    final delays = read(trayDelaysProvider);
    final proxiesAction = read(proxiesActionProvider.notifier);
    return [
      for (final group in trayState.groups)
        _buildGroupSubmenu(
          group,
          selectedName: read(selectedProxyNameProvider(group.name)),
          delays: delays[group.name] ?? const {},
          onSelected: (proxyName) {
            proxiesAction.changeProxy(
              groupName: group.name,
              proxyName: proxyName,
            );
          },
        ),
      TrayMenuAction(
        label: HotAction.delayTest.label,
        detail: _shortcut(trayState, HotAction.delayTest),
        onSelected: () {
          proxiesAction.delayTestGroups(trayState.groups);
        },
      ),
      const TrayMenuSeparator(),
    ];
  }

  TrayMenuSubmenu _buildGroupSubmenu(
    Group group, {
    required String? selectedName,
    required Map<String, int> delays,
    required void Function(String proxyName) onSelected,
  }) {
    return TrayMenuSubmenu(
      label: group.name,
      detail: _delayText(delays[selectedName]),
      items: [
        for (final proxy in group.all)
          TrayMenuCheckbox(
            label: proxy.name,
            checked: selectedName == proxy.name,
            detail: _delayText(delays[proxy.name]),
            onSelected: () {
              onSelected(proxy.name);
            },
          ),
      ],
    );
  }
}

final appTray = system.isDesktop ? AppTray() : null;
