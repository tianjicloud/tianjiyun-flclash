import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/residential.dart';
import 'package:fl_clash/models/profile.dart';
import 'package:fl_clash/pages/editor.dart';
import 'package:fl_clash/providers/action.dart';
import 'package:fl_clash/views/dashboard/business_theme.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewProfileView extends ConsumerWidget {
  final Profile profile;
  final String? initialContent;

  const PreviewProfileView({
    super.key,
    required this.profile,
    this.initialContent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (system.isDesktop &&
        BusinessTheme.of(context) &&
        isTianjiSubscriptionProfile(profile)) {
      return _BusinessPreviewProfileView(
        profile: profile,
        initialContent: initialContent,
      );
    }
    return EditorPage(
      title: profile.realLabel,
      readOnly: true,
      load: () async => CodeForgeDocument.fromText(
        await ref
            .read(setupActionProvider.notifier)
            .getProfileWithId(profile.id),
      ),
    );
  }
}

const _previewCodeRadius = 14.0;

class _BusinessPreviewProfileView extends ConsumerStatefulWidget {
  const _BusinessPreviewProfileView({
    required this.profile,
    this.initialContent,
  });

  final Profile profile;
  final String? initialContent;

  @override
  ConsumerState<_BusinessPreviewProfileView> createState() =>
      _BusinessPreviewProfileViewState();
}

class _BusinessPreviewProfileViewState
    extends ConsumerState<_BusinessPreviewProfileView> {
  String? _source;
  Object? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialContent case final content?) {
      _source = content;
      return;
    }
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final text = await ref
          .read(setupActionProvider.notifier)
          .getProfileWithId(widget.profile.id);
      if (!mounted) {
        return;
      }
      setState(() => _source = text);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCode(BuildContext context) {
    final lines = (_source ?? '').split('\n');
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          sliver: SliverPrismList(
            itemCount: lines.length,
            itemExtent: 20,
            itemBuilder: (context, index) => SizedBox(
              height: 20,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 58,
                      child: Text(
                        '${index + 1}',
                        textAlign: TextAlign.end,
                        style: BusinessText.customRuleContent(
                          context,
                        ).copyWith(color: context.colorScheme.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Text(
                      lines[index],
                      softWrap: false,
                      style: BusinessText.customRuleContent(context),
                    ),
                  ],
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
    final l = context.appLocalizations;
    return Scaffold(
      title: l.profilePreviewTitle,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 56),
            Text(
              '${l.previewReadOnly} · ${widget.profile.realLabel}',
              style: BusinessText.metaLabel(
                context,
              ).copyWith(color: BusinessPalette.secondary),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: AppShape.all(_previewCodeRadius),
                ),
                child: ColoredBox(
                  color: context.colorScheme.brightness == Brightness.dark
                      ? BusinessPalette.customEditorCardFor(Brightness.dark)
                      : BusinessPalette.sidebarLight,
                  child: _error != null
                      ? Center(child: Text(_error.toString()))
                      : _source == null
                      ? const SizedBox.expand()
                      : _buildCode(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
