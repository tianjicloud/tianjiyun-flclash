import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/port_probe.dart';
import 'package:fl_clash/pages/error.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/widgets/widgets.dart' show BannerLevel;

class CoreStartupFailureView extends ConsumerWidget {
  const CoreStartupFailureView({super.key, required this.error});

  final String error;

  Future<void> _changePort(WidgetRef ref, BuildContext context) async {
    try {
      final port = await findAvailableMixedPort();
      ref
          .read(patchClashConfigProvider.notifier)
          .update((state) => state.copyWith(mixedPort: port));
      await ref.read(coreActionProvider.notifier).restartCore();
      if (context.mounted) Navigator.of(context).maybePop();
    } catch (failure) {
      if (context.mounted) {
        dialogs.showBanner(failure.toString(), level: BannerLevel.error);
      }
    }
  }

  Future<void> _export(WidgetRef ref, BuildContext context) async {
    try {
      final saved = await ref
          .read(logsProvider.notifier)
          .exportSupportReport(error);
      if (saved && context.mounted) {
        dialogs.showBanner(context.appLocalizations.exportSuccess);
      }
    } catch (failure) {
      if (context.mounted) {
        dialogs.showBanner(failure.toString(), level: BannerLevel.error);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ErrorPageBody(
    error: error,
    onAutoChangePort: isPortConflictError(error)
        ? () => _changePort(ref, context)
        : null,
    onExportReport: () => _export(ref, context),
  );
}
