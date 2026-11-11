import 'dart:async';
import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/pages/scan.dart';
import 'package:fl_clash/providers/outbound_ip.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessPrimaryButton, BusinessSecondaryButton;
import 'package:fl_clash/views/dashboard/probe_start_hold.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'plan_card.dart';

class OnboardingView extends ConsumerWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final useDesktopSplit =
        MediaQuery.sizeOf(context).width >= 1100 &&
        MediaQuery.sizeOf(context).height >= 620 &&
        MediaQuery.textScalerOf(context).scale(1) < 1.25 &&
        !context.isMobileView;
    return Surface(
      color: SurfaceLevel.page.colorOf(context.colorScheme),
      child: _OnboardingBackdrop(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (BusinessTheme.of(context) &&
                  context.isMobileView &&
                  state is OnboardingFailed) {
                return _BusinessFailedMobileView(
                  failure: state.failure,
                  url: state.url,
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: math.max(0, constraints.maxHeight - 48),
                  ),
                  child: useDesktopSplit
                      ? _DesktopOnboardingLayout(
                          state: state,
                          content: _onboardingContent(state),
                          minHeight: math.max(0, constraints.maxHeight - 48),
                        )
                      : Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420),
                            child: _onboardingContent(state),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _onboardingContent(OnboardingState state) => switch (state) {
  OnboardingWelcome() || OnboardingDone() => const _WelcomeView(),
  OnboardingConfirm(:final url) => _ConfirmView(url: url),
  OnboardingImporting() => const _ProgressView(
    titleKey: _ProgressTitle.importing,
  ),
  OnboardingImported(:final profileId, :final proxyCount) => _ImportedView(
    profileId: profileId,
    proxyCount: proxyCount,
  ),
  OnboardingFailed(:final failure, :final url) => _FailedView(
    failure: failure,
    url: url,
  ),
  OnboardingConnecting() || OnboardingConnected() => const _ConnectView(),
};

class _DesktopOnboardingLayout extends StatelessWidget {
  const _DesktopOnboardingLayout({
    required this.state,
    required this.content,
    required this.minHeight,
  });

  final OnboardingState state;
  final Widget content;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final activeStep = switch (state) {
      OnboardingWelcome() || OnboardingDone() => 0,
      OnboardingConfirm() || OnboardingImporting() || OnboardingFailed() => 1,
      _ => 2,
    };
    final business = BusinessTheme.of(context) && system.isDesktop;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 460,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: BusinessPalette.deep,
                  shape: AppShape.all(AppCorner.fit(800)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/icon.png',
                        width: 48,
                        height: 48,
                      ),
                      const SizedBox(height: 28),
                      if (business) ...[
                        Text(
                          appName,
                          style: BusinessText.pageTitle(
                            context,
                          ).copyWith(color: BusinessPalette.onBlue),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          l10n.businessOnboardingHeroTitle,
                          style: BusinessText.pageTitle(
                            context,
                          ).copyWith(color: BusinessPalette.onBlue),
                        ),
                        const SizedBox(height: 22),
                        for (final text in [
                          l10n.businessOnboardingFactImport,
                          l10n.businessOnboardingFactStatus,
                          l10n.businessOnboardingFactDashboard,
                        ])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '•',
                                  style: BusinessText.cardTitle(
                                    context,
                                  ).copyWith(color: BusinessPalette.onBlue),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    text,
                                    style: BusinessText.cardTitle(context)
                                        .copyWith(
                                          color: BusinessPalette
                                              .sidebarDarkSecondary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ] else ...[
                        Text(
                          appName,
                          style: AppTextStyle.title2
                              .of(context, emphasized: true)
                              .copyWith(color: BusinessPalette.onBlue),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.onboardingTitle,
                          style: AppTextStyle.title1
                              .of(context, emphasized: true)
                              .copyWith(color: BusinessPalette.onBlue),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.onboardingDescription,
                          style: AppTextStyle.body
                              .of(context)
                              .copyWith(
                                color: BusinessPalette.sidebarDarkSecondary,
                              ),
                        ),
                      ],
                      const Spacer(),
                      TextButton(
                        onPressed: () => dialogs.openUrl(userPanelUrl),
                        child: Text(
                          l10n.onboardingNoSubscription,
                          style: AppTextStyle.callout
                              .of(context)
                              .copyWith(color: const Color(0xFFFFFFFF)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 56,
                  vertical: 36,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _OnboardingSteps(activeStep: activeStep),
                    const SizedBox(height: 32),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: content,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSteps extends StatelessWidget {
  const _OnboardingSteps({required this.activeStep});

  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final labels = [
      l10n.onboardingPasteFromClipboard,
      l10n.onboardingConfirmTitle,
      l10n.onboardingConnect,
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        for (var i = 0; i < labels.length; i++)
          _OnboardingStep(index: i, activeStep: activeStep, label: labels[i]),
      ],
    );
  }
}

class _OnboardingStep extends StatelessWidget {
  const _OnboardingStep({
    required this.index,
    required this.activeStep,
    required this.label,
  });

  final int index;
  final int activeStep;
  final String label;

  @override
  Widget build(BuildContext context) {
    final selected = index == activeStep;
    final done = index < activeStep;
    final color = done
        ? const Color(0xFF0E8A5F)
        : selected
        ? context.colorScheme.primary
        : context.colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        DecoratedBox(
          decoration: ShapeDecoration(
            color: done ? color : const Color(0x00000000),
            shape: AppShape.circle,
          ),
          child: SizedBox.square(
            dimension: 26,
            child: Center(
              child: Text(
                done ? '✓' : '${index + 1}',
                style: AppTextStyle.caption1
                    .of(context, emphasized: true)
                    .copyWith(color: done ? const Color(0xFFFFFFFF) : color),
              ),
            ),
          ),
        ),
        Text(
          label,
          style: AppTextStyle.footnote.of(context).copyWith(color: color),
        ),
      ],
    );
  }
}

class _OnboardingBackdrop extends StatelessWidget {
  const _OnboardingBackdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.colorScheme.brightness == Brightness.dark;
    const blue = Color(defaultPrimaryColor);
    const cyan = Color(0xFF00C9E8);
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.9, -0.85),
                    radius: 1.05,
                    colors: [
                      blue.withValues(alpha: isDark ? 0.22 : 0.13),
                      blue.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.95, 0.7),
                      radius: 0.95,
                      colors: [
                        cyan.withValues(alpha: isDark ? 0.14 : 0.10),
                        cyan.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

Future<void> _importUrl(WidgetRef ref, String url) async {
  final onboarding = ref.read(onboardingProvider.notifier);
  final profiles = ref.read(profilesActionProvider.notifier);
  final core = ref.read(coreHandlerProvider);
  onboarding.importing();
  Profile? saved;
  try {
    saved = await profiles.importForOnboarding(url);
    final config = await core.readConfig(saved.id);
    final proxies = config['proxies'];
    final proxyCount = proxies is List ? proxies.length : 0;
    if (proxyCount == 0) {
      await profiles.deleteProfile(saved.id);
      onboarding.failed(ImportFailure.empty, url: url);
      return;
    }
    onboarding.imported(profileId: saved.id, proxyCount: proxyCount);
  } catch (error) {
    // A profile saved before the failure would surface as a stray entry once
    // the user leaves the flow.
    if (saved != null) {
      await profiles.deleteProfile(saved.id);
    }
    onboarding.failed(classifyImportError(error), url: url);
  }
}

void _finishTo(WidgetRef ref, PageLabel page) {
  ref.read(onboardingProvider.notifier).finish();
  ref.read(currentPageLabelProvider.notifier).toPage(page);
}

class _WelcomeView extends ConsumerWidget {
  const _WelcomeView();

  Future<void> _paste(BuildContext context, WidgetRef ref) async {
    final emptyMessage = context.appLocalizations.onboardingClipboardEmpty;
    String? text;
    try {
      text = (await Clipboard.getData('text/plain'))?.text?.trim();
    } catch (_) {
      text = null;
    }
    if (text == null || text.isEmpty) {
      dialogs.showBanner(emptyMessage);
      return;
    }
    final url = subscriptionUrlFromText(text);
    if (url == null) {
      ref
          .read(onboardingProvider.notifier)
          .failed(ImportFailure.notSubscription);
      return;
    }
    ref.read(onboardingProvider.notifier).confirm(url);
  }

  Future<void> _scan(BuildContext context, WidgetRef ref) async {
    String? text;
    if (system.isDesktop) {
      text = await globalState.safeRun<String?>(picker.pickerConfigQRCode);
    } else {
      text = await BaseNavigator.push<String>(context, const ScanPage());
      if (text != null && context.mounted) {
        await whenRouteUncovered(context);
      }
    }
    if (text == null) return;
    final url = subscriptionUrlFromText(text);
    if (url == null) {
      ref
          .read(onboardingProvider.notifier)
          .failed(ImportFailure.notSubscription);
      return;
    }
    ref.read(onboardingProvider.notifier).confirm(url);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (BusinessTheme.of(context) && system.isDesktop) {
      return _BusinessOnboardingImport(onScan: () => _scan(context, ref));
    }
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: SurfaceLevel.card.colorOf(colorScheme),
              shape: AppShape.all(AppCorner.fit(96)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                'assets/images/icon.png',
                width: 68,
                height: 68,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          appLocalizations.onboardingTitle,
          textAlign: TextAlign.center,
          style: AppTextStyle.title1.of(context, emphasized: true),
        ),
        const SizedBox(height: 12),
        Text(
          appLocalizations.onboardingDescription,
          textAlign: TextAlign.center,
          style: AppTextStyle.body
              .of(context)
              .copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        FilledButton(
          style: const ButtonStyle(minimumSize: Size.fromHeight(52)),
          onPressed: () => _paste(context, ref),
          child: Text(appLocalizations.onboardingPasteFromClipboard),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          style: const ButtonStyle(minimumSize: Size.fromHeight(52)),
          onPressed: () => _scan(context, ref),
          icon: const GlyphIcon(AppGlyphs.qrCode),
          label: Text(appLocalizations.onboardingScanQr),
        ),
        const SizedBox(height: 24),
        Text(
          appLocalizations.onboardingPrivacyNote,
          textAlign: TextAlign.center,
          style: AppTextStyle.footnote
              .of(context)
              .copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => dialogs.openUrl(userPanelUrl),
          child: Text(appLocalizations.onboardingNoSubscription),
        ),
      ],
    );
  }
}

class _BusinessOnboardingImport extends ConsumerStatefulWidget {
  const _BusinessOnboardingImport({required this.onScan});

  final Future<void> Function() onScan;

  @override
  ConsumerState<_BusinessOnboardingImport> createState() =>
      _BusinessOnboardingImportState();
}

class _BusinessOnboardingImportState
    extends ConsumerState<_BusinessOnboardingImport> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    final url = subscriptionUrlFromText(_controller.text.trim());
    if (url == null) {
      ref
          .read(onboardingProvider.notifier)
          .failed(ImportFailure.notSubscription);
      return;
    }
    ref.read(onboardingProvider.notifier).confirm(url);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.appLocalizations;
    final colorScheme = context.colorScheme;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colorScheme.surface,
        shape: AppShape.all(BusinessPalette.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.businessOnboardingUrlLabel,
              style: BusinessText.cardTitle(context),
            ),
            const SizedBox(height: 10),
            DecoratedBox(
              decoration: ShapeDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: AppShape.all(AppRadius.sm.topLeft.x),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: l.businessOnboardingUrlHint,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: AppTextStyle.callout
                      .of(context)
                      .copyWith(color: colorScheme.onSurface)
                      .toJetBrainsMono,
                  onSubmitted: (_) => _continue(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            BusinessPrimaryButton(
              label: l.businessOnboardingImportConnect,
              width: double.infinity,
              onPressed: _continue,
            ),
            const SizedBox(height: 12),
            BusinessSecondaryButton(
              label: l.businessOnboardingScanFile,
              width: double.infinity,
              onPressed: () => widget.onScan(),
            ),
            const SizedBox(height: 16),
            Text(
              l.onboardingPrivacyNote,
              textAlign: TextAlign.center,
              style: BusinessText.metaLabel(
                context,
              ).copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmView extends ConsumerWidget {
  const _ConfirmView({required this.url});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          appLocalizations.onboardingConfirmTitle,
          textAlign: TextAlign.center,
          style: AppTextStyle.title2.of(context, emphasized: true),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: SurfaceLevel.inset.colorOf(colorScheme),
            shape: AppShape.md,
          ),
          child: SelectableText(
            url,
            textAlign: TextAlign.center,
            style: AppTextStyle.callout
                .of(context)
                .copyWith(color: colorScheme.onSurface),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          appLocalizations.onboardingConfirmNote,
          textAlign: TextAlign.center,
          style: AppTextStyle.footnote
              .of(context)
              .copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        FilledButton(
          style: const ButtonStyle(minimumSize: Size.fromHeight(52)),
          onPressed: () => _importUrl(ref, url),
          child: Text(appLocalizations.import),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => ref.read(onboardingProvider.notifier).welcome(),
          child: Text(appLocalizations.cancel),
        ),
      ],
    );
  }
}

enum _ProgressTitle { importing, connecting, checking }

class _ProgressView extends StatelessWidget {
  const _ProgressView({required this.titleKey});

  final _ProgressTitle titleKey;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final (title, description) = switch (titleKey) {
      _ProgressTitle.importing => (
        appLocalizations.onboardingImporting,
        appLocalizations.onboardingImportingDescription,
      ),
      _ProgressTitle.connecting => (
        appLocalizations.onboardingConnecting,
        appLocalizations.onboardingConnectingDescription,
      ),
      _ProgressTitle.checking => (
        appLocalizations.onboardingCheckingInternet,
        appLocalizations.onboardingConnectingDescription,
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: ActivityIndicator(size: 44)),
        const SizedBox(height: 28),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.title2.of(context, emphasized: true),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTextStyle.body
              .of(context)
              .copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ImportedView extends ConsumerWidget {
  const _ImportedView({required this.profileId, required this.proxyCount});

  final int profileId;
  final int proxyCount;

  Future<void> _connect(BuildContext context, WidgetRef ref) async {
    if (system.isAndroid) {
      final proceed = await showSheet<bool>(
        context: context,
        builder: (_) => const _VpnAuthorizationSheet(),
      );
      if (proceed != true) return;
    }
    ref.read(onboardingProvider.notifier).connecting();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final profile = ref.watch(
      profilesProvider.select((profiles) => profiles.getProfile(profileId)),
    );
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          appLocalizations.onboardingImported(proxyCount),
          textAlign: TextAlign.center,
          style: AppTextStyle.title2.of(context, emphasized: true),
        ),
        const SizedBox(height: 20),
        OnboardingPlanCard(info: profile?.subscriptionInfo),
        const SizedBox(height: 32),
        FilledButton(
          style: const ButtonStyle(minimumSize: Size.fromHeight(52)),
          onPressed: () => _connect(context, ref),
          child: Text(appLocalizations.onboardingConnect),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => _finishTo(ref, PageLabel.dashboard),
          child: Text(appLocalizations.onboardingNotNow),
        ),
        const SizedBox(height: 8),
        Text(
          appLocalizations.onboardingPrivacyNote,
          textAlign: TextAlign.center,
          style: AppTextStyle.footnote
              .of(context)
              .copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _VpnAuthorizationSheet extends StatelessWidget {
  const _VpnAuthorizationSheet();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (context.isMobileView) const SheetDragHandle(),
            const SizedBox(height: 20),
            Text(
              appLocalizations.onboardingVpnTitle,
              textAlign: TextAlign.center,
              style: AppTextStyle.title3.of(context, emphasized: true),
            ),
            const SizedBox(height: 12),
            Text(
              appLocalizations.onboardingVpnDescription,
              textAlign: TextAlign.center,
              style: AppTextStyle.body
                  .of(context)
                  .copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 28),
            FilledButton(
              style: const ButtonStyle(minimumSize: Size.fromHeight(48)),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(appLocalizations.onboardingContinue),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(appLocalizations.onboardingNotNow),
            ),
          ],
        ),
      ),
    );
  }
}

class _FailedView extends ConsumerWidget {
  const _FailedView({required this.failure, this.url});

  final ImportFailure failure;
  final String? url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final (title, description) = switch (failure) {
      ImportFailure.expired => (
        appLocalizations.onboardingFailureExpiredTitle,
        appLocalizations.onboardingFailureExpiredDescription,
      ),
      ImportFailure.unreachable => (
        appLocalizations.onboardingFailureUnreachableTitle,
        appLocalizations.onboardingFailureUnreachableDescription,
      ),
      ImportFailure.empty => (
        appLocalizations.onboardingFailureEmptyTitle,
        appLocalizations.onboardingFailureEmptyDescription,
      ),
      ImportFailure.notSubscription => (
        appLocalizations.onboardingFailureNotSubscriptionTitle,
        appLocalizations.onboardingFailureNotSubscriptionDescription,
      ),
      ImportFailure.unknown => (
        appLocalizations.onboardingFailureUnknownTitle,
        appLocalizations.onboardingFailureUnknownDescription,
      ),
    };
    void retry() {
      final url = this.url;
      if (url == null) {
        ref.read(onboardingProvider.notifier).welcome();
      } else {
        _importUrl(ref, url);
      }
    }

    void pasteAgain() => ref.read(onboardingProvider.notifier).welcome();

    final (primaryLabel, primaryAction) = switch (failure) {
      ImportFailure.expired ||
      ImportFailure.empty ||
      ImportFailure.notSubscription => (
        appLocalizations.onboardingOpenPanel,
        () => dialogs.openUrl(userPanelUrl),
      ),
      ImportFailure.unreachable => (
        appLocalizations.onboardingViewStatus,
        () => dialogs.openUrl(statusPageUrl),
      ),
      ImportFailure.unknown => (appLocalizations.retry, retry),
    };
    final (secondaryLabel, secondaryAction) = switch (failure) {
      ImportFailure.expired || ImportFailure.notSubscription => (
        appLocalizations.onboardingPasteAgain,
        pasteAgain,
      ),
      ImportFailure.unreachable ||
      ImportFailure.empty => (appLocalizations.retry, retry),
      ImportFailure.unknown => (
        appLocalizations.onboardingPasteAgain,
        pasteAgain,
      ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: GlyphIcon(
            AppGlyphs.warning,
            size: 56,
            color: colorScheme.error,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.title2.of(context, emphasized: true),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTextStyle.body
              .of(context)
              .copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        FilledButton(
          style: const ButtonStyle(minimumSize: Size.fromHeight(52)),
          onPressed: primaryAction,
          child: Text(primaryLabel),
        ),
        const SizedBox(height: 12),
        TextButton(onPressed: secondaryAction, child: Text(secondaryLabel)),
      ],
    );
  }
}

class _BusinessFailedMobileView extends ConsumerWidget {
  const _BusinessFailedMobileView({required this.failure, this.url});

  final ImportFailure failure;
  final String? url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final step = _onboardingActiveStep(OnboardingFailed(failure, url: url));
    final profiles = ref.watch(profilesProvider);
    final profile = profiles
        .where((item) => url != null && item.url == url)
        .firstOrNull;
    final info = profile?.subscriptionInfo;
    final expiryDate = info?.expireDate;
    final title = failure == ImportFailure.expired
        ? l10n.businessOnboardingFailedExpiredTitle
        : switch (failure) {
            ImportFailure.expired => l10n.onboardingFailureExpiredTitle,
            ImportFailure.unreachable => l10n.onboardingFailureUnreachableTitle,
            ImportFailure.empty => l10n.onboardingFailureEmptyTitle,
            ImportFailure.notSubscription =>
              l10n.onboardingFailureNotSubscriptionTitle,
            ImportFailure.unknown => l10n.onboardingFailureUnknownTitle,
          };
    final description = failure == ImportFailure.expired && expiryDate != null
        ? l10n.businessOnboardingFailedExpiredDescription(expiryDate.show)
        : switch (failure) {
            ImportFailure.expired => l10n.onboardingFailureExpiredDescription,
            ImportFailure.unreachable =>
              l10n.onboardingFailureUnreachableDescription,
            ImportFailure.empty => l10n.onboardingFailureEmptyDescription,
            ImportFailure.notSubscription =>
              l10n.onboardingFailureNotSubscriptionDescription,
            ImportFailure.unknown => l10n.onboardingFailureUnknownDescription,
          };
    void retry() {
      if (url == null) {
        ref.read(onboardingProvider.notifier).welcome();
      } else {
        unawaited(_importUrl(ref, url!));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BusinessFailureProgress(step: step),
                const SizedBox(height: 40),
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: BusinessPalette.warningContainerFor(
                      colorScheme.brightness,
                    ),
                    shape: AppShape.all(18),
                  ),
                  child: const SizedBox(
                    width: 64,
                    height: 64,
                    child: Center(
                      child: GlyphIcon(
                        AppGlyphs.warningCircle,
                        size: 28,
                        color: BusinessPalette.warning,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: AppTextStyle.custom(
                    context,
                    size: 26,
                    leading: 32,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppTextStyle.custom(
                    context,
                    size: 15,
                    leading: 25,
                  ).copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                _BusinessFailureSubscriptionCard(
                  url: url,
                  profile: profile,
                  expiryDate: expiryDate,
                ),
                if (profiles.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        shape: AppShape.all(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Text(
                          l10n.businessOnboardingFailedRetainedConfig,
                          style: AppTextStyle.custom(
                            context,
                            size: 13,
                            leading: 19,
                          ).copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 12 + context.bottomInset),
          child: Column(
            children: [
              if (failure == ImportFailure.expired && userPanelUrl.isNotEmpty)
                _BusinessFailureButton(
                  label: l10n.businessOnboardingFailedRenew,
                  primary: true,
                  onPressed: () => dialogs.openUrl(userPanelUrl),
                ),
              if (failure == ImportFailure.expired && userPanelUrl.isNotEmpty)
                const SizedBox(height: 10),
              _BusinessFailureButton(
                label: l10n.businessOnboardingFailedRetry,
                onPressed: retry,
              ),
              const SizedBox(height: 2),
              TextButton(
                onPressed: () =>
                    ref.read(onboardingProvider.notifier).welcome(),
                child: Text(
                  l10n.businessOnboardingFailedChangeLink,
                  style: AppTextStyle.custom(
                    context,
                    size: 14,
                    leading: 20,
                  ).copyWith(color: colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BusinessFailureProgress extends StatelessWidget {
  const _BusinessFailureProgress({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var index = 0; index < 3; index++) ...[
              if (index > 0) const SizedBox(width: 6),
              Expanded(
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: index <= step
                        ? context.colorScheme.primary
                        : context.colorScheme.outlineVariant,
                    shape: AppShape.all(2),
                  ),
                  child: const SizedBox(height: 4),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.businessOnboardingFailedStep(step + 1, 3),
          style: BusinessText.metaLabel(
            context,
          ).copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _BusinessFailureSubscriptionCard extends StatelessWidget {
  const _BusinessFailureSubscriptionCard({
    required this.url,
    required this.profile,
    required this.expiryDate,
  });

  final String? url;
  final Profile? profile;
  final DateTime? expiryDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final info = profile?.subscriptionInfo;
    final expired = expiryDate != null && expiryDate!.isBefore(DateTime.now());
    final days = expired ? DateTime.now().difference(expiryDate!).inDays : null;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: context.colorScheme.surface,
        shape: AppShape.all(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.businessOnboardingFailedPastedUrl,
              style: BusinessText.metaLabel(
                context,
              ).copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            Text(
              url == null ? '' : maskTianjiSubscriptionUrl(url!),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.custom(context, size: 12.5, leading: 18)
                  .toJetBrainsMono
                  .copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 14),
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colorScheme.outlineVariant,
              ),
              child: const SizedBox(width: double.infinity, height: 1),
            ),
            if (info != null && profile!.label.isNotEmpty) ...[
              const SizedBox(height: 10),
              _BusinessFailureValueRow(
                label: l10n.businessOnboardingFailedPackage,
                value: profile!.label,
              ),
            ],
            if (expired && days != null) ...[
              const SizedBox(height: 8),
              _BusinessFailureValueRow(
                label: l10n.businessOnboardingFailedStatus,
                value: l10n.businessOnboardingFailedDays(days),
                valueColor: BusinessPalette.warningForegroundFor(
                  context.colorScheme.brightness,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BusinessFailureValueRow extends StatelessWidget {
  const _BusinessFailureValueRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: AppTextStyle.subheadline
              .of(context)
              .copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      ),
      Text(
        value,
        style: AppTextStyle.custom(
          context,
          size: 14,
          leading: 20,
          weight: FontWeight.w600,
        ).copyWith(color: valueColor ?? context.colorScheme.onSurface),
      ),
    ],
  );
}

class _BusinessFailureButton extends StatelessWidget {
  const _BusinessFailureButton({
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final shape = AppShape.all(14);
    if (primary) {
      return FilledButton(
        onPressed: onPressed,
        style: ButtonStyle.from(
          backgroundColor: Colors.transparent,
          foregroundColor: BusinessPalette.onBlue,
          shape: shape,
          fixedSize: const Size(double.infinity, 54),
          minimumSize: const Size(double.infinity, 54),
          maximumSize: const Size(double.infinity, 54),
          padding: EdgeInsets.zero,
          tapTargetSize: TapTargetSize.shrinkWrap,
          backgroundBuilder: (context, states, child) => DecoratedBox(
            decoration: ShapeDecoration(
              gradient: BusinessPalette.gradient(context.colorScheme),
              shape: shape,
            ),
            child: child,
          ),
        ),
        child: Text(
          label,
          style: BusinessText.actionLabel(
            context,
          ).copyWith(color: BusinessPalette.onBlue),
        ),
      );
    }
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle.from(
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.onSurface,
        shape: shape,
        fixedSize: const Size(double.infinity, 54),
        minimumSize: const Size(double.infinity, 54),
        maximumSize: const Size(double.infinity, 54),
        padding: EdgeInsets.zero,
        tapTargetSize: TapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: BusinessText.actionLabel(context)),
    );
  }
}

int _onboardingActiveStep(OnboardingState state) => switch (state) {
  OnboardingWelcome() || OnboardingDone() => 0,
  OnboardingConfirm() || OnboardingImporting() || OnboardingFailed() => 1,
  _ => 2,
};

class _ConnectView extends ConsumerStatefulWidget {
  const _ConnectView();

  @override
  ConsumerState<_ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends ConsumerState<_ConnectView>
    with ProbeStartHold<_ConnectView> {
  late final OutboundIpProbe _probe;
  var _started = false;

  @override
  void initState() {
    super.initState();
    _probe = ref.read(outboundIpProbeProvider.notifier)..watch(routedOutbound);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && ref.read(onboardingProvider) is OnboardingConnecting) {
        _start();
      }
    });
  }

  @override
  void dispose() {
    _probe.unwatch(routedOutbound);
    super.dispose();
  }

  Future<void> _start() async {
    if (_started) return;
    _started = true;
    final onboarding = ref.read(onboardingProvider.notifier);
    try {
      final applied = await ref
          .read(setupActionProvider.notifier)
          .setRunning(true);
      if (!mounted) return;
      if (applied) {
        onboarding.connected();
      } else {
        onboarding.connectFailed();
        dialogs.showBanner(
          context.appLocalizations.onboardingConnectFailed,
          level: BannerLevel.error,
        );
      }
    } catch (error) {
      if (!mounted) return;
      onboarding.connectFailed();
      dialogs.showBanner(
        userFacingErrorMessage(error, currentAppLocalizations),
        level: BannerLevel.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final entry = ref.watch(
      outboundIpProbeProvider.select(
        (probes) => probes.entryOf(routedOutbound),
      ),
    );
    if (state is OnboardingConnecting) {
      return const _ProgressView(titleKey: _ProgressTitle.connecting);
    }
    final ipInfo = entry.value;
    final phase = shownPhase(entry);
    if (phase == ProbePhase.failed && ipInfo == null) {
      return const _ConnectFailedView();
    }
    if (phase == ProbePhase.fresh && ipInfo != null) {
      return _ConnectSuccessView(ipInfo: ipInfo);
    }
    return const _ProgressView(titleKey: _ProgressTitle.checking);
  }
}

class _ConnectSuccessView extends ConsumerWidget {
  const _ConnectSuccessView({required this.ipInfo});

  final IpInfo ipInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final countryCode = ipInfo.countryCode.toUpperCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: GlyphIcon(
            AppGlyphs.checkCircle,
            size: 60,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          appLocalizations.onboardingConnected,
          textAlign: TextAlign.center,
          style: AppTextStyle.title2.of(context, emphasized: true),
        ),
        if (countryCode.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: ShapeDecoration(
              color: SurfaceLevel.card.colorOf(colorScheme),
              shape: AppShape.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    appLocalizations.onboardingExit,
                    style: AppTextStyle.subheadline
                        .of(context)
                        .copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
                Text(
                  '${countryCode.countryFlagEmoji} $countryCode',
                  style: AppTextStyle.subheadline
                      .of(context, emphasized: true)
                      .copyWith(color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          appLocalizations.onboardingInternetVerified,
          textAlign: TextAlign.center,
          style: AppTextStyle.body
              .of(context)
              .copyWith(color: colorScheme.primary),
        ),
        const SizedBox(height: 32),
        FilledButton(
          style: const ButtonStyle(minimumSize: Size.fromHeight(52)),
          onPressed: () => _finishTo(ref, PageLabel.dashboard),
          child: Text(appLocalizations.done),
        ),
      ],
    );
  }
}

class _ConnectFailedView extends ConsumerWidget {
  const _ConnectFailedView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: GlyphIcon(
            AppGlyphs.warning,
            size: 60,
            color: colorScheme.error,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          appLocalizations.onboardingConnectedNoInternet,
          textAlign: TextAlign.center,
          style: AppTextStyle.title2.of(context, emphasized: true),
        ),
        const SizedBox(height: 12),
        Text(
          appLocalizations.onboardingNodeUnavailable,
          textAlign: TextAlign.center,
          style: AppTextStyle.body
              .of(context)
              .copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 32),
        FilledButton(
          style: const ButtonStyle(minimumSize: Size.fromHeight(52)),
          onPressed: () => _finishTo(ref, PageLabel.proxies),
          child: Text(appLocalizations.onboardingSwitchNode),
        ),
      ],
    );
  }
}
