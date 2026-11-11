import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/action.dart';
import 'package:fl_clash/providers/app.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/config/general.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeveloperView extends ConsumerWidget {
  const DeveloperView({super.key, this.business = false});

  final bool business;

  Widget _getDeveloperList(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    return generateSection(
      title: appLocalizations.options,
      items: [
        ListItem(
          title: Text(appLocalizations.messageTest),
          onTap: () {
            for (final level in BannerLevel.values) {
              dialogs.showBanner(
                '${level.name}: ${appLocalizations.messageTestTip}',
                level: level,
              );
            }
          },
        ),
        ListItem(
          title: Text(appLocalizations.logsTest),
          onTap: () {
            for (int i = 0; i < 1000; i++) {
              ref
                  .read(logsProvider.notifier)
                  .add(
                    Log.app(
                      '[$i]${generateRandomString(maxLength: 200, minLength: 20)}',
                    ),
                  );
            }
          },
        ),
        if (globalState.canCrashCore)
          ListItem(
            title: Text(appLocalizations.crashTest),
            onTap: () async {
              final coreAction = ref.read(coreActionProvider.notifier);
              final res = await dialogs.showMessage(
                message: TextSpan(text: appLocalizations.confirmForceCrashCore),
                destructive: true,
              );
              if (res != true) {
                return;
              }
              unawaited(coreAction.crash());
            },
          ),
        if (selfUpdateSuffix != null)
          ListItem(
            title: Text(appLocalizations.updateDownloadTest),
            onTap: () {
              if (ref.read(loadingProvider(LoadingTag.checkUpdate))) return;
              unawaited(
                ref.read(commonActionProvider.notifier).testUpdateDownload(),
              );
            },
          ),
        ListItem(
          title: Text(appLocalizations.clearData),
          onTap: () async {
            final storeAction = ref.read(storeActionProvider.notifier);
            final res = await dialogs.showMessage(
              message: TextSpan(text: appLocalizations.confirmClearAllData),
              destructive: true,
              confirmText: appLocalizations.clearData,
            );
            if (res != true) {
              return;
            }
            await storeAction.handleClear();
          },
        ),
        ListItem(
          title: Text(appLocalizations.pruneCache),
          onTap: () async {
            await ref.read(storeActionProvider.notifier).shakingStore();
          },
        ),
      ],
    );
  }

  Widget _buildBusiness(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final externalController = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.externalController == ExternalControllerStatus.open,
      ),
    );
    return ListView(
      padding: EdgeInsets.only(left: 40, bottom: context.bottomInset + 20),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            l10n.businessDeveloperOptionsTitle,
            style: BusinessText.pageTitle(context),
          ),
        ),
        BusinessWarningBanner(
          message: l10n.businessDeveloperOptionsDescription,
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.logLevel,
          items: [
            const LogLevelItem(),
            ConfigToggleItem(
              title: (l) => l.logcat,
              selector: appSettingProvider.select((state) => state.openLogs),
              onChanged: (ref, value) => ref
                  .read(appSettingProvider.notifier)
                  .update((state) => state.copyWith(openLogs: value)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.externalController,
          items: [
            ConfigToggleItem(
              title: (l) => l.externalController,
              selector: patchClashConfigProvider.select(
                (state) =>
                    state.externalController == ExternalControllerStatus.open,
              ),
              onChanged: (ref, value) => ref
                  .read(patchClashConfigProvider.notifier)
                  .update(
                    (state) => state
                        .copyWith(
                          externalController: value
                              ? ExternalControllerStatus.open
                              : ExternalControllerStatus.close,
                        )
                        .ensureControllerSecret(),
                  ),
            ),
            if (externalController) const ExternalControllerSecretItem(),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.developerMode,
          items: [
            ListItem.toggle(
              title: Text(l10n.developerMode),
              value: ref.watch(
                appSettingProvider.select((state) => state.developerMode),
              ),
              onChanged: (value) => ref
                  .read(appSettingProvider.notifier)
                  .update((state) => state.copyWith(developerMode: value)),
            ),
            ListItem(
              title: Text(l10n.messageTest),
              onTap: () {
                for (final level in BannerLevel.values) {
                  dialogs.showBanner(
                    '${level.name}: ${l10n.messageTestTip}',
                    level: level,
                  );
                }
              },
            ),
            ListItem(
              title: Text(l10n.logsTest),
              onTap: () {
                for (int i = 0; i < 1000; i++) {
                  ref
                      .read(logsProvider.notifier)
                      .add(
                        Log.app(
                          '[$i]${generateRandomString(maxLength: 200, minLength: 20)}',
                        ),
                      );
                }
              },
            ),
            if (selfUpdateSuffix != null)
              ListItem(
                title: Text(l10n.updateDownloadTest),
                trailing: BusinessSecondaryButton(
                  label: l10n.updateDownloadTest,
                  width: 64,
                  onPressed: ref.read(loadingProvider(LoadingTag.checkUpdate))
                      ? null
                      : () => unawaited(
                          ref
                              .read(commonActionProvider.notifier)
                              .testUpdateDownload(),
                        ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.clearData,
          items: [
            if (globalState.canCrashCore)
              ListItem(
                title: Text(l10n.crashTest),
                trailing: BusinessSecondaryButton(
                  label: l10n.crashTest,
                  width: 64,
                  labelColor: context.colorScheme.error,
                  onPressed: () async {
                    final result = await dialogs.showMessage(
                      message: TextSpan(text: l10n.confirmForceCrashCore),
                      destructive: true,
                    );
                    if (result == true) {
                      unawaited(ref.read(coreActionProvider.notifier).crash());
                    }
                  },
                ),
              ),
            ListItem(
              title: Text(l10n.clearData),
              trailing: BusinessSecondaryButton(
                label: l10n.clearData,
                width: 84,
                labelColor: context.colorScheme.error,
                onPressed: () async {
                  final result = await dialogs.showMessage(
                    message: TextSpan(text: l10n.confirmClearAllData),
                    destructive: true,
                    confirmText: l10n.clearData,
                  );
                  if (result == true) {
                    await ref.read(storeActionProvider.notifier).handleClear();
                  }
                },
              ),
            ),
            ListItem(
              title: Text(l10n.pruneCache),
              trailing: BusinessSecondaryButton(
                label: l10n.pruneCache,
                width: 72,
                labelColor: context.colorScheme.error,
                onPressed: () =>
                    ref.read(storeActionProvider.notifier).shakingStore(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final enable = ref.watch(
      appSettingProvider.select((state) => state.developerMode),
    );
    if (business) {
      return _buildBusiness(context, ref);
    }
    return BaseScaffold(
      title: appLocalizations.developerMode,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
          top: context.sectionsTopPadding,
          bottom: 16 + context.bottomInset,
        ),
        children: [
          generateSection(
            items: [
              ListItem.toggle(
                title: Text(appLocalizations.developerMode),
                value: enable,
                onChanged: (value) {
                  ref
                      .read(appSettingProvider.notifier)
                      .update((state) => state.copyWith(developerMode: value));
                },
              ),
            ],
          ),
          _getDeveloperList(context, ref),
        ],
      ),
    );
  }
}
