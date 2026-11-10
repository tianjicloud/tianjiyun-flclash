import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/region_code_badge.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void selectGroupProxy(
  WidgetRef ref, {
  required String groupName,
  required GroupType groupType,
  required String proxyName,
}) {
  final isComputedSelected =
      groupType.isComputedSelected ||
      ref
              .read(currentProfileProvider)
              ?.overrides
              .manualSelections[groupName]
              ?.automaticGroup ==
          true;
  if (isComputedSelected || groupType == GroupType.Selector) {
    final currentProxyName = ref.read(proxyNameProvider(groupName));
    final nextProxyName = switch (isComputedSelected) {
      true => currentProxyName == proxyName ? '' : proxyName,
      false => proxyName,
    };
    ref
        .read(proxiesActionProvider.notifier)
        .changeProxyDebounce(groupName, nextProxyName);
    return;
  }
  dialogs.showBanner(
    currentAppLocalizations.notSelectedTip,
    level: BannerLevel.warning,
  );
}

/// Built-ins and groups have no definition, and a custom profile's own proxies
/// are the local proxies already.
bool _isAddableToLocal(Proxy proxy, {required bool isCustomProfile}) {
  return (proxy.providerName != null || !isCustomProfile) &&
      !reservedCustomProxyNames.contains(proxy.name) &&
      GroupTypeExtension.getGroupType(proxy.type) == null;
}

class ProxyCard extends ConsumerWidget {
  final String groupName;
  final Proxy proxy;
  final GroupType groupType;
  final ProxyCardType type;
  final String? testUrl;
  final bool businessStyle;

  const ProxyCard({
    super.key,
    required this.groupName,
    required this.testUrl,
    required this.proxy,
    required this.groupType,
    required this.type,
    this.businessStyle = false,
  });

  Measure get measure => globalState.measure;

  Widget _buildProxyNameText(BuildContext context) {
    if (type == ProxyCardType.compact) {
      return SizedBox(
        height: measure.textHeight(AppTextStyle.subheadline) * 1,
        child: EmojiText(
          proxy.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.subheadline.of(context),
        ),
      );
    } else {
      return SizedBox(
        height: measure.textHeight(AppTextStyle.subheadline) * 2,
        child: EmojiText(
          proxy.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.subheadline.of(context),
        ),
      );
    }
  }

  ({String? code, String name}) _businessName() {
    final runes = proxy.name.runes.toList();
    var start = 0;
    while (start < runes.length &&
        (runes[start] == 0x20 || runes[start] == 0xA0)) {
      start++;
    }
    if (start + 1 >= runes.length ||
        runes[start] < 0x1F1E6 ||
        runes[start] > 0x1F1FF ||
        runes[start + 1] < 0x1F1E6 ||
        runes[start + 1] > 0x1F1FF) {
      return (code: null, name: proxy.name);
    }
    return (
      code: String.fromCharCodes([
        65 + runes[start] - 0x1F1E6,
        65 + runes[start + 1] - 0x1F1E6,
      ]),
      name: String.fromCharCodes(runes.skip(start + 2)).trimLeft(),
    );
  }

  Widget _buildBusinessContent(BuildContext context) {
    final region = _businessName();
    final multiplier = RegExp(
      r'\b(\d+(?:\.\d+)?)x\b',
      caseSensitive: false,
    ).firstMatch(proxy.name)?.group(1);
    final delayText = _BusinessDelayText(proxy: proxy, testUrl: testUrl);
    final chipStyle = AppTextStyle.caption1
        .of(context)
        .copyWith(color: context.colorScheme.onSurfaceVariant);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            if (region.code case final code?) RegionCodeBadge(code: code),
            Expanded(
              child: EmojiText(
                region.name.replaceAll(
                  RegExp(r'\s*\d+(?:\.\d+)?x\b', caseSensitive: false),
                  '',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: BusinessText.cardTitle(context),
              ),
            ),
            Align(alignment: Alignment.centerRight, child: delayText),
          ],
        ),
        const SizedBox(height: 8),
        if (multiplier != null)
          _ProxyMetaChip(
            label: context.appLocalizations.businessMultiplier(multiplier),
            style: chipStyle,
          )
        else
          const SizedBox(height: 22),
      ],
    );
  }

  void _handleSelect(WidgetRef ref) {
    selectGroupProxy(
      ref,
      groupName: groupName,
      groupType: groupType,
      proxyName: proxy.name,
    );
  }

  void _handleAddToLocalProxies(WidgetRef ref) {
    final proxiesAction = ref.read(proxiesActionProvider.notifier);
    globalState.safeRun(() => proxiesAction.addToLocalProxies(proxy.name));
  }

  List<PopupMenuItem> _menuItems(
    BuildContext context,
    WidgetRef ref, {
    required bool inUse,
    required bool pinned,
    required bool addable,
    required bool businessStyle,
  }) {
    final appLocalizations = context.appLocalizations;
    return [
      if (businessStyle)
        PopupMenuItem(
          glyph: AppGlyphs.bolt,
          label: appLocalizations.delayTest,
          onPressed: () => ref.read(proxiesActionProvider.notifier).delayTest([
            proxy,
          ], testUrl),
        ),
      if (groupType == GroupType.Selector)
        PopupMenuItem(
          glyph: AppGlyphs.checkCircle,
          label: appLocalizations.select,
          checked: inUse,
          onPressed: () => _handleSelect(ref),
        )
      else if (groupType.isComputedSelected)
        PopupMenuItem(
          glyph: AppGlyphs.pin,
          label: appLocalizations.preferred,
          checked: pinned,
          onPressed: () => _handleSelect(ref),
        ),
      if (addable)
        PopupMenuItem(
          glyph: AppGlyphs.listAdd,
          label: appLocalizations.addToLocalProxies,
          onPressed: () => _handleAddToLocalProxies(ref),
        ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measure = globalState.measure;
    final isLoose = type == ProxyCardType.loose;
    final delayText = _DelayText(
      proxy: proxy,
      testUrl: testUrl,
      alignment: isLoose ? Alignment.centerLeft : Alignment.centerRight,
    );
    final proxyNameText = _buildProxyNameText(context);
    final typeStyle = AppTextStyle.footnote
        .of(context)
        .copyWith(
          overflow: TextOverflow.ellipsis,
          color: context.colorScheme.onSurface.opacity80,
        );
    final details = isLoose
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: measure.textHeight(AppTextStyle.footnote),
                child: _ProxyDesc(proxy: proxy, style: typeStyle),
              ),
              const SizedBox(height: 6),
              delayText,
            ],
          )
        : SizedBox(
            height: measure.textHeight(AppTextStyle.footnote),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: TooltipText(
                    text: Text(proxy.type, maxLines: 1, style: typeStyle),
                  ),
                ),
                delayText,
              ],
            ),
          );
    return Consumer(
      builder: (context, ref, _) {
        final inUse = ref.watch(
          selectedProxyNameProvider(
            groupName,
          ).select((name) => name == proxy.name),
        );
        final pinned =
            groupType.isComputedSelected &&
            ref.watch(
              proxyNameProvider(groupName).select((name) => name == proxy.name),
            );
        final isCustomProfile = ref.watch(
          currentProfileProvider.select(
            (profile) => profile?.type == ProfileType.custom,
          ),
        );
        final card = Card(
          radius: businessStyle ? AppCorner.md : AppCorner.lg,
          shape: businessStyle
              ? const RoundedSuperellipseBorder(
                  side: BorderSide.none,
                  borderRadius: AppRadius.md,
                )
              : null,
          enterActionsOnRight: true,
          key: key,
          onPressed: () => _handleSelect(ref),
          isSelected: inUse,
          padding: businessStyle
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
              : const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: businessStyle
                ? [_buildBusinessContent(context)]
                : [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Expanded(child: proxyNameText),
                        if (pinned)
                          SelectionBadge(glyph: Glyphs.pin, tonal: !inUse)
                        else if (inUse)
                          const SelectionBadge(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    details,
                  ],
          ),
        );
        final selectedCard = businessStyle && inUse
            ? DecoratedBox(
                decoration: ShapeDecoration(
                  shadows: [BusinessShadow.selectedLine(BusinessPalette.blue)],
                  shape: AppShape.md,
                ),
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: const ShapeDecoration(
                    shape: RoundedSuperellipseBorder(
                      side: BorderSide(color: BusinessPalette.blue, width: 2),
                      borderRadius: AppRadius.md,
                    ),
                  ),
                  child: card,
                ),
              )
            : card;
        return ContextMenuRegion(
          menuItems: _menuItems(
            context,
            ref,
            inUse: inUse,
            pinned: pinned,
            addable: _isAddableToLocal(proxy, isCustomProfile: isCustomProfile),
            businessStyle: businessStyle,
          ),
          child: Semantics(selected: inUse, child: selectedCard),
        );
      },
    );
  }
}

class _BusinessDelayText extends ConsumerWidget {
  const _BusinessDelayText({required this.proxy, required this.testUrl});

  final Proxy proxy;
  final String? testUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delay = ref.watch(
      delayProvider(proxyName: proxy.name, testUrl: testUrl),
    );
    final phase = ref.watch(
      delayTestPhaseProvider(proxyName: proxy.name, testUrl: testUrl),
    );
    final color = delay != null && delay <= 0
        ? context.colorScheme.error
        : businessDelayColor(context.colorScheme, delay);
    final label = switch ((phase, delay)) {
      (DelayTestPhase.running || DelayTestPhase.queued, _) => '…',
      (_, null) => '—',
      (_, final value?) when value > 0 => '$value ms',
      _ => context.appLocalizations.businessDelayTimeout,
    };
    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style:
          (delay != null && delay <= 0
                  ? AppTextStyle.footnote.of(context, emphasized: true)
                  : BusinessText.cardDelay(context))
              .copyWith(color: color),
    );
  }
}

class _ProxyMetaChip extends StatelessWidget {
  const _ProxyMetaChip({required this.label, required this.style});

  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: context.colorScheme.brightness == Brightness.dark
            ? context.colorScheme.surfaceContainerHigh
            : const Color(0xFFEEF1F4),
        shape: AppShape.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ),
    );
  }
}

class _ProxyDesc extends ConsumerWidget {
  const _ProxyDesc({required this.proxy, required this.style});

  final Proxy proxy;
  final TextStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGroup = GroupType.values.any((type) => type.name == proxy.type);
    final nodeName = isGroup
        ? ref.watch(
            realSelectedProxyStateProvider(
              proxy.name,
            ).select((state) => state.proxyName),
          )
        : proxy.name;
    return EmojiText(
      nodeName == proxy.name ? proxy.type : '${proxy.type}($nodeName)',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}

class _DelayText extends ConsumerStatefulWidget {
  const _DelayText({
    required this.proxy,
    required this.testUrl,
    required this.alignment,
  });

  final Proxy proxy;
  final String? testUrl;
  final Alignment alignment;

  @override
  ConsumerState<_DelayText> createState() => _DelayTextState();
}

class _DelayTextState extends ConsumerState<_DelayText> {
  final FocusNode _focusNode = SkipTraversalFocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    final isFocused = _focusNode.hasPrimaryFocus;
    if (isFocused == _isFocused) {
      return;
    }
    setState(() {
      _isFocused = isFocused;
    });
  }

  void _handleTestCurrentDelay() {
    ref
        .read(proxiesActionProvider.notifier)
        .proxyDelayTest(widget.proxy, widget.testUrl);
  }

  Widget _withFocusRing(BuildContext context, Widget child) {
    if (!_isFocused) {
      return child;
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -2,
          right: -3,
          bottom: -2,
          left: -3,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: AppShape.xs.copyWith(
                  side: focusRingSide(context.colorScheme),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final measure = globalState.measure;
    final delay = ref.watch(
      delayProvider(proxyName: widget.proxy.name, testUrl: widget.testUrl),
    );
    final phase = ref.watch(
      delayTestPhaseProvider(
        proxyName: widget.proxy.name,
        testUrl: widget.testUrl,
      ),
    );
    return Actions(
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _handleTestCurrentDelay();
            return null;
          },
        ),
      },
      child: Focus(
        focusNode: _focusNode,
        child: SizedBox(
          height: measure.textHeight(AppTextStyle.caption2),
          child: FadeBox(
            alignment: widget.alignment,
            child: phase != null || delay == null
                ? SizedBox(
                    height: measure.textHeight(AppTextStyle.caption2),
                    width: measure.textHeight(AppTextStyle.caption2),
                    child: _withFocusRing(context, switch (phase) {
                      DelayTestPhase.running => ActivityIndicator(
                        size: measure.textHeight(AppTextStyle.caption2),
                      ),
                      DelayTestPhase.queued => GlyphIcon(
                        AppGlyphs.clock,
                        size: measure.textHeight(AppTextStyle.caption2),
                        color: context.colorScheme.onSurfaceVariant.opacity38,
                      ),
                      null => HoverTooltip(
                        message: context.appLocalizations.delayTest,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _handleTestCurrentDelay,
                          child: GlyphIcon(
                            AppGlyphs.bolt,
                            size: measure.textHeight(AppTextStyle.caption2),
                          ),
                        ),
                      ),
                    }),
                  )
                : GestureDetector(
                    onTap: _handleTestCurrentDelay,
                    child: _withFocusRing(
                      context,
                      Text(
                        delay > 0
                            ? '$delay ms'
                            : delayFailureText(delay, context.appLocalizations),
                        maxLines: 1,
                        style: AppTextStyle.caption2
                            .of(context, emphasized: true)
                            .copyWith(
                              overflow: TextOverflow.ellipsis,
                              color: context.colorScheme.delayColor(delay),
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
