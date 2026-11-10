import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:prism_ui/prism_ui.dart';

enum BusinessExitWarningKind { probeFailed, tunUnauthorized }

BusinessExitWarningKind? businessExitWarningKind({
  required bool active,
  required bool coreConnected,
  required bool probeFailed,
  required bool tunEnabled,
  required bool tunAuthorized,
}) {
  if (!active || !coreConnected) return null;
  if (probeFailed) return BusinessExitWarningKind.probeFailed;
  if (tunEnabled && !tunAuthorized) {
    return BusinessExitWarningKind.tunUnauthorized;
  }
  return null;
}

class BusinessExitWarningBanner extends StatelessWidget {
  const BusinessExitWarningBanner({
    super.key,
    required this.kind,
    required this.onRetry,
    required this.onAuthorize,
    required this.onDiagnostics,
  });

  final BusinessExitWarningKind? kind;
  final VoidCallback onRetry;
  final VoidCallback onAuthorize;
  final VoidCallback onDiagnostics;

  @override
  Widget build(BuildContext context) => AnimatedSize(
    alignment: Alignment.topCenter,
    duration: context.motionDuration(commonDuration),
    child: kind == null
        ? const SizedBox.shrink()
        : LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 680;
              final strings = context.appLocalizations;
              final title = switch (kind!) {
                BusinessExitWarningKind.probeFailed =>
                  strings.businessExitProbeUnavailable,
                BusinessExitWarningKind.tunUnauthorized =>
                  strings.businessExitMismatch,
              };
              final description = switch (kind!) {
                BusinessExitWarningKind.probeFailed =>
                  strings.businessExitProbeDescription,
                BusinessExitWarningKind.tunUnauthorized =>
                  strings.businessExitTunDescription,
              };
              final primary = switch (kind!) {
                BusinessExitWarningKind.probeFailed => strings.selectionRecheck,
                BusinessExitWarningKind.tunUnauthorized =>
                  strings.businessAuthorizeTun,
              };
              final action = switch (kind!) {
                BusinessExitWarningKind.probeFailed => onRetry,
                BusinessExitWarningKind.tunUnauthorized => onAuthorize,
              };
              final details = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: BusinessText.cardTitle(context)),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: BusinessText.metaLabel(context),
                  ),
                ],
              );
              final actions = Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _AmberActionButton(label: primary, onPressed: action),
                  BusinessSecondaryButton(
                    label: strings.businessViewDiagnostics,
                    width: 112,
                    onPressed: onDiagnostics,
                  ),
                ],
              );
              return Container(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 14, 10),
                decoration: ShapeDecoration(
                  color: BusinessPalette.exitBannerBackgroundFor(
                    context.colorScheme.brightness,
                  ),
                  shape: AppShape.all(BusinessRadius.heroDesktop).copyWith(
                    side: BorderSide(
                      color: BusinessPalette.exitBannerStrokeFor(
                        context.colorScheme.brightness,
                      ),
                    ),
                  ),
                ),
                child: compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 8,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: GlyphIcon(
                                  AppGlyphs.warning,
                                  size: 18,
                                  color: BusinessPalette.warning,
                                ),
                              ),
                              Expanded(child: details),
                            ],
                          ),
                          actions,
                        ],
                      )
                    : Row(
                        spacing: 14,
                        children: [
                          const GlyphIcon(
                            AppGlyphs.warning,
                            size: 18,
                            color: BusinessPalette.warning,
                          ),
                          Expanded(child: details),
                          actions,
                        ],
                      ),
              );
            },
          ),
  );
}

class _AmberActionButton extends StatelessWidget {
  const _AmberActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    style: ButtonStyle.from(
      backgroundColor: BusinessPalette.exitWarningGradientEnd,
      foregroundColor: BusinessPalette.exitWarningInk,
      shape: AppShape.full,
      minimumSize: const Size(0, 34),
      maximumSize: const Size(double.infinity, 34),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      tapTargetSize: TapTargetSize.shrinkWrap,
      backgroundBuilder: (context, states, child) => DecoratedBox(
        decoration: const ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              BusinessPalette.exitWarningGradientStart,
              BusinessPalette.exitWarningGradientEnd,
            ],
          ),
          shape: AppShape.full,
        ),
        child: child,
      ),
    ),
    child: Text(
      label,
      style: BusinessText.actionLabel(
        context,
      ).copyWith(color: BusinessPalette.exitWarningInk),
    ),
  );
}
