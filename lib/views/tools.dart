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
        keyName: 'general',
        section: l10n.settings,
        title: l10n.general,
        glyph: AppGlyphs.settings,
        page: const GeneralView(),
      ),
      if (system.isAndroid)
        _SettingsEntry(
          keyName: 'access',
          section: l10n.settings,
          title: l10n.accessControl,
          glyph: AppGlyphs.appsList,
          page: const AccessView(),
        ),
      _SettingsEntry(
        keyName: 'language',
        section: l10n.settings,
        title: l10n.language,
        glyph: AppGlyphs.language,
        page: const _LocaleSettingsView(),
      ),
      _SettingsEntry(
        keyName: 'appearance',
        section: l10n.settings,
        title: l10n.theme,
        glyph: AppGlyphs.paintbrush,
        page: const ThemeView(),
      ),
      if (system.isDesktop)
        _SettingsEntry(
          keyName: 'hotkeys',
          section: l10n.settings,
          title: l10n.hotkeyManagement,
          glyph: AppGlyphs.keyboard,
          page: const HotKeyView(),
        ),
      _SettingsEntry(
        keyName: 'on-demand',
        section: l10n.settings,
        title: l10n.onDemand,
        glyph: AppGlyphs.proxies,
        page: const OnDemandView(),
      ),
      _SettingsEntry(
        keyName: 'backup',
        section: l10n.settings,
        title: l10n.backupAndRestore,
        glyph: AppGlyphs.cloudSync,
        page: const BackupAndRestore(),
      ),
      _SettingsEntry(
        keyName: 'network',
        section: l10n.advancedConfig,
        title: l10n.network,
        glyph: AppGlyphs.key,
        page: BaseScaffold(title: l10n.network, body: const NetworkListView()),
      ),
      _SettingsEntry(
        keyName: 'dns',
        section: l10n.advancedConfig,
        title: 'DNS',
        glyph: AppGlyphs.dns,
        page: const DnsView(),
      ),
      _SettingsEntry(
        keyName: 'rules',
        section: l10n.advancedConfig,
        title: l10n.addedRules,
        glyph: AppGlyphs.rules,
        page: const AddedRulesView(),
      ),
      _SettingsEntry(
        keyName: 'scripts',
        section: l10n.advancedConfig,
        title: l10n.script,
        glyph: AppGlyphs.code,
        page: const ScriptsView(),
      ),
      if (mitmFeature)
        _SettingsEntry(
          keyName: 'mitm',
          section: l10n.advancedConfig,
          title: l10n.mitm,
          glyph: AppGlyphs.lockOpen,
          page: MitmView(isAndroid: system.isAndroid),
        ),
      _SettingsEntry(
        keyName: 'icon-sets',
        section: l10n.advancedConfig,
        title: l10n.iconSets,
        glyph: AppGlyphs.photos,
        page: const IconSetsView(),
      ),
      _SettingsEntry(
        keyName: 'providers',
        section: l10n.advancedConfig,
        title: l10n.ruleProviders,
        glyph: AppGlyphs.resources,
        page: const ClashProvidersView(),
      ),
      _SettingsEntry(
        keyName: 'filters',
        section: l10n.advancedConfig,
        title: l10n.filters,
        glyph: AppGlyphs.filter,
        page: const FiltersView(),
      ),
      _SettingsEntry(
        keyName: 'user-agents',
        section: l10n.advancedConfig,
        title: l10n.userAgent,
        glyph: AppGlyphs.language,
        page: const UserAgentsView(),
      ),
      _SettingsEntry(
        keyName: 'custom-proxies',
        section: l10n.advancedConfig,
        title: l10n.proxies,
        glyph: AppGlyphs.proxies,
        page: const CustomProxiesView(),
      ),
      _SettingsEntry(
        keyName: 'service-management',
        section: l10n.advancedConfig,
        title: l10n.serviceManage,
        glyph: AppGlyphs.settings,
        page: const ServiceManageView(),
      ),
      _SettingsEntry(
        keyName: 'other',
        section: l10n.other,
        title: l10n.about,
        glyph: AppGlyphs.info,
        page: const AboutView(),
      ),
      if (widget.developerMode)
        _SettingsEntry(
          keyName: 'developer',
          section: l10n.other,
          title: l10n.developerMode,
          glyph: AppGlyphs.code,
          page: const DeveloperView(),
        ),
      for (final item in navigation)
        _SettingsEntry(
          keyName: 'tool:${item.label.name}',
          section: l10n.settings,
          title: item.label.label,
          glyph: item.glyph,
          page: item.builder(context),
        ),
    ];
    final active = entries.firstWhere(
      (entry) => entry.keyName == _selectedKey,
      orElse: () => entries.first,
    );
    final sections = <String, List<_SettingsEntry>>{};
    for (final entry in entries) {
      sections.putIfAbsent(entry.section, () => []).add(entry);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 180,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: context.colorScheme.surfaceContainerLow,
              shape: AppShape.all(AppCorner.xl),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 18),
                    child: Text(
                      l10n.settings,
                      style: AppTextStyle.pageTitle
                          .of(context)
                          .copyWith(color: context.colorScheme.onSurface),
                    ),
                  ),
                  Expanded(
                    child: FocusTraversalGroup(
                      child: ListView(
                        children: [
                          for (final section in sections.entries) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 12, 10, 6),
                              child: Text(
                                section.key,
                                style: AppTextStyle.caption1
                                    .of(context, emphasized: true)
                                    .copyWith(
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                            for (final entry in section.value)
                              _SettingsNavigationItem(
                                entry: entry,
                                selected: entry.keyName == active.keyName,
                                onPressed: () => setState(
                                  () => _selectedKey = entry.keyName,
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: KeyedSubtree(
            key: ValueKey(active.keyName),
            child: active.page,
          ),
        ),
      ],
    );
  }
}

class _SettingsEntry {
  const _SettingsEntry({
    required this.keyName,
    required this.section,
    required this.title,
    required this.glyph,
    required this.page,
  });

  final String keyName;
  final String section;
  final String title;
  final Glyph glyph;
  final Widget page;
}

class _LocaleSettingsView extends StatelessWidget {
  const _LocaleSettingsView();

  @override
  Widget build(BuildContext context) => generateSection(
    title: context.appLocalizations.language,
    items: [const _LocaleItem()],
  );
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
    final dark = context.colorScheme.brightness == Brightness.dark;
    final foreground = selected
        ? dark
              ? context.colorScheme.onSurface
              : BusinessPalette.deep
        : context.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: FocusRing(
        shape: AppShape.md,
        child: PressRegion(
          onTap: onPressed,
          shape: AppShape.md,
          overlay: PressRegion.hoverOverlay,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: selected
                  ? context.colorScheme.surfaceBright
                  : const Color(0x00FFFFFF),
              shape: selected
                  ? RoundedSuperellipseBorder(
                      side: BorderSide(
                        color: context.colorScheme.outlineVariant,
                      ),
                      borderRadius: AppRadius.md,
                    )
                  : AppShape.md,
            ),
            child: SizedBox(
              height: 38,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    GlyphIcon(
                      entry.glyph,
                      color: selected ? BusinessPalette.blue : foreground,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.subheadline
                            .of(context, emphasized: selected)
                            .copyWith(color: foreground),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
