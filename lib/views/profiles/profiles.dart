import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/views/profiles/custom/custom.dart';
import 'package:fl_clash/views/profiles/extend/extend.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add.dart';
import 'edit.dart';
import 'preview.dart';

const _infoGap = 4.0;

double get _profileItemHeight {
  final measure = globalState.measure;
  return measure.textHeight(AppTextStyle.headline) +
      _infoGap +
      measure.textHeight(AppTextStyle.footnote) +
      2 * listRowVerticalPadding;
}

class ProfilesView extends ConsumerStatefulWidget {
  const ProfilesView({super.key, this.picker = false});

  /// Clears the bar and opens at the top, for switching profiles from a sheet.
  final bool picker;

  @override
  ConsumerState<ProfilesView> createState() => _ProfilesViewState();
}

class _ProfilesViewState extends ConsumerState<ProfilesView> {
  bool _isUpdating = false;

  Future<void> _updateProfiles(List<Profile> profiles) async {
    if (_isUpdating == true) {
      return;
    }
    _isUpdating = true;
    final appLocalizations = context.appLocalizations;
    final profilesAction = ref.read(profilesActionProvider.notifier);
    final List<UpdatingMessage> messages = [];
    final updateProfiles = profiles.map<Future>((profile) async {
      if (profile.type != ProfileType.url) return;
      try {
        await profilesAction.updateProfile(profile, showLoading: true);
      } catch (e) {
        messages.add(
          UpdatingMessage(
            label: profile.realLabel,
            message: userFacingErrorMessage(e, appLocalizations),
          ),
        );
      }
    });
    await Future.wait(updateProfiles);
    dialogs.showFailures(messages);
    _isUpdating = false;
  }

  List<IconButtonData> _buildActions(List<Profile> profiles) {
    return profiles.isNotEmpty
        ? [
            IconButtonData(
              glyph: AppGlyphs.sync,
              onPressed: () {
                _updateProfiles(profiles);
              },
              tooltip: context.appLocalizations.update,
            ),
            IconButtonData(
              glyph: AppGlyphs.sort,
              onPressed: () {
                showSheet(
                  context: context,
                  builder: (_) {
                    return ReorderableProfilesSheet(profiles: profiles);
                  },
                );
              },
              tooltip: context.appLocalizations.profilesSort,
            ),
          ]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, _) {
        final appLocalizations = context.appLocalizations;
        final isLoading = ref.watch(loadingProvider(LoadingTag.profiles));
        final state = ref.watch(profilesStateProvider);
        final business = isTianjiSubscriptionProfile(
          ref.watch(currentProfileProvider),
        );
        final spacing = cardSpacingOf(context, ref.watch(viewModeProvider));
        final picker = widget.picker;
        return Scaffold(
          isLoading: isLoading,
          title: business && !picker
              ? appLocalizations.businessSubscriptions
              : appLocalizations.profiles,
          iconActions: picker ? const [] : _buildActions(state.profiles),
          actions: state.profiles.isEmpty || picker
              ? null
              : [
                  AddProfileMenu(
                    builder: (open) => IconButton(
                      tooltip: appLocalizations.addProfile,
                      onPressed: open,
                      icon: const GlyphIcon(AppGlyphs.addCircle),
                    ),
                  ),
                ],
          body: NullStatusSwitcher(
            isEmpty: state.profiles.isEmpty,
            nullStatus: NullStatus(
              label: appLocalizations.nullTip(appLocalizations.profiles),
              description: appLocalizations.nullProfileDesc,
              illustration: NullStatusIllustration.profile,
              action: AddProfileMenu(
                builder: (open) => TonalButton(
                  size: TonalButtonSize.bar,
                  glyph: AppGlyphs.addCircle,
                  label: appLocalizations.addProfile,
                  onPressed: open,
                ),
              ),
            ),
            child: !picker && business
                ? _BusinessProfilesList(
                    profiles: state.profiles,
                    currentProfileId: state.currentProfileId,
                    spacing: spacing,
                  )
                : _ProfilesGrid(
                    profiles: state.profiles,
                    currentProfileId: state.currentProfileId,
                    spacing: spacing,
                    revealsSelected: !picker,
                  ),
          ),
        );
      },
    );
  }
}

class _ProfilesGrid extends ConsumerStatefulWidget {
  const _ProfilesGrid({
    required this.profiles,
    required this.currentProfileId,
    required this.spacing,
    required this.revealsSelected,
  });

  final List<Profile> profiles;
  final int? currentProfileId;
  final double spacing;
  final bool revealsSelected;

  @override
  ConsumerState<_ProfilesGrid> createState() => _ProfilesGridState();
}

class _ProfilesGridState extends ConsumerState<_ProfilesGrid> {
  static const _horizontalPadding = 16.0;

  late final ScrollController _controller;
  var _revealed = false;

  @override
  void initState() {
    super.initState();
    _controller = sheetScrollController(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_revealed ||
        !widget.revealsSelected ||
        !PageActivityScope.isActiveOf(context)) {
      return;
    }
    _revealed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  EdgeInsets get _padding => EdgeInsets.only(
    left: _horizontalPadding,
    right: _horizontalPadding,
    top: context.contentTopPadding,
    bottom: 16 + context.bottomInset,
  );

  int _columnsFor(double width) => getProfilesColumns(
    width - _horizontalPadding * 2,
    spacing: widget.spacing,
    minItemWidth: profileItemMinWidth.ap(context),
  );

  void _revealSelected() {
    if (!mounted || !_controller.hasClients) {
      return;
    }
    final index = widget.profiles.indexWhere(
      (profile) => profile.id == widget.currentProfileId,
    );
    if (index == -1) {
      return;
    }
    final position = _controller.position;
    final padding = _padding;
    final height = _profileItemHeight;
    final row = index ~/ _columnsFor(context.size!.width);
    final atTop = row * (height + widget.spacing);
    final atBottom =
        atTop + padding.vertical + height - position.viewportDimension;
    if (position.pixels >= atBottom && position.pixels <= atTop) {
      return;
    }
    _controller.jumpTo(
      ((atTop + atBottom) / 2).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profiles = widget.profiles;
    return WidthBuilder(
      builder: (_, width) {
        return GridView.builder(
          key: profilesStoreKey,
          controller: _controller,
          padding: _padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _columnsFor(width),
            mainAxisSpacing: widget.spacing,
            crossAxisSpacing: widget.spacing,
            mainAxisExtent: _profileItemHeight,
          ),
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            final profile = profiles[index];
            return ProfileItem(
              key: ValueKey(profile.id),
              profile: profile,
              groupValue: widget.currentProfileId,
              onChanged: (profileId) {
                ref.read(currentProfileIdProvider.notifier).value = profileId;
              },
            );
          },
        );
      },
    );
  }
}

class _BusinessProfilesList extends ConsumerWidget {
  const _BusinessProfilesList({
    required this.profiles,
    required this.currentProfileId,
    required this.spacing,
  });

  final List<Profile> profiles;
  final int? currentProfileId;
  final double spacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current =
        profiles.getProfile(currentProfileId) ??
        (profiles.isEmpty ? null : profiles.first);
    final others = [
      for (final profile in profiles)
        if (profile.id != current?.id) profile,
    ];
    final horizontalInset = ref.watch(isMobileViewProvider) ? 16.0 : 24.0;
    return CustomScrollView(
      key: profilesStoreKey,
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: context.contentTopPadding)),
        if (current != null)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalInset),
            sliver: SliverToBoxAdapter(
              child: _BusinessSubscriptionCard(
                profile: current,
                currentProfileId: currentProfileId,
              ),
            ),
          ),
        if (others.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalInset,
                24,
                horizontalInset,
                10,
              ),
              child: Text(
                context.appLocalizations.other,
                style: AppTextStyle.headline.of(context, emphasized: true),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalInset),
            sliver: SliverPrismList(
              itemCount: others.length,
              gap: spacing,
              itemBuilder: (_, index) => ProfileItem(
                profile: others[index],
                groupValue: currentProfileId,
                businessCompact: true,
                onChanged: (profileId) {
                  ref.read(currentProfileIdProvider.notifier).value = profileId;
                },
              ),
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalInset,
              16,
              horizontalInset,
              20 + context.bottomInset,
            ),
            child: AddProfileMenu(
              builder: (open) => TonalButton(
                size: TonalButtonSize.bar,
                glyph: AppGlyphs.addCircle,
                label: context.appLocalizations.addProfile,
                onPressed: open,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BusinessSubscriptionCard extends ConsumerWidget {
  const _BusinessSubscriptionCard({
    required this.profile,
    required this.currentProfileId,
  });

  final Profile profile;
  final int? currentProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = profile.type == ProfileType.url
        ? profile.subscriptionInfo
        : null;
    final usage = info?.usage;
    final used = info == null ? null : info.upload + info.download;
    final isUpdating = ref.watch(isUpdatingProvider(profile.updatingKey));
    final action = ProfileItem(
      profile: profile,
      groupValue: currentProfileId,
      onChanged: (_) {},
    );
    final colorScheme = context.colorScheme;
    return ContextMenuRegion(
      menuItems: isUpdating ? null : action._menuItems(context, ref),
      child: Card(
        radius: BusinessPalette.cardRadius,
        padding: const EdgeInsets.all(22),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 900) {
              return _buildDesktop(
                context,
                action: action,
                info: info,
                usage: usage,
                used: used,
                isUpdating: isUpdating,
                colorScheme: colorScheme,
                ref: ref,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        profile.realLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.title2.of(
                          context,
                          emphasized: true,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: context.appLocalizations.subscriptionDetails,
                      child: const SelectionBadge(size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _profileTypeLabel(context, profile.type),
                        style: AppTextStyle.subheadline
                            .of(context)
                            .copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                    action._buildTrailing(context, isUpdating: isUpdating),
                  ],
                ),
                if (info?.expireDate case final expire?) ...[
                  const SizedBox(height: 18),
                  Text(
                    context.appLocalizations.validUntil(expire.show),
                    style: AppTextStyle.footnote
                        .of(context)
                        .copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.appLocalizations.profileDaysLeft(
                      expire
                          .difference(DateTime.now())
                          .inDays
                          .clamp(0, 999999)
                          .toInt(),
                    ),
                    style: AppTextStyle.title3.of(context, emphasized: true),
                  ),
                ],
                if (usage != null && used != null && info != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${used.traffic.show} / ${info.total.traffic.show}',
                          style: AppTextStyle.footnote
                              .of(context)
                              .copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                      Text(
                        '${(usage * 100).round()}%',
                        style: AppTextStyle.footnote
                            .of(context, emphasized: true)
                            .copyWith(color: BusinessPalette.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 8,
                    child: DecoratedBox(
                      decoration: const ShapeDecoration(
                        color: Color(0xFFEEF1F4),
                        shape: AppShape.full,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: FractionallySizedBox(
                          widthFactor: usage,
                          heightFactor: 1,
                          child: const DecoratedBox(
                            decoration: ShapeDecoration(
                              color: BusinessPalette.blue,
                              shape: AppShape.full,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (profile.type == ProfileType.url)
                      TonalButton(
                        size: TonalButtonSize.bar,
                        glyph: AppGlyphs.link,
                        label: context.appLocalizations.renew,
                        onPressed: () => dialogs.openUrl(userPanelUrl),
                      ),
                    if (profile.type == ProfileType.url)
                      TonalButton(
                        size: TonalButtonSize.bar,
                        glyph: AppGlyphs.sync,
                        label: context.appLocalizations.update,
                        onPressed: isUpdating
                            ? null
                            : () => action.updateProfile(ref),
                      ),
                    if (profile.type == ProfileType.url)
                      TonalButton(
                        size: TonalButtonSize.bar,
                        glyph: AppGlyphs.copy,
                        label: context.appLocalizations.copyLink,
                        onPressed: () => action._handleCopyLink(context),
                      ),
                    TonalButton(
                      size: TonalButtonSize.bar,
                      glyph: AppGlyphs.edit,
                      label: context.appLocalizations.edit,
                      onPressed: () => action._handleEdit(context),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktop(
    BuildContext context, {
    required ProfileItem action,
    required SubscriptionInfo? info,
    required double? usage,
    required int? used,
    required bool isUpdating,
    required ColorScheme colorScheme,
    required WidgetRef ref,
  }) {
    final l10n = context.appLocalizations;
    final expire = info?.expireDate;
    final url = Uri.tryParse(profile.url);
    final maskedUrl = url != null && url.hasAuthority
        ? '${url.scheme}://${url.host}/••••••••'
        : null;
    final actions = <Widget>[
      if (profile.type == ProfileType.url)
        FilledButton.icon(
          onPressed: () => dialogs.openUrl(userPanelUrl),
          icon: const GlyphIcon(AppGlyphs.link, fill: 1),
          label: Text(l10n.renew),
        ),
      if (profile.type == ProfileType.url)
        OutlinedButton.icon(
          onPressed: isUpdating ? null : () => action.updateProfile(ref),
          icon: const GlyphIcon(AppGlyphs.sync),
          label: Text(l10n.update),
        ),
      if (profile.type == ProfileType.url)
        OutlinedButton.icon(
          onPressed: () => action._handleCopyLink(context),
          icon: const GlyphIcon(AppGlyphs.copy),
          label: Text(l10n.copyLink),
        ),
      OutlinedButton.icon(
        onPressed: () => action._handleEdit(context),
        icon: const GlyphIcon(AppGlyphs.edit),
        label: Text(l10n.edit),
      ),
    ];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Text(
                        profile.realLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.title2.of(
                          context,
                          emphasized: true,
                        ),
                      ),
                    ),
                    const SelectionBadge(size: 24),
                  ],
                ),
                if (maskedUrl != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    maskedUrl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.footnote
                        .of(context)
                        .toJetBrainsMono
                        .copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (info?.total case final total? when total > 0)
                      _ProfileMetaChip(label: total.traffic.show),
                    if (profile.type == ProfileType.url)
                      _ProfileMetaChip(label: l10n.remote),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ProfileMetric(
                        label: l10n.trafficUsage,
                        value: used != null && info != null
                            ? '${used.traffic.show} / ${info.total.traffic.show}'
                            : '—',
                        footnote: usage == null
                            ? null
                            : '${(usage * 100).round()}%',
                        progress: usage,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ProfileMetric(
                        label: l10n.expireTime,
                        value: info == null
                            ? '—'
                            : expire?.show ?? l10n.infiniteTime,
                        footnote: expire == null
                            ? null
                            : l10n.profileDaysLeft(
                                expire
                                    .difference(DateTime.now())
                                    .inDays
                                    .clamp(0, 999999)
                                    .toInt(),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.lastUpdated,
                            style: AppTextStyle.footnote
                                .of(context)
                                .copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 4),
                          action._buildTrailing(
                            context,
                            isUpdating: isUpdating,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 1,
            child: ColoredBox(color: colorScheme.outlineVariant),
          ),
          SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: actions,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({
    required this.label,
    required this.value,
    this.footnote,
    this.progress,
  });

  final String label;
  final String value;
  final String? footnote;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.footnote
              .of(context)
              .copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.title3.of(context, emphasized: true),
        ),
        if (footnote != null) ...[
          const SizedBox(height: 4),
          Text(
            footnote!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.footnote
                .of(context)
                .copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ],
        if (progress case final value?) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 8,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: dark
                    ? context.colorScheme.surfaceContainerHigh
                    : const Color(0xFFEEF1F4),
                shape: AppShape.full,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: FractionallySizedBox(
                  widthFactor: value,
                  heightFactor: 1,
                  child: const DecoratedBox(
                    decoration: ShapeDecoration(
                      color: BusinessPalette.blue,
                      shape: AppShape.full,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProfileMetaChip extends StatelessWidget {
  const _ProfileMetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final dark = context.colorScheme.brightness == Brightness.dark;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: dark
            ? context.colorScheme.surfaceContainerHigh
            : const Color(0xFFEEF1F4),
        shape: AppShape.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: AppTextStyle.caption1
              .of(context)
              .copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

String _profileTypeLabel(BuildContext context, ProfileType type) {
  final l10n = context.appLocalizations;
  return switch (type) {
    ProfileType.url => l10n.remote,
    ProfileType.file => l10n.local,
    ProfileType.custom => l10n.custom,
  };
}

class ProfileItem extends ConsumerWidget {
  final Profile profile;
  final int? groupValue;
  final void Function(int? value) onChanged;
  final bool businessCompact;

  const ProfileItem({
    super.key,
    required this.profile,
    required this.groupValue,
    required this.onChanged,
    this.businessCompact = false,
  });

  Future<void> _handleDeleteProfile(BuildContext context, WidgetRef ref) async {
    final profilesAction = ref.read(profilesActionProvider.notifier);
    final appLocalizations = context.appLocalizations;
    final users = await profilesAction.providerUsers(profile);
    final res = await dialogs.showMessage(
      title: appLocalizations.tip,
      message: TextSpan(
        text: users.isEmpty
            ? appLocalizations.deleteTip(appLocalizations.profile)
            : appLocalizations.providerInUse(
                profile.realLabel,
                users.map((item) => item.realLabel).join(', '),
              ),
      ),
      destructive: true,
      confirmText: appLocalizations.delete,
    );
    if (res != true) {
      return;
    }
    await profilesAction.deleteProfile(profile.id);
  }

  Future<void> _handlePreview(BuildContext context) async {
    unawaited(
      BaseNavigator.push<String>(context, PreviewProfileView(profile: profile)),
    );
  }

  Future updateProfile(WidgetRef ref) async {
    if (profile.type != ProfileType.url) return;
    await globalState.loadingRun(() async {
      await ref
          .read(profilesActionProvider.notifier)
          .updateProfile(profile, showLoading: true);
    }, tag: LoadingTag.profiles);
  }

  void _handleShowEditExtendPage(BuildContext context) {
    showExtend(
      context,
      builder: (context) => EditProfileView(profile: profile),
    );
  }

  SubscriptionInfo? get _subscriptionInfo =>
      profile.type == ProfileType.url ? profile.subscriptionInfo : null;

  String _subtitle(BuildContext context) {
    final info = _subscriptionInfo;
    if (info != null && info.usage != null) {
      final used = info.upload + info.download;
      return '${used.traffic.show} / ${info.total.traffic.show}';
    }
    final appLocalizations = context.appLocalizations;
    return switch (profile.type) {
      ProfileType.url => appLocalizations.remote,
      ProfileType.file => appLocalizations.local,
      ProfileType.custom => appLocalizations.custom,
    };
  }

  Widget _buildTrailing(BuildContext context, {required bool isUpdating}) {
    return AnimatedSwitcher(
      duration: context.motionDuration(commonDuration),
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [...previousChildren, ?currentChild],
      ),
      child: isUpdating
          ? const ActivityIndicator(key: ValueKey('updating'), size: 24)
          : LastUpdateTimeText(
              key: const ValueKey('lastUpdate'),
              lastUpdateDate: profile.lastUpdateDate,
              style: AppTextStyle.footnote.of(context).toLighter,
              compact: true,
            ),
    );
  }

  Future<void> _handleCopyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: profile.url));
    if (context.mounted) {
      dialogs.showBanner(
        context.appLocalizations.copySuccess,
        level: BannerLevel.success,
      );
    }
  }

  Future<void> _handleExportFile(BuildContext context) async {
    final appLocalizations = context.appLocalizations;
    final res = await globalState.safeRun<bool>(() async {
      final mFile = await profile.file;
      final value = await picker.saveFile(
        profile.exportFileName,
        mFile.readAsBytesSync(),
      );
      if (value == null) return false;
      return true;
    }, title: appLocalizations.tip);
    if (res == true && context.mounted) {
      dialogs.showBanner(
        appLocalizations.exportSuccess,
        level: BannerLevel.success,
      );
    }
  }

  void _handlePushGenProfilePage(BuildContext context, int id) {
    BaseNavigator.push(context, ExtendView(profileId: id));
  }

  void _handlePushCustomProfilePage(BuildContext context, int id) {
    BaseNavigator.push(context, CustomProfileView(profileId: id));
  }

  void _handleEdit(BuildContext context) {
    if (profile.type == ProfileType.custom) {
      _handlePushCustomProfilePage(context, profile.id);
    } else {
      _handleShowEditExtendPage(context);
    }
  }

  List<PopupMenuItem> _menuItems(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final isUrl = profile.type == ProfileType.url;
    final isCustom = profile.type == ProfileType.custom;
    return [
      PopupMenuItem(
        glyph: AppGlyphs.edit,
        label: appLocalizations.edit,
        onPressed: () => _handleEdit(context),
      ),
      if (isCustom) ...[
        PopupMenuItem(
          glyph: AppGlyphs.textShort,
          label: appLocalizations.rename,
          onPressed: () {
            renameProfile(context, ref, profile);
          },
        ),
        PopupMenuItem(
          glyph: AppGlyphs.eye,
          label: appLocalizations.runtimeConfig,
          onPressed: () {
            _handlePreview(context);
          },
        ),
      ] else
        PopupMenuItem(
          glyph: AppGlyphs.puzzle,
          label: appLocalizations.extend,
          onPressed: () {
            _handlePushGenProfilePage(context, profile.id);
          },
        ),
      if (isUrl)
        PopupMenuItem(
          glyph: AppGlyphs.sync,
          label: appLocalizations.sync,
          onPressed: () {
            updateProfile(ref);
          },
        ),
      if (!isCustom)
        PopupMenuItem(
          glyph: AppGlyphs.moreCircle,
          label: appLocalizations.more,
          subItems: [
            PopupMenuItem(
              glyph: AppGlyphs.eye,
              label: appLocalizations.runtimeConfig,
              onPressed: () {
                _handlePreview(context);
              },
            ),
            if (isUrl)
              PopupMenuItem(
                glyph: AppGlyphs.copy,
                label: appLocalizations.copyLink,
                onPressed: () {
                  _handleCopyLink(context);
                },
              ),
            if (isUrl)
              PopupMenuItem(
                glyph: AppGlyphs.qrCode,
                label: appLocalizations.qrcode,
                onPressed: () {
                  dialogs.showQrCode(
                    title: profile.realLabel,
                    data: profile.url,
                    message: appLocalizations.shareQrcodeTip,
                  );
                },
              ),
            PopupMenuItem(
              glyph: AppGlyphs.export,
              label: appLocalizations.exportFile,
              onPressed: () {
                _handleExportFile(context);
              },
            ),
          ],
        ),
      PopupMenuItem(
        danger: true,
        glyph: AppGlyphs.delete,
        label: appLocalizations.delete,
        onPressed: () {
          _handleDeleteProfile(context, ref);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUpdating = ref.watch(isUpdatingProvider(profile.updatingKey));
    final subscriptionInfo = _subscriptionInfo;
    final isSelected = profile.id == groupValue;
    return ContextMenuRegion(
      menuItems: isUpdating ? null : _menuItems(context, ref),
      child: Card(
        enterActionsOnRight: true,
        radius: businessCompact ? BusinessPalette.cardRadius : AppCorner.xl,
        isSelected: isSelected,
        onPressed: () {
          onChanged(profile.id);
        },
        child: ListItem(
          key: Key(profile.id.toString()),
          minTileHeight: _profileItemHeight,
          minVerticalPadding: listRowVerticalPadding,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              if (profile.type == ProfileType.custom)
                _GroupsCountChip(profileId: profile.id)
              else
                _buildTrailing(context, isUpdating: isUpdating),
              if (isSelected) const SelectionBadge(size: 24),
            ],
          ),
          title: _ProfileCardTitle(
            profile: profile,
            expire: subscriptionInfo?.expireDate,
            subtitle: _subtitle(context),
          ),
        ),
      ),
    );
  }
}

class _ProfileCardTitle extends StatelessWidget {
  const _ProfileCardTitle({
    required this.profile,
    required this.expire,
    required this.subtitle,
  });

  final Profile profile;
  final DateTime? expire;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipTitle(
          title: profile.realLabel,
          expire: expire,
          style: AppTextStyle.headline.of(context),
        ),
        const SizedBox(height: _infoGap),
        Text(
          subtitle,
          style: AppTextStyle.footnote.of(context).toLighter,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Square-cornered so a lone digit never reads as a second [SelectionBadge].
class _GroupsCountChip extends ConsumerWidget {
  const _GroupsCountChip({required this.profileId});

  final int profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(profileGroupsCountProvider(profileId)).value;
    if (count == null) {
      return const SizedBox.shrink();
    }
    final colorScheme = context.colorScheme;
    return Tooltip(
      message: context.appLocalizations.proxyGroupsCount(count, count.compact),
      child: TonalChip(
        label: count.compact,
        color: colorScheme.primary.opacity15,
        foregroundColor: colorScheme.primary,
      ),
    );
  }
}

class ReorderableProfilesSheet extends ConsumerStatefulWidget {
  final List<Profile> profiles;

  const ReorderableProfilesSheet({super.key, required this.profiles});

  @override
  ConsumerState<ReorderableProfilesSheet> createState() =>
      _ReorderableProfilesSheetState();
}

class _ReorderableProfilesSheetState
    extends ConsumerState<ReorderableProfilesSheet> {
  late List<Profile> profiles;

  @override
  void initState() {
    super.initState();
    profiles = List.from(widget.profiles);
  }

  Widget _buildItem(int index) {
    final position = ItemPosition.get(index, profiles.length);
    final profile = profiles[index];
    return ReorderDragStartListener(
      key: Key(profile.id.toString()),
      index: index,
      child: ItemPositionProvider(
        position: position,
        child: DecorationListItem(
          contentPadding: const EdgeInsets.only(left: 16),
          trailing: SortHandle(index: index),
          title: Text(profile.realLabel),
        ),
      ),
    );
  }

  void _handleSave() {
    Navigator.of(context).pop();
    final latest = ref.read(profilesProvider);
    final ids = {for (final profile in profiles) profile.id};
    ref.read(profilesProvider.notifier).reorder([
      for (final profile in profiles) ?latest.getProfile(profile.id),
      for (final profile in latest)
        if (!ids.contains(profile.id)) profile,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return Scaffold(
      confirmationAction: IconButtonData(
        glyph: AppGlyphs.check,
        onPressed: _handleSave,
        tooltip: context.appLocalizations.save,
      ),
      body: PrismReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
          top: context.contentTopPadding,
          bottom: 32 + context.bottomInset,
        ),
        proxyDecorator: (child, index, animation) {
          return commonProxyDecorator(_buildItem(index), index, animation);
        },
        onReorderItem: (oldIndex, newIndex) {
          setState(() {
            profiles = profiles.copyAndReorder(oldIndex, newIndex);
          });
        },
        itemBuilder: (_, index) {
          return _buildItem(index);
        },
        itemCount: profiles.length,
      ),
      title: appLocalizations.profilesSort,
    );
  }
}
