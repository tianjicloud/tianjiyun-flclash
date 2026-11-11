import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/views/config/override.dart';
import 'package:fl_clash/views/config/user_agents.dart';
import 'package:fl_clash/views/theme_choices.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'general/overrides.dart';
part 'general/port_form.dart';

class LogLevelItem extends ConsumerWidget {
  const LogLevelItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return ConfigOptionsItem<LogLevel>(
      title: (l) => l.logLevel,
      options: LogLevel.values,
      textBuilder: (logLevel) => logLevel.name,
      selector: patchClashConfigProvider.select((state) => state.logLevel),
      onChanged: (ref, value) => ref
          .read(patchClashConfigProvider.notifier)
          .update((state) => state.copyWith(logLevel: value)),
    );
  }
}

class UaItem extends ConsumerWidget {
  const UaItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final globalUa = ref.watch(
      patchClashConfigProvider.select((state) => state.globalUa),
    );
    return ListItem.open(
      title: Text(appLocalizations.userAgent),
      subtitle: Text(globalUa ?? appLocalizations.defaultText),
      widget: const UserAgentsView(),
    );
  }
}

class DelayTestTimeoutItem extends ConsumerWidget {
  const DelayTestTimeoutItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return ConfigOptionsItem<int>(
      title: (l) => l.delayTestTimeout,
      options: delayTestTimeoutOptions,
      textBuilder: (value) => '$value ms',
      selector: appSettingProvider.select((state) => state.delayTestTimeout),
      onChanged: (ref, value) => ref
          .read(appSettingProvider.notifier)
          .update((state) => state.copyWith(delayTestTimeout: value)),
    );
  }
}

class PortItem extends ConsumerWidget {
  const PortItem({super.key});

  Future<void> handleShowPortForm(BuildContext context) async {
    await showFormSheet<void>(
      context: context,
      builder: (_) => const _PortForm(),
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final mixedPort = ref.watch(
      patchClashConfigProvider.select((state) => state.mixedPort),
    );
    return ListItem(
      title: Text(appLocalizations.port),
      subtitle: Text('$mixedPort'),
      onTap: () {
        handleShowPortForm(context);
      },
    );
  }
}

class HostsItem extends ConsumerWidget {
  const HostsItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final hosts = ref.watch(
      patchClashConfigProvider.select((state) => state.hosts),
    );
    return ListItem.open(
      title: const Text('Hosts'),
      subtitle: Text(
        hosts.isEmpty
            ? appLocalizations.none
            : appLocalizations.itemsCount(hosts.length),
      ),
      widget: MapEditView(
        title: 'Hosts',
        entries: hosts,
        keyMaxLength: TextInputLimits.domain,
        valueMaxLength: TextInputLimits.hostValue,
        titleBuilder: (item) => Text(item.key),
        subtitleBuilder: (item) => Text(item.value),
      ),
      onChanged: (value) {
        if (value is! Map<String, String>) {
          return;
        }
        ref
            .read(patchClashConfigProvider.notifier)
            .update((state) => state.copyWith(hosts: value));
      },
    );
  }
}

class AuthenticationItem extends ConsumerWidget {
  const AuthenticationItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return ConfigToggleItem(
      title: (l) => l.authentication,
      selector: networkSettingProvider.select(
        (state) => state.authentication.enable,
      ),
      onChanged: (ref, value) =>
          ref.read(networkSettingProvider.notifier).update((state) {
            var authentication = state.authentication.copyWith(enable: value);
            if (value && authentication.username.isEmpty) {
              authentication = authentication.copyWith(
                username: generateRandomSecret(8),
                password: generateRandomSecret(16),
              );
            }
            return state.copyWith(authentication: authentication);
          }),
    );
  }
}

class AuthenticationAccountItem extends ConsumerWidget {
  const AuthenticationAccountItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return ConfigTextItem(
      title: (l) => l.account,
      maxLength: TextInputLimits.userName,
      selector: networkSettingProvider.select(
        (state) => state.authentication.username,
      ),
      // mihomo and the Dart proxy string both split user:pass on the first
      // colon, so a colon in the username breaks authentication.
      normalize: (value) => value.trim().replaceAll(':', ''),
      onChanged: (ref, value) => ref
          .read(networkSettingProvider.notifier)
          .update((state) => state.copyWith.authentication(username: value)),
    );
  }
}

class AuthenticationPasswordItem extends ConsumerWidget {
  const AuthenticationPasswordItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return ConfigTextItem(
      title: (l) => l.password,
      maxLength: TextInputLimits.password,
      selector: networkSettingProvider.select(
        (state) => state.authentication.password,
      ),
      normalize: (value) => value.trim(),
      onChanged: (ref, value) => ref
          .read(networkSettingProvider.notifier)
          .update((state) => state.copyWith.authentication(password: value)),
    );
  }
}

class ExternalControllerSecretItem extends ConsumerWidget {
  const ExternalControllerSecretItem({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return ConfigTextItem(
      title: (l) => l.externalControllerSecret,
      maxLength: TextInputLimits.password,
      selector: patchClashConfigProvider.select((state) => state.secret),
      normalize: (value) => value.trim(),
      onChanged: (ref, value) => ref
          .read(patchClashConfigProvider.notifier)
          .update((state) => state.copyWith(secret: value)),
    );
  }
}

ConfigToggleItem _clashToggle({
  required ConfigLabel title,
  required bool Function(PatchClashConfig state) select,
  required PatchClashConfig Function(PatchClashConfig state, bool value) update,
}) {
  return ConfigToggleItem(
    title: title,
    selector: patchClashConfigProvider.select(select),
    onChanged: (ref, value) => ref
        .read(patchClashConfigProvider.notifier)
        .update((state) => update(state, value)),
  );
}

ConfigToggleItem _appSettingToggle({
  required ConfigLabel title,
  required bool Function(AppSettingProps state) select,
  required AppSettingProps Function(AppSettingProps state, bool value) update,
}) {
  return ConfigToggleItem(
    title: title,
    selector: appSettingProvider.select(select),
    onChanged: (ref, value) => ref
        .read(appSettingProvider.notifier)
        .update((state) => update(state, value)),
  );
}

class GeneralView extends ConsumerWidget {
  const GeneralView({super.key});

  Widget _toggle({
    required ConfigLabel title,
    required bool Function(AppSettingProps state) select,
    required AppSettingProps Function(AppSettingProps state, bool value) update,
  }) => _appSettingToggle(title: title, select: select, update: update);

  List<Widget> _inboundItems({
    required bool authentication,
    required bool externalController,
  }) => [
    const PortItem(),
    _clashToggle(
      title: (l) => l.allowLan,
      select: (state) => state.allowLan,
      update: (state, value) => state.copyWith(allowLan: value),
    ),
    _clashToggle(
      title: (l) => l.externalController,
      select: (state) =>
          state.externalController == ExternalControllerStatus.open,
      update: (state, value) => state
          .copyWith(
            externalController: value
                ? ExternalControllerStatus.open
                : ExternalControllerStatus.close,
          )
          .ensureControllerSecret(),
    ),
    if (externalController) const ExternalControllerSecretItem(),
    const AuthenticationItem(),
    if (authentication) ...const [
      AuthenticationAccountItem(),
      AuthenticationPasswordItem(),
    ],
  ];

  List<Widget> _connectionItems() => [
    const DelayTestTimeoutItem(),
    _clashToggle(
      title: (l) => l.findProcessMode,
      select: (state) => state.findProcessMode == FindProcessMode.always,
      update: (state, value) => state.copyWith(
        findProcessMode: value ? FindProcessMode.always : FindProcessMode.off,
      ),
    ),
    _toggle(
      title: (l) => l.autoCloseConnections,
      select: (state) => state.closeConnections,
      update: (state, value) => state.copyWith(closeConnections: value),
    ),
    _toggle(
      title: (l) => l.onlyStatisticsProxy,
      select: (state) => state.onlyStatisticsProxy,
      update: (state, value) => state.copyWith(onlyStatisticsProxy: value),
    ),
  ];

  List<Widget> _coreItems() => [
    const HostsItem(key: ValueKey(#hosts)),
    ConfigToggleItem(
      key: const ValueKey(#appendSystemDns),
      title: (l) => l.appendSystemDns,
      selector: networkSettingProvider.select((state) => state.appendSystemDns),
      onChanged: (ref, value) => ref
          .read(networkSettingProvider.notifier)
          .update((state) => state.copyWith(appendSystemDns: value)),
    ),
  ];

  List<Widget> _logItems() => [
    const LogLevelItem(),
    _toggle(
      title: (l) => l.logcat,
      select: (state) => state.openLogs,
      update: (state, value) => state.copyWith(openLogs: value),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final authentication = ref.watch(
      networkSettingProvider.select((state) => state.authentication.enable),
    );
    final externalController = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.externalController == ExternalControllerStatus.open,
      ),
    );
    final locale = ref.watch(
      appSettingProvider.select((state) => state.locale),
    );
    final currentLocale = getLocaleForString(locale);
    return ListView(
      padding: EdgeInsets.only(left: 40, bottom: context.bottomInset + 20),
      children: [
        _BusinessSettingsCard(
          title: l10n.businessSettingsStartupWindow,
          items: [
            if (system.isDesktop)
              ListItem.toggle(
                title: Text(l10n.businessAutoLaunchTitle),
                subtitle: Text(l10n.businessAutoLaunchDesc),
                value: ref.watch(
                  appSettingProvider.select((state) => state.autoLaunch),
                ),
                onChanged: (value) => ref
                    .read(appSettingProvider.notifier)
                    .update((state) => state.copyWith(autoLaunch: value)),
              ),
            ListItem.toggle(
              title: Text(l10n.businessAutoRunTitle),
              subtitle: Text(l10n.businessAutoRunDesc),
              value: ref.watch(
                appSettingProvider.select((state) => state.autoRun),
              ),
              onChanged: (value) => ref
                  .read(appSettingProvider.notifier)
                  .update((state) => state.copyWith(autoRun: value)),
            ),
            ListItem<bool>.options(
              title: Text(l10n.businessCloseWindow),
              subtitle: Text(l10n.businessMinimizeDesc),
              options: const [true, false],
              value: ref.watch(
                appSettingProvider.select((state) => state.minimizeOnExit),
              ),
              textBuilder: (value) =>
                  value ? l10n.businessMinimizeToTray : l10n.exit,
              onChanged: (value) => ref
                  .read(appSettingProvider.notifier)
                  .update((state) => state.copyWith(minimizeOnExit: value)),
            ),
            ListItem<Locale?>.options(
              title: Text(l10n.language),
              options: [null, ...AppLocalizations.delegate.supportedLocales],
              value: currentLocale,
              textBuilder: (value) => value?.label ?? l10n.defaultText,
              onChanged: (value) => ref
                  .read(appSettingProvider.notifier)
                  .update((state) => state.copyWith(locale: value?.toString())),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _BusinessSettingsCard(
          title: l10n.businessSettingsAppearance,
          items: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: BusinessThemeChoices(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _BusinessSettingsCard(
          title: l10n.update,
          items: [
            const _SubscriptionUpdateDurationItem(),
            ListItem(
              title: Text.rich(
                TextSpan(
                  text: '${l10n.businessClientVersion} ',
                  children: [
                    TextSpan(
                      text: _clientVersion(),
                      style: AppTextStyle.custom(
                        context,
                        size: 14,
                        leading: 20,
                      ).toJetBrainsMono,
                    ),
                  ],
                ),
              ),
              subtitle: Text(l10n.businessClientVersionDesc),
              trailing: _BusinessSecondaryButton(
                label: l10n.checkUpdate,
                onPressed: () => _checkForUpdate(context, ref),
              ),
            ),
            _toggle(
              title: (l) => l.autoCheckUpdate,
              select: (state) => state.autoCheckUpdate,
              update: (state, value) => state.copyWith(autoCheckUpdate: value),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _BusinessSettingsCard(
          title: l10n.advancedConfig,
          items: [
            if (system.isDesktop)
              _toggle(
                title: (l) => l.silentLaunch,
                select: (state) => state.silentLaunch,
                update: (state, value) => state.copyWith(silentLaunch: value),
              ),
            if (system.isAndroid) ...[
              _toggle(
                title: (l) => l.exclude,
                select: (state) => state.hidden,
                update: (state, value) => state.copyWith(hidden: value),
              ),
              _toggle(
                title: (l) => l.showNotificationStopAction,
                select: (state) => state.showNotificationStopAction,
                update: (state, value) =>
                    state.copyWith(showNotificationStopAction: value),
              ),
            ],
            const UaItem(),
            _toggle(
              title: (l) => l.checkCertificate,
              select: (state) => state.checkCertificate,
              update: (state, value) => state.copyWith(checkCertificate: value),
            ),
            ..._inboundItems(
              authentication: authentication,
              externalController: externalController,
            ),
            ..._connectionItems(),
            OverrideSection(
              title: l10n.core,
              spec: _generalOverrideSpec,
              items: _coreItems(),
            ),
            ..._logItems(),
          ],
        ),
      ],
    );
  }

  Future<void> _checkForUpdate(BuildContext context, WidgetRef ref) async {
    if (ref.read(loadingProvider(LoadingTag.checkUpdate))) return;
    final result = await globalState.loadingRun(
      () async => request.checkForUpdate(),
      title: context.appLocalizations.checkUpdate,
      tag: LoadingTag.checkUpdate,
    );
    if (result != null) {
      await ref
          .read(commonActionProvider.notifier)
          .checkUpdateResultHandle(data: result, isUser: true);
    }
  }

  String _clientVersion() {
    const buildVersion = String.fromEnvironment('FLUTTER_BUILD_NAME');
    return buildVersion.isNotEmpty
        ? buildVersion
        : globalState.packageInfo.version;
  }
}

class _BusinessSettingsCard extends StatelessWidget {
  const _BusinessSettingsCard({required this.title, required this.items});

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: context.colorScheme.brightness == Brightness.dark
          ? context.colorScheme.surfaceContainerLow
          : context.colorScheme.surface,
      shape: AppShape.all(BusinessPalette.cardRadius),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Text(title, style: BusinessText.cardTitle(context)),
          ),
          const SizedBox(height: 8),
          generateGroup(items),
        ],
      ),
    ),
  );
}

class _SubscriptionUpdateDurationItem extends ConsumerWidget {
  const _SubscriptionUpdateDurationItem();

  static const _options = [
    Duration(hours: 1),
    Duration(hours: 6),
    Duration(hours: 12),
    Duration(days: 1),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentProfileProvider);
    final duration = profile?.autoUpdateDuration ?? defaultUpdateDuration;
    return ListItem<Duration>.options(
      title: Text(context.appLocalizations.businessSubscriptionAutoUpdate),
      subtitle: Text(
        context.appLocalizations.businessSubscriptionAutoUpdateDesc,
      ),
      options: _options,
      value: _options.contains(duration) ? duration : defaultUpdateDuration,
      textBuilder: (value) => switch (value.inHours) {
        1 => context.appLocalizations.businessUpdateHour1,
        6 => context.appLocalizations.businessUpdateHour6,
        12 => context.appLocalizations.businessUpdateHour12,
        _ => context.appLocalizations.businessUpdateDaily,
      },
      onChanged: (value) {
        final current = ref.read(currentProfileProvider);
        if (current == null) return;
        ref
            .read(profilesProvider.notifier)
            .updateProfile(
              current.id,
              (state) => state.copyWith(autoUpdateDuration: value),
            );
      },
    );
  }
}

class _BusinessSecondaryButton extends StatelessWidget {
  const _BusinessSecondaryButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    return FocusRing(
      shape: AppShape.full,
      child: PressRegion(
        onTap: onPressed,
        shape: AppShape.full,
        overlay: PressRegion.hoverOverlay,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: dark
                  ? [
                      BusinessPalette.secondaryButtonDarkTop,
                      BusinessPalette.secondaryButtonDarkBottom,
                    ]
                  : [
                      BusinessPalette.secondaryButtonTop,
                      BusinessPalette.secondaryButtonBottom,
                    ],
            ),
            shape: RoundedSuperellipseBorder(
              side: BorderSide(
                color: dark
                    ? BusinessPalette.secondaryButtonDarkStroke
                    : BusinessPalette.secondaryButtonStroke,
              ),
              borderRadius: AppRadius.full,
            ),
          ),
          child: SizedBox(
            width: 86,
            height: 34,
            child: Center(
              child: Text(label, style: BusinessText.actionLabel(context)),
            ),
          ),
        ),
      ),
    );
  }
}
