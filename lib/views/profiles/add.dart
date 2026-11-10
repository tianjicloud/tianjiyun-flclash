import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/pages/scan.dart';
import 'package:fl_clash/plugins/app.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
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
    final profilesAction = ref.read(profilesActionProvider.notifier);
    final request = await showFormSheet<_ProfileAddRequest>(
      context: context,
      builder: (_) => const _ProfileAddForm(),
    );
    if (request == null || !context.mounted) return;
    switch (request.source) {
      case _ProfileAddSource.link:
        unawaited(
          profilesAction.addProfileFromLink(
            request.url,
            label: request.label,
            ageSecretKey: request.ageSecretKey,
          ),
        );
      case _ProfileAddSource.file:
        unawaited(profilesAction.addProfileFormFile());
      case _ProfileAddSource.custom:
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

enum _ProfileAddSource { link, file, custom }

class _ProfileAddRequest {
  const _ProfileAddRequest({
    required this.source,
    this.url = '',
    this.label = '',
    this.ageSecretKey = '',
  });

  final _ProfileAddSource source;
  final String url;
  final String label;
  final String ageSecretKey;
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
  var _source = _ProfileAddSource.link;
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
    if (_source == _ProfileAddSource.link && _urlIssue != null) {
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
    required _ProfileAddSource source,
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
                source: _ProfileAddSource.link,
                title: appLocalizations.link,
                description: appLocalizations.profileAddLinkSourceDesc,
              ),
              _sourceCard(
                context,
                source: _ProfileAddSource.file,
                title: appLocalizations.file,
                description: appLocalizations.profileAddFileSourceDesc,
              ),
              _sourceCard(
                context,
                source: _ProfileAddSource.custom,
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
        if (_source == _ProfileAddSource.link) ...[
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
