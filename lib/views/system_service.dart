import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/desktop/helper_client.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessPrimaryButton;
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef HelperReadinessNameReader = Future<String> Function();

final systemServiceReadinessNameProvider = Provider<HelperReadinessNameReader>((
  ref,
) {
  return () async => (await helperClient.readiness()).name;
});

enum HelperServiceStatus { running, notReady, abnormal }

const _serviceIconRadius = 12.0;

HelperServiceStatus helperServiceStatusForName(String name) => switch (name) {
  'ready' => HelperServiceStatus.running,
  'notReady' => HelperServiceStatus.notReady,
  'manifestMissing' => HelperServiceStatus.abnormal,
  _ => HelperServiceStatus.abnormal,
};

class SystemServiceView extends ConsumerStatefulWidget {
  const SystemServiceView({super.key, this.readinessNameReader});

  final HelperReadinessNameReader? readinessNameReader;

  @override
  ConsumerState<SystemServiceView> createState() => _SystemServiceViewState();
}

class _SystemServiceViewState extends ConsumerState<SystemServiceView> {
  String? _readinessName;
  bool _loading = true;
  bool _installing = false;

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final HelperReadinessNameReader readReadiness =
          widget.readinessNameReader ??
          ref.read(systemServiceReadinessNameProvider);
      final readinessName = await readReadiness();
      if (mounted) setState(() => _readinessName = readinessName);
    } catch (_) {
      if (mounted) setState(() => _readinessName = null);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _install() async {
    setState(() => _installing = true);
    try {
      await system.authorizeCore();
      await _refresh();
    } finally {
      if (mounted) setState(() => _installing = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final readinessName = _readinessName;
    final status = readinessName == null
        ? HelperServiceStatus.abnormal
        : helperServiceStatusForName(readinessName);
    final brightness = context.colorScheme.brightness;
    final statusLabel = switch (status) {
      HelperServiceStatus.running => l10n.systemServiceRunning,
      HelperServiceStatus.notReady => l10n.systemServiceNotInstalled,
      HelperServiceStatus.abnormal =>
        readinessName == null
            ? l10n.systemServiceAbnormal
            : '${l10n.systemServiceAbnormal} ($readinessName)',
    };
    final statusColor = switch (status) {
      HelperServiceStatus.running => BusinessPalette.connectedForegroundFor(
        brightness,
      ),
      HelperServiceStatus.notReady => BusinessPalette.disconnectedForegroundFor(
        brightness,
      ),
      HelperServiceStatus.abnormal => BusinessPalette.warningForegroundFor(
        brightness,
      ),
    };
    final statusGlyph = status == HelperServiceStatus.running
        ? AppGlyphs.verified
        : status == HelperServiceStatus.abnormal
        ? AppGlyphs.warning
        : AppGlyphs.cpu;
    final iconBackground = switch (status) {
      HelperServiceStatus.running => BusinessPalette.connectedContainerFor(
        brightness,
      ),
      HelperServiceStatus.notReady => BusinessPalette.disconnectedContainerFor(
        brightness,
      ),
      HelperServiceStatus.abnormal => BusinessPalette.warningContainerFor(
        brightness,
      ),
    };
    final iconForeground = switch (status) {
      HelperServiceStatus.running => BusinessPalette.connectedForegroundFor(
        brightness,
      ),
      HelperServiceStatus.notReady => BusinessPalette.disconnectedForegroundFor(
        brightness,
      ),
      HelperServiceStatus.abnormal => BusinessPalette.warningForegroundFor(
        brightness,
      ),
    };
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: brightness == Brightness.dark
                ? context.colorScheme.surfaceContainerLow
                : context.colorScheme.surface,
            shape: AppShape.all(BusinessPalette.cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: iconBackground,
                    shape: AppShape.all(_serviceIconRadius),
                  ),
                  child: SizedBox.square(
                    dimension: 44,
                    child: Center(
                      child: GlyphIcon(
                        statusGlyph,
                        size: 22,
                        color: iconForeground,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: '$appHelperService · '),
                              TextSpan(
                                text: _loading ? l10n.loading : statusLabel,
                                style: TextStyle(
                                  color: _loading ? null : statusColor,
                                ),
                              ),
                            ],
                          ),
                          style: BusinessText.systemServiceTitle(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.systemServiceDescription,
                          style: BusinessText.metaLabel(context).copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: _loading ? null : _refresh,
                      icon: const GlyphIcon(AppGlyphs.refresh, size: 16),
                      tooltip: l10n.systemServiceRefresh,
                      style: ButtonStyle.from(
                        shape: AppShape.circle,
                        fixedSize: const Size.square(34),
                        minimumSize: const Size.square(34),
                        maximumSize: const Size.square(34),
                        padding: EdgeInsets.zero,
                        tapTargetSize: TapTargetSize.shrinkWrap,
                      ),
                    ),
                    if (status != HelperServiceStatus.running) ...[
                      const SizedBox(height: 8),
                      BusinessPrimaryButton(
                        label: status == HelperServiceStatus.notReady
                            ? l10n.systemServiceInstall
                            : l10n.systemServiceRepair,
                        width: 104,
                        glyph: AppGlyphs.wrench,
                        onPressed: _installing || _loading ? null : _install,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
