import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/views/dashboard/widgets/card.dart'
    show BusinessPrimaryButton, BusinessSecondaryButton;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

class InitErrorApp extends StatelessWidget {
  final Object error;
  final StackTrace stack;
  final AsyncCallback onClearData;
  final AsyncCallback onExit;

  const InitErrorApp({
    super.key,
    required this.error,
    required this.stack,
    required this.onClearData,
    required this.onExit,
  });

  ThemeData _theme(Brightness brightness) {
    return ThemeData(
      colorScheme: seededColorScheme(
        seedColor: const Color(defaultPrimaryColor),
        brightness: brightness,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PrismApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        AppUiLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.delegate.supportedLocales,
      home: InitErrorScreen(
        error: error,
        stack: stack,
        onClearData: onClearData,
        onExit: onExit,
      ),
    );
  }
}

class InitErrorScreen extends StatefulWidget {
  final Object error;
  final StackTrace stack;
  final AsyncCallback onClearData;
  final AsyncCallback onExit;

  const InitErrorScreen({
    super.key,
    required this.error,
    required this.stack,
    required this.onClearData,
    required this.onExit,
  });

  @override
  State<InitErrorScreen> createState() => _InitErrorScreenState();
}

class _InitErrorScreenState extends State<InitErrorScreen> {
  static const _maxContentWidth = 520.0;

  final _notice = ValueNotifier<({String text, bool visible})?>(null);
  Timer? _noticeTimer;
  bool _isExiting = false;
  bool _detailsExpanded = false;

  @override
  void dispose() {
    _noticeTimer?.cancel();
    _notice.dispose();
    super.dispose();
  }

  void _showNotice(String text) {
    _noticeTimer?.cancel();
    _notice.value = (text: text, visible: true);
    _noticeTimer = Timer(const Duration(seconds: 4), () {
      _notice.value = (text: text, visible: false);
    });
  }

  Future<void> _copyDetails() async {
    final text =
        '=== ERROR ===\n${widget.error}\n\n'
        '=== STACK TRACE ===\n${widget.stack}';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) {
      return;
    }
    _showNotice(context.appLocalizations.copySuccess);
  }

  Future<bool> _confirmClearData() async {
    final appLocalizations = context.appLocalizations;
    final res = await dialogs.showCommonDialog<bool>(
      context: context,
      child: Builder(
        builder: (context) {
          return AlertDialog(
            title: appLocalizations.clearData,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(appLocalizations.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(appLocalizations.confirm),
              ),
            ],
            child: Text(appLocalizations.clearDataAndExitTip),
          );
        },
      ),
    );
    return res == true;
  }

  Future<void> _clearData() async {
    if (!await _confirmClearData() || !mounted) {
      return;
    }
    final appLocalizations = context.appLocalizations;
    setState(() {
      _isExiting = true;
    });
    try {
      await widget.onClearData();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isExiting = false;
      });
      _showNotice(appLocalizations.clearDataFailed('$error'));
      return;
    }
    await widget.onExit();
  }

  Future<void> _exit() async {
    setState(() {
      _isExiting = true;
    });
    await widget.onExit();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final errorText = widget.error.toString();
    final portConflict =
        errorText.contains('7890') &&
        RegExp(
          r'(address already in use|address.*in use|bind.*(failed|error)|cannot assign requested address)',
          caseSensitive: false,
        ).hasMatch(errorText);
    return Surface(
      color: context.colorScheme.brightness == Brightness.dark
          ? BusinessPalette.themePreviewDarkBackground
          : BusinessPalette.page,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight > 64
                                ? constraints.maxHeight - 64
                                : 0,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: _maxContentWidth,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: DecoratedBox(
                                      decoration: ShapeDecoration(
                                        color:
                                            BusinessPalette.errorBackgroundFor(
                                              context.colorScheme.brightness,
                                            ),
                                        shape: AppShape.full,
                                      ),
                                      child: SizedBox.square(
                                        dimension: 48,
                                        child: Center(
                                          child: GlyphIcon(
                                            AppGlyphs.warning,
                                            size: 24,
                                            color:
                                                BusinessPalette.errorForegroundFor(
                                                  context
                                                      .colorScheme
                                                      .brightness,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    appLocalizations.businessKernelStartFailed,
                                    style: BusinessText.errorTitle(context),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    portConflict
                                        ? appLocalizations
                                              .businessPortConflictTip
                                        : appLocalizations.initFailedTip,
                                    style: BusinessText.errorBody(context)
                                        .copyWith(
                                          color: BusinessPalette.secondaryFor(
                                            context.colorScheme.brightness,
                                          ),
                                        ),
                                  ),
                                  if (portConflict) ...[
                                    const SizedBox(height: 20),
                                    _PortSolutionsCard(
                                      title: appLocalizations
                                          .businessErrorSolutions,
                                      steps: [
                                        appLocalizations
                                            .businessErrorStepClosePort,
                                        appLocalizations
                                            .businessErrorStepChangePort,
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  _ErrorCodeRow(
                                    text: _detailsExpanded
                                        ? errorText
                                        : errorText.split('\n').first,
                                    expanded: _detailsExpanded,
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: TextButton(
                                      onPressed: () => setState(
                                        () => _detailsExpanded =
                                            !_detailsExpanded,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 6,
                                        children: [
                                          Text(appLocalizations.errorDetails),
                                          GlyphIcon(
                                            _detailsExpanded
                                                ? AppGlyphs.chevronUp
                                                : AppGlyphs.chevronDown,
                                            key: const ValueKey(
                                              'error-details-chevron',
                                            ),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_detailsExpanded) ...[
                                    Text(
                                      appLocalizations.stackTrace,
                                      style: BusinessText.metaLabel(context)
                                          .copyWith(
                                            color: BusinessPalette.secondaryFor(
                                              context.colorScheme.brightness,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    SelectableText(
                                      widget.stack.toString(),
                                      style: BusinessText.errorCode(context)
                                          .copyWith(
                                            color: BusinessPalette.secondaryFor(
                                              context.colorScheme.brightness,
                                            ),
                                          ),
                                    ),
                                    const SizedBox(height: 20),
                                  ] else
                                    const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      BusinessPrimaryButton(
                                        label: appLocalizations
                                            .businessCopyErrorInfo,
                                        glyph: AppGlyphs.copy,
                                        width: 176,
                                        height: 40,
                                        onPressed: _copyDetails,
                                      ),
                                      BusinessSecondaryButton(
                                        label: appLocalizations.clearData,
                                        width: 120,
                                        height: 40,
                                        labelColor:
                                            BusinessPalette.errorForegroundFor(
                                              context.colorScheme.brightness,
                                            ),
                                        onPressed: _isExiting
                                            ? null
                                            : _clearData,
                                      ),
                                      BusinessSecondaryButton(
                                        label: appLocalizations.exit,
                                        width: 88,
                                        height: 40,
                                        onPressed: _isExiting ? null : _exit,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: _Notice(notice: _notice),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.notice});

  final ValueListenable<({String text, bool visible})?> notice;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return ValueListenableBuilder(
      valueListenable: notice,
      builder: (context, value, _) {
        if (value == null) {
          return const SizedBox.shrink();
        }
        return IgnorePointer(
          child: AnimatedOpacity(
            opacity: value.visible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Semantics(
              liveRegion: value.visible,
              child: Center(
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: colorScheme.inverseSurface,
                    shape: AppShape.lg,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      value.text,
                      style: AppTextStyle.subheadline
                          .of(context)
                          .copyWith(color: colorScheme.onInverseSurface),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PortSolutionsCard extends StatelessWidget {
  const _PortSolutionsCard({required this.title, required this.steps});

  final String title;
  final List<String> steps;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: BusinessPalette.customEditorCardFor(
        context.colorScheme.brightness,
      ),
      shape: AppShape.all(BusinessRadius.account),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(
            title,
            style: BusinessText.metaLabel(context).copyWith(
              color: BusinessPalette.secondaryFor(
                context.colorScheme.brightness,
              ),
            ),
          ),
          for (var index = 0; index < steps.length; index++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: context.colorScheme.brightness == Brightness.dark
                        ? BusinessPalette.themePreviewDarkBackground
                        : BusinessPalette.themePreviewLightBackground,
                    shape: AppShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: 22,
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: BusinessText.errorStep(context),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    steps[index],
                    style: BusinessText.errorStep(context),
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

class _ErrorCodeRow extends StatelessWidget {
  const _ErrorCodeRow({required this.text, required this.expanded});

  final String text;
  final bool expanded;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: BusinessPalette.errorCodeBackgroundFor(
        context.colorScheme.brightness,
      ),
      shape: AppShape.all(BusinessRadius.account),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SelectableText(
        text,
        maxLines: expanded ? null : 1,
        style: BusinessText.errorCode(context).copyWith(
          color: BusinessPalette.secondaryFor(context.colorScheme.brightness),
        ),
      ),
    ),
  );
}
