import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/clash_config.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;
import 'package:fl_clash/views/config/scripts.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'script.dart';
import 'standard.dart';

/// Long enough that a quick apply still reads as one, not as a flicker.
const _minApplyingDuration = Duration(milliseconds: 600);

class ExtendView extends ConsumerStatefulWidget {
  final int profileId;

  const ExtendView({super.key, required this.profileId});

  @override
  ConsumerState<ExtendView> createState() => _ExtendViewState();
}

class _ExtendViewState extends ConsumerState<ExtendView> {
  late SetupAction _setupAction;
  List<Object?>? _applied;
  var _unappliedOnOpen = false;
  var _applying = false;

  @override
  void initState() {
    super.initState();
    _setupAction = ref.read(setupActionProvider.notifier);
    ref.listenManual(clashConfigProvider(widget.profileId), (_, _) {});
    if (ref.read(currentProfileIdProvider) == widget.profileId) {
      unawaited(_checkUnappliedOnOpen());
    }
  }

  Future<void> _checkUnappliedOnOpen() async {
    final applied = await _setupAction.inputsApplied();
    if (!applied && mounted) {
      setState(() {
        _unappliedOnOpen = true;
      });
    }
  }

  List<Object?>? _watchInputs() {
    final profileId = widget.profileId;
    final profile = ref.watch(
      profileProvider(profileId).select(
        (state) => (state?.extendType, state?.scriptId, state?.matchTarget),
      ),
    );
    final rules = ref.watch(profileRulesProvider(profileId)).value;
    final disabledRuleIds = ref
        .watch(profileDisabledRuleIdsProvider(profileId))
        .value;
    if (rules == null || disabledRuleIds == null) {
      return null;
    }
    return [profile, rules, disabledRuleIds];
  }

  Future<void> _handleApplyNow(List<Object?> inputs) async {
    final appLocalizations = context.appLocalizations;
    setState(() {
      _applying = true;
    });
    try {
      final (applied, _) = await (
        globalState.safeRun(_setupAction.applyProfile),
        Future<void>.delayed(_minApplyingDuration),
      ).wait;
      if (applied != true || !mounted) {
        return;
      }
      _applied = inputs;
      _unappliedOnOpen = false;
      dialogs.showBanner(appLocalizations.applied, level: BannerLevel.success);
    } finally {
      if (mounted) {
        setState(() {
          _applying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final inputs = _watchInputs();
    if (inputs != null) {
      _applied ??= inputs;
    }
    final isCurrent = ref.watch(currentProfileIdProvider) == widget.profileId;
    final hasChanges =
        isCurrent &&
        inputs != null &&
        (_unappliedOnOpen ||
            !const DeepCollectionEquality().equals(_applied, inputs));
    return ArrivalHold(
      ready: inputs != null,
      child: ProfileIdProvider(
        profileId: widget.profileId,
        child: Scaffold(
          title:
              BusinessTheme.of(context) &&
                  system.isDesktop &&
                  isTianjiSubscriptionProfile(
                    ref.read(profileProvider(widget.profileId)),
                  )
              ? appLocalizations.extendOverridesScripts
              : appLocalizations.extend,
          isLoading: _applying,
          actions: [
            if (hasChanges || _applying)
              FilledButton(
                onPressed: _applying || inputs == null
                    ? null
                    : () => _handleApplyNow(inputs),
                child: Text(appLocalizations.applyNow),
              ),
          ],
          body: LayoutBuilder(
            builder: (context, constraints) {
              final modePane = ScrollConfiguration(
                behavior: const ShowBarScrollBehavior(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: context.sectionsTopPadding),
                    ),
                    const _ModeSection(),
                    SliverToBoxAdapter(
                      child: SizedBox(height: context.bottomInset),
                    ),
                  ],
                ),
              );
              final contentPane = ScrollConfiguration(
                behavior: const ShowBarScrollBehavior(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: context.sectionsTopPadding),
                    ),
                    _contentFor(context),
                    SliverToBoxAdapter(
                      child: SizedBox(height: context.bottomInset),
                    ),
                  ],
                ),
              );
              if (!system.isDesktop || constraints.maxWidth < 900) {
                return ScrollConfiguration(
                  behavior: const ShowBarScrollBehavior(),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: context.sectionsTopPadding),
                      ),
                      const _ModeSection(),
                      _contentFor(context),
                      SliverToBoxAdapter(
                        child: SizedBox(height: context.bottomInset),
                      ),
                    ],
                  ),
                );
              }
              return Row(
                children: [
                  SizedBox(width: 300, child: modePane),
                  Expanded(child: contentPane),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _contentFor(BuildContext context) {
    final profile = ref.watch(profileProvider(widget.profileId));
    if (system.isDesktop &&
        BusinessTheme.of(context) &&
        isTianjiSubscriptionProfile(profile)) {
      return const _BusinessExtendContent();
    }
    return const _Content();
  }

  @override
  void dispose() {
    _setupAction.autoApplyProfile();
    super.dispose();
  }
}

class _BusinessExtendContent extends ConsumerWidget {
  const _BusinessExtendContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.appLocalizations;
    final profileId = ProfileIdProvider.of(context)!.profileId;
    final rules = ref.watch(profileRulesProvider(profileId)).value ?? const [];
    final disabled =
        ref.watch(profileDisabledRuleIdsProvider(profileId)).value?.toSet() ??
        const <int>{};
    final scripts = ref.watch(scriptsProvider).value ?? const [];
    final selectedScript = ref.watch(
      profileProvider(profileId).select((p) => p?.scriptId),
    );
    Future<void> editRule([Rule? rule]) async {
      final result = await showFormSheet<Rule>(
        context: context,
        builder: (_) => RuleForm(rule: rule),
      );
      if (result != null) {
        ref.read(profileRulesProvider(profileId).notifier).put(result);
      }
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: BusinessSettingsCard(
            title: l.overridesLabel,
            trailing: BusinessSecondaryButton(
              label: '＋ ${l.add}',
              width: 92,
              onPressed: () => editRule(),
            ),
            items: [
              for (final rule in rules)
                _BusinessExtendRow(
                  name:
                      rule.realContent ?? rule.content ?? rule.ruleAction.value,
                  type: rule.ruleAction.value,
                  enabled: !disabled.contains(rule.id),
                  onToggle: (value) => value
                      ? ref
                            .read(
                              profileDisabledRuleIdsProvider(
                                profileId,
                              ).notifier,
                            )
                            .del(rule.id)
                      : ref
                            .read(
                              profileDisabledRuleIdsProvider(
                                profileId,
                              ).notifier,
                            )
                            .put(rule.id),
                  onEdit: () => editRule(rule),
                ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 14)),
        SliverToBoxAdapter(
          child: BusinessSettingsCard(
            title: l.script,
            trailing: BusinessSecondaryButton(
              label: '＋ ${l.add}',
              width: 92,
              onPressed: () => showInSheet<void>(
                context,
                builder: (_) => const ScriptsView(),
              ),
            ),
            items: [
              for (final script in scripts)
                _BusinessExtendRow(
                  name: script.label,
                  type: script.url == null ? l.local : l.remote,
                  enabled: selectedScript == script.id,
                  onToggle: (value) => ref
                      .read(profilesProvider.notifier)
                      .updateProfile(
                        profileId,
                        (state) =>
                            state.copyWith(scriptId: value ? script.id : null),
                      ),
                  onEdit: () => showInSheet<void>(
                    context,
                    builder: (_) => const ScriptsView(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BusinessExtendRow extends StatelessWidget {
  const _BusinessExtendRow({
    required this.name,
    required this.type,
    required this.enabled,
    required this.onToggle,
    required this.onEdit,
  });
  final String name;
  final String type;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
    child: Row(
      spacing: 10,
      children: [
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: BusinessText.cardTitle(context),
          ),
        ),
        DecoratedBox(
          decoration: ShapeDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            shape: AppShape.all(AppCorner.sm),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(type, style: BusinessText.proxyProtocol(context)),
          ),
        ),
        Switch(value: enabled, onChanged: onToggle),
        BusinessSecondaryButton(
          label: context.appLocalizations.edit,
          width: 64,
          height: 30,
          onPressed: onEdit,
        ),
      ],
    ),
  );
}

class _ModeSection extends ConsumerWidget {
  const _ModeSection();

  String _label(AppLocalizations l, ExtendType type) => switch (type) {
    ExtendType.standard => l.standard,
    ExtendType.script => l.script,
  };

  String _description(AppLocalizations l, ExtendType type) => switch (type) {
    ExtendType.standard => l.standardModeDesc,
    ExtendType.script => l.scriptModeDesc,
  };

  void _handleChangeType(WidgetRef ref, int profileId, ExtendType type) {
    ref.read(profilesProvider.notifier).updateProfile(profileId, (state) {
      return state.copyWith(extendType: type);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final profileId = ProfileIdProvider.of(context)!.profileId;
    final extendType = ref.watch(extendTypeProvider(profileId));
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: generateSection(
          title: appLocalizations.extendMode,
          items: [
            for (final type in ExtendType.values)
              DecorationListItem(
                isSelected: type == extendType,
                title: Text(_label(appLocalizations, type)),
                subtitle: Text(_description(appLocalizations, type)),
                trailing: type == extendType
                    ? const SelectionBadge(size: 24)
                    : null,
                onPressed: () => _handleChangeType(ref, profileId, type),
              ),
          ],
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content();

  @override
  Widget build(BuildContext context, ref) {
    final profileId = ProfileIdProvider.of(context)!.profileId;
    final extendType = ref.watch(extendTypeProvider(profileId));
    return switch (extendType) {
      ExtendType.standard => const StandardContent(),
      ExtendType.script => const ScriptContent(),
    };
  }
}
