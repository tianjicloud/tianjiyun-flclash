import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/selection_check.dart';
import 'package:fl_clash/providers/selection_verification.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectionNotice extends ConsumerWidget {
  const SelectionNotice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verdict = ref.watch(selectionCheckProvider);
    final l10n = context.appLocalizations;
    final message = switch (verdict) {
      SelectionVerdict.untouched || SelectionVerdict.consistent => null,
      SelectionVerdict.confirming => l10n.selectionConfirming,
      SelectionVerdict.failed => l10n.serviceFailed,
      SelectionVerdict.notCaptured => l10n.selectionNotCaptured,
      SelectionVerdict.residentialLocked => l10n.selectionResidentialLocked,
      SelectionVerdict.groupOverridden => l10n.selectionGroupOverridden,
      SelectionVerdict.unknownPending => l10n.selectionUnknownPending,
      SelectionVerdict.unknown => l10n.selectionUnknown,
    };
    if (message == null) return const SizedBox.shrink();
    final confirming = verdict == SelectionVerdict.confirming;
    return Semantics(
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: AppTextStyle.subheadline
                .of(context)
                .copyWith(
                  color: confirming
                      ? context.colorScheme.onSurfaceVariant
                      : context.colorScheme.error,
                ),
          ),
          if (!confirming)
            TextButton(
              onPressed: () => ref
                  .read(outboundIpProbeProvider.notifier)
                  .refresh(const [routedOutbound]),
              child: Text(l10n.selectionRecheck),
            ),
        ],
      ),
    );
  }
}
