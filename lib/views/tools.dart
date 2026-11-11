import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
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
import 'package:fl_clash/views/config/tun.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/dashboard/business_exit_warning_banner.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessPrimaryButton, BusinessSecondaryButton;
import 'package:fl_clash/views/diagnostics.dart';
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
      padding: EdgeInsets.only(left: 40, bottom: context.bottomInset + 20),
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
                onTap: () => Navigator.of(
                  context,
                ).push(PagedSheetRoute(builder: (_) => const AddedRulesView())),
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
      Navigator.of(context).push(PagedSheetRoute(builder: (_) => page));
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
    final authentication = ref.watch(
      networkSettingProvider.select((state) => state.authentication.enable),
    );
    final externalController = ref.watch(
      patchClashConfigProvider.select(
        (state) => state.externalController == ExternalControllerStatus.open,
      ),
    );
    return ListView(
      padding: EdgeInsets.only(left: 40, bottom: context.bottomInset + 20),
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
            PagedSheetRoute(
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

class _DnsSettingsView extends ConsumerWidget {
  const _DnsSettingsView({required this.navigation});

  final List<NavigationItem> navigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
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
    final dnsQuery = navigation.where((item) => item.label == PageLabel.dns);
    final resources = navigation.where(
      (item) => item.label == PageLabel.resources,
    );
    return ListView(
      padding: EdgeInsets.only(left: 40, bottom: context.bottomInset + 20),
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
    return ListView(
      padding: EdgeInsets.only(left: 40, bottom: context.bottomInset + 20),
      children: [
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
              onDiagnostics: () => Navigator.of(
                context,
              ).push(PagedSheetRoute(builder: (_) => const DiagnosticsView())),
            ),
          ),
        BusinessSettingsCard(
          title: l10n.tun,
          items: [
            const TunStackItem(),
            if (system.isDesktop) const InterfaceNameModeItem(),
            if (system.isDesktop && customName) const InterfaceNameItem(),
          ],
        ),
        const SizedBox(height: 14),
        BusinessSettingsCard(
          title: l10n.routeAddress,
          items: [
            if (system.isDesktop)
              const BypassPrivateRouteItem()
            else
              ...tunItems(isMipsStack: isMipsStack),
            if (profile != null)
              _BusinessManageRow(
                title: l10n.businessOverrideSettings,
                page: TunView(profile.id),
              ),
          ],
        ),
      ],
    );
  }
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
