import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/common/service_probe.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/providers/routed_probe.dart';
import 'package:fl_clash/providers/service_status.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/views/about.dart';
import 'package:fl_clash/views/access.dart';
import 'package:fl_clash/views/backup_and_restore.dart';
import 'package:fl_clash/views/config/dns.dart';
import 'package:fl_clash/views/config/filters.dart';
import 'package:fl_clash/views/config/general.dart';
import 'package:fl_clash/views/config/icon_sets.dart';
import 'package:fl_clash/views/config/mitm.dart';
import 'package:fl_clash/views/config/network.dart';
import 'package:fl_clash/views/config/on_demand.dart';
import 'package:fl_clash/views/config/providers.dart';
import 'package:fl_clash/views/config/rules.dart';
import 'package:fl_clash/views/config/scripts.dart';
import 'package:fl_clash/views/config/sniffer.dart';
import 'package:fl_clash/views/config/tun.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/dashboard/business_exit_warning_banner.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessPrimaryButton, BusinessSecondaryButton;
import 'package:fl_clash/views/diagnostics.dart';
import 'package:fl_clash/views/resources.dart';
import 'package:fl_clash/views/system_service.dart';
import 'package:fl_clash/views/config/user_agents.dart';
import 'package:fl_clash/views/dashboard/widgets/service_status.dart';
import 'package:fl_clash/views/dashboard/widgets/segmented.dart';
import 'package:fl_clash/views/hotkey.dart';
import 'package:fl_clash/views/profiles/custom/custom_proxies.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/advanced.dart';
import 'developer.dart';
import 'theme.dart';

class ToolsView extends ConsumerStatefulWidget {
  const ToolsView({super.key});

  @override
  ConsumerState<ToolsView> createState() => _ToolViewState();
}

class _ToolViewState extends ConsumerState<ToolsView> {
  Widget _buildNavigationMenuItem(NavigationItem navigationItem) {
    return ListItem.open(
      leading: GlyphIcon(navigationItem.glyph),
      title: Text(navigationItem.label.label),
      widget: navigationItem.builder(context),
      forceFull: navigationItem.modes.contains(NavigationItemMode.moreFull),
    );
  }

  Widget _getOtherList(bool enableDeveloperMode) {
    return generateSection(
      title: context.appLocalizations.other,
      items: [
        if (enableDeveloperMode) const _DeveloperItem(),
        if (system.hasHelperService) const _SystemServiceItem(),
        const _InfoItem(),
      ],
    );
  }

  Widget _getSettingList() {
    return generateSection(
      title: context.appLocalizations.settings,
      items: [
        const _LocaleItem(),
        const _ThemeItem(),
        if (system.isDesktop) const _HotkeyItem(),
        if (system.isAndroid) const _AccessItem(),
        const _BackupItem(),
        const _AdvancedConfigItem(),
        const _GeneralItem(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final developerMode = ref.watch(
      appSettingProvider.select((state) => state.developerMode),
    );
    final business = isTianjiSubscriptionProfile(
      ref.watch(currentProfileProvider),
    );
    final isMobile = ref.watch(isMobileViewProvider);
    if (business && isMobile) {
      return _BusinessMobileTools(
        developerMode: developerMode,
        navigation: ref.watch(moreToolsSelectorStateProvider).navigationItems,
      );
    }
    final items = [
      Consumer(
        builder: (_, ref, _) {
          final state = ref.watch(moreToolsSelectorStateProvider);
          if (state.navigationItems.isEmpty) {
            return Container();
          }
          return generateSection(
            items: state.navigationItems.map(_buildNavigationMenuItem),
          );
        },
      ),
      _getSettingList(),
      _getOtherList(developerMode),
    ];
    if (business && !isMobile) {
      return _BusinessSettingsLayout(developerMode: developerMode);
    }
    return Scaffold(
      title: business && !isMobile
          ? context.appLocalizations.settings
          : context.appLocalizations.tools,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final list = PrismListView(
            key: toolsStoreKey,
            itemCount: items.length,
            itemBuilder: (_, index) => items[index],
            padding: EdgeInsets.only(
              left: business && !isMobile ? 24 : 16,
              right: business && !isMobile ? 24 : 16,
              top: context.sectionsTopPadding,
              bottom: 20 + context.bottomInset,
            ),
          );
          if (!business || isMobile) {
            return list;
          }
          return Align(
            alignment: AlignmentDirectional.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth.clamp(0, 1040).toDouble(),
              ),
              child: list,
            ),
          );
        },
      ),
    );
  }
}

class _BusinessMobileTools extends ConsumerWidget {
  const _BusinessMobileTools({
    required this.developerMode,
    required this.navigation,
  });

  final bool developerMode;
  final List<NavigationItem> navigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final entries = {for (final item in navigation) item.label: item};
    final requests = ref.watch(requestsProvider).list.length;
    final accessList = ref.watch(
      accessControlStateProvider.select((state) => state.currentList),
    );
    final probes = ref.watch(serviceStatusProvider);
    final diagnosticTargets = [
      ServiceTarget.chatgpt,
      ServiceTarget.claude,
      ServiceTarget.gemini,
    ];
    final hasDiagnostics = diagnosticTargets.any(
      (target) => probes.entryOf(target).phase != ProbePhase.empty,
    );
    final passedDiagnostics = diagnosticTargets
        .where(
          (target) =>
              probes.entryOf(target).value?.status ==
              ServiceProbeStatus.available,
        )
        .length;
    final themeMode = ref.watch(
      themeSettingProvider.select((state) => state.themeMode),
    );
    final locale = getLocaleForString(
      ref.watch(appSettingProvider.select((state) => state.locale)),
    );
    final themeLabel = switch (themeMode) {
      ThemeMode.system => l10n.businessFollowSystem,
      ThemeMode.light => l10n.light,
      ThemeMode.dark => l10n.dark,
    };
    final localeLabel = switch (locale?.toString()) {
      null => l10n.businessFollowSystem,
      'zh_CN' => l10n.businessToolsSimplifiedChinese,
      _ => locale!.label,
    };

    Widget value(String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: BusinessText.metaLabel(
            context,
          ).copyWith(color: BusinessPalette.secondary),
        ),
        const SizedBox(width: 6),
        const DisclosureIndicator(),
      ],
    );

    Widget icon(Glyph glyph) => DecoratedBox(
      decoration: ShapeDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        shape: AppShape.all(10),
      ),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: GlyphIcon(
            glyph,
            size: MacOSMetrics.sidebarIconSize(context, fallback: 24),
          ),
        ),
      ),
    );

    Widget nav(PageLabel label, {String? title, String? trailing}) {
      final item = entries[label];
      return ListItem.open(
        leading: icon(item?.glyph ?? AppGlyphs.settings),
        title: Text(title ?? label.label),
        trailing: trailing == null ? null : value(trailing),
        widget: item?.builder(context) ?? const SizedBox.shrink(),
      );
    }

    Widget setting(
      String title,
      Glyph glyph,
      Widget page, {
      String? trailing,
    }) => ListItem.open(
      leading: icon(glyph),
      title: Text(title),
      trailing: trailing == null ? null : value(trailing),
      widget: page,
    );

    return Scaffold(
      title: l10n.tools,
      body: ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: context.sectionsTopPadding,
          bottom: 20 + context.bottomInset,
        ),
        children: [
          _BusinessMobileSection(
            title: l10n.businessToolsBrowse,
            items: [
              nav(
                PageLabel.requests,
                title: l10n.businessToolsConnectionRequests,
                trailing: l10n.businessToolsRequestCount(requests),
              ),
              ListItem.open(
                leading: icon(AppGlyphs.target),
                title: Text(l10n.diagnosticsTitle),
                trailing: hasDiagnostics
                    ? value(l10n.businessToolsPassedCount(passedDiagnostics))
                    : null,
                widget: const DiagnosticsView(),
              ),
              ListItem.open(
                leading: icon(AppGlyphs.dns),
                title: Text(l10n.businessSettingsDnsResources),
                widget: _BusinessDnsResourcesPage(navigation: navigation),
              ),
              ListItem.open(
                leading: icon(AppGlyphs.logs),
                title: Text(l10n.businessToolsRuntimeLogs),
                widget:
                    entries[PageLabel.logs]?.builder(context) ??
                    const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _BusinessMobileSection(
            title: l10n.network,
            items: [
              if (defaultTargetPlatform == TargetPlatform.android)
                ListItem(
                  leading: icon(AppGlyphs.vpn),
                  title: Text(l10n.alwaysOnVpn),
                  subtitle: Text(l10n.alwaysOnVpnDescription),
                  trailing: const GlyphIcon(AppGlyphs.chevronForward),
                  onTap: () {
                    final plugin = app;
                    if (plugin != null) {
                      unawaited(plugin.openVpnSettings().then<void>((_) {}));
                    }
                  },
                ),
              ListItem.open(
                leading: icon(AppGlyphs.appsList),
                title: Text(l10n.businessToolsPerAppProxy),
                trailing: accessList.isNotEmpty
                    ? value(
                        l10n.businessToolsApplicationCount(accessList.length),
                      )
                    : null,
                widget: const AccessView(),
              ),
              Ipv6Item(leading: icon(AppGlyphs.vpn)),
              BypassPrivateRouteItem(
                title: l10n.businessToolsLocalDirect,
                leading: icon(AppGlyphs.wifi),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _BusinessMobileSection(
            title: l10n.businessToolsGeneral,
            items: [
              setting(
                l10n.businessToolsAppearance,
                AppGlyphs.paintbrush,
                const ThemeView(business: true),
                trailing: themeLabel,
              ),
              setting(
                l10n.language,
                AppGlyphs.language,
                const ThemeView(business: true),
                trailing: localeLabel,
              ),
              setting(
                l10n.backupAndRestore,
                AppGlyphs.cloudSync,
                const BackupAndRestore(),
              ),
              setting(
                l10n.businessAdvancedNetworkSettings,
                AppGlyphs.wrench,
                _BusinessNetworkPage(navigation: navigation),
              ),
              setting(
                l10n.about,
                AppGlyphs.info,
                const AboutView(business: true),
              ),
              if (developerMode)
                setting(
                  l10n.developerMode,
                  AppGlyphs.cpu,
                  const DeveloperView(),
                ),
              if (system.hasHelperService)
                setting(
                  l10n.systemService,
                  AppGlyphs.settings,
                  const SystemServiceView(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BusinessDnsResourcesPage extends StatelessWidget {
  const _BusinessDnsResourcesPage({required this.navigation});

  final List<NavigationItem> navigation;

  @override
  Widget build(BuildContext context) => BaseScaffold(
    title: context.appLocalizations.businessSettingsDnsResources,
    body: _DnsSettingsView(navigation: navigation),
  );
}

class _BusinessNetworkPage extends StatelessWidget {
  const _BusinessNetworkPage({required this.navigation});

  final List<NavigationItem> navigation;

  @override
  Widget build(BuildContext context) => BaseScaffold(
    title: context.appLocalizations.businessAdvancedNetworkSettings,
    body: _BusinessMobileNetworkSettings(navigation: navigation),
  );
}

class _BusinessMobileSection extends StatelessWidget {
  const _BusinessMobileSection({required this.title, required this.items});

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(title, style: BusinessText.metaLabel(context)),
      ),
      BusinessSettingsCard(items: items),
    ],
  );
}

class _BusinessSettingsLayout extends ConsumerStatefulWidget {
  const _BusinessSettingsLayout({required this.developerMode});

  final bool developerMode;

  @override
  ConsumerState<_BusinessSettingsLayout> createState() =>
      _BusinessSettingsLayoutState();
}

class _BusinessSettingsLayoutState
    extends ConsumerState<_BusinessSettingsLayout> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final navigation = ref
        .watch(moreToolsSelectorStateProvider)
        .navigationItems;
    final profile = ref.watch(currentProfileProvider);
    final selectedKey = ref.watch(macOSSettingsSelectionProvider);
    final entries = [
      _SettingsEntry(
        'general',
        l10n.businessSettingsCommon,
        l10n.general,
        GeneralView(hideAdvanced: MacOSStyle.of(context)),
      ),
      if (MacOSStyle.of(context))
        _SettingsEntry(
          'advanced-general',
          l10n.businessSettingsNetworkAdvanced,
          l10n.advancedConfig,
          const GeneralView(advancedOnly: true),
        ),
      _SettingsEntry(
        'appearance',
        l10n.businessSettingsCommon,
        l10n.businessSettingsAppearance,
        const ThemeView(business: true),
      ),
      if (system.isDesktop)
        _SettingsEntry(
          'hotkeys',
          l10n.businessSettingsCommon,
          l10n.businessSettingsHotkeys,
          const HotKeyView(business: true),
        ),
      _SettingsEntry(
        'on-demand',
        l10n.businessSettingsCommon,
        l10n.businessOnDemandConnection,
        const OnDemandView(business: true),
      ),
      _SettingsEntry(
        'backup',
        l10n.businessSettingsCommon,
        l10n.backupAndRestore,
        const BackupAndRestore(business: true),
      ),
      _SettingsEntry(
        'network',
        l10n.businessSettingsNetworkAdvanced,
        l10n.businessSettingsInboundPorts,
        _NetworkSettingsView(navigation: navigation),
      ),
      _SettingsEntry(
        'tun',
        l10n.businessSettingsNetworkAdvanced,
        l10n.businessSettingsTun,
        const _TunSettingsView(),
      ),
      _SettingsEntry(
        'dns',
        l10n.businessSettingsNetworkAdvanced,
        'DNS',
        _DnsSettingsView(navigation: navigation),
      ),
      _SettingsEntry(
        'rules',
        l10n.businessSettingsNetworkAdvanced,
        l10n.businessSettingsRules,
        const _RuleSettingsView(),
      ),
      if (profile != null)
        _SettingsEntry(
          'sniffer',
          l10n.businessSettingsNetworkAdvanced,
          l10n.sniffer,
          SnifferView(profile.id),
        ),
      if (mitmFeature)
        _SettingsEntry(
          'mitm',
          l10n.businessSettingsNetworkAdvanced,
          l10n.mitm,
          MitmView(isAndroid: system.isAndroid, business: true),
        ),
      _SettingsEntry(
        'user-agents',
        l10n.businessSettingsNetworkAdvanced,
        l10n.businessSettingsIconsUa,
        const _IconAndUaSettingsView(),
      ),
      if (system.isAndroid)
        _SettingsEntry(
          'access',
          l10n.businessSettingsNetworkAdvanced,
          l10n.accessControl,
          const AccessView(),
        ),
      _SettingsEntry(
        'service-management',
        l10n.businessSettingsOther,
        l10n.serviceManage,
        const ServiceManageView(),
      ),
      if (system.hasHelperService)
        _SettingsEntry(
          'system-service',
          l10n.businessSettingsOther,
          l10n.systemService,
          const SystemServiceView(),
        ),
      _SettingsEntry(
        'other',
        l10n.businessSettingsOther,
        l10n.businessSettingsAbout,
        const AboutView(business: true),
      ),
      if (widget.developerMode)
        _SettingsEntry(
          'developer',
          l10n.businessSettingsOther,
          l10n.developerMode,
          const DeveloperView(business: true),
        ),
    ];
    final active = entries.firstWhere(
      (entry) => entry.key == selectedKey,
      orElse: () => entries.first,
    );
    final sections = <String, List<_SettingsEntry>>{};
    for (final entry in entries) {
      sections.putIfAbsent(entry.section, () => []).add(entry);
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MacOSMetrics.pageMargin(context, fallback: 29),
        MacOSStyle.of(context) ? 12 : 50,
        MacOSMetrics.pageMargin(context, fallback: 24),
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(l10n.settings, style: BusinessText.pageTitle(context)),
          ),
          Expanded(
            child: MacOSStyle.of(context)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: BusinessSegmented<String>(
                          items: [
                            for (final section in sections.keys)
                              BusinessSegment(value: section, label: section),
                          ],
                          selected: active.section,
                          onSelected: (section) => ref
                              .read(macOSSettingsSelectionProvider.notifier)
                              .select(sections[section]!.first.key),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: MacOSMetrics.sidebarRowHeight(
                          context,
                          fallback: 32,
                        ),
                        child: PrismListView(
                          scrollDirection: Axis.horizontal,
                          itemCount: sections[active.section]!.length,
                          gap: 4,
                          itemBuilder: (_, index) {
                            final entry = sections[active.section]![index];
                            return _SettingsNavigationItem(
                              entry: entry,
                              selected: entry.key == active.key,
                              onPressed: () => ref
                                  .read(macOSSettingsSelectionProvider.notifier)
                                  .select(entry.key),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: KeyedSubtree(
                          key: ValueKey(active.key),
                          child: active.page,
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 160,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            for (final section in sections.entries) ...[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                                child: Text(
                                  section.key,
                                  style: AppTextStyle.caption1
                                      .of(context)
                                      .copyWith(
                                        color: context
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                              for (final entry in section.value)
                                _SettingsNavigationItem(
                                  entry: entry,
                                  selected: entry.key == active.key,
                                  onPressed: () => ref
                                      .read(
                                        macOSSettingsSelectionProvider.notifier,
                                      )
                                      .select(entry.key),
                                ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: KeyedSubtree(
                          key: ValueKey(active.key),
                          child: active.page,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SettingsEntry {
  const _SettingsEntry(this.key, this.section, this.title, this.page);

  final String key;
  final String section;
  final String title;
  final Widget page;
}

class _SettingsNavigationItem extends StatelessWidget {
  const _SettingsNavigationItem({
    required this.entry,
    required this.selected,
    required this.onPressed,
  });

  final _SettingsEntry entry;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? context.colorScheme.onSurface
        : context.colorScheme.onSurfaceVariant;
    final shape = AppShape.all(BusinessRadius.navItem);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: FocusRing(
        shape: shape,
        child: PressRegion(
          onTap: onPressed,
          shape: shape,
          overlay: PressRegion.hoverOverlay,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: selected
                  ? context.colorScheme.surface
                  : const Color(0x00FFFFFF),
              shape: shape,
              shadows: selected
                  ? [
                      BusinessShadow.selectedLine(
                        BusinessPalette.sidebarSelectionShadow,
                      ),
                    ]
                  : const [],
            ),
            child: SizedBox(
              height: MacOSMetrics.sidebarRowHeight(context, fallback: 32),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.subheadline
                        .of(context, emphasized: selected)
                        .copyWith(color: foreground),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RuleSettingsView extends ConsumerWidget {
  const _RuleSettingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final rules = ref.watch(globalRulesProvider).value ?? const <Rule>[];
    final scripts = ref.watch(scriptsProvider).value ?? const <Script>[];
    final ruleProviders =
        ref.watch(clashProvidersProvider).value ?? const <ClashProvider>[];
    final filters = ref.watch(
      appSettingProvider.select((state) => state.filters),
    );
    return ListView(
      padding: EdgeInsets.only(
        left: MacOSMetrics.pageMargin(context, fallback: 40),
        right: MacOSMetrics.pageMargin(context, fallback: 0),
        bottom: context.bottomInset + 20,
      ),
      children: [
        BusinessSettingsCard(
          title: '${l10n.global} ${l10n.addedRules} · ${rules.length}',
          trailing: BusinessPrimaryButton(
            label: l10n.add,
            width: 84,
            height: 32,
            glyph: AppGlyphs.addCircle,
            onPressed: () async {
              final rule = await showFormSheet<Rule>(
                context: context,
                builder: (_) => const RuleForm(),
              );
              if (rule != null) {
                ref.read(globalRulesProvider.notifier).put(rule);
              }
            },
          ),
          items: [
            for (final rule in rules.take(5)) _RuleSummaryItem(rule: rule),
            if (rules.length > 5)
              ListItem(
                title: Text(
                  '${l10n.viewAll} ${l10n.itemsCount(rules.length)} ›',
                ),
                onTap: () => Navigator.of(context).push(
                  MacOSPagedSheetRoute(
                    macOS: MacOSStyle.of(context),
                    reducedMotion: context.disableAnimations,
                    builder: (_) => const AddedRulesView(),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.businessOverrideSettings,
          items: [
            _BusinessManageRow(
              title: l10n.general,
              page: const GeneralOverridesView(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.script,
          items: [
            _BusinessManageRow(
              title: l10n.script,
              subtitle: scripts.isEmpty
                  ? null
                  : l10n.itemsCount(scripts.length),
              page: const ScriptsView(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.ruleProviders,
          items: [
            _BusinessManageRow(
              title: l10n.ruleProviders,
              subtitle: ruleProviders.isEmpty
                  ? null
                  : l10n.itemsCount(ruleProviders.length),
              page: const ClashProvidersView(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.filters,
          items: [
            _BusinessManageRow(
              title: l10n.filters,
              subtitle: filters.isEmpty
                  ? null
                  : l10n.itemsCount(filters.length),
              page: const FiltersView(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.other,
          items: [
            _BusinessManageRow(
              title: l10n.proxies,
              page: const CustomProxiesView(),
            ),
          ],
        ),
      ],
    );
  }
}

class _BusinessManageRow extends StatelessWidget {
  const _BusinessManageRow({
    required this.title,
    required this.page,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    void open() {
      Navigator.of(context).push(
        MacOSPagedSheetRoute(
          macOS: MacOSStyle.of(context),
          reducedMotion: context.disableAnimations,
          builder: (_) => page,
        ),
      );
    }

    return ListItem(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: BusinessSecondaryButton(
        label: context.appLocalizations.businessManage,
        width: 86,
        onPressed: open,
      ),
      onTap: open,
    );
  }
}

class _RuleSummaryItem extends StatelessWidget {
  const _RuleSummaryItem({required this.rule});

  final Rule rule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final type = rule.ruleAction.value;
    final content = rule.content ?? rule.ruleProvider ?? rule.subRule ?? '';
    final target = (rule.ruleTarget ?? '').toUpperCase();
    final colorScheme = context.colorScheme;
    final (background, foreground, label) = switch (target) {
      'DIRECT' => (
        colorScheme.successContainer,
        colorScheme.onSuccessContainer,
        l10n.direct,
      ),
      'REJECT' || 'REJECT-DROP' => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        l10n.businessIntercept,
      ),
      _ => (
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
        rule.ruleTarget ?? '',
      ),
    };
    return ListItem(
      title: Row(
        children: [
          DecoratedBox(
            decoration: ShapeDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: AppShape.sm,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                type,
                style: AppTextStyle.caption1
                    .of(context)
                    .toJetBrainsMono
                    .copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.subheadline.of(context).toJetBrainsMono,
            ),
          ),
        ],
      ),
      trailing: DecoratedBox(
        decoration: ShapeDecoration(color: background, shape: AppShape.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            label,
            style: AppTextStyle.caption1
                .of(context, emphasized: true)
                .copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}

class _NetworkSettingsView extends ConsumerWidget {
  const _NetworkSettingsView({required this.navigation});

  final List<NavigationItem> navigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    if (ref.watch(isMobileViewProvider)) {
      return _BusinessMobileNetworkSettings(navigation: navigation);
    }
    final authentication = ref.watch(
      networkSettingProvider.select((state) => state.authentication.enable),
    );
    final externalController = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.externalController == ExternalControllerStatus.open,
      ),
    );
    return ListView(
      padding: EdgeInsets.only(
        left: MacOSMetrics.pageMargin(context, fallback: 40),
        right: MacOSMetrics.pageMargin(context, fallback: 0),
        bottom: context.bottomInset + 20,
      ),
      children: [
        BusinessSettingsCard(
          title: l10n.businessLocalPorts,
          items: [
            const PortItem(business: true),
            ConfigToggleItem(
              title: (l) => l.allowLan,
              selector: patchClashConfigProvider.select(
                (state) => state.allowLan,
              ),
              onChanged: (ref, value) => ref
                  .read(patchClashConfigProvider.notifier)
                  .update((state) => state.copyWith(allowLan: value)),
            ),
            _BusinessManageRow(
              title: 'IPv6',
              subtitle: l10n.ipv6Desc,
              page: const GeneralOverridesView(),
            ),
            ConfigToggleItem(
              title: (l) => l.findProcessMode,
              selector: patchClashConfigProvider.select(
                (state) => state.findProcessMode == FindProcessMode.always,
              ),
              onChanged: (ref, value) => ref
                  .read(patchClashConfigProvider.notifier)
                  .update(
                    (state) => state.copyWith(
                      findProcessMode: value
                          ? FindProcessMode.always
                          : FindProcessMode.off,
                    ),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.systemProxy,
          items: [
            const SystemProxyItem(),
            const _BusinessBypassDomainsRow(),
            if (system.isWindows) const LoopbackItem(),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.other,
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
            const AuthenticationItem(),
            if (authentication) ...const [
              AuthenticationAccountItem(),
              AuthenticationPasswordItem(),
            ],
            for (final item in navigation.where(
              (item) => item.label == PageLabel.requests,
            ))
              _BusinessManageRow(
                title: item.label.label,
                page: item.builder(context),
              ),
          ],
        ),
      ],
    );
  }
}

class _BusinessMobileNetworkSettings extends ConsumerWidget {
  const _BusinessMobileNetworkSettings({required this.navigation});

  final List<NavigationItem> navigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final profile = ref.watch(currentProfileProvider);
    final stack = ref.watch(
      patchClashConfigProvider.select((state) => state.tun.stack),
    );
    final mode = ref.watch(
      patchClashConfigProvider.select((state) => state.dns.enhancedMode),
    );
    final vpn = ref.watch(vpnSettingProvider);
    final wifiRules = ref.watch(excludeSSIDsProvider);
    final mitmEnabled = ref.watch(
      patchClashConfigProvider.select((state) => state.mitm.enable),
    );
    final developerMode = ref.watch(
      appSettingProvider.select((state) => state.developerMode),
    );
    final sniffing = profile?.overrides.sniffer.enable ?? false;
    Widget section(String title, List<Widget> items) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              title,
              style: BusinessText.metaLabel(
                context,
              ).copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
          ),
          BusinessSettingsCard(items: items),
        ],
      ),
    );
    Widget value(String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (text.isNotEmpty)
          Text(
            text,
            style: BusinessText.metaLabel(
              context,
            ).copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        if (text.isNotEmpty) const SizedBox(width: 5),
        const DisclosureIndicator(),
      ],
    );
    Widget row(
      String title,
      String description,
      String trailing,
      Widget page,
    ) => ListItem.open(
      title: Text(title, style: BusinessText.dataBody(context)),
      subtitle: Text(
        description,
        style: BusinessText.metaLabel(
          context,
        ).copyWith(color: context.colorScheme.onSurfaceVariant),
      ),
      trailing: value(trailing),
      widget: page,
    );
    Widget toggle(
      String title,
      String description,
      bool enabled,
      ValueChanged<bool> onChanged,
    ) => ListItem(
      title: Text(title, style: BusinessText.dataBody(context)),
      subtitle: Text(
        description,
        style: BusinessText.metaLabel(
          context,
        ).copyWith(color: context.colorScheme.onSurfaceVariant),
      ),
      trailing: SizedBox(
        width: 44,
        height: 26,
        child: Transform.scale(
          scale: 0.84,
          child: Switch(value: enabled, onChanged: onChanged),
        ),
      ),
      minTileHeight: 64,
    );

    final stackLabel = switch (stack) {
      TunStack.gvisor => 'gVisor',
      TunStack.system => l10n.system,
      TunStack.mixed => l10n.businessTunStackMixed,
      TunStack.mips => 'MIPS',
    };
    final modeLabel = switch (mode) {
      DnsMode.fakeIp => 'fake-ip',
      DnsMode.redirHost => 'redir-host',
      DnsMode.normal => 'normal',
      DnsMode.hosts => 'hosts',
    };
    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        context.sectionsTopPadding,
        16,
        context.bottomInset + 20,
      ),
      children: [
        section(l10n.businessVpn, [
          row(
            l10n.businessNetworkStack,
            l10n.businessStackModeDescription,
            stackLabel,
            const _TunSettingsView(),
          ),
          toggle(
            l10n.dnsHijacking,
            l10n.dnsHijackDesc,
            vpn.dnsHijacking,
            (value) => ref.read(vpnSettingProvider.notifier).value = vpn
                .copyWith(dnsHijacking: value),
          ),
          toggle(
            l10n.businessSystemProxyHttp,
            l10n.businessSystemProxyDescription,
            vpn.systemProxy,
            (value) => ref.read(vpnSettingProvider.notifier).value = vpn
                .copyWith(systemProxy: value),
          ),
          toggle(
            l10n.allowBypass,
            l10n.businessAllowBypassDescription,
            vpn.allowBypass,
            (value) => ref.read(vpnSettingProvider.notifier).value = vpn
                .copyWith(allowBypass: value),
          ),
          row(
            l10n.businessMoreVpnSettings,
            l10n.businessMoreVpnDescription,
            '',
            const _TunSettingsView(),
          ),
        ]),
        section(l10n.businessDnsAndSniffing, [
          row(
            l10n.dnsMode,
            l10n.businessDnsModeDescription,
            modeLabel,
            const DnsView(),
          ),
          if (profile != null)
            row(
              l10n.sniffer,
              l10n.businessDomainSniffingDescription,
              sniffing ? l10n.enabled : l10n.disabled,
              SnifferView(profile.id),
            ),
          if (profile != null)
            row(
              l10n.businessOverrideSettings,
              l10n.businessSubscriptionOverridesDescription,
              '',
              DnsView.profile(profile.id),
            ),
        ]),
        section(l10n.other, [
          row(
            l10n.businessOnDemandConnection,
            l10n.excludeSsidsDesc,
            l10n.businessWifiRulesCount(wifiRules.length),
            const OnDemandView(business: true),
          ),
          row(
            l10n.businessSettingsRules,
            l10n.businessRuleOverrideDescription,
            '',
            const _RuleSettingsView(),
          ),
          if (mitmFeature)
            row(
              l10n.mitm,
              l10n.businessMitmDescription,
              mitmEnabled ? l10n.enabled : l10n.disabled,
              MitmView(isAndroid: system.isAndroid, business: true),
            ),
          if (developerMode)
            row(
              l10n.developerMode,
              l10n.businessDeveloperDescription,
              '',
              const DeveloperView(business: true),
            ),
        ]),
      ],
    );
  }
}

class _BusinessBypassDomainsRow extends ConsumerWidget {
  const _BusinessBypassDomainsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final domains = ref.watch(
      networkSettingProvider.select((state) => state.bypassDomain),
    );
    void open() {
      Navigator.of(context)
          .push(
            MacOSPagedSheetRoute(
              macOS: MacOSStyle.of(context),
              reducedMotion: context.disableAnimations,
              builder: (_) => ListEditView(
                title: l10n.bypassDomain,
                description: l10n.bypassDomainDesc,
                items: domains,
                itemMaxLength: TextInputLimits.domain,
                titleBuilder: (item) => Text(item),
              ),
            ),
          )
          .then((result) {
            if (result is List<String>) {
              ref
                  .read(networkSettingProvider.notifier)
                  .update((state) => state.copyWith(bypassDomain: result));
            }
          });
    }

    return ListItem(
      title: Text(l10n.bypassDomain),
      subtitle: domains.isEmpty
          ? Text(l10n.none)
          : Wrap(
              spacing: 6,
              runSpacing: 5,
              children: [
                for (final domain in domains.take(7))
                  DecoratedBox(
                    decoration: ShapeDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      shape: AppShape.sm,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        domain,
                        style: AppTextStyle.caption1
                            .of(context)
                            .toJetBrainsMono,
                      ),
                    ),
                  ),
              ],
            ),
      trailing: BusinessSecondaryButton(
        label: '+ ${l10n.add}',
        width: 86,
        onPressed: open,
      ),
      onTap: open,
    );
  }
}

class _DnsSettingsView extends ConsumerStatefulWidget {
  const _DnsSettingsView({required this.navigation});

  final List<NavigationItem> navigation;

  @override
  ConsumerState<_DnsSettingsView> createState() => _DnsSettingsViewState();
}

class _DnsSettingsViewState extends ConsumerState<_DnsSettingsView> {
  var _showResources = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final mobile = ref.watch(isMobileViewProvider);
    if (mobile) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              context.sectionsTopPadding,
              16,
              12,
            ),
            child: BusinessSegmented<bool>(
              items: [
                BusinessSegment(value: false, label: l10n.dnsQueries),
                BusinessSegment(
                  value: true,
                  label: l10n.businessToolsRoutingResources,
                ),
              ],
              selected: _showResources,
              onSelected: (value) => setState(() => _showResources = value),
              expand: true,
              mobile: true,
              height: 36,
            ),
          ),
          const _BusinessDnsSummary(),
          Expanded(
            child: _showResources
                ? const ResourcesView(embedded: true)
                : const _BusinessDnsQueriesContent(),
          ),
        ],
      );
    }
    final dnsState = ref.watch(
      patchClashConfigProvider.select(
        (state) => (dns: state.dns, keys: state.dnsOverrideKeys),
      ),
    );
    final upstreams = <String>[
      if (dnsState.keys.contains(DnsOverrideKey.nameserver))
        ...dnsState.dns.nameserver,
      if (dnsState.keys.contains(DnsOverrideKey.fallback))
        ...dnsState.dns.fallback,
      if (dnsState.keys.contains(DnsOverrideKey.defaultNameserver))
        ...dnsState.dns.defaultNameserver,
      if (dnsState.keys.contains(DnsOverrideKey.proxyServerNameserver))
        ...dnsState.dns.proxyServerNameserver,
      if (dnsState.keys.contains(DnsOverrideKey.directNameserver))
        ...dnsState.dns.directNameserver,
    ];
    final dnsQuery = widget.navigation.where(
      (item) => item.label == PageLabel.dns,
    );
    final resources = widget.navigation.where(
      (item) => item.label == PageLabel.resources,
    );
    return ListView(
      padding: EdgeInsets.only(
        left: MacOSMetrics.pageMargin(context, fallback: 40),
        right: MacOSMetrics.pageMargin(context, fallback: 0),
        bottom: context.bottomInset + 20,
      ),
      children: [
        BusinessSettingsCard(
          title: l10n.businessDnsServers,
          items: [
            if (upstreams.isEmpty)
              ListItem(title: Text(l10n.businessDnsNoUpstream)),
            for (final address in upstreams)
              ListItem(
                title: Text(
                  address,
                  style: AppTextStyle.footnote.of(context).toJetBrainsMono,
                ),
                trailing: _DnsProtocolChip(address: address),
              ),
            if (dnsState.keys.contains(DnsOverrideKey.enhancedMode))
              _BusinessManageRow(
                title: l10n.dnsMode,
                subtitle: dnsState.dns.enhancedMode.name,
                page: const DnsView(),
              ),
            if (dnsState.keys.contains(DnsOverrideKey.fakeIpRange))
              _BusinessManageRow(
                title: l10n.fakeipRange,
                subtitle: dnsState.dns.fakeIpRange,
                page: const DnsView(),
              ),
            _BusinessManageRow(
              title: 'DNS',
              subtitle: l10n.dnsOverrideDesc,
              page: const DnsView(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.other,
          items: [
            for (final item in dnsQuery)
              _BusinessManageRow(
                title: item.label.label,
                page: item.builder(context),
              ),
            for (final item in resources)
              _BusinessManageRow(
                title: item.label.label,
                page: item.builder(context),
              ),
          ],
        ),
      ],
    );
  }
}

class _BusinessDnsSummary extends ConsumerWidget {
  const _BusinessDnsSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      patchClashConfigProvider.select(
        (state) => (dns: state.dns, keys: state.dnsOverrideKeys),
      ),
    );
    final upstream = [
      if (state.keys.contains(DnsOverrideKey.nameserver))
        ...state.dns.nameserver,
      if (state.keys.contains(DnsOverrideKey.fallback)) ...state.dns.fallback,
      if (state.keys.contains(DnsOverrideKey.defaultNameserver))
        ...state.dns.defaultNameserver,
      if (state.keys.contains(DnsOverrideKey.proxyServerNameserver))
        ...state.dns.proxyServerNameserver,
      if (state.keys.contains(DnsOverrideKey.directNameserver))
        ...state.dns.directNameserver,
    ];
    if (!state.keys.contains(DnsOverrideKey.enhancedMode) && upstream.isEmpty) {
      return const SizedBox.shrink();
    }
    final mode = switch (state.dns.enhancedMode) {
      DnsMode.fakeIp => 'fake-ip',
      DnsMode.redirHost => 'redir-host',
      DnsMode.normal => 'normal',
      DnsMode.hosts => 'hosts',
    };
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Row(
          children: [
            if (state.keys.contains(DnsOverrideKey.enhancedMode))
              _DnsSummaryChip(label: mode, primary: true),
            if (state.keys.contains(DnsOverrideKey.enhancedMode) &&
                upstream.isNotEmpty)
              const SizedBox(width: 6),
            if (upstream.isNotEmpty)
              _DnsSummaryChip(
                label:
                    '${context.appLocalizations.businessOverrideSettings} · ${upstream.length}',
                source: true,
              ),
          ],
        ),
      ),
    );
  }
}

class _DnsSummaryChip extends StatelessWidget {
  const _DnsSummaryChip({
    required this.label,
    this.primary = false,
    this.source = false,
  });

  final String label;
  final bool primary;
  final bool source;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: primary
          ? context.colorScheme.primaryContainer
          : context.colorScheme.surface,
      shape: AppShape.full.copyWith(
        side: source
            ? BorderSide(color: context.colorScheme.outlineVariant)
            : BorderSide.none,
      ),
    ),
    child: SizedBox(
      height: 20,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          label,
          style: BusinessText.metaLabel(context).copyWith(
            color: primary
                ? context.colorScheme.onPrimaryContainer
                : context.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    ),
  );
}

class _BusinessDnsQueriesContent extends ConsumerWidget {
  const _BusinessDnsQueriesContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queries = ref.watch(dnsQueriesProvider).list;
    if (queries.isEmpty) {
      return Center(
        child: Text(
          context.appLocalizations.nullTip(context.appLocalizations.dnsQueries),
          style: BusinessText.metaLabel(
            context,
          ).copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 0, 16, context.bottomInset + 20),
      children: [
        DecoratedBox(
          decoration: ShapeDecoration(
            color: context.colorScheme.surface,
            shape: AppShape.all(16),
          ),
          child: Column(
            children: [
              for (var index = 0; index < queries.length; index++) ...[
                if (index > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colorScheme.outlineVariant,
                      ),
                      child: const SizedBox(width: double.infinity, height: 1),
                    ),
                  ),
                _BusinessDnsQueryRow(
                  query: queries[queries.length - index - 1],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        const BusinessResourcesPreview(),
      ],
    );
  }
}

class _BusinessDnsQueryRow extends StatelessWidget {
  const _BusinessDnsQueryRow({required this.query});

  final DnsQuery query;

  bool get _isFakeIp => query.answers.any((answer) {
    final parts = answer.split('.').map(int.tryParse).toList();
    if (parts.length != 4 || parts.any((part) => part == null)) return false;
    final value =
        (parts[0]! << 24) | (parts[1]! << 16) | (parts[2]! << 8) | parts[3]!;
    return value >= 0xC6120000 && value <= 0xC613FFFF;
  });

  @override
  Widget build(BuildContext context) {
    final secondary = BusinessText.metaLabel(
      context,
    ).copyWith(color: context.colorScheme.onSurfaceVariant);
    final details = [
      '${query.time.hour.toString().padLeft(2, '0')}:${query.time.minute.toString().padLeft(2, '0')}',
      if (query.answers.isNotEmpty) query.answers.join(', '),
      if (query.delay > 0) '${query.delay}ms',
    ].join(' · ');
    return SizedBox(
      height: 57,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    query.domain,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BusinessText.dnsDomain(context),
                  ),
                  Text(
                    details,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: secondary.toJetBrainsMono,
                  ),
                ],
              ),
            ),
            if (_isFakeIp) ...[
              const SizedBox(width: 8),
              DecoratedBox(
                decoration: ShapeDecoration(
                  color: context.colorScheme.primaryContainer,
                  shape: AppShape.full,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: Text(
                    context.appLocalizations.businessDnsProxyResolved,
                    style: BusinessText.metaLabel(
                      context,
                    ).copyWith(color: context.colorScheme.onPrimaryContainer),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DnsProtocolChip extends StatelessWidget {
  const _DnsProtocolChip({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final normalized = address.toLowerCase();
    final protocol = normalized.startsWith('https://')
        ? 'DoH'
        : normalized.startsWith('tls://') || normalized.startsWith('dot://')
        ? 'DoT'
        : 'UDP';
    final colorScheme = context.colorScheme;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: protocol == 'UDP'
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primaryContainer,
        shape: AppShape.full,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Text(
          protocol,
          style: AppTextStyle.caption1
              .of(context, emphasized: true)
              .copyWith(
                color: protocol == 'UDP'
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onPrimaryContainer,
              ),
        ),
      ),
    );
  }
}

class _TunSettingsView extends ConsumerWidget {
  const _TunSettingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final tunEnabled = ref.watch(
      patchClashConfigProvider.select((state) => state.tun.enable),
    );
    final authorization = ref.watch(authorizedTunEnableProvider);
    final isUnauthorized =
        tunEnabled && authorization != TunAuthorizationState.authorized;
    final isMipsStack = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.tun.stack == TunStack.mips,
      ),
    );
    final customName = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.interfaceNameMode == InterfaceNameMode.custom,
      ),
    );
    final profile = ref.watch(currentProfileProvider);
    final tunOverrideState = ref.watch(
      patchClashConfigProvider.select(
        (state) => (tun: state.tunOverride, keys: state.tunOverrideKeys),
      ),
    );
    final profileTunOverrides = profile == null
        ? null
        : profile.type == ProfileType.custom
        ? profile.overrides.overAppTun(
            tunOverrideState.tun,
            tunOverrideState.keys,
          )
        : ProfileOverrides(
            tun: tunOverrideState.tun,
            tunOverrideKeys: tunOverrideState.keys,
          );
    final excludedRoutes =
        profileTunOverrides?.tunOverrideKeys.contains(
              TunOverrideKey.routeExcludeAddress,
            ) ==
            true
        ? profileTunOverrides!.tun.routeExcludeAddress
        : null;
    final mtuOverride =
        profileTunOverrides?.tunOverrideKeys.contains(TunOverrideKey.mtu) ==
            true
        ? profileTunOverrides!.tun.mtu
        : null;
    final tun = ref.watch(
      patchClashConfigProvider.select((state) => state.tun),
    );
    final helperReadiness = system.hasHelperService
        ? ref.watch(systemServiceReadinessProvider)
        : null;
    final serviceStatus = helperReadiness?.when(
      data: (name) => helperServiceStatusForName(name),
      loading: () => null,
      error: (_, _) => HelperServiceStatus.abnormal,
    );
    final serviceLabel = switch (serviceStatus) {
      HelperServiceStatus.running => l10n.systemServiceRunning,
      HelperServiceStatus.notReady => l10n.systemServiceNotInstalled,
      HelperServiceStatus.abnormal => l10n.systemServiceAbnormal,
      null => l10n.loading,
    };
    return ListView(
      padding: EdgeInsets.only(
        left: MacOSMetrics.pageMargin(context, fallback: 40),
        right: MacOSMetrics.pageMargin(context, fallback: 0),
        bottom: context.bottomInset + 20,
      ),
      children: [
        if (system.hasHelperService) ...[
          PressSurface(
            fill: context.colorScheme.primaryContainer,
            shape: AppShape.all(AppCorner.md),
            onPressed: () => Navigator.of(context).push(
              MacOSPagedSheetRoute(
                macOS: MacOSStyle.of(context),
                reducedMotion: context.disableAnimations,
                builder: (_) => const SystemServiceView(),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.businessTunTakeoverDescription,
                      style: BusinessText.metaLabel(
                        context,
                      ).copyWith(color: context.colorScheme.onPrimaryContainer),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DecoratedBox(
                    decoration: ShapeDecoration(
                      color: context.colorScheme.surface,
                      shape: AppShape.full,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Text(
                        '${l10n.systemService} · $serviceLabel',
                        style: BusinessText.metaLabel(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(l10n.tun, style: BusinessText.pageTitle(context)),
              ),
              SizedBox(
                width: 190,
                child: ConfigToggleItem(
                  title: (l) => tunEnabled ? l.enabled : l.disabled,
                  selector: patchClashConfigProvider.select(
                    (state) => state.tun.enable,
                  ),
                  onChanged: (ref, value) => ref
                      .read(patchClashConfigProvider.notifier)
                      .update((state) => state.copyWith.tun(enable: value)),
                ),
              ),
            ],
          ),
        ),
        if (isUnauthorized)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: BusinessExitWarningBanner(
              kind: BusinessExitWarningKind.tunUnauthorized,
              onRetry: () {},
              onAuthorize: () async {
                try {
                  await ref
                      .read(setupActionProvider.notifier)
                      .applyProfile(force: true);
                } catch (error) {
                  dialogs.showBanner(
                    error.toString(),
                    level: BannerLevel.error,
                  );
                }
              },
              onDiagnostics: () => Navigator.of(context).push(
                MacOSPagedSheetRoute(
                  macOS: MacOSStyle.of(context),
                  reducedMotion: context.disableAnimations,
                  builder: (_) => const DiagnosticsView(),
                ),
              ),
            ),
          ),
        BusinessSettingsCard(
          title: l10n.businessTunTakeoverMode,
          items: [
            TunStackItem(
              title: (l) => l.businessNetworkStack,
              subtitle: (l) => switch (tun.stack) {
                TunStack.mixed => l.businessTunStackMixedDescription,
                TunStack.system => l.businessTunStackSystemDescription,
                TunStack.gvisor => l.businessTunStackGvisorDescription,
                TunStack.mips => l.businessTunStackMipsDescription,
              },
            ),
            if (system.isDesktop)
              BypassPrivateRouteItem(
                subtitle: (l) => l.businessTunBypassPrivateDescription,
              ),
            if (system.isDesktop) const InterfaceNameModeItem(),
            if (system.isDesktop && customName) const InterfaceNameItem(),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          items: [
            if (!system.isDesktop) ...tunItems(isMipsStack: isMipsStack),
            if (system.isDesktop) ...[
              ListItem(
                title: Text(l10n.businessTunDevice),
                trailing: Text(
                  tun.device,
                  style: AppTextStyle.footnote.of(context).toJetBrainsMono,
                ),
              ),
              if (mtuOverride != null)
                ListItem(
                  title: Text(l10n.businessTunMtu),
                  trailing: Text(
                    '$mtuOverride',
                    style: AppTextStyle.footnote.of(context).toJetBrainsMono,
                  ),
                ),
              if (profile != null && excludedRoutes != null)
                ListItem.open(
                  title: Text(l10n.businessTunExcludedRoutes),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${excludedRoutes.length} ${l10n.businessTunRouteCount}',
                      ),
                      const SizedBox(width: 4),
                      const DisclosureIndicator(),
                    ],
                  ),
                  widget: TunView(profile.id),
                ),
              if (profile != null && excludedRoutes == null)
                _BusinessManageRow(
                  title: l10n.businessOverrideSettings,
                  page: TunView(profile.id),
                ),
            ],
          ],
        ),
      ],
    );
  }
}

class _IconAndUaSettingsView extends ConsumerWidget {
  const _IconAndUaSettingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    final iconSets = ref.watch(iconSetsProvider).value ?? const <IconSet>[];
    final savedUserAgents = ref.watch(
      appSettingProvider.select((state) => state.userAgents),
    );
    final selectedUserAgent = ref.watch(
      patchClashConfigProvider.select((state) => state.globalUa),
    );
    return ListView(
      padding: EdgeInsets.only(
        left: MacOSMetrics.pageMargin(context, fallback: 40),
        right: MacOSMetrics.pageMargin(context, fallback: 0),
        bottom: context.bottomInset + 20,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            l10n.businessSettingsIconsUa,
            style: BusinessText.pageTitle(context),
          ),
        ),
        BusinessSettingsCard(
          title: l10n.iconSets,
          footer: iconSets.isEmpty
              ? null
              : _IconSetGalleryPreview(
                  label: l10n.preview,
                  icons: iconSets.first.icons,
                ),
          trailing: BusinessSecondaryButton(
            label: l10n.businessManage,
            width: 84,
            onPressed: () => BaseNavigator.push(context, const IconSetsView()),
          ),
          items: [
            if (iconSets.isEmpty)
              ListItem(title: Text(l10n.iconSets), subtitle: Text(l10n.none))
            else
              for (final iconSet in iconSets)
                ListItem(
                  title: Text(iconSet.name),
                  subtitle: Text(l10n.itemsCount(iconSet.icons.length)),
                ),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.userAgent,
          trailing: BusinessSecondaryButton(
            label: l10n.businessManage,
            width: 84,
            onPressed: () =>
                BaseNavigator.push(context, const UserAgentsView()),
          ),
          items: [
            ListItem(
              title: Text(selectedUserAgent ?? l10n.defaultText),
              subtitle: Text(
                selectedUserAgent == null
                    ? l10n.defaultText
                    : l10n.itemsCount(savedUserAgents.length),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IconSetGalleryPreview extends StatelessWidget {
  const _IconSetGalleryPreview({required this.label, required this.icons});

  final String label;
  final List<IconSetIcon> icons;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(18, 12, 18, 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BusinessText.metaLabel(context)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children: [
              for (final icon in icons.take(8))
                Tooltip(
                  message: icon.label,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: context.colorScheme.surfaceContainerLow,
                      shape: AppShape.sm,
                    ),
                    child: SizedBox.square(
                      dimension: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: CommonTargetIcon(src: icon.url),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _LocaleItem extends ConsumerWidget {
  const _LocaleItem();

  String _getLocaleString(BuildContext context, Locale? locale) {
    if (locale == null) return context.appLocalizations.defaultText;
    return locale.label;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(
      appSettingProvider.select((state) => state.locale),
    );
    final currentLocale = getLocaleForString(locale);
    return ListItem<Locale?>.options(
      leading: const GlyphIcon(AppGlyphs.language),
      title: Text(context.appLocalizations.language),
      options: [null, ...AppLocalizations.delegate.supportedLocales],
      onChanged: (Locale? locale) {
        ref
            .read(appSettingProvider.notifier)
            .update((state) => state.copyWith(locale: locale?.toString()));
      },
      textBuilder: (locale) => _getLocaleString(context, locale),
      value: currentLocale,
    );
  }
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const GlyphIcon(AppGlyphs.paintbrush),
      title: Text(context.appLocalizations.theme),
      widget: const ThemeView(),
    );
  }
}

class _BackupItem extends StatelessWidget {
  const _BackupItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const GlyphIcon(AppGlyphs.cloudSync),
      title: Text(context.appLocalizations.backupAndRestore),
      widget: const BackupAndRestore(),
    );
  }
}

class _HotkeyItem extends StatelessWidget {
  const _HotkeyItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const GlyphIcon(AppGlyphs.keyboard),
      title: Text(context.appLocalizations.hotkeyManagement),
      widget: const HotKeyView(),
    );
  }
}

class _AccessItem extends StatelessWidget {
  const _AccessItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const GlyphIcon(AppGlyphs.appsList),
      title: Text(context.appLocalizations.accessControl),
      widget: const AccessView(),
    );
  }
}

class _GeneralItem extends StatelessWidget {
  const _GeneralItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const GlyphIcon(AppGlyphs.settings),
      title: Text(context.appLocalizations.general),
      widget: const GeneralView(),
    );
  }
}

class _AdvancedConfigItem extends StatelessWidget {
  const _AdvancedConfigItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const GlyphIcon(AppGlyphs.wrench),
      title: Text(context.appLocalizations.advancedConfig),
      widget: const AdvancedConfigView(),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const GlyphIcon(AppGlyphs.info),
      title: Text(context.appLocalizations.about),
      widget: const AboutView(),
    );
  }
}

class _SystemServiceItem extends StatelessWidget {
  const _SystemServiceItem();

  @override
  Widget build(BuildContext context) => ListItem.open(
    leading: const GlyphIcon(AppGlyphs.settings),
    title: Text(context.appLocalizations.systemService),
    widget: const SystemServiceView(),
  );
}

class _DeveloperItem extends StatelessWidget {
  const _DeveloperItem();

  @override
  Widget build(BuildContext context) {
    return ListItem.open(
      leading: const GlyphIcon(AppGlyphs.cpu),
      title: Text(context.appLocalizations.developerMode),
      widget: const DeveloperView(),
    );
  }
}
