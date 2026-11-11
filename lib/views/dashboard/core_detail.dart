import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;
import 'package:fl_clash/views/dashboard/widgets/memory_info.dart'
    show MemoryReader, MemorySnapshot, readMemorySnapshot;
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
    return readMemorySnapshot(ref);
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final status = ref.watch(coreStatusProvider);
    final runtime = ref.watch(runTimeProvider);
    final config = ref.watch(patchClashConfigProvider);
    final running = status == CoreStatus.connected;
    final ports = <(String, int)>[
      (l10n.mixedPort, config.mixedPort),
      (l10n.socksPort, config.socksPort),
      (l10n.redirPort, config.redirPort),
      (l10n.tproxyPort, config.tproxyPort),
    ].where((entry) => entry.$2 > 0).toList();
    return BusinessAppearance(
      child: Scaffold(
        title: l10n.coreStatus,
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            24,
            context.contentTopPadding,
            24,
            24 + context.bottomInset,
          ),
          children: [
            BusinessSettingsCard(
              title: l10n.core,
              trailing: BusinessSecondaryButton(
                label: l10n.businessKernelRestart,
                width: 132,
                onPressed: status == CoreStatus.connecting ? null : _restart,
              ),
              items: [
                ListItem(
                  title: Text(l10n.coreStatus),
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
              items: [
                ListItem(
                  title: Text(l10n.memoryInfo),
                  trailing: FutureBuilder(
                    future: _memory,
                    builder: (context, snapshot) {
                      final total = snapshot.data?.total;
                      return Text(
                        total == null
                            ? '—'
                            : '${total.traffic.value} ${total.traffic.unit}',
                        style: BusinessText.metaValue(context),
                      );
                    },
                  ),
                ),
              ],
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
