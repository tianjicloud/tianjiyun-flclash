import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/pages/editor.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/profiles/extend/extend.dart';
import 'package:fl_clash/views/profiles/preview.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessPrimaryButton, BusinessSecondaryButton, DashboardCard;
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _ProfileField { label, url, autoUpdateInterval }

class EditProfileView extends ConsumerStatefulWidget {
  final Profile profile;

  const EditProfileView({super.key, required this.profile});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late final TextEditingController _labelController;
  late final TextEditingController _urlController;
  late final TextEditingController _ageSecretKeyController;
  late final TextEditingController _autoUpdateDurationController;
  late bool _autoUpdate;
  Uint8List? _editedData;
  bool _attempted = false;
  bool _showAgeSecretKey = false;
  final _fileInfoNotifier = ValueNotifier<FileInfo?>(null);
  late SetupAction _setupAction;
  Uint8List? _fileData;

  int get _overrideCount {
    final overrides = widget.profile.overrides;
    return overrides.dnsOverrideKeys.length +
        overrides.ntpOverrideKeys.length +
        overrides.snifferOverrideKeys.length +
        overrides.tunOverrideKeys.length +
        overrides.proxyProviders.length +
        overrides.manualSelections.length +
        (overrides.residentialExit == null ? 0 : 1);
  }

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.profile.label);
    _urlController = TextEditingController(text: widget.profile.url);
    _ageSecretKeyController = TextEditingController(
      text: widget.profile.ageSecretKey,
    );
    _autoUpdate = widget.profile.autoUpdate;
    _autoUpdateDurationController = TextEditingController(
      text: widget.profile.autoUpdateDuration.inMinutes.toString(),
    );
    _setupAction = ref.read(setupActionProvider.notifier);
    _updateFileInfo();
  }

  Future<void> _updateFileInfo() async {
    final file = await widget.profile.file;
    final fileInfo = await file.getFileInfo();
    if (!mounted) {
      return;
    }
    _fileInfoNotifier.value = fileInfo;
  }

  ({_ProfileField field, String message})? _issue(
    AppLocalizations appLocalizations,
  ) {
    final labelError = validateProfileName(
      appLocalizations,
      _labelController.text,
    );
    if (labelError != null) {
      return (field: _ProfileField.label, message: labelError);
    }
    if (widget.profile.type != ProfileType.url) {
      return null;
    }
    final url = _urlController.text;
    if (url.isEmpty) {
      return (
        field: _ProfileField.url,
        message: appLocalizations.profileUrlNullValidationDesc,
      );
    }
    if (!url.isUrl) {
      return (
        field: _ProfileField.url,
        message: appLocalizations.profileUrlInvalidValidationDesc,
      );
    }
    if (!_autoUpdate) {
      return null;
    }
    final interval = _autoUpdateDurationController.text;
    if (interval.isEmpty) {
      return (
        field: _ProfileField.autoUpdateInterval,
        message: appLocalizations.profileAutoUpdateIntervalNullValidationDesc,
      );
    }
    if ((int.tryParse(interval) ?? 0) <= 0) {
      return (
        field: _ProfileField.autoUpdateInterval,
        message:
            appLocalizations.profileAutoUpdateIntervalInvalidValidationDesc,
      );
    }
    return null;
  }

  void _handleChanged(String _) {
    if (_attempted) {
      setState(() {});
    }
  }

  Future<void> _handleConfirm() async {
    if (_issue(context.appLocalizations) != null) {
      setState(() {
        _attempted = true;
      });
      return;
    }
    final current =
        ref.read(profilesProvider).getProfile(widget.profile.id) ??
        widget.profile;
    final interval = int.tryParse(_autoUpdateDurationController.text);
    var profile = current.copyWith(
      url: _urlController.text,
      ageSecretKey: _ageSecretKeyController.text.trim(),
      label: _labelController.text,
      autoUpdate: _autoUpdate,
      autoUpdateDuration: interval != null && interval > 0
          ? Duration(minutes: interval)
          : current.autoUpdateDuration,
    );
    final profilesAction = ref.read(profilesActionProvider.notifier);
    final appLocalizations = context.appLocalizations;
    final hasUpdate =
        current.url != profile.url ||
        current.ageSecretKey != profile.ageSecretKey;
    if (_fileData != null) {
      if (profile.type == ProfileType.url && _autoUpdate) {
        final res = await dialogs.showMessage(
          title: appLocalizations.tip,
          message: TextSpan(text: appLocalizations.profileHasUpdate),
        );
        if (res == true) {
          profile = profile.copyWith(autoUpdate: false);
        }
      }
      final savedProfile = await globalState.safeRun(
        () => profile.saveFile(
          _fileData!,
          validate: (path, key) =>
              ref.read(coreHandlerProvider).validateProfile(path, key),
        ),
      );
      if (savedProfile == null) {
        return;
      }
      profilesAction.putProfile(savedProfile);
    } else if (!hasUpdate) {
      profilesAction.putProfile(profile);
    } else {
      unawaited(
        globalState.safeRun(() async {
          await Future.delayed(commonDuration);
          if (hasUpdate) {
            await profilesAction.updateProfile(profile);
          }
        }),
      );
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _setAutoUpdate(bool value) {
    if (_autoUpdate == value) return;
    setState(() {
      _autoUpdate = value;
    });
  }

  Future<void> _handleSaveEdit(BuildContext context, Uint8List data) async {
    final issue = await globalState.safeRun(
      () => ref
          .read(profilesActionProvider.notifier)
          .validateConfigWithData(data),
      silence: false,
    );
    if (issue != null) {
      unawaited(
        dialogs.showAlert(
          title: currentAppLocalizations.tip,
          message: TextSpan(text: issue),
        ),
      );
      return;
    }
    if (context.mounted) {
      Navigator.of(context).pop(data);
    }
  }

  Future<void> _editProfileFile() async {
    final title = widget.profile.label.takeFirstValid([
      widget.profile.id.toString(),
    ]);
    final editedData = _editedData;
    final editorPage = EditorPage(
      title: title,
      load: () async => editedData != null
          ? CodeForgeDocument.fromUtf8(editedData)
          : openEditorFile(
              await appPath.getProfilePath(widget.profile.id.toString()),
            ),
      onSave: (context, _, content) async {
        final data = await content.readBytes();
        if (context.mounted) {
          await _handleSaveEdit(context, data);
        }
      },
      onPop: (context, _, content) async {
        final res = await dialogs.showMessage(
          title: title,
          message: TextSpan(text: context.appLocalizations.hasCacheChange),
        );
        if (res != true || !context.mounted) {
          return true;
        }
        final data = await content.readBytes();
        if (context.mounted) {
          unawaited(_handleSaveEdit(context, data));
        }
        return false;
      },
    );
    final data = await BaseNavigator.push<Uint8List>(context, editorPage);
    if (data == null || !mounted) {
      return;
    }
    _editedData = data;
    setState(() {
      _fileData = data;
    });
    _fileInfoNotifier.value = _fileInfoNotifier.value?.copyWith(
      size: _fileData?.length ?? 0,
      lastModified: DateTime.now(),
    );
  }

  Future<void> _uploadProfileFile() async {
    final platformFile = await globalState.safeRun(picker.pickerFile);
    if (platformFile == null) return;
    final fileData = await platformFile.readBytes();
    if (!mounted) {
      return;
    }
    setState(() {
      _fileData = fileData;
    });
    _fileInfoNotifier.value = _fileInfoNotifier.value?.copyWith(
      size: _fileData?.length ?? 0,
      lastModified: DateTime.now(),
    );
  }

  Future<void> _handleDeleteProfile() async {
    final profilesAction = ref.read(profilesActionProvider.notifier);
    final appLocalizations = context.appLocalizations;
    final users = await profilesAction.providerUsers(widget.profile);
    if (!mounted) {
      return;
    }
    final res = await dialogs.showMessage(
      title: appLocalizations.tip,
      message: TextSpan(
        text: users.isEmpty
            ? appLocalizations.deleteTip(appLocalizations.profile)
            : appLocalizations.providerInUse(
                widget.profile.realLabel,
                users.map((item) => item.realLabel).join(', '),
              ),
      ),
      destructive: true,
      confirmText: appLocalizations.delete,
    );
    if (res != true || !mounted) {
      return;
    }
    await profilesAction.deleteProfile(widget.profile.id);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleBack() async {
    final appLocalizations = context.appLocalizations;
    final res = await dialogs.showMessage(
      title: appLocalizations.tip,
      message: TextSpan(text: appLocalizations.fileIsUpdate),
    );
    if (res == true) {
      unawaited(_handleConfirm());
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _urlController.dispose();
    _ageSecretKeyController.dispose();
    _fileInfoNotifier.dispose();
    _autoUpdateDurationController.dispose();
    super.dispose();
    _setupAction.autoApplyProfile();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final isUrl = widget.profile.type == ProfileType.url;
    final issue = _attempted ? _issue(appLocalizations) : null;
    final sections = <Widget>[
      generateSection(
        items: [
          _ProfileNameField(
            controller: _labelController,
            invalid: issue?.field == _ProfileField.label,
            onChanged: _handleChanged,
          ),
          if (isUrl)
            _ProfileUrlField(
              controller: _urlController,
              invalid: issue?.field == _ProfileField.url,
              onChanged: _handleChanged,
            ),
          _AgeSecretKeyField(controller: _ageSecretKeyController),
        ],
      ),
      if (isUrl)
        generateSection(
          items: [
            FormRow(
              title: appLocalizations.autoUpdate,
              onPressed: () => _setAutoUpdate(!_autoUpdate),
              trailing: Switch(value: _autoUpdate, onChanged: _setAutoUpdate),
            ),
            if (_autoUpdate)
              _AutoUpdateIntervalField(
                controller: _autoUpdateDurationController,
                invalid: issue?.field == _ProfileField.autoUpdateInterval,
                onChanged: _handleChanged,
              ),
          ],
        ),
      if (isUrl)
        generateSection(
          items: [
            FormRow(
              title: appLocalizations.extend,
              trailing: const GlyphIcon(AppGlyphs.chevronForward),
              onPressed: () => BaseNavigator.push(
                context,
                ExtendView(profileId: widget.profile.id),
              ),
            ),
            FormRow(
              title: appLocalizations.runtimeConfig,
              trailing: const GlyphIcon(AppGlyphs.chevronForward),
              onPressed: () => BaseNavigator.push(
                context,
                PreviewProfileView(profile: widget.profile),
              ),
            ),
          ],
        ),
      generateSection(
        items: [
          _ProfileFileItem(
            fileInfoNotifier: _fileInfoNotifier,
            onEdit: _editProfileFile,
            onUpload: _uploadProfileFile,
          ),
        ],
      ),
      if (isUrl)
        generateSection(
          items: [
            FormRow(
              title: appLocalizations.delete,
              trailing: Text(
                appLocalizations.delete,
                style: TextStyle(color: context.colorScheme.error),
              ),
              onPressed: _handleDeleteProfile,
            ),
          ],
        ),
    ];
    final mobileView = ref.watch(isMobileViewProvider);
    final businessEdit =
        (system.isDesktop || mobileView) &&
        isTianjiSubscriptionProfile(widget.profile);
    return FocusTraversalGroup(
      policy: PageTraversalPolicy(),
      child: PageFocusScope(
        child: PopGuard(
          onPop: _fileData == null
              ? null
              : (_) {
                  _handleBack();
                  return false;
                },
          child: Scaffold(
            title: businessEdit ? null : appLocalizations.edit,
            titleWidget: businessEdit
                ? mobileView
                      ? Text(
                          appLocalizations.businessProfileEditTitle,
                          style: AppTextStyle.custom(
                            context,
                            size: 19,
                            leading: 24,
                            weight: FontWeight.w700,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              child: Text(
                                '${appLocalizations.businessSubscriptions} ›',
                                style: BusinessText.metaLabel(context).copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Text(
                              appLocalizations.businessProfileEditTitle,
                              style: BusinessText.pageTitle(context),
                            ),
                          ],
                        )
                : null,
            actions: businessEdit
                ? mobileView
                      ? [
                          BusinessPrimaryButton(
                            label: appLocalizations.save,
                            width: 60,
                            height: 36,
                            onPressed: _handleConfirm,
                          ),
                        ]
                      : [
                          BusinessSecondaryButton(
                            label: appLocalizations.cancel,
                            width: 68,
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          BusinessPrimaryButton(
                            label: appLocalizations.save,
                            width: 68,
                            onPressed: _handleConfirm,
                          ),
                        ]
                : null,
            businessTitleInset: businessEdit && !mobileView,
            showLeading: !businessEdit || mobileView,
            confirmationAction: businessEdit
                ? null
                : IconButtonData(
                    glyph: AppGlyphs.check,
                    onPressed: _handleConfirm,
                    tooltip: appLocalizations.save,
                  ),
            body: businessEdit
                ? _buildBusinessEditor(issue)
                : Builder(
                    builder: (context) => LayoutBuilder(
                      builder: (context, constraints) {
                        final padding =
                            const EdgeInsets.symmetric(horizontal: 16).copyWith(
                              top: context.sectionsTopPadding,
                              bottom: context.bottomInset + 16,
                            );
                        final form = ListView(
                          padding: padding,
                          children: [
                            ErrorBanner(message: issue?.message),
                            ...sections,
                          ],
                        );
                        if (!system.isDesktop || constraints.maxWidth < 900) {
                          return form;
                        }
                        final editorSections = isUrl
                            ? sections.take(sections.length - 1).toList()
                            : sections;
                        return ListView(
                          padding: padding,
                          children: [
                            ErrorBanner(message: issue?.message),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: editorSections,
                                  ),
                                ),
                                if (isUrl)
                                  SizedBox(
                                    width: 320,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _SubscriptionSummary(
                                          profile: widget.profile,
                                        ),
                                        _DeleteProfileAction(
                                          onPressed: _handleDeleteProfile,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessEditor(({_ProfileField field, String message})? issue) {
    final context = this.context;
    final l10n = context.appLocalizations;
    final info = widget.profile.subscriptionInfo;
    final used = (info?.upload ?? 0) + (info?.download ?? 0);
    final activeProfile = ref.read(currentProfileProvider);
    final counts = activeProfile?.id == widget.profile.id
        ? globalState.lastConfigCounts
        : null;
    if (ref.watch(isMobileViewProvider)) {
      return _buildBusinessMobileEditor(issue);
    }
    Widget fieldLabel(String label) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: BusinessText.cardTitle(context)),
    );
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        padding: EdgeInsets.fromLTRB(
          24,
          context.sectionsTopPadding,
          24,
          context.bottomInset + 24,
        ),
        children: [
          ErrorBanner(message: issue?.message),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Expanded(
                child: DashboardCard(
                  radius: 18,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      fieldLabel(l10n.name),
                      _BusinessEditInput(
                        controller: _labelController,
                        onChanged: _handleChanged,
                      ),
                      const SizedBox(height: 18),
                      fieldLabel(l10n.businessProfileAddUrlLabel),
                      _BusinessEditInput(
                        controller: _urlController,
                        obscure: true,
                        onChanged: _handleChanged,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.businessProfileEditPrivacy,
                        style: BusinessText.quickMeta(
                          context,
                        ).copyWith(color: context.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 18),
                      fieldLabel(l10n.businessProfileAddAutoUpdate),
                      _BusinessIntervalInput(
                        controller: _autoUpdateDurationController,
                        onChanged: (value) {
                          _setAutoUpdate(true);
                          _handleChanged(value);
                        },
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      _BusinessEditRow(
                        title: l10n.businessProfileEditExtensionTitle,
                        subtitle:
                            '${l10n.businessProfileEditExtendDescription}$_overrideCount${l10n.businessProfileEditExtendSuffix}',
                        action: l10n.businessProfileEditManage,
                        onPressed: () => BaseNavigator.push(
                          context,
                          ExtendView(profileId: widget.profile.id),
                        ),
                      ),
                      _BusinessEditRow(
                        title: l10n.businessProfileEditRawTitle,
                        subtitle: l10n.businessProfileEditPreviewDescription,
                        action: l10n.businessProfileEditOpen,
                        onPressed: () => BaseNavigator.push(
                          context,
                          PreviewProfileView(profile: widget.profile),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(
                          () => _showAgeSecretKey = !_showAgeSecretKey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.businessProfileAddMoreOptions,
                                  style: BusinessText.quickMeta(context),
                                ),
                              ),
                              const GlyphIcon(AppGlyphs.chevronDown),
                            ],
                          ),
                        ),
                      ),
                      if (_showAgeSecretKey)
                        _AgeSecretKeyField(controller: _ageSecretKeyController),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 316,
                child: Column(
                  children: [
                    DashboardCard(
                      radius: 18,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.businessProfileEditSummaryTitle,
                            style: BusinessText.cardTitle(context),
                          ),
                          const SizedBox(height: 14),
                          if (widget.profile.label.isNotEmpty)
                            _BusinessSummaryRow(
                              label: l10n.businessProfileEditPlan,
                              value: widget.profile.label,
                            ),
                          if (info?.expireDate != null)
                            _BusinessSummaryRow(
                              label: l10n.businessProfileEditExpire,
                              value:
                                  '${info!.expireDate!.show}（${l10n.profileDaysLeft(info.expireDate!.difference(DateTime.now()).inDays.clamp(0, 9999))}）',
                            ),
                          if (info != null && info.total > 0)
                            _BusinessSummaryRow(
                              label: l10n.traffic,
                              value: formatTianjiTrafficUsage(
                                used.traffic,
                                info.total.traffic,
                              ),
                              mono: true,
                            ),
                          if (counts != null &&
                              (counts.proxies > 0 || counts.groups > 0))
                            _BusinessSummaryRow(
                              label: l10n.businessProfileEditLineLabel,
                              value:
                                  '${counts.proxies}${l10n.businessProfileEditLineCountSeparator}${counts.groups}${l10n.businessProfileEditGroupCountSuffix}',
                            ),
                          if (widget.profile.lastUpdateDate != null)
                            _BusinessSummaryRow(
                              label: l10n.lastUpdated,
                              value: widget.profile.lastUpdateDate!.show,
                            ),
                          const SizedBox(height: 16),
                          BusinessPrimaryButton(
                            label: l10n.businessProfileEditRenew,
                            width: double.infinity,
                            onPressed: () => dialogs.openUrl(userPanelUrl),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    DashboardCard(
                      radius: 18,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.businessProfileEditDeleteTitle,
                            style: BusinessText.cardTitle(context),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.businessProfileEditDeleteDescription,
                            style: BusinessText.quickMeta(context),
                          ),
                          const SizedBox(height: 14),
                          BusinessSecondaryButton(
                            label: l10n.businessProfileEditDelete,
                            width: double.infinity,
                            labelColor: context.colorScheme.error,
                            onPressed: _handleDeleteProfile,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessMobileEditor(
    ({_ProfileField field, String message})? issue,
  ) {
    final context = this.context;
    final l10n = context.appLocalizations;
    final isUrl = widget.profile.type == ProfileType.url;
    Widget field(String label, Widget child) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: AppTextStyle.custom(
                context,
                size: 13,
                leading: 18,
                weight: FontWeight.w600,
              ),
            ),
          ),
          child,
        ],
      ),
    );
    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        context.sectionsTopPadding,
        16,
        context.bottomInset + 20,
      ),
      children: [
        if (issue != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ErrorBanner(message: issue.message),
          ),
        field(
          l10n.name,
          _BusinessEditInput(
            controller: _labelController,
            onChanged: _handleChanged,
          ),
        ),
        if (isUrl)
          field(
            l10n.businessProfileAddUrlLabel,
            _BusinessEditInput(
              controller: _urlController,
              obscure: true,
              onChanged: _handleChanged,
            ),
          ),
        if (isUrl) ...[
          const SizedBox(height: 16),
          field(
            l10n.businessProfileAddAutoUpdate,
            _BusinessIntervalInput(
              controller: _autoUpdateDurationController,
              enabled: _autoUpdate,
              includeDisabled: true,
              onChanged: (value) {
                _setAutoUpdate(value != 'disabled');
                if (value != 'disabled') _handleChanged(value);
              },
            ),
          ),
          const SizedBox(height: 16),
          BusinessSettingsCard(
            items: [
              ListItem(
                title: Text(l10n.businessProfileEditExtensionTitle),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.itemsCount(_overrideCount),
                      style: BusinessText.metaLabel(
                        context,
                      ).copyWith(color: context.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(width: 6),
                    const GlyphIcon(AppGlyphs.chevronForward),
                  ],
                ),
                onTap: () => BaseNavigator.push(
                  context,
                  ExtendView(profileId: widget.profile.id),
                ),
              ),
              ListItem(
                title: Text(l10n.businessProfileEditRawTitle),
                trailing: const GlyphIcon(AppGlyphs.chevronForward),
                onTap: () => BaseNavigator.push(
                  context,
                  PreviewProfileView(profile: widget.profile),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: _handleDeleteProfile,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  context.colorScheme.surface,
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: context.colorScheme.error.withValues(alpha: 0.22),
                  ),
                ),
                shape: AppShape.all(14),
              ),
              child: Text(
                l10n.businessProfileEditDelete,
                style: AppTextStyle.custom(
                  context,
                  size: 15,
                  leading: 20,
                  weight: FontWeight.w600,
                ).copyWith(color: context.colorScheme.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Text(
                l10n.businessProfileEditDeleteDescription,
                style: BusinessText.metaLabel(
                  context,
                ).copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _BusinessEditInput extends StatefulWidget {
  const _BusinessEditInput({
    required this.controller,
    required this.onChanged,
    this.obscure = false,
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool obscure;

  @override
  State<_BusinessEditInput> createState() => _BusinessEditInputState();
}

class _BusinessEditInputState extends State<_BusinessEditInput> {
  late bool hidden = widget.obscure;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        color: context.colorScheme.surface,
        shape: AppShape.all(
          12,
        ).copyWith(side: BorderSide(color: context.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: widget.obscure && hidden
                ? Text(
                    maskTianjiSubscriptionUrl(widget.controller.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BusinessText.heroMetaValue(context).toJetBrainsMono,
                  )
                : TextField(
                    controller: widget.controller,
                    keyboardType: widget.obscure
                        ? TextInputType.url
                        : TextInputType.text,
                    autocorrect: false,
                    onChanged: widget.onChanged,
                    style: widget.obscure
                        ? BusinessText.quickMeta(context).toJetBrainsMono
                        : BusinessText.dataBody(context),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration.collapsed(hintText: ''),
                  ),
          ),
          if (widget.obscure)
            TextButton(
              onPressed: () => setState(() => hidden = !hidden),
              child: Text(
                hidden
                    ? context.appLocalizations.businessProfileEditShow
                    : context.appLocalizations.businessProfileEditHide,
              ),
            ),
        ],
      ),
    ),
  );
}

class _BusinessIntervalInput extends StatelessWidget {
  const _BusinessIntervalInput({
    required this.controller,
    required this.onChanged,
    this.enabled = true,
    this.includeDisabled = false,
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool includeDisabled;

  @override
  Widget build(BuildContext context) {
    final minutes = int.tryParse(controller.text) ?? 360;
    return PopupAnchor(
      targetBuilder: (open) => GestureDetector(
        onTap: open,
        child: Container(
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: ShapeDecoration(
            color: context.colorScheme.surface,
            shape: AppShape.all(12).copyWith(
              side: BorderSide(color: context.colorScheme.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  enabled
                      ? context.appLocalizations.zzAutoUpdateHours(
                          minutes ~/ 60,
                        )
                      : context.appLocalizations.disabled,
                  style: BusinessText.dataBody(context),
                ),
              ),
              const GlyphIcon(AppGlyphs.chevronDown),
            ],
          ),
        ),
      ),
      popupBuilder: (_) => PopupMenu(
        items: [
          if (includeDisabled)
            PopupMenuItem(
              label: context.appLocalizations.disabled,
              onPressed: () => onChanged('disabled'),
            ),
          for (final hours in [6, 12, 24, 48])
            PopupMenuItem(
              label: context.appLocalizations.zzAutoUpdateHours(hours),
              onPressed: () {
                controller.text = '${hours * 60}';
                onChanged(controller.text);
              },
            ),
        ],
      ),
    );
  }
}

class _BusinessEditRow extends StatelessWidget {
  const _BusinessEditRow({
    required this.title,
    required this.subtitle,
    required this.action,
    required this.onPressed,
  });
  final String title, subtitle, action;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 64,
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: BusinessText.cardTitle(context)),
              Text(subtitle, style: BusinessText.quickMeta(context)),
            ],
          ),
        ),
        BusinessSecondaryButton(label: action, width: 76, onPressed: onPressed),
      ],
    ),
  );
}

class _BusinessSummaryRow extends StatelessWidget {
  const _BusinessSummaryRow({
    required this.label,
    required this.value,
    this.mono = false,
  });
  final String label, value;
  final bool mono;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(child: Text(label, style: BusinessText.quickMeta(context))),
        Text(
          value,
          style: mono
              ? BusinessText.dataBody(context).toJetBrainsMono
              : BusinessText.dataBody(context),
        ),
      ],
    ),
  );
}

class _DeleteProfileAction extends StatelessWidget {
  const _DeleteProfileAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return generateSection(
      title: appLocalizations.delete,
      items: [
        FormRow(
          title: appLocalizations.deleteTip(appLocalizations.profile),
          trailing: Text(
            appLocalizations.delete,
            style: TextStyle(color: context.colorScheme.error),
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class _SubscriptionSummary extends StatelessWidget {
  const _SubscriptionSummary({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final info = profile.subscriptionInfo;
    final used = (info?.upload ?? 0) + (info?.download ?? 0);
    final expireDate = info?.expireDate;
    return generateSection(
      title: appLocalizations.subscriptionInfo,
      items: [
        if (expireDate != null)
          FormRow(
            title: appLocalizations.expireTime,
            trailing: Text(expireDate.show),
          ),
        if (info != null && info.total > 0)
          FormRow(
            title: appLocalizations.traffic,
            trailing: Text('${used.traffic.show} / ${info.total.traffic.show}'),
          ),
        if (profile.lastUpdateDate != null)
          FormRow(
            title: appLocalizations.lastUpdated,
            trailing: LastUpdateTimeText(
              lastUpdateDate: profile.lastUpdateDate!,
              compact: true,
            ),
          ),
      ],
    );
  }
}

String? validateProfileName(AppLocalizations appLocalizations, String? value) {
  if (value == null || value.isEmpty) {
    return appLocalizations.profileNameNullValidationDesc;
  }
  return null;
}

Future<void> renameProfile(
  BuildContext context,
  WidgetRef ref,
  Profile profile, {
  bool selectAll = false,
}) async {
  final appLocalizations = context.appLocalizations;
  final profilesAction = ref.read(profilesActionProvider.notifier);
  final label = await dialogs.showCommonDialog<String>(
    child: InputDialog(
      title: appLocalizations.rename,
      labelText: appLocalizations.name,
      value: profile.label,
      selectAll: selectAll,
      inputFormatters: TextInputLimits.limit(TextInputLimits.name),
      validator: (value) => validateProfileName(appLocalizations, value),
    ),
  );
  if (label == null || label == profile.label) {
    return;
  }
  profilesAction.putProfile(profile.copyWith(label: label));
}

class _ProfileNameField extends StatelessWidget {
  const _ProfileNameField({
    required this.controller,
    required this.invalid,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool invalid;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return FormRow(
      title: appLocalizations.name,
      invalid: invalid,
      trailing: FormRowTextField(
        controller: controller,
        hintText: appLocalizations.required,
        textInputAction: TextInputAction.next,
        inputFormatters: TextInputLimits.limit(TextInputLimits.name),
        onChanged: onChanged,
      ),
    );
  }
}

class _ProfileUrlField extends StatelessWidget {
  const _ProfileUrlField({
    required this.controller,
    required this.invalid,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool invalid;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return FormRow(
      title: appLocalizations.url,
      invalid: invalid,
      trailing: _SecretProfileUrlField(
        controller: controller,
        onChanged: onChanged,
      ),
    );
  }
}

class _SecretProfileUrlField extends StatefulWidget {
  const _SecretProfileUrlField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  State<_SecretProfileUrlField> createState() => _SecretProfileUrlFieldState();
}

class _SecretProfileUrlFieldState extends State<_SecretProfileUrlField> {
  var _obscure = true;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: FormRowTextField(
            controller: widget.controller,
            hintText: appLocalizations.required,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            inputFormatters: TextInputLimits.limit(TextInputLimits.url),
            obscureText: _obscure,
            onChanged: widget.onChanged,
          ),
        ),
        MinIconButtonTheme(
          child: IconButton(
            tooltip: _obscure
                ? appLocalizations.showPassword
                : appLocalizations.hidePassword,
            icon: GlyphIcon(_obscure ? AppGlyphs.eye : AppGlyphs.eyeOff),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ],
    );
  }
}

class _AgeSecretKeyField extends StatelessWidget {
  const _AgeSecretKeyField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return FormRow(
      title: appLocalizations.ageSecretKey,
      trailing: FormRowSecretTextField(
        controller: controller,
        hintText: appLocalizations.optional,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class _AutoUpdateIntervalField extends StatelessWidget {
  const _AutoUpdateIntervalField({
    required this.controller,
    required this.invalid,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool invalid;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return FormRow(
      title: appLocalizations.autoUpdateInterval,
      invalid: invalid,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Flexible(
            child: FormRowTextField(
              controller: controller,
              hintText: appLocalizations.required,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              inputFormatters: TextInputLimits.digitsOnly(
                TextInputLimits.interval,
              ),
              onChanged: onChanged,
            ),
          ),
          Text(
            appLocalizations.minutes,
            style: AppTextStyle.subheadline.of(context),
          ),
        ],
      ),
    );
  }
}

class _ProfileFileItem extends StatelessWidget {
  const _ProfileFileItem({
    required this.fileInfoNotifier,
    required this.onEdit,
    required this.onUpload,
  });

  final ValueNotifier<FileInfo?> fileInfoNotifier;
  final VoidCallback onEdit;
  final VoidCallback onUpload;

  Widget _buildSubtitle(BuildContext context, FileInfo fileInfo) {
    final style = context.listCaptionStyle;
    final lastModified = fileInfo.lastModified;
    if (lastModified == null) {
      return Text(context.appLocalizations.unknown, style: style);
    }
    return LastUpdateTimeText(lastUpdateDate: lastModified, style: style);
  }

  List<PopupMenuItem> _menuItems(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return [
      PopupMenuItem(
        glyph: AppGlyphs.edit,
        label: appLocalizations.edit,
        onPressed: onEdit,
      ),
      PopupMenuItem(
        glyph: AppGlyphs.upload,
        label: appLocalizations.upload,
        onPressed: onUpload,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return ValueListenableBuilder<FileInfo?>(
      valueListenable: fileInfoNotifier,
      builder: (context, fileInfo, _) {
        return FadeThroughBox(
          alignment: Alignment.centerLeft,
          child: fileInfo == null
              ? Container()
              : ContextMenuRegion(
                  menuItems: _menuItems(context),
                  child: DecorationListItem(
                    contentPadding: const EdgeInsets.only(left: 16),
                    title: Text(appLocalizations.profile),
                    subtitle: _buildSubtitle(context, fileInfo),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          fileInfo.size.traffic.show,
                          style: context.listCaptionStyle,
                        ),
                        const DisclosureIndicator(),
                      ],
                    ),
                    onPressed: onEdit,
                  ),
                ),
        );
      },
    );
  }
}
