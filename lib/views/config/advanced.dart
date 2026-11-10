import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/config/dns.dart';
import 'package:fl_clash/views/config/filters.dart';
import 'package:fl_clash/views/config/icon_sets.dart';
import 'package:fl_clash/views/config/mitm.dart';
import 'package:fl_clash/views/config/network.dart';
import 'package:fl_clash/views/config/providers.dart';
import 'package:fl_clash/views/config/scripts.dart';
import 'package:fl_clash/views/profiles/custom/custom_proxies.dart';
import 'package:fl_clash/views/dashboard/widgets/outbound_mode.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'rules.dart';

class AdvancedConfigView extends StatelessWidget {
  const AdvancedConfigView({super.key, this.isAndroid});

  final bool? isAndroid;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final isAndroid = this.isAndroid ?? system.isAndroid;
    final items = [
      if (isAndroid) const _OutboundModeItem(),
      ListItem.open(
        title: Text(appLocalizations.network),
        leading: const GlyphIcon(AppGlyphs.key),
        widget: BaseScaffold(
          title: appLocalizations.network,
          body: const NetworkListView(),
        ),
      ),
      ListItem.open(
        title: const Text('DNS'),
        leading: const GlyphIcon(AppGlyphs.dns),
        widget: const DnsView(),
      ),
      ListItem.open(
        title: Text(appLocalizations.addedRules),
        leading: const GlyphIcon(AppGlyphs.rules),
        widget: const AddedRulesView(),
      ),
      ListItem.open(
        title: Text(appLocalizations.script),
        leading: const GlyphIcon(AppGlyphs.code),
        widget: const ScriptsView(),
      ),
      if (mitmFeature)
        ListItem.open(
          title: Text(appLocalizations.mitm),
          leading: const GlyphIcon(AppGlyphs.lockOpen),
          widget: MitmView(isAndroid: system.isAndroid),
        ),
    ];
    final customItems = [
      ListItem.open(
        title: Text(appLocalizations.proxies),
        leading: const GlyphIcon(AppGlyphs.proxies),
        widget: const CustomProxiesView(),
      ),
      ListItem.open(
        title: Text(appLocalizations.ruleProviders),
        leading: const GlyphIcon(AppGlyphs.resources),
        widget: const ClashProvidersView(),
      ),
      ListItem.open(
        title: Text(appLocalizations.filters),
        leading: const GlyphIcon(AppGlyphs.filter),
        widget: const FiltersView(),
      ),
      ListItem.open(
        title: Text(appLocalizations.iconSets),
        leading: const GlyphIcon(AppGlyphs.photos),
        widget: const IconSetsView(),
      ),
    ];
    return BaseScaffold(
      title: appLocalizations.advancedConfig,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
          top: context.sectionsTopPadding,
          bottom: 16 + context.bottomInset,
        ),
        children: [
          generateSection(items: items),
          generateSection(
            title: appLocalizations.customResources,
            items: customItems,
          ),
        ],
      ),
    );
  }
}

class _OutboundModeItem extends ConsumerWidget {
  const _OutboundModeItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    return ListItem(
      minVerticalPadding: 12,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.outboundMode),
          Text(
            l10n.outboundModeDescription,
            style: context.listSubtitleStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          const SizedBox(
            width: double.infinity,
            child: OutboundModeInline(height: 28),
          ),
        ],
      ),
    );
  }
}
