import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/config.dart';
import 'package:fl_clash/ui/business_style.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessThemeChoices extends ConsumerWidget {
  const BusinessThemeChoices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      themeSettingProvider.select((state) => state.themeMode),
    );
    final labels = context.appLocalizations;
    const modes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < 480
            ? (constraints.maxWidth - 16) / 3
            : 144.0;
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (final mode in modes) ...[
              SizedBox(
                width: width,
                child: PressRegion(
                  onTap: () => ref
                      .read(themeSettingProvider.notifier)
                      .update((state) => state.copyWith(themeMode: mode)),
                  shape: AppShape.md,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: context.colorScheme.surface,
                      shape: RoundedSuperellipseBorder(
                        side: BorderSide(
                          color: selected == mode
                              ? BusinessPalette.blue
                              : context.colorScheme.outlineVariant,
                          width: selected == mode ? 2 : 1,
                        ),
                        borderRadius: AppRadius.md,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 80,
                            child: _BusinessThemePreview(mode: mode),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            switch (mode) {
                              ThemeMode.light => labels.light,
                              ThemeMode.dark => labels.dark,
                              ThemeMode.system => labels.businessFollowSystem,
                            },
                            style: AppTextStyle.custom(
                              context,
                              size: 13,
                              leading: 18,
                              weight: selected == mode
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (mode != ThemeMode.system) const SizedBox(width: 8),
            ],
          ],
        );
      },
    );
  }
}

class _BusinessThemePreview extends StatelessWidget {
  const _BusinessThemePreview({required this.mode});

  final ThemeMode mode;

  @override
  Widget build(BuildContext context) {
    if (mode == ThemeMode.system) {
      return const ClipRSuperellipse(
        borderRadius: AppRadius.sm,
        child: Row(
          children: [
            Expanded(child: _MiniThemeSurface(brightness: Brightness.light)),
            Expanded(child: _MiniThemeSurface(brightness: Brightness.dark)),
          ],
        ),
      );
    }
    return _MiniThemeSurface(
      brightness: mode == ThemeMode.light ? Brightness.light : Brightness.dark,
    );
  }
}

class _MiniThemeSurface extends StatelessWidget {
  const _MiniThemeSurface({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final dark = brightness == Brightness.dark;
    final background = dark
        ? BusinessPalette.themePreviewDarkBackground
        : BusinessPalette.themePreviewLightBackground;
    final sidebar = dark
        ? BusinessPalette.themePreviewDarkSidebar
        : BusinessPalette.themePreviewLightSidebar;
    final content = dark
        ? BusinessPalette.themePreviewDarkContent
        : BusinessPalette.themePreviewLightContent;
    return ColoredBox(
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 22,
              child: DecoratedBox(
                decoration: ShapeDecoration(color: sidebar, shape: AppShape.xs),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: DecoratedBox(
                decoration: ShapeDecoration(color: content, shape: AppShape.xs),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
