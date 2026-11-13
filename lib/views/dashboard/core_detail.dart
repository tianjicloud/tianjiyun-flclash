import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;
import 'package:fl_clash/views/dashboard/widgets/memory_info.dart'
    show MemoryReader, MemorySnapshot;
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoreDetailView extends ConsumerStatefulWidget {
  const CoreDetailView({super.key, this.memoryReader});

  final MemoryReader? memoryReader;

  @override
  ConsumerState<CoreDetailView> createState() => _CoreDetailViewState();
}

class _CoreDetailViewState extends ConsumerState<CoreDetailView> {
  late final Future<MemorySnapshot> _memory = _readMemory();

  Future<MemorySnapshot> _readMemory() async {
    if (widget.memoryReader case final reader?) return reader();
    final rss = ProcessInfo.currentRss;
    final connected = ref.read(coreStatusProvider) == CoreStatus.connected;
    final core = connected
        ? await ref.read(coreHandlerProvider).getMemoryStats()
        : null;
    return MemorySnapshot(
      app: rss,
      core: core,
      coreTotal: system.isAndroid ? 0 : (core?.rss ?? 0),
      coreInProcess: system.isAndroid,
    );
  }

  Future<void> _restart() async {
    final status = ref.read(coreStatusProvider);
    if (status == CoreStatus.connecting) return;
    final prompt = status == CoreStatus.connected
        ? context.appLocalizations.forceRestartCoreTip
        : context.appLocalizations.restartCoreTip;
    if (await dialogs.showMessage(message: TextSpan(text: prompt)) != true ||
        !mounted) {
      return;
    }
    try {
      await ref.read(coreActionProvider.notifier).restartCore();
    } catch (error) {
      dialogs.showBanner(error.toString(), level: BannerLevel.error);
    }
  }

  Future<void> _releaseCache() async {
    try {
      await ref.read(coreHandlerProvider).forceGc();
      if (mounted) {
        dialogs.showBanner(context.appLocalizations.cacheReleased);
      }
    } catch (error) {
      if (mounted) {
        dialogs.showBanner(error.toString(), level: BannerLevel.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final status = ref.watch(coreStatusProvider);
    final runtime = ref.watch(runTimeProvider);
    final config = ref.watch(patchClashConfigProvider);
    final running = status == CoreStatus.connected;
    final ports = <(String, int)>[
      (l10n.localProxyPort, config.mixedPort),
      (l10n.socksPort, config.socksPort),
      (l10n.redirPort, config.redirPort),
      (l10n.tproxyPort, config.tproxyPort),
    ].where((entry) => entry.$2 > 0).toList();
    return BusinessAppearance(
      child: Scaffold(
        title: l10n.serviceStatus,
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            24,
            context.contentTopPadding,
            24,
            24 + context.bottomInset,
          ),
          children: [
            BusinessSettingsCard(
              title: l10n.service,
              trailing: BusinessSecondaryButton(
                label: l10n.restartService,
                width: 132,
                onPressed: status == CoreStatus.connecting ? null : _restart,
              ),
              items: [
                ListItem(
                  title: Text(l10n.serviceStatus),
                  trailing: Text(
                    running ? l10n.running : l10n.notRunning,
                    style: BusinessText.metaValue(context).copyWith(
                      color: running
                          ? BusinessPalette.connectedForegroundFor(
                              context.colorScheme.brightness,
                            )
                          : BusinessPalette.disconnectedForegroundFor(
                              context.colorScheme.brightness,
                            ),
                    ),
                  ),
                ),
                if (runtime != null)
                  ListItem(
                    title: Text(l10n.businessKernelUptime),
                    trailing: Text(
                      _formatRuntime(runtime),
                      style: BusinessText.metaValue(context),
                    ),
                  ),
                for (final port in ports)
                  ListItem(
                    title: Text(port.$1),
                    trailing: Text(
                      '127.0.0.1:${port.$2}',
                      style: BusinessText.metaValue(context),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            BusinessSettingsCard(
              title: l10n.memoryInfo,
              trailing: BusinessSecondaryButton(
                label: l10n.releaseCache,
                width: 132,
                onPressed: running ? _releaseCache : null,
              ),
              items: [
                ListItem(
                  title: Text(
                    system.isAndroid
                        ? l10n.interfaceAndKernelCombined
                        : l10n.interfaceMemory,
                  ),
                  trailing: FutureBuilder(
                    future: _memory,
                    builder: (context, snapshot) {
                      final memory = snapshot.data;
                      final total = memory?.app;
                      if (total == null) return const SizedBox.shrink();
                      return Text(
                        '${total.traffic.value} ${total.traffic.unit}',
                        style: BusinessText.metaValue(context),
                      );
                    },
                  ),
                ),
                if (running && !system.isAndroid)
                  FutureBuilder(
                    future: _memory,
                    builder: (context, snapshot) {
                      final core = snapshot.data?.core;
                      if (core == null) return const SizedBox.shrink();
                      return Column(
                        children: [
                          ListItem(
                            title: Text(l10n.serviceMemory),
                            trailing: Text(
                              '${core.rss.traffic.value} ${core.rss.traffic.unit}',
                              style: BusinessText.metaValue(context),
                            ),
                          ),
                          ListItem(
                            title: Text(l10n.heapInUse),
                            trailing: Text(
                              '${core.heapInuse.traffic.value} ${core.heapInuse.traffic.unit}',
                              style: BusinessText.metaValue(context),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
              footer: system.isAndroid
                  ? Text(
                      l10n.androidSharedMemory,
                      style: BusinessText.metaValue(context),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

String _formatRuntime(int milliseconds) {
  final duration = Duration(milliseconds: milliseconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
}
