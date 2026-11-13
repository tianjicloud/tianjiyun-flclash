import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/service_probe.dart' show routedOutbound;
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/ui/macos_style.dart';
import 'package:fl_clash/views/diagnostics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MacOSMenuBar extends ConsumerWidget {
  const MacOSMenuBar({super.key, required this.child});

  final Widget child;

  PlatformMenuItem _item(
    String label,
    VoidCallback? onSelected, {
    LogicalKeyboardKey? key,
    bool shift = false,
    bool option = false,
  }) {
    return PlatformMenuItem(
      label: label,
      shortcut: key == null
          ? null
          : SingleActivator(key, meta: !option, alt: option, shift: shift),
      onSelected: onSelected,
    );
  }

  void _invokeTextIntent(BuildContext context, Intent intent) {
    Actions.invoke(
      FocusManager.instance.primaryFocus?.context ?? context,
      intent,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = context.appLocalizations;
    final running = ref.watch(isStartProvider);
    final mode = ref.watch(
      patchClashConfigProvider.select((value) => value.mode),
    );
    final navigation = ref.watch(navigationStateProvider);
    final menus = <PlatformMenuItem>[
      PlatformMenu(
        label: strings.brandName,
        menus: [
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.about,
          ),
          _item(strings.settings, () {
            ref.read(currentPageLabelProvider.notifier).toPage(PageLabel.tools);
            ref.read(macOSSettingsSelectionProvider.notifier).select('general');
          }, key: LogicalKeyboardKey.comma),
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.hide,
          ),
          const PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.hideOtherApplications,
          ),
          _item(
            strings.exit,
            () => ref.read(systemActionProvider.notifier).handleExit(),
            key: LogicalKeyboardKey.keyQ,
          ),
        ],
      ),
      PlatformMenu(
        label: strings.edit,
        menus: [
          _item(
            strings.undo,
            () => _invokeTextIntent(
              context,
              const UndoTextIntent(SelectionChangedCause.keyboard),
            ),
            key: LogicalKeyboardKey.keyZ,
          ),
          _item(
            strings.redo,
            () => _invokeTextIntent(
              context,
              const RedoTextIntent(SelectionChangedCause.keyboard),
            ),
            key: LogicalKeyboardKey.keyZ,
            shift: true,
          ),
          _item(
            strings.cut,
            () => _invokeTextIntent(
              context,
              const CopySelectionTextIntent.cut(SelectionChangedCause.keyboard),
            ),
            key: LogicalKeyboardKey.keyX,
          ),
          _item(
            strings.copy,
            () => _invokeTextIntent(context, CopySelectionTextIntent.copy),
            key: LogicalKeyboardKey.keyC,
          ),
          _item(
            strings.paste,
            () => _invokeTextIntent(
              context,
              const PasteTextIntent(SelectionChangedCause.keyboard),
            ),
            key: LogicalKeyboardKey.keyV,
          ),
          _item(
            strings.selectAll,
            () => _invokeTextIntent(
              context,
              const SelectAllTextIntent(SelectionChangedCause.keyboard),
            ),
            key: LogicalKeyboardKey.keyA,
          ),
        ],
      ),
      PlatformMenu(
        label: strings.connection,
        menus: [
          _item(running ? strings.menuDisconnect : strings.menuConnect, () {
            ref
                .read(setupActionProvider.notifier)
                .setRunning(!running, initialize: true);
          }, key: LogicalKeyboardKey.keyK),
          _item(
            strings.menuRecheckExit,
            () => ref
                .read(outboundIpProbeProvider.notifier)
                .recheck(routedOutbound),
            key: LogicalKeyboardKey.keyR,
          ),
          for (final item in Mode.values)
            _item(
              item.label,
              mode == item
                  ? null
                  : () =>
                        ref.read(setupActionProvider.notifier).changeMode(item),
            ),
        ],
      ),
      PlatformMenu(
        label: strings.view,
        menus: [
          for (
            var index = 0;
            index < navigation.navigationItems.length && index < 9;
            index++
          )
            _item(
              navigation.navigationItems[index].label.label,
              () => ref
                  .read(currentPageLabelProvider.notifier)
                  .toPage(navigation.navigationItems[index].label),
              key: [
                LogicalKeyboardKey.digit1,
                LogicalKeyboardKey.digit2,
                LogicalKeyboardKey.digit3,
                LogicalKeyboardKey.digit4,
                LogicalKeyboardKey.digit5,
                LogicalKeyboardKey.digit6,
                LogicalKeyboardKey.digit7,
                LogicalKeyboardKey.digit8,
                LogicalKeyboardKey.digit9,
              ][index],
            ),
        ],
      ),
      PlatformMenu(
        label: strings.menuWindow,
        menus: const [
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.minimizeWindow,
          ),
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.zoomWindow,
          ),
          PlatformProvidedMenuItem(
            type: PlatformProvidedMenuItemType.arrangeWindowsInFront,
          ),
        ],
      ),
      PlatformMenu(
        label: strings.menuHelp,
        menus: [
          _item(
            strings.menuContactSupport,
            () => dialogs.openUrl('mailto:$supportEmail'),
          ),
          _item(
            strings.diagnosticsTitle,
            () => Navigator.of(context).push(
              MacOSPagedSheetRoute<void>(
                macOS: true,
                reducedMotion: MediaQuery.disableAnimationsOf(context),
                builder: (_) => const DiagnosticsView(),
              ),
            ),
          ),
        ],
      ),
    ];
    return PlatformMenuBar(menus: menus, child: child);
  }
}
