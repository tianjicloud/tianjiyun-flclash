import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/pages/editor.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/business_settings_card.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessSecondaryButton;
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClashProvidersView extends ConsumerStatefulWidget {
  const ClashProvidersView({super.key});

  @override
  ConsumerState<ClashProvidersView> createState() => _ClashProvidersViewState();
}

class _ClashProvidersViewState extends ConsumerState<ClashProvidersView> {
  late final ClashProvidersAction _providersAction;

  @override
  void initState() {
    super.initState();
    _providersAction = ref.read(clashProvidersActionProvider.notifier);
  }

  Set<String> _reservedLabels({ClashProvider? except}) {
    return {
      for (final item
          in ref.read(clashProvidersProvider).value ?? const <ClashProvider>[])
        if (item.id != except?.id) item.label,
    };
  }

  String? _validateLabel(
    String? value, {
    ClashProvider? except,
    bool optional = false,
  }) {
    final appLocalizations = context.appLocalizations;
    final label = value?.trim() ?? '';
    if (label.isEmpty) {
      return optional ? null : appLocalizations.emptyTip(appLocalizations.name);
    }
    if (_reservedLabels(except: except).contains(label)) {
      return appLocalizations.existsTip(appLocalizations.name);
    }
    return null;
  }

  String _uniqueLabel(String name, [Set<String>? reserved]) {
    return uniqueLabelFor(
      name,
      fallback: context.appLocalizations.ruleProviders,
      taken: (reserved ?? _reservedLabels()).contains,
    );
  }

  Future<bool> _put(
    ClashProvider provider, {
    ClashProvider? previous,
    List<int>? content,
    bool refresh = false,
  }) async {
    final saved = await globalState.loadingRun(
      () => _providersAction.putProvider(
        provider,
        previous: previous,
        content: content,
        refresh: refresh,
      ),
      title: provider.label,
      tag: LoadingTag.ruleProviders,
    );
    return saved != null;
  }

  Future<void> _handleImportFromUrl() async {
    final appLocalizations = context.appLocalizations;
    final res = await showNamedUrlsForm(
      context,
      title: appLocalizations.importUrl,
      labelValidator: (value) => _validateLabel(value, optional: true),
      urlValidator: _validateProviderUrl,
      existingUrls: {
        for (final item
            in ref.read(clashProvidersProvider).value ??
                const <ClashProvider>[])
          if (item.isRemote) item.url,
      },
    );
    if (res == null || !mounted) {
      return;
    }
    if (res case [final single]) {
      final label = single.label.isNotEmpty
          ? single.label
          : _uniqueLabel(single.url.urlFileName.fileStem);
      await _put(ClashProvider.create(label: label, url: single.url));
      return;
    }
    final reserved = _reservedLabels();
    final providers = <ClashProvider>[];
    for (final item in res) {
      final label = _uniqueLabel(item.url.urlFileName.fileStem, reserved);
      reserved.add(label);
      providers.add(ClashProvider.create(label: label, url: item.url));
    }
    await globalState.batchRun(
      providers,
      _providersAction.putProvider,
      label: (provider) => provider.url,
      concurrency: maxConcurrentImports,
      tag: LoadingTag.ruleProviders,
    );
  }

  Future<void> _handleImportFromFile() async {
    final file = await globalState.safeRun(picker.pickerFile);
    if (file == null) {
      return;
    }
    final bytes = await file.readBytes();
    if (!mounted) {
      return;
    }
    await _put(
      ClashProvider.create(label: _uniqueLabel(file.name.fileStem)),
      content: bytes,
    );
  }

  Future<String?> _showNameDialog({ClashProvider? except}) async {
    final appLocalizations = context.appLocalizations;
    final res = await dialogs.showCommonDialog<String>(
      child: InputDialog(
        title: appLocalizations.save,
        value: '',
        labelText: appLocalizations.name,
        inputFormatters: TextInputLimits.limit(TextInputLimits.name),
        validator: (value) => _validateLabel(value, except: except),
      ),
    );
    return res?.trim().value;
  }

  Future<void> _handleEditorSave(
    String title,
    EditorContent content, {
    ClashProvider? provider,
  }) async {
    final appLocalizations = context.appLocalizations;
    var label = title.trim();
    if (label.isEmpty) {
      final res = await _showNameDialog(except: provider);
      if (res == null) {
        return;
      }
      label = res;
    }
    if (_reservedLabels(except: provider).contains(label)) {
      unawaited(
        dialogs.showAlert(
          message: TextSpan(
            text: appLocalizations.existsTip(appLocalizations.name),
          ),
        ),
      );
      return;
    }
    final next =
        provider?.copyWith(label: label) ?? ClashProvider.create(label: label);
    if (!await _put(
      next,
      previous: provider,
      content: await content.readBytes(),
    )) {
      return;
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _handleEditorPop(
    String title,
    EditorContent content, {
    ClashProvider? provider,
  }) async {
    final res = await dialogs.showSaveChanges();
    if (res == null) {
      return false;
    }
    if (!res || !mounted) {
      return true;
    }
    unawaited(_handleEditorSave(title, content, provider: provider));
    return false;
  }

  void _handleToEditor([ClashProvider? provider]) {
    unawaited(
      BaseNavigator.push(
        context,
        EditorPage(
          titleEditable: true,
          title: provider?.label ?? '',
          load: () async => provider == null
              ? CodeForgeDocument.fromText('')
              : openEditorFile(await provider.path),
          schema: EditorSchema.provider,
          onSave: (_, title, content) =>
              _handleEditorSave(title, content, provider: provider),
          onPop: (_, title, content) =>
              _handleEditorPop(title, content, provider: provider),
        ),
      ),
    );
  }

  void _handlePreview(ClashProvider provider) {
    final core = ref.read(coreHandlerProvider);
    unawaited(
      BaseNavigator.push(
        context,
        EditorPage(
          title: provider.label,
          load: () async => provider.isTextContent
              ? openEditorFile(await provider.path)
              : CodeForgeDocument.fromText(
                  await core.dumpRuleSet(await provider.path),
                ),
          schema: EditorSchema.provider,
        ),
      ),
    );
  }

  Future<void> _handleEditOptions(ClashProvider provider) =>
      _showClashProviderOptions(context, ref, provider);

  Future<void> _handleDelete(ClashProvider provider) async {
    final appLocalizations = context.appLocalizations;
    final users = await _providersAction.profilesUsing(provider);
    final res = await dialogs.showMessage(
      title: appLocalizations.tip,
      message: TextSpan(
        text: users.isEmpty
            ? appLocalizations.deleteTip(provider.label)
            : appLocalizations.providerInUse(
                provider.label,
                users.map((profile) => profile.realLabel).join(', '),
              ),
      ),
      destructive: true,
      confirmText: appLocalizations.delete,
    );
    if (res != true) {
      return;
    }
    _providersAction.delProvider(provider);
  }

  bool _isEditable(ClashProvider provider) =>
      !provider.isRemote && provider.isTextContent;

  List<PopupMenuItem> _buildMenuItems(ClashProvider provider) {
    final appLocalizations = context.appLocalizations;
    final editable = _isEditable(provider);
    return [
      if (editable)
        PopupMenuItem(
          glyph: AppGlyphs.compose,
          label: appLocalizations.edit,
          onPressed: () {
            _handleToEditor(provider);
          },
        ),
      if (!provider.isTextContent)
        PopupMenuItem(
          glyph: AppGlyphs.eye,
          label: appLocalizations.preview,
          onPressed: () {
            _handlePreview(provider);
          },
        ),
      if (provider.isRemote)
        PopupMenuItem(
          glyph: AppGlyphs.sync,
          label: appLocalizations.sync,
          onPressed: () {
            _put(provider, previous: provider, refresh: true);
          },
        ),
      PopupMenuItem(
        glyph: AppGlyphs.settings,
        label: appLocalizations.options,
        onPressed: () {
          _handleEditOptions(provider);
        },
      ),
      PopupMenuItem(
        danger: true,
        glyph: AppGlyphs.delete,
        label: appLocalizations.delete,
        onPressed: () {
          _handleDelete(provider);
        },
      ),
    ];
  }

  Widget _buildItem(List<ClashProvider> providers, int index) {
    final provider = providers[index];
    final editable = _isEditable(provider);
    return SortableItem(
      key: ValueKey(provider.id),
      index: index,
      child: ContextMenuRegion(
        menuItems: _buildMenuItems(provider),
        child: ItemPositionProvider(
          position: ItemPosition.get(index, providers.length),
          child: DecorationListItem(
            contentPadding: const EdgeInsets.only(left: 16),
            title: ChipTitle(
              title: provider.label,
              chip: provider.behavior.name,
            ),
            subtitle: Text(
              provider.isRemote
                  ? context.appLocalizations.remote
                  : context.appLocalizations.local,
              style: context.listCaptionStyle,
            ),
            trailing: _RuleSetUpdateTime(provider: provider),
            onPressed: () {
              if (editable) {
                _handleToEditor(provider);
              } else {
                _handlePreview(provider);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessItem(ClashProvider provider) {
    final type = provider.isRemote
        ? 'http'
        : provider.isTextContent
        ? 'inline'
        : 'file';
    final updating = ref.watch(loadingProvider(LoadingTag.ruleProviders));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        provider.label,
                        style: BusinessText.cardTitle(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ProviderTypeChip(type: type),
                  ],
                ),
                _RuleSetUpdateTime(provider: provider),
              ],
            ),
          ),
          const SizedBox(width: 10),
          BusinessSecondaryButton(
            label: context.appLocalizations.update,
            width: 64,
            height: 30,
            onPressed: updating || !provider.isRemote
                ? null
                : () => _put(provider, previous: provider, refresh: true),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<ClashProvider> providers, {required bool loading}) {
    final appLocalizations = context.appLocalizations;
    return NullStatusSwitcher(
      isLoading: loading,
      isEmpty: providers.isEmpty,
      nullStatus: NullStatus(
        illustration: NullStatusIllustration.rules,
        label: appLocalizations.nullTip(appLocalizations.ruleProviders),
      ),
      child: PrismReorderableListView(
        padding: const EdgeInsets.all(16).copyWith(
          top: context.contentTopPadding,
          bottom: 16 + context.bottomInset,
        ),
        itemCount: providers.length,
        itemBuilder: (_, index) => _buildItem(providers, index),
        proxyDecorator: (_, index, animation) {
          return commonProxyDecorator(
            _buildItem(providers, index),
            index,
            animation,
          );
        },
        onReorderItem: ref.read(clashProvidersProvider.notifier).order,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final state = ref.watch(clashProvidersProvider);
    final providers = state.value ?? [];
    if (BusinessTheme.of(context) && system.isDesktop) {
      final proxyProviders = ref
          .watch(providersProvider)
          .where((provider) => provider.type == 'Proxy')
          .toList(growable: false);
      return Scaffold(
        title: appLocalizations.businessProvidersTitle,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final proxyCard = proxyProviders.isEmpty
                ? null
                : BusinessSettingsCard(
                    title:
                        '${appLocalizations.businessProxyProviders} · ${proxyProviders.length}',
                    items: [
                      for (
                        var index = 0;
                        index < proxyProviders.length;
                        index++
                      )
                        _BusinessProxyProviderItem(
                          provider: proxyProviders[index],
                        ),
                    ],
                  );
            final ruleCard = providers.isEmpty
                ? null
                : BusinessSettingsCard(
                    title:
                        '${appLocalizations.businessRuleProviders} · ${providers.length}',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PopupAnchor(
                          targetBuilder: (open) => BusinessSecondaryButton(
                            label: '＋ ${appLocalizations.add}',
                            width: 78,
                            onPressed: open,
                          ),
                          popupBuilder: (_) => PopupMenu(
                            items: [
                              PopupMenuItem(
                                glyph: AppGlyphs.compose,
                                label: appLocalizations.startFromScratch,
                                onPressed: _handleToEditor,
                              ),
                              PopupMenuItem(
                                glyph: AppGlyphs.cloudDownload,
                                label: appLocalizations.importUrl,
                                onPressed: _handleImportFromUrl,
                              ),
                              PopupMenuItem(
                                glyph: AppGlyphs.importFile,
                                label: appLocalizations.importFile,
                                onPressed: _handleImportFromFile,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    items: [
                      for (final provider in providers) ...[
                        _buildBusinessItem(provider),
                        if (provider != providers.last)
                          const SizedBox(height: 16),
                      ],
                    ],
                  );
            final cards = [?proxyCard, ?ruleCard];
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                top: context.sectionsTopPadding + 14,
                right: 20,
                bottom: 20 + context.bottomInset,
              ),
              child: constraints.maxWidth >= 900 && cards.length > 1
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        for (final card in cards) Expanded(child: card),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: cards,
                    ),
            );
          },
        ),
      );
    }
    return Scaffold(
      canSort: providers.length > 1,
      isLoading: ref.watch(loadingProvider(LoadingTag.ruleProviders)),
      actions: [
        PopupAnchor(
          targetBuilder: (open) {
            return IconButton(
              tooltip: appLocalizations.add,
              onPressed: open,
              icon: const GlyphIcon(AppGlyphs.addCircle),
            );
          },
          popupBuilder: (_) => PopupMenu(
            items: [
              PopupMenuItem(
                glyph: AppGlyphs.compose,
                label: appLocalizations.startFromScratch,
                onPressed: _handleToEditor,
              ),
              PopupMenuItem(
                glyph: AppGlyphs.cloudDownload,
                label: appLocalizations.importUrl,
                onPressed: _handleImportFromUrl,
              ),
              PopupMenuItem(
                glyph: AppGlyphs.importFile,
                label: appLocalizations.importFile,
                onPressed: _handleImportFromFile,
              ),
            ],
          ),
        ),
      ],
      body: _buildContent(providers, loading: state.isLoading),
      title: appLocalizations.ruleProviders,
    );
  }
}

class _ProviderTypeChip extends StatelessWidget {
  const _ProviderTypeChip({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: context.colorScheme.surfaceContainerHighest,
      shape: AppShape.all(AppRadius.sm.topLeft.x),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: Text(type, style: BusinessText.proxyProtocol(context)),
    ),
  );
}

class _BusinessProxyProviderItem extends ConsumerWidget {
  const _BusinessProxyProviderItem({required this.provider});

  final ExternalProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.appLocalizations;
    final updating = ref.watch(isUpdatingProvider(provider.updatingKey));
    final action = ref.read(proxiesActionProvider.notifier);
    final type = provider.vehicleType.toLowerCase() == 'http'
        ? 'http'
        : provider.path == null
        ? 'inline'
        : 'file';
    final metadataStyle = AppTextStyle.caption1
        .of(context)
        .copyWith(color: context.colorScheme.onSurfaceVariant);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        provider.name,
                        style: BusinessText.cardTitle(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ProviderTypeChip(type: type),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(l.providerCount(provider.count), style: metadataStyle),
                    if (provider.updateAt.millisecondsSinceEpoch > 0) ...[
                      Text(' · ', style: metadataStyle),
                      LastUpdateTimeText(
                        lastUpdateDate: provider.updateAt,
                        style: metadataStyle,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (updating)
            const ActivityIndicator()
          else
            BusinessSecondaryButton(
              label: l.update,
              width: 64,
              height: 30,
              onPressed: provider.vehicleType == 'HTTP'
                  ? () async {
                      await globalState.safeRun(
                        () =>
                            action.updateProvider(provider, showLoading: true),
                        silence: false,
                      );
                      action.updateGroupsDebounce();
                    }
                  : null,
            ),
        ],
      ),
    );
  }
}

/// The update time is the cached file's, so it is read again whenever a save or
/// sync on this page finishes.
class _RuleSetUpdateTime extends ConsumerStatefulWidget {
  final ClashProvider provider;

  const _RuleSetUpdateTime({required this.provider});

  @override
  ConsumerState<_RuleSetUpdateTime> createState() => _RuleSetUpdateTimeState();
}

class _RuleSetUpdateTimeState extends ConsumerState<_RuleSetUpdateTime> {
  late Future<FileInfo?> _fileInfo = widget.provider.fileInfo;

  @override
  void didUpdateWidget(covariant _RuleSetUpdateTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider != widget.provider) {
      _fileInfo = widget.provider.fileInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loadingProvider(LoadingTag.ruleProviders), (previous, next) {
      if (previous == true && !next) {
        setState(() {
          _fileInfo = widget.provider.fileInfo;
        });
      }
    });
    // Inset here, not in the row, so the sort handle that replaces it sits flush.
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 16),
      child: FutureBuilder<FileInfo?>(
        future: _fileInfo,
        builder: (context, snapshot) => LastUpdateTimeText(
          lastUpdateDate: snapshot.data?.lastModified,
          compact: true,
          style: context.listCaptionStyle,
        ),
      ),
    );
  }
}

Future<void> _showClashProviderOptions(
  BuildContext context,
  WidgetRef ref,
  ClashProvider provider,
) async {
  final res = await showFormSheet<ClashProvider>(
    context: context,
    builder: (_) => _ProviderForm(
      provider: provider,
      reservedLabels: {
        for (final item
            in ref.read(clashProvidersProvider).value ??
                const <ClashProvider>[])
          if (item.id != provider.id) item.label,
      },
    ),
  );
  if (res == null) {
    return;
  }
  await globalState.loadingRun(
    () => ref
        .read(clashProvidersActionProvider.notifier)
        .putProvider(res, previous: provider),
    title: res.label,
    tag: LoadingTag.ruleProviders,
  );
}

String? _validateProviderUrl(String? value) {
  final appLocalizations = currentAppLocalizations;
  final url = value?.trim() ?? '';
  if (url.isEmpty) {
    return appLocalizations.emptyTip(appLocalizations.url);
  }
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.isScheme('http') && !uri.isScheme('https')) {
    return appLocalizations.providerUrlTip;
  }
  return null;
}

enum _ProviderField { label, url }

class _ProviderForm extends StatefulWidget {
  const _ProviderForm({required this.provider, required this.reservedLabels});

  final ClashProvider provider;
  final Set<String> reservedLabels;

  @override
  State<_ProviderForm> createState() => _ProviderFormState();
}

class _ProviderFormState extends State<_ProviderForm> {
  late final TextEditingController _labelController;
  late final TextEditingController _urlController;
  bool _attempted = false;

  ClashProvider get _provider => widget.provider;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: _provider.label);
    _urlController = TextEditingController(text: _provider.url);
  }

  @override
  void dispose() {
    _labelController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  ({_ProviderField field, String message})? _issue() {
    final appLocalizations = context.appLocalizations;
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      return (
        field: _ProviderField.label,
        message: appLocalizations.emptyTip(appLocalizations.name),
      );
    }
    if (widget.reservedLabels.contains(label)) {
      return (
        field: _ProviderField.label,
        message: appLocalizations.existsTip(appLocalizations.name),
      );
    }
    if (_provider.isRemote) {
      if (_validateProviderUrl(_urlController.text) case final message?) {
        return (field: _ProviderField.url, message: message);
      }
    }
    return null;
  }

  void _handleChanged(String _) {
    if (_attempted) {
      setState(() {});
    }
  }

  void _handleSubmit() {
    if (_issue() != null) {
      setState(() {
        _attempted = true;
      });
      return;
    }
    Navigator.of(context).pop(
      _provider.copyWith(
        label: _labelController.text.trim(),
        url: _urlController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final issue = _attempted ? _issue() : null;
    return FormPage(
      title: appLocalizations.options,
      onSave: _handleSubmit,
      error: issue?.message,
      children: [
        generateSection(
          items: [
            FormRow(
              title: appLocalizations.name,
              invalid: issue?.field == _ProviderField.label,
              trailing: FormRowTextField(
                controller: _labelController,
                hintText: appLocalizations.required,
                textInputAction: _provider.isRemote
                    ? TextInputAction.next
                    : TextInputAction.done,
                inputFormatters: TextInputLimits.limit(TextInputLimits.name),
                onChanged: _handleChanged,
                onFieldSubmitted: _provider.isRemote
                    ? null
                    : (_) => _handleSubmit(),
              ),
            ),
            if (_provider.isRemote)
              FormRow(
                title: appLocalizations.url,
                invalid: issue?.field == _ProviderField.url,
                trailing: FormRowTextField(
                  controller: _urlController,
                  hintText: appLocalizations.required,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  onChanged: _handleChanged,
                  onFieldSubmitted: (_) => _handleSubmit(),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
