import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/clash_config.dart';
import 'package:fl_clash/pages/editor.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show
        BusinessPrimaryButton,
        BusinessSecondaryButton,
        DashboardChip,
        DashboardChipTone;
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomRulesView extends ConsumerStatefulWidget {
  final int profileId;
  final bool embedded;
  final ValueChanged<Widget?>? onEditPanel;

  const CustomRulesView(
    this.profileId, {
    super.key,
    this.embedded = false,
    this.onEditPanel,
  });

  @override
  ConsumerState createState() => _CustomRulesViewState();
}

class _CustomRulesViewState extends ConsumerState<CustomRulesView> {
  final _searchTexts = Expando<String>();
  var _query = SearchQuery('');
  var _showSearch = false;

  int get _profileId => widget.profileId;

  void _handleReorder(int oldIndex, int newIndex) {
    ref
        .read(profileRulesProvider(_profileId).notifier)
        .order(oldIndex, newIndex);
  }

  void _handleQuickActions() {
    showSheet<void>(
      context: context,
      builder: (_) => RulePresetSheet(
        onAdd: ref.read(profileRulesProvider(_profileId).notifier).putAll,
      ),
    );
  }

  void _handleDelete(Set<int> ruleIds) {
    ref.read(profileRulesProvider(_profileId).notifier).delAll(ruleIds);
  }

  Future<void> _handleConfirmDelete(Rule rule) async {
    final appLocalizations = context.appLocalizations;
    final res = await dialogs.showMessage(
      message: TextSpan(
        text: appLocalizations.deleteTip(appLocalizations.rule),
      ),
      destructive: true,
      confirmText: appLocalizations.delete,
    );
    if (res == true && mounted) {
      _handleDelete({rule.id});
    }
  }

  void _handleDuplicate(Set<int> ruleIds) {
    final notifier = ref.read(profileRulesProvider(_profileId).notifier);
    notifier.insertAfterEach({
      for (final rule in notifier.value)
        if (ruleIds.contains(rule.id)) rule.id: rule.copyWith(id: snowflake.id),
    });
  }

  List<PopupMenuItem> _menuItems(Rule rule) {
    final appLocalizations = context.appLocalizations;
    return [
      PopupMenuItem(
        glyph: AppGlyphs.copy,
        label: appLocalizations.copy,
        onPressed: () => _handleDuplicate({rule.id}),
      ),
      PopupMenuItem(
        glyph: AppGlyphs.delete,
        label: appLocalizations.delete,
        danger: true,
        onPressed: () => _handleConfirmDelete(rule),
      ),
    ];
  }

  Future<void> _handleQuickEdit() {
    final appLocalizations = context.appLocalizations;
    final provider = profileRulesProvider(_profileId);
    final previous = ref.read(provider).value;
    if (previous == null) {
      return Future.value();
    }
    final notifier = ref.read(provider.notifier);
    return showQuickEdit(
      context,
      title: appLocalizations.rule,
      content: encodeRuleList(previous),
      schema: EditorSchema.rules,
      invalidMessage: appLocalizations.ruleListInvalid,
      apply: (content) {
        final rules = <Rule>[];
        try {
          for (final (:line, :rule) in decodeRuleList(
            content,
            previous: previous,
          )) {
            if (rule.ruleAction == RuleAction.SUB_RULE) {
              continue;
            }
            final error = _ruleSaveError(context, rule);
            if (error != null) {
              throw MessageException(
                appLocalizations.lineIssueTip(line, error),
              );
            }
            rules.add(rule);
          }
        } on RuleLineException catch (error) {
          throw MessageException(
            appLocalizations.lineIssueTip(
              error.line,
              appLocalizations.ruleTextInvalid,
            ),
          );
        }
        notifier.setAll(rules);
      },
    );
  }

  void _handleAddOrUpdate({Rule? rule}) {
    final initial = rule ?? Rule.init();
    final overrides = [ruleProvider.overrideWithBuild((_, _) => initial)];
    final onEditPanel = widget.onEditPanel;
    if (onEditPanel != null) {
      onEditPanel(
        ProfileIdProvider(
          profileId: widget.profileId,
          child: ProviderScope(
            overrides: overrides,
            child: InlineFormHost(
              formBuilder: (_) => const _AddOrEditRuleView(),
              onClose: () => onEditPanel(null),
            ),
          ),
        ),
      );
      return;
    }
    showNestedFormSheet<Rule>(
      context: context,
      profileId: widget.profileId,
      overrides: overrides,
      currentOf: (ref) => ref.read(ruleProvider),
      formBuilder: (_) => const _AddOrEditRuleView(),
    );
  }

  void _handleSearch(String value) {
    setState(() => _query = SearchQuery(value));
  }

  Widget _buildEmbedded(BuildContext context, CustomProfileData? profileData) {
    final appLocalizations = context.appLocalizations;
    final all = ref.watch(profileRulesProvider(_profileId)).value;
    final rules = (all ?? const <Rule>[])
        .whereMatches(_query, (rule) => rule.searchFields, texts: _searchTexts)
        .toList();
    final color = BusinessPalette.customEditorCardFor(
      context.colorScheme.brightness,
    );
    Widget rowAt(int index) {
      final rule = rules[index];
      final issues = profileData == null
          ? const <CustomIssue>[]
          : customRuleIssues(rule, profileData);
      final row = _BusinessRuleRow(
        index: index + 1,
        rule: rule,
        issues: issues,
        isLast: index == rules.length - 1,
        reorderable: _query.isEmpty,
        onEdit: () => _handleAddOrUpdate(rule: rule),
      );
      return ItemPositionProvider(
        key: ValueKey(rule.id),
        position: ItemPosition.get(index, rules.length),
        child: row,
      );
    }

    return NullStatusSwitcher(
      isLoading: all == null,
      isEmpty: rules.isEmpty,
      isSearching: _query.isNotEmpty,
      nullStatus: NullStatus(
        label: appLocalizations.ruleEmpty,
        illustration: NullStatusIllustration.data,
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: ShapeDecoration(
                color: color,
                shape: rules.isEmpty
                    ? AppShape.all(BusinessPalette.cardRadius)
                    : AppShape.top(BusinessPalette.cardRadius),
              ),
              child: Row(
                spacing: 8,
                children: [
                  Text(
                    appLocalizations.customRuleCardTitle,
                    style: BusinessText.cardTitle(context),
                  ),
                  const Spacer(),
                  if (_showSearch)
                    SizedBox(
                      width: 180,
                      child: TextField(
                        onChanged: _handleSearch,
                        decoration: InputDecoration(
                          hintText: appLocalizations.search,
                        ),
                      ),
                    )
                  else
                    IconButton(
                      icon: const GlyphIcon(AppGlyphs.search),
                      tooltip: appLocalizations.search,
                      onPressed: () => setState(() => _showSearch = true),
                    ),
                  BusinessSecondaryButton(
                    label: appLocalizations.quickEdit,
                    width: 92,
                    onPressed: _handleQuickEdit,
                  ),
                  BusinessSecondaryButton(
                    label: appLocalizations.customRulePresets,
                    width: 118,
                    onPressed: _handleQuickActions,
                  ),
                  BusinessPrimaryButton(
                    label: appLocalizations.add,
                    glyph: AppGlyphs.add,
                    width: 92,
                    onPressed: () => _handleAddOrUpdate(),
                  ),
                ],
              ),
            ),
          ),
          if (rules.isEmpty)
            SliverToBoxAdapter(
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color,
                  shape: AppShape.vertical(
                    top: AppCorner.none,
                    bottom: BusinessPalette.cardRadius,
                  ),
                ),
                child: const SizedBox(height: 80),
              ),
            )
          else if (_query.isEmpty)
            SliverPrismReorderableList(
              itemCount: rules.length,
              itemBuilder: (_, index) => rowAt(index),
              itemExtent: 49,
              proxyDecorator: (child, index, animation) =>
                  commonProxyDecorator(rowAt(index), index, animation),
              onReorderItem: _handleReorder,
            )
          else
            SliverPrismList(
              itemCount: rules.length,
              itemBuilder: (_, index) => rowAt(index),
              itemExtent: 49,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    final appLocalizations = context.appLocalizations;
    final profileData = ref.watch(customProfileDataProvider(_profileId));
    if (widget.embedded) {
      return _buildEmbedded(context, profileData);
    }
    return ListEditorPage<Rule, int>(
      title: appLocalizations.rule,
      idOf: (rule) => rule.id,
      itemsOf: (ref) {
        return ref.watch(profileRulesProvider(_profileId)).value;
      },
      itemBuilder:
          (context, ref, rule, index, isEditing, isSelected, onToggleSelected) {
            return RuleItem(
              invalidMessageOf: (target) {
                final issues = profileData == null
                    ? const <CustomIssue>[]
                    : customRuleIssues(target, profileData);
                return issues.isEmpty ? null : issues.getMessage(context);
              },
              isEditing: isEditing,
              isSelected: isSelected,
              rule: rule,
              onSelected: onToggleSelected,
              onEdit: (rule) {
                _handleAddOrUpdate(rule: rule);
              },
            );
          },
      onQuickEdit: _handleQuickEdit,
      onReorder: _handleReorder,
      onAdd: () => _handleAddOrUpdate(),
      addMenuItems: [
        PopupMenuItem(
          glyph: AppGlyphs.rulePresets,
          label: appLocalizations.quickActions,
          onPressed: _handleQuickActions,
        ),
      ],
      onDelete: _handleDelete,
      menuItemsOf: _menuItems,
      searchFieldsOf: (rule) => rule.searchFields,
      emptyLabel: appLocalizations.ruleEmpty,
      itemExtent: ruleItemHeight,
    );
  }
}

class _BusinessRuleRow extends StatelessWidget {
  const _BusinessRuleRow({
    required this.index,
    required this.rule,
    required this.issues,
    required this.isLast,
    required this.reorderable,
    required this.onEdit,
  });

  final int index;
  final Rule rule;
  final List<CustomIssue> issues;
  final bool isLast;
  final bool reorderable;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final target = rule.ruleTarget ?? '';
    final tone = switch (target.toUpperCase()) {
      'DIRECT' || 'COMPATIBLE' => DashboardChipTone.ok,
      'REJECT' || 'REJECT-DROP' => DashboardChipTone.warn,
      _ => DashboardChipTone.primary,
    };
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
                    if (reorderable)
                      ReorderDragStartListener(
                        index: index - 1,
                        child: GlyphIcon(
                          AppGlyphs.dragHandle,
                          color: context.colorScheme.onSurfaceVariant,
                          size: 14,
                        ),
                      ),
                    SizedBox(
                      width: 28,
                      child: Text(
                        index.toString().padLeft(2, '0'),
                        textAlign: TextAlign.end,
                        style: BusinessText.proxyProtocol(
                          context,
                        ).copyWith(color: context.colorScheme.onSurfaceVariant),
                      ),
                    ),
                    SizedBox(
                      width: 136,
                      child: DashboardChip(
                        label: rule.ruleAction.value,
                        labelStyle: BusinessText.proxyProtocol(context),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rule.realContent ?? rule.content ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: BusinessText.customRuleContent(context),
                      ),
                    ),
                    if (issues.isNotEmpty) CustomIssueButton(issues: issues),
                    DashboardChip(
                      label: switch (target.toUpperCase()) {
                        'DIRECT' => context.appLocalizations.direct,
                        'REJECT' ||
                        'REJECT-DROP' => context.appLocalizations.intercept,
                        _ => target,
                      },
                      tone: tone,
                    ),
                    BusinessSecondaryButton(
                      label: context.appLocalizations.edit,
                      width: 64,
                      height: 30,
                      onPressed: onEdit,
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
}

class _AddOrEditRuleView extends ConsumerStatefulWidget {
  const _AddOrEditRuleView();

  @override
  ConsumerState<_AddOrEditRuleView> createState() => _AddOrEditRuleViewState();
}

class _AddOrEditRuleViewState extends ConsumerState<_AddOrEditRuleView> {
  @override
  void initState() {
    super.initState();
    NestedFormSheet.bindSave(context, _handleSave);
  }

  Widget _buildItem({
    required String title,
    TextStyle? titleStyle,
    Widget? trailing,
    bool? invalid,
    final VoidCallback? onPressed,
  }) {
    return FormRow(
      invalid: invalid ?? false,
      onPressed: onPressed,
      title: title,
      titleStyle: titleStyle,
      trailing: trailing,
    );
  }

  Future<void> _handleSelectedType() async {
    final res = await Navigator.of(context).push(
      PagedSheetRoute(
        builder: (context) => SelectionSheet<RuleAction>(
          title: context.appLocalizations.proxyType,
          sections: [
            SelectionSection(
              items: [
                for (final action in RuleAction.values)
                  if (action != RuleAction.SUB_RULE) action,
              ],
              subtitleBuilder: (context, item) => item.getDesc(context),
            ),
          ],
          labelBuilder: (item) => item.name,
          selectedOf: (ref) =>
              ref.watch(ruleProvider.select((state) => state.ruleAction)),
          onSelected: (item) => Navigator.of(context).pop(item),
        ),
      ),
    );
    if (res == null) {
      return;
    }
    ref
        .read(ruleProvider.notifier)
        .update((state) => state.copyWith(ruleAction: res));
  }

  Widget _buildTypeItem(RuleAction action) {
    return _buildItem(
      title: context.appLocalizations.proxyType,
      onPressed: () {
        _handleSelectedType();
      },
      trailing: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TooltipText(
              text: Text(
                action.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.listTitleStyle.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const GlyphIcon(AppGlyphs.chevronForward),
        ],
      ),
    );
  }

  Widget _buildContentItem(String? content) {
    final appLocalizations = context.appLocalizations;
    final payloadError = ref.watch(
      ruleProvider.select((state) => state.payloadError),
    );
    final field = FormRowTextField(
      initialValue: content,
      keyboardType: TextInputType.name,
      inputFormatters: TextInputLimits.limit(TextInputLimits.rule),
      onChanged: (value) {
        ref
            .read(ruleProvider.notifier)
            .update((state) => state.copyWith(content: value));
      },
      hintText: appLocalizations.inputRuleContent,
    );
    return _buildItem(
      invalid: payloadError != null,
      title: appLocalizations.content,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (payloadError != null)
            InfoMessageButton(message: payloadError.getMessage(context)),
          Flexible(child: field),
        ],
      ),
    );
  }

  Future<void> _handleSelectedRuleProvider() async {
    final res = await Navigator.of(context).push(
      PagedSheetRoute(
        builder: (context) => Consumer(
          builder: (_, ref, _) {
            final ruleProviders = ref.watch(
              appProviderNamesProvider(ProviderKind.rule),
            );
            return SelectionSheet<String>(
              title: context.appLocalizations.ruleSet,
              sections: [SelectionSection(items: ruleProviders.toList())],
              labelBuilder: (item) => item,
              selectedOf: (ref) =>
                  ref.watch(ruleProvider.select((state) => state.ruleProvider)),
              onSelected: (item) => Navigator.of(context).pop(item),
              emptyLabel: context.appLocalizations.nullTip(
                context.appLocalizations.ruleProviders,
              ),
            );
          },
        ),
      ),
    );
    if (res == null) {
      return;
    }
    ref
        .read(ruleProvider.notifier)
        .update((state) => state.copyWith(ruleProvider: res));
  }

  Widget _buildRuleProviderItem(int profileId, String? ruleProvider) {
    final appLocalizations = context.appLocalizations;
    final invalid =
        ruleProvider != null &&
        !ref.watch(
          customProfileRuleProviderIsValidProvider(profileId, ruleProvider),
        );
    final foregroundColor = invalid
        ? context.colorScheme.error
        : context.colorScheme.onSurfaceVariant;
    return _buildItem(
      invalid: invalid,
      title: appLocalizations.ruleSet,
      onPressed: _handleSelectedRuleProvider,
      trailing: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (invalid)
            InfoMessageButton(
              message: appLocalizations.invalidRuleSet(ruleProvider),
            ),
          Flexible(
            child: TooltipText(
              text: Text(
                ruleProvider ?? appLocalizations.selectRuleSet,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.listTitleStyle.copyWith(color: foregroundColor),
              ),
            ),
          ),
          GlyphIcon(AppGlyphs.chevronForward, color: foregroundColor),
        ],
      ),
    );
  }

  Future<void> _handleSelectedTarget() async {
    final res = await Navigator.of(context).push(
      PagedSheetRoute(
        builder: (context) => Consumer(
          builder: (_, ref, _) {
            final profileId = ProfileIdProvider.of(context)!.profileId;
            final profileData = ref.watch(customProfileDataProvider(profileId));
            final groupTypes = {
              for (final item
                  in profileData?.proxyGroups ?? const <ProxyGroup>[])
                item.name: item.type.name,
            };
            final named = profileData?.namedProxies ?? const <String>{};
            final proxyTypes = {
              for (final item
                  in ref.watch(customProxiesProvider).value ??
                      const <CustomProxy>[])
                if (named.contains(item.name)) item.name: item.type,
            };
            return SelectionSheet<String>(
              title: context.appLocalizations.splitStrategy,
              sections: [
                SelectionSection(
                  label: context.appLocalizations.basicStrategy,
                  items: [
                    for (final name in RuleTarget.ruleTargetNames)
                      if (!groupTypes.containsKey(name)) name,
                  ],
                ),
                SelectionSection(
                  label: context.appLocalizations.ruleTarget,
                  items: groupTypes.keys.toList(),
                  subtitleBuilder: (context, name) => groupTypes[name] ?? '',
                ),
                SelectionSection(
                  label: context.appLocalizations.localProxies,
                  items: proxyTypes.keys.toList(),
                  subtitleBuilder: (context, name) => proxyTypes[name],
                ),
              ],
              labelBuilder: (item) => item,
              selectedOf: (ref) =>
                  ref.watch(ruleProvider.select((state) => state.ruleTarget)),
              onSelected: (item) => Navigator.of(context).pop(item),
            );
          },
        ),
      ),
    );
    if (res == null) {
      return;
    }
    ref
        .read(ruleProvider.notifier)
        .update((state) => state.copyWith(ruleTarget: res));
  }

  Widget _buildTargetItem(int profileId, String? target) {
    final appLocalizations = context.appLocalizations;
    return Consumer(
      builder: (_, ref, _) {
        final invalid = !ref.watch(
          customProfileTargetIsValidProvider(profileId, target),
        );
        final foregroundColor = invalid
            ? context.colorScheme.error
            : context.colorScheme.onSurfaceVariant;
        return _buildItem(
          invalid: invalid,
          title: appLocalizations.splitStrategy,
          onPressed: _handleSelectedTarget,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (invalid && target != null)
                InfoMessageButton(
                  message: appLocalizations.invalidPolicy(target),
                ),
              Flexible(
                flex: 1,
                child: TooltipText(
                  text: Text(
                    target ?? appLocalizations.selectSplitStrategy,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.listTitleStyle.copyWith(
                      color: foregroundColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GlyphIcon(AppGlyphs.chevronForward, color: foregroundColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoResolveItem(bool noResolve, bool src) {
    final appLocalizations = context.appLocalizations;
    // The core turns no-resolve on with src, so the switch cannot disagree.
    return _buildItem(
      title: appLocalizations.noResolveHostname,
      trailing: Switch(
        value: noResolve || src,
        onChanged: src
            ? null
            : (value) {
                ref
                    .read(ruleProvider.notifier)
                    .update((state) => state.copyWith(noResolve: value));
              },
      ),
    );
  }

  Widget _buildSrcItem(bool src) {
    final appLocalizations = context.appLocalizations;
    return _buildItem(
      title: appLocalizations.matchSourceIp,
      trailing: Switch(
        value: src,
        onChanged: (value) {
          ref
              .read(ruleProvider.notifier)
              .update((state) => state.copyWith(src: value));
        },
      ),
    );
  }

  Future<void> _handleSave() async {
    final error = _handleSaveRule(context, ref);
    if (error != null) {
      await showSaveBlocked(context, error);
      return;
    }
    context.safeNestedPop();
  }

  Future<void> _handleDelete(int profileId) async {
    final appLocalizations = context.appLocalizations;
    final res = await dialogs.showMessage(
      message: TextSpan(
        text: appLocalizations.deleteTip(appLocalizations.rule),
      ),
      destructive: true,
      confirmText: appLocalizations.delete,
    );
    if (res == true && mounted) {
      final id = ref.read(ruleProvider).id;
      ref.read(profileRulesProvider(profileId).notifier).delAll([id]);
      context.safeNestedPop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final profileId = ProfileIdProvider.of(context)!.profileId;
    final rule = ref.watch(ruleProvider);
    return Scaffold(
      confirmationAction: customSaveAction(context, onPressed: _handleSave),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
          bottom: 20 + context.bottomInset,
          top: context.sectionsTopPadding,
        ),
        children: [
          generateSection(
            title: appLocalizations.basicInfo,
            items: [
              _buildTypeItem(rule.ruleAction),
              if (rule.ruleAction != RuleAction.MATCH)
                rule.ruleAction == RuleAction.RULE_SET
                    ? _buildRuleProviderItem(profileId, rule.ruleProvider)
                    : _buildContentItem(rule.content),
              _buildTargetItem(profileId, rule.ruleTarget),
            ],
          ),
          if (rule.ruleAction.hasParams)
            generateSection(
              title: appLocalizations.additionalParameters,
              items: [
                _buildNoResolveItem(rule.noResolve, rule.src),
                _buildSrcItem(rule.src),
              ],
            ),
          generateSection(
            title: appLocalizations.action,
            items: [
              if (rule.id != -1)
                _buildItem(
                  title: appLocalizations.delete,
                  titleStyle: TextStyle(color: context.colorScheme.error),
                  onPressed: () {
                    _handleDelete(profileId);
                  },
                ),
            ],
          ),
        ],
      ),
      title: rule.id == -1
          ? appLocalizations.addRule
          : appLocalizations.editRule,
    );
  }
}

String? _handleSaveRule(BuildContext context, WidgetRef ref) {
  final rule = ref.read(ruleProvider);
  final error = _ruleSaveError(context, rule);
  if (error != null) {
    return error;
  }
  final profileId = ProfileIdProvider.of(context)!.profileId;
  Rule addedRule = rule;
  if (rule.id == -1) {
    addedRule = rule.copyWith(id: snowflake.id);
  }
  ref.read(profileRulesProvider(profileId).notifier).put(addedRule);
  return null;
}

String? _ruleSaveError(BuildContext context, Rule rule) {
  final appLocalizations = context.appLocalizations;
  if (rule.ruleAction == RuleAction.SUB_RULE) {
    return appLocalizations.invalidSubRule(rule.subRule ?? '');
  }
  final payloadError = rule.payloadError;
  if (payloadError != null) {
    return payloadError.getMessage(context);
  }
  if (rule.ruleAction != RuleAction.MATCH &&
      rule.realContent?.isNotEmpty != true) {
    return rule.ruleAction == RuleAction.RULE_SET
        ? appLocalizations.emptyTip(appLocalizations.ruleSet)
        : appLocalizations.contentNotEmpty;
  }
  if (rule.realTarget?.isNotEmpty != true) {
    return appLocalizations.splitStrategyNotEmpty;
  }
  return null;
}
