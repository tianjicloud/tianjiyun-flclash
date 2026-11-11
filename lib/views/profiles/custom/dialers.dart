import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton, DashboardChip;
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomProxyDialersView extends ConsumerWidget {
  final int profileId;
  final bool embedded;

  const CustomProxyDialersView(
    this.profileId, {
    super.key,
    this.embedded = false,
  });

  Future<void> _handleSelect(
    BuildContext context,
    WidgetRef ref,
    CustomProxy proxy,
  ) async {
    final res = await showSheet<String>(
      context: context,
      builder: (context) => Consumer(
        builder: (_, ref, _) {
          final appLocalizations = context.appLocalizations;
          final profileData = ref.watch(customProfileDataProvider(profileId));
          final named = profileData?.namedProxies ?? const <String>{};
          final groups = profileData?.proxyGroups ?? const <ProxyGroup>[];
          final loopOf = dialerLoopsOf(
            groups,
            proxy: proxy.name,
            dialers: profileData?.dialers ?? const {},
          );
          bool loops(String target) => loopOf(target).isNotEmpty;
          final nodeTypes = {
            for (final item
                in ref.watch(customProxiesProvider).value ??
                    const <CustomProxy>[])
              if (named.contains(item.name) && !loops(item.name))
                item.name: item.type,
          };
          final groupTypes = {
            for (final group in groups)
              if (!loops(group.name)) group.name: group.type.name,
          };
          return SelectionSheet<String>(
            title: appLocalizations.dialerProxy,
            sections: [
              const SelectionSection(items: ['']),
              SelectionSection(
                label: appLocalizations.localProxies,
                items: nodeTypes.keys.toList(),
                subtitleBuilder: (_, name) => nodeTypes[name],
              ),
              SelectionSection(
                label: appLocalizations.proxyGroup,
                items: groupTypes.keys.toList(),
                subtitleBuilder: (_, name) => groupTypes[name],
              ),
            ],
            labelBuilder: (item) => item.isEmpty ? appLocalizations.none : item,
            selectedOf: (ref) => ref.watch(
              proxyDialersProvider(
                profileId,
              ).select((state) => state.value?[proxy.id] ?? ''),
            ),
            onSelected: (item) => Navigator.of(context).pop(item),
          );
        },
      ),
    );
    if (res == null) {
      return;
    }
    ref
        .read(proxyDialersProvider(profileId).notifier)
        .set(proxy.id, res.isEmpty ? null : res);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final all = ref.watch(customProxiesProvider).value;
    final named = ref.watch(
      customProfileDataProvider(profileId).select(
        (state) => state == null ? null : SelectValue(state.namedProxies),
      ),
    );
    final proxies = all == null || named == null
        ? null
        : [
            for (final proxy in all)
              if (named.value.contains(proxy.name)) proxy,
          ];
    if (embedded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: ShapeDecoration(
              color: BusinessPalette.customEditorCardFor(
                context.colorScheme.brightness,
              ),
              shape: AppShape.top(BusinessPalette.cardRadius),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              appLocalizations.dialerProxy,
              style: BusinessText.cardTitle(context),
            ),
          ),
          if (proxies != null)
            for (final (index, proxy) in proxies.indexed)
              ItemPositionProvider(
                key: ValueKey(proxy.id),
                position: ItemPosition.get(index, proxies.length),
                child: _ProxyDialerItem(
                  profileId: profileId,
                  proxy: proxy,
                  embedded: true,
                  isLast: index == proxies.length - 1,
                  onPressed: () => _handleSelect(context, ref, proxy),
                ),
              ),
          if (proxies?.isEmpty ?? false)
            DecoratedBox(
              decoration: ShapeDecoration(
                color: BusinessPalette.customEditorCardFor(
                  context.colorScheme.brightness,
                ),
                shape: AppShape.vertical(
                  top: AppCorner.none,
                  bottom: BusinessPalette.cardRadius,
                ),
              ),
              child: const SizedBox(height: 80),
            ),
        ],
      );
    }
    return Scaffold(
      title: appLocalizations.dialerProxy,
      body: NullStatusSwitcher(
        isLoading: proxies == null,
        isEmpty: proxies?.isEmpty ?? true,
        isSearching: false,
        nullStatus: NullStatus(
          label: appLocalizations.appProxiesEmpty,
          illustration: NullStatusIllustration.data,
        ),
        child: PrismListView(
          padding: EdgeInsets.fromLTRB(
            16,
            context.contentTopPadding,
            16,
            24 + context.bottomInset,
          ),
          itemCount: proxies?.length ?? 0,
          itemBuilder: (_, index) {
            final proxy = proxies![index];
            return ItemPositionProvider(
              key: ValueKey(proxy.id),
              position: ItemPosition.get(index, proxies.length),
              child: _ProxyDialerItem(
                profileId: profileId,
                proxy: proxy,
                onPressed: () => _handleSelect(context, ref, proxy),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProxyDialerItem extends ConsumerWidget {
  final int profileId;
  final CustomProxy proxy;
  final VoidCallback onPressed;
  final bool embedded;
  final bool isLast;

  const _ProxyDialerItem({
    required this.profileId,
    required this.proxy,
    required this.onPressed,
    this.embedded = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final target = ref.watch(
      proxyDialersProvider(profileId).select((state) => state.value?[proxy.id]),
    );
    final issues = ref
        .watch(
          customProfileIssuesProvider(profileId).select(
            (state) =>
                SelectValue(state.dialers[proxy.id] ?? const <CustomIssue>[]),
          ),
        )
        .value;
    if (embedded) {
      final host = proxy.definition['server']?.toString() ?? '';
      final port = proxy.definition['port']?.toString();
      final address = port == null || port.isEmpty ? host : '$host:$port';
      return SizedBox(
        height: 49,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: BusinessPalette.customEditorCardFor(
              context.colorScheme.brightness,
            ),
            shape: isLast
                ? AppShape.vertical(
                    top: AppCorner.none,
                    bottom: BusinessPalette.cardRadius,
                  )
                : AppShape.none,
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              proxy.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: BusinessText.cardTitle(context),
                            ),
                            Text(
                              target == null || target.isEmpty
                                  ? address
                                  : target,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: BusinessText.metaLabel(context).copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                fontFamily: 'JetBrainsMono',
                              ),
                            ),
                          ],
                        ),
                      ),
                      DashboardChip(
                        label: proxy.type,
                        labelStyle: BusinessText.proxyProtocol(context),
                      ),
                      if (issues.isNotEmpty) CustomIssueButton(issues: issues),
                      BusinessSecondaryButton(
                        label: context.appLocalizations.edit,
                        width: 64,
                        height: 30,
                        onPressed: onPressed,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                SizedBox(
                  height: 1,
                  child: ColoredBox(color: context.colorScheme.outlineVariant),
                ),
            ],
          ),
        ),
      );
    }
    return DecorationListItem(
      invalid: issues.isNotEmpty,
      onPressed: onPressed,
      contentPadding: const EdgeInsets.only(left: 16, right: 8),
      title: TooltipText(
        text: Text(proxy.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      subtitle: target == null
          ? null
          : Text(target, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: issues.isEmpty ? null : CustomIssueButton(issues: issues),
    );
  }
}
