import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
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
import 'package:fl_clash/views/config/user_agents.dart';
import 'package:fl_clash/views/dashboard/widgets/service_status.dart';
import 'package:fl_clash/views/hotkey.dart';
import 'package:fl_clash/views/profiles/custom/custom_proxies.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
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

class _BusinessSettingsLayout extends ConsumerStatefulWidget {
  const _BusinessSettingsLayout({required this.developerMode});

  final bool developerMode;

  @override
  ConsumerState<_BusinessSettingsLayout> createState() =>
      _BusinessSettingsLayoutState();
}

class _BusinessSettingsLayoutState
    extends ConsumerState<_BusinessSettingsLayout> {
  String _selectedKey = 'general';

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final navigation = ref
        .watch(moreToolsSelectorStateProvider)
        .navigationItems;
    final entries = [
      _SettingsEntry(
        'general',
        l10n.businessSettingsCommon,
        l10n.general,
        const GeneralView(),
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
          const HotKeyView(),
        ),
      _SettingsEntry(
        'on-demand',
        l10n.businessSettingsCommon,
        l10n.businessOnDemandConnection,
        const OnDemandView(),
      ),
      _SettingsEntry(
        'backup',
        l10n.businessSettingsCommon,
        l10n.backupAndRestore,
        const BackupAndRestore(),
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
      if (mitmFeature)
        _SettingsEntry(
          'mitm',
          l10n.businessSettingsNetworkAdvanced,
          l10n.mitm,
          MitmView(isAndroid: system.isAndroid),
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
      _SettingsEntry(
        'other',
        l10n.businessSettingsOther,
        l10n.businessSettingsAbout,
        const AboutView(),
      ),
      if (widget.developerMode)
        _SettingsEntry(
          'developer',
          l10n.businessSettingsOther,
          l10n.developerMode,
          const DeveloperView(),
        ),
    ];
    final active = entries.firstWhere(
      (entry) => entry.key == _selectedKey,
      orElse: () => entries.first,
    );
    final sections = <String, List<_SettingsEntry>>{};
    for (final entry in entries) {
      sections.putIfAbsent(entry.section, () => []).add(entry);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(29, 50, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(l10n.settings, style: BusinessText.pageTitle(context)),
          ),
          Expanded(
            child: Row(
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
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                        for (final entry in section.value)
                          _SettingsNavigationItem(
                            entry: entry,
                            selected: entry.key == active.key,
                            onPressed: () =>
                                setState(() => _selectedKey = entry.key),
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
              height: 32,
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

class _RuleSettingsView extends StatelessWidget {
  const _RuleSettingsView();

  @override
  Widget build(BuildContext context) => generateSection(
    title: context.appLocalizations.businessSettingsRules,
    items: [
      ListItem.open(
        title: Text(context.appLocalizations.addedRules),
        widget: const AddedRulesView(),
      ),
      ListItem.open(
        title: Text(context.appLocalizations.script),
        widget: const ScriptsView(),
      ),
      ListItem.open(
        title: Text(context.appLocalizations.ruleProviders),
        widget: const ClashProvidersView(),
      ),
      ListItem.open(
        title: Text(context.appLocalizations.filters),
        widget: const FiltersView(),
      ),
      ListItem.open(
        title: Text(context.appLocalizations.proxies),
        widget: const CustomProxiesView(),
      ),
    ],
  );
}

class _NetworkSettingsView extends StatelessWidget {
  const _NetworkSettingsView({required this.navigation});

  final List<NavigationItem> navigation;

  @override
  Widget build(BuildContext context) => generateSection(
    title: context.appLocalizations.businessSettingsInboundPorts,
    items: [
      ListItem.open(
        title: Text(context.appLocalizations.network),
        widget: BaseScaffold(
          title: context.appLocalizations.network,
          body: const NetworkListView(),
        ),
      ),
      for (final item in navigation.where(
        (item) => item.label == PageLabel.requests,
      ))
        ListItem.open(
          title: Text(item.label.label),
          widget: item.builder(context),
        ),
    ],
  );
}

class _DnsSettingsView extends StatelessWidget {
  const _DnsSettingsView({required this.navigation});

  final List<NavigationItem> navigation;

  @override
  Widget build(BuildContext context) => generateSection(
    title: 'DNS',
    items: [
      ListItem.open(title: const Text('DNS'), widget: const DnsView()),
      for (final item in navigation.where(
        (item) =>
            item.label == PageLabel.dns || item.label == PageLabel.resources,
      ))
        ListItem.open(
          title: Text(item.label.label),
          widget: item.builder(context),
        ),
    ],
  );
}

class _TunSettingsView extends StatelessWidget {
  const _TunSettingsView();

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.only(bottom: context.bottomInset + 20),
    children: [
      const NetworkOptionsSection(),
      TunSection(
        isDesktop: system.isDesktop,
        isLinux: system.isLinux,
        isWindows: system.isWindows,
      ),
    ],
  );
}

class _IconAndUaSettingsView extends StatelessWidget {
  const _IconAndUaSettingsView();

  @override
  Widget build(BuildContext context) => generateSection(
    title: context.appLocalizations.businessSettingsIconsUa,
    items: [
      ListItem.open(
        title: Text(context.appLocalizations.iconSets),
        widget: const IconSetsView(),
      ),
      ListItem.open(
        title: Text(context.appLocalizations.userAgent),
        widget: const UserAgentsView(),
      ),
    ],
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
