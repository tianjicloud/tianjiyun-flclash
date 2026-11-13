import 'dart:async';
import 'dart:ffi' show Abi;
import 'dart:io';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/business_brand_mark.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/widgets/update_status.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/backup_and_restore.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;
import 'package:fl_clash/views/disclaimer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class Contributor {
  final String avatar;
  final String name;

  const Contributor({required this.avatar, required this.name});
}

class AboutView extends ConsumerWidget {
  const AboutView({super.key, this.business = false});

  final bool business;

  static const _contributors = [
    Contributor(avatar: 'assets/images/avatar/june2.jpg', name: 'June2'),
    Contributor(avatar: 'assets/images/avatar/arue.jpg', name: 'Arue'),
  ];

  Future<void> _checkUpdate(BuildContext context, WidgetRef ref) async {
    if (ref.read(loadingProvider(LoadingTag.checkUpdate))) return;
    final commonAction = ref.read(commonActionProvider.notifier);
    final result = await globalState.loadingRun(
      () async => (release: await request.checkForUpdate()),
      title: context.appLocalizations.checkUpdate,
      tag: LoadingTag.checkUpdate,
    );
    if (result == null) return;
    ref.read(updateCheckResultProvider.notifier).record(result.release == null);
    unawaited(
      commonAction.checkUpdateResultHandle(data: result.release, isUser: true),
    );
  }

  Widget _buildLinkItem({
    required Glyph glyph,
    required String title,
    required String url,
    required String label,
  }) {
    return ListItem(
      leading: _LinkBadge(glyph: glyph),
      title: Text(title),
      subtitle: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const GlyphIcon(AppGlyphs.openExternal),
      onTap: () {
        dialogs.openUrl(url);
      },
    );
  }

  Widget _buildBusinessLink(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) => ListItem(
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: const DisclosureIndicator(),
    onTap: onTap,
  );

  Widget _buildBusinessPage(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations appLocalizations,
    bool isLoading,
  ) {
    final version = globalState.packageInfo.version;
    final download = ref.watch(updateDownloadStateProvider);
    final updateTag = download?.tag;
    final upToDate = ref.watch(updateCheckResultProvider) == true;
    final hasUpdate =
        updateTag != null &&
        compareVersions(updateTag.replaceFirst(RegExp(r'^v'), ''), version) > 0;
    final platform = Platform.isWindows ? 'Windows' : Platform.operatingSystem;
    final architecture = Abi.current()
        .toString()
        .split('.')
        .last
        .split('_')
        .last;
    final links = [
      _buildBusinessLink(
        context,
        title: appLocalizations.businessAboutPanel,
        subtitle: userPanelUrl,
        onTap: () => dialogs.openUrl(userPanelUrl),
      ),
      _buildBusinessLink(
        context,
        title: appLocalizations.serviceStatus,
        subtitle: statusPageUrl,
        onTap: () => dialogs.openUrl(statusPageUrl),
      ),
      _buildBusinessLink(
        context,
        title: appLocalizations.businessContactSupport,
        subtitle: supportEmail,
        onTap: () => dialogs.openUrl('mailto:$supportEmail'),
      ),
      _buildBusinessLink(
        context,
        title: appLocalizations.project,
        subtitle: 'github.com/$repository',
        onTap: () => dialogs.openUrl('https://github.com/$repository'),
      ),
      _buildBusinessLink(
        context,
        title: appLocalizations.core,
        subtitle: 'github.com/chen08209/Clash.Meta',
        onTap: () => dialogs.openUrl(
          'https://github.com/chen08209/Clash.Meta/tree/FlClash',
        ),
      ),
      _buildBusinessLink(
        context,
        title: 'FlClash',
        subtitle: 'github.com/chen08209/FlClash',
        onTap: () => dialogs.openUrl('https://github.com/chen08209/FlClash'),
      ),
    ];
    return ListView(
      padding: EdgeInsets.only(left: 40, bottom: context.bottomInset + 20),
      children: [
        BusinessSettingsCard(
          title: appLocalizations.about,
          trailing: BusinessSecondaryButton(
            label: appLocalizations.checkUpdate,
            width: 96,
            onPressed: isLoading ? null : () => _checkUpdate(context, ref),
          ),
          items: [
            ListItem(
              minVerticalPadding: 16,
              leading: const BusinessBrandMark(size: 64),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appName,
                    style: AppTextStyle.title3.of(context, emphasized: true),
                  ),
                  Text(
                    'TIANJI CLOUD',
                    style: AppTextStyle.caption1
                        .of(context)
                        .copyWith(letterSpacing: 2),
                  ),
                ],
              ),
              subtitle: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${appLocalizations.businessClientVersion} ',
                    ),
                    TextSpan(
                      text: version,
                      style: AppTextStyle.subheadline
                          .of(context)
                          .toJetBrainsMono,
                    ),
                    TextSpan(text: ' · $platform $architecture · mihomo'),
                  ],
                ),
              ),
              trailing: hasUpdate
                  ? Text(
                      appLocalizations.businessUpdateAvailable(
                        updateTag.replaceFirst(RegExp(r'^v'), ''),
                      ),
                      style: AppTextStyle.caption1
                          .of(context)
                          .copyWith(
                            color: BusinessPalette.warningForegroundFor(
                              context.colorScheme.brightness,
                            ),
                          ),
                    )
                  : null,
            ),
            if (upToDate)
              ListItem(
                title: Text(appLocalizations.alreadyLatest),
                leading: const GlyphIcon(AppGlyphs.checkCircle),
              ),
          ],
        ),
        const SizedBox(height: 14),
        const _LastBackupItem(),
        BusinessSettingsCard(title: appLocalizations.more, items: links),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: appLocalizations.disclaimer,
          items: [
            _buildBusinessLink(
              context,
              title: appLocalizations.disclaimerPrivacyTitle,
              subtitle: appLocalizations.disclaimerLicenseTitle,
              onTap: () => BaseNavigator.push(context, const DisclaimerView()),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final isLoading = ref.watch(loadingProvider(LoadingTag.checkUpdate));
    if (business) {
      if (ref.watch(isMobileViewProvider)) {
        return _buildBusinessMobile(
          context,
          ref,
          appLocalizations,
          globalState.packageInfo.version,
          isLoading,
        );
      }
      return _buildBusinessPage(context, ref, appLocalizations, isLoading);
    }
    return Scaffold(
      isLoading: isLoading,
      title: appLocalizations.about,
      actions: const [UpdateStatusButton()],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
          top: context.contentTopPadding,
          bottom: 32 + context.bottomInset,
        ),
        children: [
          _AboutHero(
            isCheckingUpdate: isLoading,
            onCheckUpdate: () {
              _checkUpdate(context, ref);
            },
            onEnterDeveloperMode: () {
              ref
                  .read(appSettingProvider.notifier)
                  .update((state) => state.copyWith(developerMode: true));
              dialogs.showBanner(
                appLocalizations.developerModeEnableTip,
                level: BannerLevel.success,
              );
            },
          ),
          const SizedBox(height: 8),
          generateSection(
            title: appLocalizations.more,
            items: [
              _buildLinkItem(
                glyph: AppGlyphs.code,
                title: appLocalizations.profiles,
                url: userPanelUrl,
                label: 'panel.tianjiyun.org',
              ),
              _buildLinkItem(
                glyph: AppGlyphs.code,
                title: appLocalizations.serviceStatus,
                url: statusPageUrl,
                label: 'status.tianjiyun.org',
              ),
              _buildLinkItem(
                glyph: AppGlyphs.code,
                title: appLocalizations.businessContactSupport,
                url: 'mailto:$supportEmail',
                label: supportEmail,
              ),
              _buildLinkItem(
                glyph: AppGlyphs.code,
                title: appLocalizations.project,
                url: 'https://github.com/$repository',
                label: 'github.com/$repository',
              ),
              _buildLinkItem(
                glyph: AppGlyphs.cpu,
                title: appLocalizations.core,
                url: 'https://github.com/chen08209/Clash.Meta/tree/FlClash',
                label: 'github.com/chen08209/Clash.Meta',
              ),
              _buildLinkItem(
                glyph: AppGlyphs.code,
                title: 'FlClash',
                url: 'https://github.com/chen08209/FlClash',
                label: 'github.com/chen08209/FlClash',
              ),
            ],
          ),
          generateSection(
            title: appLocalizations.otherContributors,
            items: [
              for (final contributor in _contributors)
                ListItem(
                  leading: Container(
                    width: 40,
                    height: 40,
                    foregroundDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(contributor.avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colorScheme.primaryContainer,
                    ),
                  ),
                  title: Text(contributor.name),
                  subtitle: Text(appLocalizations.appIconDesign),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessMobile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String version,
    bool isLoading,
  ) {
    final architecture = Abi.current()
        .toString()
        .split('.')
        .last
        .split('_')
        .last;
    final update = ref.watch(updateDownloadStateProvider);
    final updateLabel = switch (update) {
      UpdateReady() => l10n.updateReady,
      UpdateDownloading() => l10n.downloadingUpdate,
      null => isLoading ? l10n.loading : null,
    };
    const backupPage = BackupAndRestore();
    return BaseScaffold(
      title: l10n.businessAboutBackupTitle,
      body: ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: context.sectionsTopPadding,
          bottom: context.bottomInset + 20,
        ),
        children: [
          BusinessSettingsCard(
            items: [
              ListItem(
                minVerticalPadding: 14,
                leading: const BusinessBrandMark(size: 64),
                title: Text(
                  appName,
                  style: AppTextStyle.title3.of(context, emphasized: true),
                ),
                subtitle: Text(
                  '${l10n.businessVersion} $version · $architecture',
                  style: AppTextStyle.caption1
                      .of(context)
                      .copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
                trailing: updateLabel == null
                    ? null
                    : Text(
                        updateLabel,
                        style: AppTextStyle.caption1
                            .of(context)
                            .copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BusinessSettingsCard(
            title: l10n.backupAndRestore,
            items: [
              ListItem.open(
                title: Text(l10n.businessWebDavBackup),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.businessBackupNow),
                    const SizedBox(width: 4),
                    const DisclosureIndicator(),
                  ],
                ),
                widget: backupPage,
              ),
              ListItem.open(
                title: Text(l10n.businessLocalExport),
                widget: backupPage,
              ),
              ListItem.open(
                title: Text(l10n.businessRestoreFromFileWebDav),
                widget: backupPage,
              ),
            ],
          ),
          const SizedBox(height: 14),
          BusinessSettingsCard(
            title: l10n.businessHelp,
            items: [
              ListItem(
                title: Text(l10n.businessAboutPanel),
                trailing: const DisclosureIndicator(),
                onTap: () => dialogs.openUrl(userPanelUrl),
              ),
              ListItem(
                title: Text(l10n.serviceStatus),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.businessServiceNoLogin),
                    const SizedBox(width: 4),
                    const DisclosureIndicator(),
                  ],
                ),
                onTap: () => dialogs.openUrl(statusPageUrl),
              ),
              ListItem(
                title: Text(l10n.businessContactSupport),
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(supportEmail),
                    SizedBox(width: 4),
                    DisclosureIndicator(),
                  ],
                ),
                onTap: () => dialogs.openUrl('mailto:$supportEmail'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          BusinessSettingsCard(
            title: l10n.businessLegal,
            items: [
              ListItem.open(
                title: Text(l10n.disclaimer),
                widget: const DisclaimerView(),
              ),
              ListItem.open(
                title: Text(l10n.businessPrivacyTerms),
                widget: const DisclaimerView(),
              ),
              ListItem(
                title: Text(l10n.businessOpenSource),
                subtitle: Text(l10n.businessOpenSourceDescription),
                trailing: const DisclosureIndicator(),
                onTap: () => dialogs.openUrl('https://github.com/$repository'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LastBackupItem extends StatelessWidget {
  const _LastBackupItem();

  @override
  Widget build(BuildContext context) => FutureBuilder<int?>(
    future: preferences.getLastBackupAt(),
    builder: (context, snapshot) {
      final value = snapshot.data;
      if (value == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: BusinessSettingsCard(
          items: [
            ListItem(
              title: Text(context.appLocalizations.lastBackupTime),
              subtitle: Text(DateTime.fromMillisecondsSinceEpoch(value).show),
            ),
          ],
        ),
      );
    },
  );
}

class _AboutHero extends StatelessWidget {
  final bool isCheckingUpdate;
  final VoidCallback onCheckUpdate;
  final VoidCallback onEnterDeveloperMode;

  const _AboutHero({
    required this.isCheckingUpdate,
    required this.onCheckUpdate,
    required this.onEnterDeveloperMode,
  });

  static const _logoSize = 96.0;
  static const _logoInset = 14.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final appLocalizations = context.appLocalizations;
    final logo = _DeveloperModeDetector(
      onEnterDeveloperMode: onEnterDeveloperMode,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: context.raisedSurfaceLevel.colorOf(colorScheme),
          shape: AppShape.all(AppCorner.fit(_logoSize)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(_logoInset),
          child: Image.asset(
            'assets/images/icon.png',
            width: _logoSize - _logoInset * 2,
            height: _logoSize - _logoInset * 2,
          ),
        ),
      ),
    );
    final details = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(appName, style: AppTextStyle.title2.of(context, emphasized: true)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _Pill(
              label: 'v${globalState.packageInfo.version}',
              color: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            _Pill(
              label: 'GPL-3.0',
              color: context.raisedSurfaceLevel.colorOf(colorScheme),
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            appLocalizations.desc,
            textAlign: TextAlign.center,
            style: AppTextStyle.subheadline
                .of(context)
                .copyWith(color: colorScheme.onSurfaceVariant, height: 1.5),
          ),
        ),
        const SizedBox(height: 20),
        TonalButton(
          size: TonalButtonSize.bar,
          glyph: AppGlyphs.sync,
          label: appLocalizations.checkUpdate,
          onPressed: isCheckingUpdate ? null : onCheckUpdate,
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: LayoutBuilder(
        builder: (context, constraints) => constraints.maxWidth >= 720
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24,
                children: [
                  logo,
                  Flexible(child: details),
                ],
              )
            : Column(children: [logo, const SizedBox(height: 20), details]),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final Color foregroundColor;

  const _Pill({
    required this.label,
    required this.color,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(color: color, shape: AppShape.full),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          label,
          style: AppTextStyle.caption1
              .of(context, emphasized: true)
              .copyWith(color: foregroundColor),
        ),
      ),
    );
  }
}

class _LinkBadge extends StatelessWidget {
  final Glyph glyph;

  const _LinkBadge({required this.glyph});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: context.raisedSurfaceLevel.colorOf(colorScheme),
        shape: AppShape.md,
      ),
      child: SizedBox.square(
        dimension: 40,
        child: Center(
          child: GlyphIcon(
            glyph,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _DeveloperModeDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onEnterDeveloperMode;

  const _DeveloperModeDetector({
    required this.child,
    required this.onEnterDeveloperMode,
  });

  @override
  State<_DeveloperModeDetector> createState() => _DeveloperModeDetectorState();
}

class _DeveloperModeDetectorState extends State<_DeveloperModeDetector> {
  int _counter = 0;
  Timer? _timer;

  void _handleTap() {
    _counter++;
    if (_counter >= 5) {
      widget.onEnterDeveloperMode();
      _resetCounter();
    } else {
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 1), _resetCounter);
    }
  }

  void _resetCounter() {
    _counter = 0;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: _handleTap, child: widget.child);
  }
}
