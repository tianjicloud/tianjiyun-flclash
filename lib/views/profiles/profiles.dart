import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/profiles/custom/custom.dart';
import 'package:fl_clash/views/profiles/extend/extend.dart';
import 'package:fl_clash/views/profiles/add.dart'
    show
        AddProfileMenu,
        ProfileAddSource,
        addProfileFromQrCode,
        showBusinessProfileAddDialog;
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show
        BusinessPrimaryButton,
        BusinessSecondaryButton,
        DashboardChip,
        DashboardChipTone;
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit.dart';
import 'preview.dart';

const _infoGap = 4.0;
double _scaledControlWidth(BuildContext context, double width) =>
    width * MediaQuery.textScalerOf(context).scale(1);

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

  List<IconButtonData> _buildActions(
    List<Profile> profiles, {
    required bool business,
  }) {
    return profiles.isNotEmpty
        ? [
            if (!business)
              IconButtonData(
                glyph: AppGlyphs.sync,
                onPressed: () {
                  _updateProfiles(profiles);
                },
                tooltip: context.appLocalizations.update,
              ),
            if (!business)
              IconButtonData(
                glyph: AppGlyphs.sort,
                onPressed: () => _showProfileSort(context, profiles),
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
        final mobileView = ref.watch(isMobileViewProvider);
        final businessDesktop = business && !mobileView;
        final businessMobile = business && mobileView;
        final spacing = cardSpacingOf(context, ref.watch(viewModeProvider));
        final picker = widget.picker;
        return Scaffold(
          businessTitleInset: business,
          isLoading: isLoading,
          title: business && !picker
              ? appLocalizations.businessSubscriptions
              : appLocalizations.profiles,
          iconActions: picker
              ? const []
              : _buildActions(state.profiles, business: business),
          actions: state.profiles.isEmpty || picker
              ? null
              : [
                  if (businessDesktop) ...[
                    BusinessSecondaryButton(
                      label: appLocalizations.updateAll,
                      width: _scaledControlWidth(context, 110),
                      onPressed: () => _updateProfiles(state.profiles),
                    ),
                    const SizedBox(width: 8),
                  ],
                  AddProfileMenu(
                    builder: (open) => switch ((
                      businessDesktop,
                      businessMobile,
                    )) {
                      (true, _) =>
                        MacOSStyle.of(context)
                            ? BusinessSecondaryButton(
                                label:
                                    '＋ ${appLocalizations.importSubscription}',
                                width: _scaledControlWidth(context, 126),
                                onPressed: open,
                              )
                            : BusinessPrimaryButton(
                                label:
                                    '＋ ${appLocalizations.importSubscription}',
                                width: _scaledControlWidth(context, 126),
                                onPressed: open,
                              ),
                      (_, true) => _MobileImportButton(onPressed: open),
                      _ => IconButton(
                        tooltip: appLocalizations.addProfile,
                        onPressed: open,
                        icon: const GlyphIcon(AppGlyphs.addCircle),
                      ),
                    },
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

void _showProfileSort(BuildContext context, List<Profile> profiles) {
  showSheet(
    context: context,
    builder: (_) => ReorderableProfilesSheet(
      profiles: profiles,
      business: system.isDesktop && BusinessTheme.of(context),
    ),
  );
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
  });

  final List<Profile> profiles;
  final int? currentProfileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current =
        profiles.getProfile(currentProfileId) ??
        (profiles.isEmpty ? null : profiles.first);
    final others = [
      for (final profile in profiles)
        if (profile.id != current?.id) profile,
    ];
    final mobile = ref.watch(isMobileViewProvider);
    final horizontalInset = mobile
        ? 16.0
        : MacOSMetrics.pageMargin(context, fallback: 24);
    return CustomScrollView(
      key: profilesStoreKey,
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: MacOSMetrics.pageContentTop(
              context,
              fallback: context.contentTopPadding,
            ),
          ),
        ),
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
        if (others.isNotEmpty && mobile) ...[
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalInset),
            sliver: SliverToBoxAdapter(
              child: _BusinessOtherProfilesCard(
                profiles: others,
                currentProfileId: currentProfileId,
                mobile: true,
                onSwitch: (profileId) {
                  ref.read(currentProfileIdProvider.notifier).value = profileId;
                },
                onSort: () => _showProfileSort(context, profiles),
              ),
            ),
          ),
        ],
        if (others.isNotEmpty && !mobile) ...[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalInset,
              24,
              horizontalInset,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: _BusinessOtherProfilesCard(
                profiles: others,
                currentProfileId: currentProfileId,
                mobile: false,
                onSwitch: (profileId) {
                  ref.read(currentProfileIdProvider.notifier).value = profileId;
                },
                onSort: () => _showProfileSort(context, profiles),
              ),
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalInset,
              14,
              horizontalInset,
              20 + context.bottomInset,
            ),
            child: mobile
                ? _MobileQuickImports(
                    onClipboard: () => _importClipboard(context, ref),
                    onScan: () => addProfileFromQrCode(context, ref),
                    onFile: () => unawaited(
                      ref
                          .read(profilesActionProvider.notifier)
                          .addProfileFormFile(),
                    ),
                  )
                : const _BusinessImportHintCard(),
          ),
        ),
      ],
    );
  }
}

const _businessProfileIconRadius = 10.0;

class _BusinessOtherProfilesCard extends StatelessWidget {
  const _BusinessOtherProfilesCard({
    required this.profiles,
    required this.currentProfileId,
    required this.mobile,
    required this.onSwitch,
    required this.onSort,
  });

  final List<Profile> profiles;
  final int? currentProfileId;
  final bool mobile;
  final ValueChanged<int?> onSwitch;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    return Card(
      radius: BusinessPalette.cardRadius,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l10n.otherProfilesTitle,
                style: BusinessText.cardTitle(context),
              ),
              if (!mobile) ...[
                const Spacer(),
                if (!MacOSStyle.of(context)) ...[
                  Flexible(
                    child: Text(
                      l10n.profileSwitchNote,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: BusinessText.metaLabel(
                        context,
                      ).copyWith(color: context.colorScheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                BusinessSecondaryButton(
                  label: l10n.sort,
                  width: _scaledControlWidth(context, 60),
                  height: 34,
                  onPressed: onSort,
                ),
              ],
            ],
          ),
          for (var index = 0; index < profiles.length; index++) ...[
            if (index > 0)
              SizedBox(
                height: 1,
                child: ColoredBox(color: Divider.colorOf(context)),
              ),
            _BusinessOtherProfileRow(
              profile: profiles[index],
              currentProfileId: currentProfileId,
              mobile: mobile,
              onSwitch: onSwitch,
            ),
          ],
        ],
      ),
    );
  }
}

class _BusinessOtherProfileRow extends StatelessWidget {
  const _BusinessOtherProfileRow({
    required this.profile,
    required this.currentProfileId,
    required this.mobile,
    required this.onSwitch,
  });

  final Profile profile;
  final int? currentProfileId;
  final bool mobile;
  final ValueChanged<int?> onSwitch;

  bool get _expired {
    final expiry = profile.subscriptionInfo?.expireDate;
    return profile.type == ProfileType.url &&
        expiry != null &&
        expiry.isBefore(DateTime.now());
  }

  String _subtitle(BuildContext context) {
    final l10n = context.appLocalizations;
    return switch (profile.type) {
      ProfileType.url =>
        _expired
            ? l10n.zzProfileExpiredDays(
                DateTime.now()
                    .difference(profile.subscriptionInfo!.expireDate!)
                    .inDays,
              )
            : l10n.subscriptionLink,
      ProfileType.file => l10n.zzProfileImportedOn(
        profile.lastUpdateDate?.show ?? '',
      ),
      ProfileType.custom => l10n.zzProfileBasedOnOverrides(
        profile.overrides.proxyProviders.length,
      ),
    };
  }

  Glyph get _glyph => switch (profile.type) {
    ProfileType.url => AppGlyphs.link,
    ProfileType.file => AppGlyphs.importFile,
    ProfileType.custom => AppGlyphs.sliders,
  };

  void _edit(BuildContext context) {
    ProfileItem(
      profile: profile,
      groupValue: currentProfileId,
      onChanged: onSwitch,
    )._handleEdit(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final expired = _expired;
    final custom = profile.type == ProfileType.custom;
    final row = ListItem(
      minTileHeight: MacOSMetrics.doubleLineRowHeight(context, fallback: 65),
      minVerticalPadding: MacOSStyle.of(context) ? 7 : 0,
      padding: EdgeInsets.zero,
      leading: DecoratedBox(
        decoration: ShapeDecoration(
          color: colorScheme.surfaceContainerHigh,
          shape: AppShape.all(_businessProfileIconRadius),
        ),
        child: SizedBox.square(
          dimension: MacOSStyle.of(context) ? 32 : 36,
          child: Center(
            child: GlyphIcon(
              _glyph,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
      title: Text(
        profile.realLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: BusinessText.cardTitle(context),
      ),
      subtitle: Text(
        _subtitle(context),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: BusinessText.metaLabel(
          context,
        ).copyWith(color: colorScheme.onSurfaceVariant),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (expired)
            DashboardChip(
              label: l10n.expiredStatus,
              tone: DashboardChipTone.warn,
            ),
          if (!mobile)
            BusinessSecondaryButton(
              label: custom ? l10n.edit : l10n.switchProfileShort,
              width: _scaledControlWidth(context, 60),
              onPressed: custom
                  ? () => _edit(context)
                  : () => onSwitch(profile.id),
            )
          else if (custom)
            const GlyphIcon(AppGlyphs.chevronForward),
        ],
      ),
      onTap: custom ? () => _edit(context) : () => onSwitch(profile.id),
    );
    return MacOSStyle.of(context)
        ? Padding(
            key: const ValueKey('macos-subscription-other-row'),
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: row,
          )
        : row;
  }
}

class _BusinessImportHintCard extends StatelessWidget {
  const _BusinessImportHintCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final colorScheme = context.colorScheme;
    const scheme = 'tianji://';
    final hint = l10n.zzProfileImportHint(scheme);
    final schemeStart = hint.indexOf(scheme);
    final schemeEnd = schemeStart + scheme.length;
    final textStyle = BusinessText.actionLabel(
      context,
    ).copyWith(color: colorScheme.onSurfaceVariant);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colorScheme.surfaceContainerHigh,
        shape: AppShape.all(BusinessPalette.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Text.rich(
          TextSpan(
            children: [
              if (schemeStart > 0)
                TextSpan(text: hint.substring(0, schemeStart)),
              TextSpan(text: scheme, style: textStyle.toJetBrainsMono),
              if (schemeEnd < hint.length)
                TextSpan(text: hint.substring(schemeEnd)),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      ),
    );
  }
}

class _BusinessConnectedChip extends StatelessWidget {
  const _BusinessConnectedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final brightness = context.colorScheme.brightness;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: BusinessPalette.connectedContainerFor(brightness),
        shape: AppShape.full,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        child: Text(
          label,
          style: BusinessText.heroStatus(
            context,
          ).copyWith(color: BusinessPalette.connectedForegroundFor(brightness)),
        ),
      ),
    );
  }
}

class _MobileSubscriptionMetric extends StatelessWidget {
  const _MobileSubscriptionMetric({
    required this.label,
    required this.value,
    required this.unit,
    this.largeUnit = false,
    this.footnote,
  });

  final String label;
  final String value;
  final String unit;
  final bool largeUnit;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BusinessText.metaLabel(context)),
        const SizedBox(height: 2),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: BusinessText.mobileSubscriptionMetric(context),
              ),
              if (unit.isNotEmpty)
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      unit,
                      style: largeUnit
                          ? BusinessText.mobileSubscriptionLargeUnit(context)
                          : BusinessText.mobileSubscriptionUnit(context),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (footnote != null)
          Text(
            footnote!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: BusinessText.metaLabel(
              context,
            ).copyWith(color: colorScheme.onSurfaceVariant),
          ),
      ],
    );
  }
}

class _SubscriptionProgress extends StatelessWidget {
  const _SubscriptionProgress({required this.value, required this.height});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: context.colorScheme.surfaceContainerHigh,
          shape: AppShape.full,
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0, 1),
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
    );
  }
}

class _MobileImportButton extends StatelessWidget {
  const _MobileImportButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle.from(
        backgroundColor: BusinessPalette.deep,
        foregroundColor: Colors.white,
        shape: AppShape.full,
        fixedSize: Size(_scaledControlWidth(context, 92), 34),
        minimumSize: Size(_scaledControlWidth(context, 92), 34),
        maximumSize: Size(_scaledControlWidth(context, 92), 34),
        padding: EdgeInsets.zero,
        tapTargetSize: TapTargetSize.shrinkWrap,
      ),
      child: Text(
        '＋ ${context.appLocalizations.import}',
        style: BusinessText.actionLabel(
          context,
          emphasized: true,
        ).copyWith(color: Colors.white),
      ),
    );
  }
}

class _MobileQuickImports extends StatelessWidget {
  const _MobileQuickImports({
    required this.onClipboard,
    required this.onScan,
    required this.onFile,
  });

  final VoidCallback onClipboard;
  final VoidCallback onScan;
  final VoidCallback onFile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final items = <(Glyph, String, VoidCallback)>[
      (AppGlyphs.paste, l10n.zzQuickClipboard, onClipboard),
      if (!system.isTV) (AppGlyphs.qrCode, l10n.zzQuickScan, onScan),
      (AppGlyphs.importFile, l10n.zzQuickLocalFile, onFile),
    ];
    return Row(
      spacing: 8,
      children: [
        for (final item in items)
          Expanded(
            child: Card(
              radius: BusinessPalette.buttonRadius,
              padding: EdgeInsets.zero,
              onPressed: item.$3,
              child: SizedBox(
                height: 74,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 6,
                  children: [
                    GlyphIcon(item.$1, size: 20, color: BusinessPalette.blue),
                    Text(item.$2, style: BusinessText.metaLabel(context)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Future<void> _importClipboard(BuildContext context, WidgetRef ref) async {
  final value = await Clipboard.getData(Clipboard.kTextPlain);
  if (!context.mounted) return;
  final url = subscriptionUrlFromText(value?.text ?? '');
  if (url == null) {
    dialogs.showBanner(
      context.appLocalizations.invalidLinkTip,
      level: BannerLevel.error,
    );
    return;
  }
  if (!context.isMobileView &&
      isTianjiSubscriptionProfile(ref.read(currentProfileProvider))) {
    await showBusinessProfileAddDialog(
      context,
      ref,
      source: ProfileAddSource.link,
      url: url,
    );
    return;
  }
  unawaited(ref.read(profilesActionProvider.notifier).addProfileFromLink(url));
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
    final mobile = ref.watch(isMobileViewProvider);
    final action = ProfileItem(
      profile: profile,
      groupValue: currentProfileId,
      onChanged: (_) {},
    );
    final colorScheme = context.colorScheme;
    return ContextMenuRegion(
      menuItems: isUpdating ? null : action._menuItems(context, ref),
      child: Card(
        key: MacOSStyle.of(context)
            ? const ValueKey('macos-subscription-primary-card')
            : null,
        radius: MacOSMetrics.cardRadius(
          context,
          fallback: BusinessPalette.cardRadius,
        ),
        padding: MacOSMetrics.cardPadding(
          context,
          EdgeInsets.all(mobile ? 16 : 26),
        ),
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
            return _buildMobile(
              context,
              ref: ref,
              action: action,
              info: info,
              usage: usage,
              used: used,
              isUpdating: isUpdating,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobile(
    BuildContext context, {
    required WidgetRef ref,
    required ProfileItem action,
    required SubscriptionInfo? info,
    required double? usage,
    required int? used,
    required bool isUpdating,
  }) {
    final l10n = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final expire = info?.expireDate;
    final daysLeft = expire
        ?.difference(DateTime.now())
        .inDays
        .clamp(0, 999999)
        .toInt();
    final interval = profile.autoUpdateDuration;
    final intervalLabel = profile.autoUpdate
        ? interval.inHours >= 1
              ? l10n.zzAutoUpdateHours(interval.inHours)
              : l10n.zzAutoUpdateIntervalLabel(interval.inMinutes, l10n.minutes)
        : null;
    final menuItems = [
      PopupMenuItem(
        glyph: AppGlyphs.copy,
        label: l10n.copySubscriptionLink,
        onPressed: () => action._handleCopyLink(context),
      ),
      PopupMenuItem(
        glyph: AppGlyphs.edit,
        label: l10n.edit,
        onPressed: () => action._handleEdit(context),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: profile.realLabel),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _BusinessConnectedChip(label: l10n.inUse),
                      ),
                    ),
                  ],
                ),
                maxLines: 2,
                style: BusinessText.mobileSubscriptionTitle(context),
              ),
            ),
            PopupAnchor(
              targetBuilder: (open) => IconButton(
                tooltip: l10n.more,
                onPressed: open,
                icon: const GlyphIcon(AppGlyphs.more),
              ),
              popupBuilder: (_) => PopupMenu(items: menuItems),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (info?.total case final total? when total > 0)
              _ProfileMetaChip(
                label: '${total.traffic.value} ${total.traffic.unit}',
              ),
            if (isResidentialPolicyActive(profile))
              DashboardChip(
                label: l10n.residentialOutbound,
                tone: DashboardChipTone.residential,
              ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _MobileSubscriptionMetric(
                label: l10n.zzRemaining,
                value: daysLeft?.toString() ?? '—',
                unit: l10n.zzRemainingDayUnit,
                largeUnit: true,
                footnote: expire == null
                    ? null
                    : l10n.zzExpiryDate(expire.show),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MobileSubscriptionMetric(
                label: l10n.currentUsage,
                value: used?.traffic.value ?? '—',
                unit: used == null ? '' : used.traffic.unit,
                footnote: info == null
                    ? null
                    : l10n.zzTotalQuota(
                        '${info.total.traffic.value} ${info.total.traffic.unit}',
                      ),
              ),
            ),
          ],
        ),
        if (usage != null) ...[
          const SizedBox(height: 12),
          _SubscriptionProgress(value: usage, height: 6),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            LastUpdateTimeText(
              lastUpdateDate: profile.lastUpdateDate,
              compact: true,
              style: BusinessText.metaLabel(
                context,
              ).copyWith(color: colorScheme.onSurfaceVariant),
            ),
            Text(
              ' · ',
              style: BusinessText.metaLabel(
                context,
              ).copyWith(color: colorScheme.onSurfaceVariant),
            ),
            Flexible(
              child: Text(
                intervalLabel ?? l10n.autoUpdate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: BusinessText.metaLabel(
                  context,
                ).copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = (constraints.maxWidth - 8) / 2;
            return Row(
              spacing: 8,
              children: [
                BusinessSecondaryButton(
                  label: l10n.immediateUpdate,
                  width: buttonWidth,
                  height: 44,
                  onPressed: isUpdating
                      ? null
                      : () => action.updateProfile(ref),
                ),
                BusinessPrimaryButton(
                  label: l10n.zzRenewUpgradeShort,
                  width: buttonWidth,
                  height: 44,
                  onPressed: () => dialogs.openUrl(userPanelUrl),
                ),
              ],
            );
          },
        ),
      ],
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
        ? isTianjiSubscriptionProfile(profile)
              ? maskTianjiSubscriptionUrl(profile.url)
              : '${url.scheme}://${url.host}/••••••••'
        : null;
    final updateInterval = profile.autoUpdateDuration;
    final intervalLabel = profile.autoUpdate
        ? updateInterval.inHours >= 1
              ? l10n.zzAutoUpdateHours(updateInterval.inHours)
              : l10n.zzAutoUpdateIntervalLabel(
                  updateInterval.inMinutes,
                  l10n.minutes,
                )
        : null;
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
                    Flexible(
                      fit: MacOSStyle.of(context)
                          ? FlexFit.tight
                          : FlexFit.loose,
                      child: Text(
                        profile.realLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: BusinessText.subscriptionTitle(context),
                      ),
                    ),
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: BusinessPalette.connectedContainerFor(
                          colorScheme.brightness,
                        ),
                        shape: AppShape.full,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        child: Text(
                          l10n.inUse,
                          style: BusinessText.heroStatus(context).copyWith(
                            color: BusinessPalette.connectedForegroundFor(
                              colorScheme.brightness,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (MacOSStyle.of(context)) ...[
                      BusinessPrimaryButton(
                        label: l10n.immediateUpdate,
                        width: 120,
                        onPressed: isUpdating
                            ? null
                            : () => action.updateProfile(ref),
                      ),
                      PopupAnchor(
                        targetBuilder: (open) => IconButton(
                          tooltip: l10n.more,
                          onPressed: open,
                          icon: const GlyphIcon(AppGlyphs.more),
                        ),
                        popupBuilder: (_) => PopupMenu(
                          items: [
                            PopupMenuItem(
                              glyph: AppGlyphs.openExternal,
                              label: l10n.renewUpgrade,
                              onPressed: () => dialogs.openUrl(userPanelUrl),
                            ),
                            ...action._menuItems(context, ref),
                          ],
                        ),
                      ),
                    ],
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
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (info?.total case final total? when total > 0)
                      _ProfileMetaChip(
                        label: '${total.traffic.value} ${total.traffic.unit}',
                      ),
                    if (isResidentialPolicyActive(profile))
                      DashboardChip(
                        label: l10n.residentialOutbound,
                        tone: DashboardChipTone.residential,
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ProfileMetric(
                        label: l10n.currentUsage,
                        value: used != null && info != null
                            ? formatTianjiTrafficUsage(
                                used.traffic,
                                info.total.traffic,
                              )
                            : '—',
                        footnote: null,
                        progress: usage,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ProfileMetric(
                        label: l10n.currentExpiry,
                        value: info == null
                            ? '—'
                            : expire?.show ?? l10n.infiniteTime,
                        valueStyle: BusinessText.subscriptionSecondaryValue(
                          context,
                        ),
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
                          AnimatedSwitcher(
                            duration: context.motionDuration(commonDuration),
                            child: isUpdating
                                ? const ActivityIndicator(
                                    key: ValueKey('updating'),
                                    size: 24,
                                  )
                                : LastUpdateTimeText(
                                    key: const ValueKey('lastUpdate'),
                                    lastUpdateDate: profile.lastUpdateDate,
                                    style:
                                        BusinessText.subscriptionSecondaryValue(
                                          context,
                                        ),
                                    compact: true,
                                  ),
                          ),
                          if (intervalLabel != null)
                            Text(
                              intervalLabel,
                              style: AppTextStyle.footnote
                                  .of(context)
                                  .copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!MacOSStyle.of(context)) ...[
            SizedBox(
              width: 1,
              child: ColoredBox(color: Divider.colorOf(context)),
            ),
            SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  BusinessPrimaryButton(
                    label: l10n.renewUpgrade,
                    width: 200,
                    onPressed: () => dialogs.openUrl(userPanelUrl),
                  ),
                  BusinessSecondaryButton(
                    label: l10n.immediateUpdate,
                    width: 200,
                    onPressed: isUpdating
                        ? null
                        : () => action.updateProfile(ref),
                  ),
                  BusinessSecondaryButton(
                    label: l10n.copySubscriptionLink,
                    width: 200,
                    onPressed: () => action._handleCopyLink(context),
                  ),
                  BusinessSecondaryButton(
                    label: l10n.edit,
                    width: 200,
                    onPressed: () => action._handleEdit(context),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({
    required this.label,
    required this.value,
    this.valueStyle,
    this.footnote,
    this.progress,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;
  final String? footnote;
  final double? progress;

  @override
  Widget build(BuildContext context) {
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
          style: valueStyle ?? BusinessText.subscriptionMetric(context),
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
                color: context.colorScheme.surfaceContainerHigh,
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
    return DashboardChip(label: label, tone: DashboardChipTone.idle);
  }
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
    if (isTianjiSubscriptionProfile(profile) && !context.isMobileView) {
      unawaited(BaseNavigator.push(context, EditProfileView(profile: profile)));
      return;
    }
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
        radius: MacOSMetrics.cardRadius(
          context,
          fallback: businessCompact ? BusinessPalette.cardRadius : AppCorner.xl,
        ),
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
  final bool business;

  const ReorderableProfilesSheet({
    super.key,
    required this.profiles,
    this.business = false,
  });

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

  Widget _buildBusinessItem(int index, int? currentProfileId) {
    final position = ItemPosition.get(index, profiles.length);
    final profile = profiles[index];
    final l = context.appLocalizations;
    final (glyph, subtitle) = switch (profile.type) {
      ProfileType.url => (AppGlyphs.link, l.subscriptionLink),
      ProfileType.file => (AppGlyphs.importFile, l.localFile),
      ProfileType.custom => (AppGlyphs.sliders, l.custom),
    };
    final isCurrent = profile.id == currentProfileId;
    return ReorderDragStartListener(
      key: Key(profile.id.toString()),
      index: index,
      child: ItemPositionProvider(
        position: position,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: BusinessPalette.customEditorCardFor(
                context.colorScheme.brightness,
              ),
              shape: AppShape.all(BusinessPalette.cardRadius),
            ),
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  spacing: 12,
                  children: [
                    SortHandle(index: index),
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: context.colorScheme.primaryContainer,
                        shape: AppShape.all(AppCorner.sm),
                      ),
                      child: SizedBox.square(
                        dimension: 32,
                        child: Center(
                          child: GlyphIcon(
                            glyph,
                            color: context.colorScheme.onPrimaryContainer,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.realLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: BusinessText.cardTitle(context),
                          ),
                          Text(
                            subtitle,
                            style: BusinessText.metaLabel(context).copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCurrent)
                      DecoratedBox(
                        decoration: ShapeDecoration(
                          color: BusinessPalette.connectedContainerFor(
                            context.colorScheme.brightness,
                          ),
                          shape: AppShape.full,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          child: Text(
                            l.inUse,
                            style: BusinessText.metaLabel(context).copyWith(
                              color: BusinessPalette.connectedForegroundFor(
                                context.colorScheme.brightness,
                              ),
                            ),
                          ),
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
    final business =
        widget.business || system.isDesktop && BusinessTheme.of(context);
    final currentProfileId = ref.watch(currentProfileIdProvider);
    if (business) {
      return Scaffold(
        title: appLocalizations.businessProfilesSortTitle,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MacOSMetrics.pageMargin(context, fallback: 24),
                56,
                MacOSMetrics.pageMargin(context, fallback: 24),
                12,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  appLocalizations.businessProfilesSortDescription,
                  style: BusinessText.metaLabel(
                    context,
                  ).copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            Expanded(
              child: PrismReorderableListView(
                padding: EdgeInsets.symmetric(
                  horizontal: MacOSMetrics.pageMargin(context, fallback: 24),
                ),
                proxyDecorator: (child, index, animation) =>
                    commonProxyDecorator(
                      _buildBusinessItem(index, currentProfileId),
                      index,
                      animation,
                    ),
                onReorderItem: (oldIndex, newIndex) {
                  setState(() {
                    profiles = profiles.copyAndReorder(oldIndex, newIndex);
                  });
                },
                itemBuilder: (_, index) =>
                    _buildBusinessItem(index, currentProfileId),
                itemCount: profiles.length,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MacOSMetrics.pageMargin(context, fallback: 24),
                12,
                MacOSMetrics.pageMargin(context, fallback: 24),
                20 + context.bottomInset,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: BusinessPrimaryButton(
                  label: appLocalizations.done,
                  width: 100,
                  onPressed: _handleSave,
                ),
              ),
            ),
          ],
        ),
      );
    }
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
