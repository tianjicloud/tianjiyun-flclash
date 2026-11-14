import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/pages/scan.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessPrimaryButton, BusinessSecondaryButton;
import 'package:fl_clash/views/profiles/custom/custom.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The ways to add a profile, in a menu out of the control [builder] makes.
class AddProfileMenu extends ConsumerWidget {
  const AddProfileMenu({super.key, required this.builder});

  final Widget Function(PopupOpen open) builder;

  Future<void> _toScan(BuildContext context, WidgetRef ref) async {
    await addProfileFromQrCode(context, ref);
  }

  Future<void> _toAdd(BuildContext context, WidgetRef ref) async {
    final business = isTianjiSubscriptionProfile(
      ref.read(currentProfileProvider),
    );
    if (business && !context.isMobileView) {
      await showBusinessProfileAddDialog(context, ref);
      return;
    }
    final profilesAction = ref.read(profilesActionProvider.notifier);
    final request = await showFormSheet<_ProfileAddRequest>(
      context: context,
      builder: (_) => const _ProfileAddForm(),
    );
    if (request == null || !context.mounted) return;
    switch (request.source) {
      case ProfileAddSource.link:
        unawaited(
          profilesAction.addProfileFromLink(
            request.url,
            label: request.label,
            ageSecretKey: request.ageSecretKey,
          ),
        );
      case ProfileAddSource.file:
        unawaited(profilesAction.addProfileFormFile());
      case ProfileAddSource.custom:
        _toAddCustom(context, ref);
    }
  }

  Future<void> _toAddBatch(BuildContext context, WidgetRef ref) async {
    final appLocalizations = context.appLocalizations;
    final res = await showNamedUrlsForm(
      context,
      title: appLocalizations.batchImport,
      urlLabel: appLocalizations.link,
      batchTip: appLocalizations.batchLinkInputTip,
      urlValidator: (value) {
        if (value == null || value.isEmpty) {
          return appLocalizations.emptyTip(appLocalizations.link);
        }
        if (!value.isUrl && !value.isShareLink) {
          return appLocalizations.invalidLinkTip;
        }
        return null;
      },
      existingUrls: {
        for (final profile in ref.read(profilesProvider))
          if (profile.url.isNotEmpty) profile.url,
      },
      withAgeSecretKey: true,
    );
    if (res == null) {
      return;
    }
    final profilesAction = ref.read(profilesActionProvider.notifier);
    switch (res) {
      case [final single]:
        unawaited(
          profilesAction.addProfileFromLink(
            single.url,
            label: single.label,
            ageSecretKey: single.ageSecretKey,
          ),
        );
      default:
        unawaited(
          profilesAction.addProfilesFromLinks([
            for (final item in res) item.url,
          ]),
        );
    }
  }

  Future<void> _toSendFromPhone(WidgetRef ref) async {
    final profilesAction = ref.read(profilesActionProvider.notifier);
    if (!(await app?.requestLocalNetworkPermission() ?? true)) {
      final appLocalizations = currentAppLocalizations;
      final res = await dialogs.showMessage(
        message: TextSpan(text: appLocalizations.sendFromPhonePermissionDenied),
        confirmText: appLocalizations.settings,
      );
      if (res == true) {
        await app?.openAppSettings();
      }
      return;
    }
    final link = await dialogs.showCommonDialog<String>(
      child: const _SendFromPhoneDialog(),
    );
    if (link == null) {
      return;
    }
    final appLocalizations = currentAppLocalizations;
    final confirmed = await dialogs.showMessage(
      title: appLocalizations.sendFromPhoneConfirmTitle,
      message: TextSpan(text: link),
      confirmText: appLocalizations.import,
    );
    if (confirmed == true) {
      unawaited(profilesAction.addProfileFromLink(link));
    }
  }

  void _toAddCustom(BuildContext context, WidgetRef ref) {
    final profileId = ref
        .read(profilesActionProvider.notifier)
        .addCustomProfile(context.appLocalizations.unnamed);
    unawaited(
      BaseNavigator.push(
        context,
        CustomProfileView(profileId: profileId, isNew: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    if (isTianjiSubscriptionProfile(ref.watch(currentProfileProvider)) &&
        !context.isMobileView) {
      return builder(() => unawaited(_toAdd(context, ref)));
    }
    return PopupAnchor(
      targetBuilder: builder,
      popupBuilder: (_) => PopupMenu(
        items: [
          PopupMenuItem(
            glyph: AppGlyphs.qrCode,
            label: appLocalizations.qrcode,
            onPressed: () => _toScan(context, ref),
          ),
          PopupMenuItem(
            glyph: AppGlyphs.cloudDownload,
            label: appLocalizations.addProfile,
            onPressed: () => _toAdd(context, ref),
          ),
          PopupMenuItem(
            glyph: AppGlyphs.listAdd,
            label: appLocalizations.batchImport,
            onPressed: () => _toAddBatch(context, ref),
          ),
          if (system.isTV)
            PopupMenuItem(
              glyph: AppGlyphs.devices,
              label: appLocalizations.sendFromPhone,
              onPressed: () => _toSendFromPhone(ref),
            ),
        ],
      ),
    );
  }
}

Future<void> showBusinessProfileAddDialog(
  BuildContext context,
  WidgetRef ref, {
  ProfileAddSource source = ProfileAddSource.link,
  String? url,
}) async {
  final request = await dialogs.showCommonDialog<_ProfileAddRequest>(
    context: context,
    child: _BusinessProfileAddForm(source: source, url: url),
  );
  if (request == null || !context.mounted) return;
  final action = ref.read(profilesActionProvider.notifier);
  switch (request.source) {
    case ProfileAddSource.link:
      unawaited(
        action.addProfileFromLink(
          request.url,
          label: request.label,
          ageSecretKey: request.ageSecretKey,
          autoUpdateDuration: request.autoUpdateDuration,
        ),
      );
    case ProfileAddSource.file:
      unawaited(action.addProfileFormFile());
    case ProfileAddSource.custom:
      final id = action.addCustomProfile(context.appLocalizations.unnamed);
      unawaited(
        BaseNavigator.push(
          context,
          CustomProfileView(profileId: id, isNew: true),
        ),
      );
  }
}

class _BusinessProfileAddForm extends StatefulWidget {
  const _BusinessProfileAddForm({required this.source, this.url});

  final ProfileAddSource source;
  final String? url;

  @override
  State<_BusinessProfileAddForm> createState() =>
      _BusinessProfileAddFormState();
}

class _BusinessProfileAddFormState extends State<_BusinessProfileAddForm> {
  late final _url = TextEditingController(text: widget.url ?? '');
  final _name = TextEditingController();
  final _key = TextEditingController();
  late var _source = widget.source;
  var _updateInterval = const Duration(hours: 6);
  var _attempted = false;
  var _showMoreOptions = false;

  @override
  void dispose() {
    _url.dispose();
    _name.dispose();
    _key.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _url.text.trim();
    if (_source == ProfileAddSource.link &&
        (value.isEmpty || (!value.isUrl && !value.isShareLink))) {
      setState(() => _attempted = true);
      return;
    }
    Navigator.of(context).pop(
      _ProfileAddRequest(
        source: _source,
        url: value,
        label: _name.text.trim(),
        ageSecretKey: _key.text.trim(),
        autoUpdateDuration: _updateInterval,
      ),
    );
  }

  void _choose(ProfileAddSource source) {
    if (source == ProfileAddSource.link) {
      setState(() => _source = source);
      return;
    }
    Navigator.of(context).pop(_ProfileAddRequest(source: source));
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    String? hint,
    bool mono = false,
    bool secret = false,
  }) {
    final scheme = context.colorScheme;
    final border = AppInputBorder(
      borderSide: BorderSide(color: scheme.outlineVariant, width: 1),
    );
    final inputStyle = AppTextStyle.custom(
      context,
      size: mono ? 13 : 14,
      leading: 18,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text(
          label,
          style: AppTextStyle.custom(
            context,
            size: 13,
            leading: 16,
            weight: FontWeight.w600,
          ).copyWith(color: scheme.onSurface),
        ),
        SizedBox(
          height: 44,
          child: secret
              ? SecretTextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: inputStyle.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                )
              : TextField(
                  controller: controller,
                  autocorrect: false,
                  style: mono ? inputStyle.toJetBrainsMono : inputStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: inputStyle.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ),
        ),
      ],
    );
  }

  double _submitWidth(BuildContext context, String label) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: BusinessText.actionLabel(context)),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      locale: Localizations.maybeLocaleOf(context),
      maxLines: 1,
    )..layout();
    final width = painter.width + 40;
    painter.dispose();
    return width;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final l10n = context.appLocalizations;
    final issue = _attempted && _source == ProfileAddSource.link
        ? (_url.text.trim().isEmpty
              ? l10n.emptyTip(l10n.link)
              : (!_url.text.trim().isUrl && !_url.text.trim().isShareLink
                    ? l10n.invalidLinkTip
                    : null))
        : null;
    final sources = <(ProfileAddSource, String, String)>[
      (
        ProfileAddSource.link,
        l10n.businessProfileAddLinkTitle,
        l10n.businessProfileAddLinkDescription,
      ),
      (
        ProfileAddSource.file,
        l10n.businessProfileAddFileTitle,
        l10n.businessProfileAddFileDescription,
      ),
      (
        ProfileAddSource.custom,
        l10n.businessProfileAddCustomTitle,
        l10n.businessProfileAddCustomDescription,
      ),
    ];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: scheme.surface,
            shape: AppShape.all(AppCorner.xxl),
            shadows: const [
              BoxShadow(
                color: BusinessPalette.searchShadow,
                blurRadius: 28,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.businessProfileAddTitle,
                        style: BusinessText.subscriptionTitle(context),
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: l10n.close,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: scheme.surfaceContainerHigh,
                            shape: AppShape.all(AppCorner.full),
                          ),
                          child: const SizedBox.square(
                            dimension: 32,
                            child: Center(
                              child: GlyphIcon(AppGlyphs.close, size: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    for (final (source, title, description) in sources)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _choose(source),
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: scheme.surfaceContainerLow,
                              shape: AppShape.all(AppCorner.lg).copyWith(
                                side: BorderSide(
                                  color: _source == source
                                      ? BusinessPalette.blue
                                      : scheme.outlineVariant,
                                  width: _source == source ? 2 : 0.5,
                                ),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: BusinessPalette.searchShadow,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: BusinessText.cardTitle(context),
                                    ),
                                    Expanded(
                                      child: Text(
                                        description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            AppTextStyle.custom(
                                              context,
                                              size: 12,
                                              leading: 15,
                                            ).copyWith(
                                              color: scheme.onSurfaceVariant,
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
                  ],
                ),
                if (_source == ProfileAddSource.link) ...[
                  _input(
                    l10n.businessProfileAddUrlLabel,
                    _url,
                    hint: l10n.businessProfileAddUrlHint,
                    mono: true,
                  ),
                  if (widget.url != null &&
                      isTianjiSubscriptionProfile(
                        Profile.normal(url: widget.url!),
                      ))
                    Text(
                      l10n.businessProfileAddClipboardRecognized,
                      style: BusinessText.quickMeta(
                        context,
                      ).copyWith(color: scheme.onSurfaceVariant),
                    ),
                  if (issue != null)
                    Text(issue, style: TextStyle(color: scheme.error)),
                  _input(
                    l10n.businessProfileAddNameLabel,
                    _name,
                    hint: l10n.businessProfileAddNameHint,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        l10n.businessProfileAddAutoUpdate,
                        style: AppTextStyle.custom(
                          context,
                          size: 13,
                          leading: 16,
                          weight: FontWeight.w600,
                        ).copyWith(color: scheme.onSurface),
                      ),
                      PopupAnchor(
                        targetBuilder: (open) => Semantics(
                          button: true,
                          child: GestureDetector(
                            onTap: open,
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                color: scheme.surface,
                                shape: AppShape.input.copyWith(
                                  borderSide: BorderSide(
                                    color: scheme.outlineVariant,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                height: 44,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          l10n.zzAutoUpdateHours(
                                            _updateInterval.inHours,
                                          ),
                                          style: AppTextStyle.custom(
                                            context,
                                            size: 14,
                                            leading: 18,
                                          ),
                                        ),
                                      ),
                                      const GlyphIcon(AppGlyphs.chevronDown),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        popupBuilder: (_) => PopupMenu(
                          items: [
                            for (final hours in [6, 12, 24, 48])
                              PopupMenuItem(
                                label: l10n.zzAutoUpdateHours(hours),
                                onPressed: () => setState(
                                  () =>
                                      _updateInterval = Duration(hours: hours),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Semantics(
                    button: true,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _showMoreOptions = !_showMoreOptions),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 6,
                        children: [
                          Text(
                            l10n.businessProfileAddMoreOptions,
                            style: AppTextStyle.custom(
                              context,
                              size: 13,
                              leading: 16,
                            ).copyWith(color: scheme.onSurfaceVariant),
                          ),
                          GlyphIcon(
                            _showMoreOptions
                                ? AppGlyphs.chevronUp
                                : AppGlyphs.chevronDown,
                            size: 14,
                            color: scheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showMoreOptions)
                    _input(
                      l10n.ageSecretKey,
                      _key,
                      hint: l10n.optional,
                      secret: true,
                    ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: scheme.surfaceContainerLow,
                      shape: AppShape.all(AppCorner.md),
                    ),
                    child: Text(
                      l10n.businessProfileAddValidationNote,
                      style: BusinessText.quickMeta(context),
                    ),
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    BusinessSecondaryButton(
                      label: l10n.cancel,
                      width: 84,
                      height: 36,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    BusinessPrimaryButton(
                      label: l10n.businessProfileAddSubmit,
                      width: _submitWidth(
                        context,
                        l10n.businessProfileAddSubmit,
                      ),
                      height: 36,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> addProfileFromQrCode(BuildContext context, WidgetRef ref) async {
  final profilesAction = ref.read(profilesActionProvider.notifier);
  if (system.isDesktop) {
    unawaited(profilesAction.addProfileFormQrCode());
    return;
  }
  final url = await BaseNavigator.push(context, const ScanPage());
  if (url == null) return;
  if (context.mounted) await whenRouteUncovered(context);
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(profilesAction.addProfileFromLink(url));
  });
}

enum ProfileAddSource { link, file, custom }

class _ProfileAddRequest {
  const _ProfileAddRequest({
    required this.source,
    this.url = '',
    this.label = '',
    this.ageSecretKey = '',
    this.autoUpdateDuration,
  });

  final ProfileAddSource source;
  final String url;
  final String label;
  final String ageSecretKey;
  final Duration? autoUpdateDuration;
}

class _ProfileAddForm extends StatefulWidget {
  const _ProfileAddForm();

  @override
  State<_ProfileAddForm> createState() => _ProfileAddFormState();
}

class _ProfileAddFormState extends State<_ProfileAddForm> {
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageSecretKeyController = TextEditingController();
  var _source = ProfileAddSource.link;
  var _attempted = false;

  String? get _urlIssue {
    final appLocalizations = context.appLocalizations;
    final value = _urlController.text.trim();
    if (value.isEmpty) {
      return appLocalizations.emptyTip(appLocalizations.link);
    }
    if (!value.isUrl && !value.isShareLink) {
      return appLocalizations.invalidLinkTip;
    }
    return null;
  }

  void _submit() {
    if (_source == ProfileAddSource.link && _urlIssue != null) {
      setState(() => _attempted = true);
      return;
    }
    Navigator.of(context).pop(
      _ProfileAddRequest(
        source: _source,
        url: _urlController.text.trim(),
        label: _nameController.text.trim(),
        ageSecretKey: _ageSecretKeyController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    _ageSecretKeyController.dispose();
    super.dispose();
  }

  Widget _sourceCard(
    BuildContext context, {
    required ProfileAddSource source,
    required String title,
    required String description,
  }) {
    final selected = source == _source;
    return DecorationListItem(
      isSelected: selected,
      minVerticalPadding: 8,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(title),
      subtitle: Text(description, maxLines: 2),
      onPressed: () => setState(() => _source = source),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final urlIssue = _attempted ? _urlIssue : null;
    return FormPage(
      title: appLocalizations.addProfile,
      saveLabel: appLocalizations.import,
      onSave: _submit,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [
              _sourceCard(
                context,
                source: ProfileAddSource.link,
                title: appLocalizations.link,
                description: appLocalizations.profileAddLinkSourceDesc,
              ),
              _sourceCard(
                context,
                source: ProfileAddSource.file,
                title: appLocalizations.file,
                description: appLocalizations.profileAddFileSourceDesc,
              ),
              _sourceCard(
                context,
                source: ProfileAddSource.custom,
                title: appLocalizations.customProfile,
                description: appLocalizations.profileAddCustomSourceDesc,
              ),
            ];
            if (constraints.maxWidth < 500) {
              return Column(spacing: 8, children: cards);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [for (final card in cards) Expanded(child: card)],
            );
          },
        ),
        if (_source == ProfileAddSource.link) ...[
          generateSection(
            items: [
              FormRow(
                title: appLocalizations.link,
                invalid: urlIssue != null,
                trailing: FormRowTextField(
                  controller: _urlController,
                  hintText: appLocalizations.required,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  onChanged: (_) {
                    if (_attempted) setState(() {});
                  },
                ),
              ),
              FormRow(
                title: appLocalizations.name,
                trailing: FormRowTextField(
                  controller: _nameController,
                  hintText: appLocalizations.optional,
                  textInputAction: TextInputAction.next,
                ),
              ),
              FormRow(
                title: appLocalizations.ageSecretKey,
                trailing: FormRowSecretTextField(
                  controller: _ageSecretKeyController,
                  hintText: appLocalizations.optional,
                ),
              ),
            ],
          ),
          generateSection(
            items: [
              ListItem(
                leading: const GlyphIcon(AppGlyphs.info),
                title: Text(appLocalizations.profileAddValidationNote),
              ),
            ],
          ),
        ],
        if (urlIssue != null) ErrorBanner(message: urlIssue),
      ],
    );
  }
}

class _SendFromPhoneDialog extends StatefulWidget {
  const _SendFromPhoneDialog();

  @override
  State<_SendFromPhoneDialog> createState() => _SendFromPhoneDialogState();
}

class _SendFromPhoneDialogState extends State<_SendFromPhoneDialog> {
  LinkReceiver? _receiver;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    final appLocalizations = currentAppLocalizations;
    final receiver = await LinkReceiver.start((
      title: appLocalizations.sendFromPhonePageTitle,
      hint: appLocalizations.sendFromPhonePageHint,
      send: appLocalizations.send,
      sent: appLocalizations.sendFromPhonePageSent,
      invalid: appLocalizations.invalidLinkTip,
    )).catchError((Object _) => null);
    if (!mounted) {
      unawaited(receiver?.close());
      return;
    }
    setState(() {
      _receiver = receiver;
      _failed = receiver == null;
    });
    final link = await receiver?.link;
    if (link != null && mounted) {
      Navigator.of(context).pop(link);
    }
  }

  @override
  void dispose() {
    unawaited(_receiver?.close());
    super.dispose();
  }

  Widget _buildContent(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    if (_failed) {
      return Text(
        appLocalizations.sendFromPhoneNoNetwork,
        textAlign: TextAlign.center,
      );
    }
    final address = _receiver?.address.toString();
    if (address == null) {
      return const SizedBox.square(
        dimension: 96,
        child: Center(child: ActivityIndicator()),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        QrCodeView(data: address, size: 200),
        SelectableText(address, textAlign: TextAlign.center),
        Text(appLocalizations.sendFromPhoneTip, textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: context.appLocalizations.sendFromPhone,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.appLocalizations.cancel),
        ),
      ],
      child: _buildContent(context),
    );
  }
}
