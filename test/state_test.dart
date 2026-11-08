import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/hct/hct.dart';
import 'package:prism_ui/prism_ui.dart';

void main() {
  test(
    'DynamicColor falls back to the default primary color before seeding',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(
        container.read(dynamicColorProvider).accentColor,
        const Color(defaultPrimaryColor),
      );
    },
  );

  test('genColorScheme seeds each brightness from its own dynamic seed', () {
    const lightSeed = Color(0xFF00FF00);
    const darkSeed = Color(0xFF0000FF);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(dynamicColorProvider.notifier)
        .seed(
          lightSeed: lightSeed,
          darkSeed: darkSeed,
          accentColor: const Color(defaultPrimaryColor),
        );

    final style = container.read(themeSettingProvider).colorStyle;

    expect(
      container.read(genColorSchemeProvider(Brightness.light)),
      seededColorScheme(
        seedColor: lightSeed,
        brightness: Brightness.light,
        style: style,
      ),
    );
    expect(
      container.read(genColorSchemeProvider(Brightness.dark)),
      seededColorScheme(
        seedColor: darkSeed,
        brightness: Brightness.dark,
        style: style,
      ),
    );
  });

  test('default Tianji schemes use the v4 light and dark surfaces', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final light = container.read(genColorSchemeProvider(Brightness.light));
    expect(light.primary, const Color(0xFF0A55F5));
    expect(light.surface, const Color(0xFFFFFFFF));
    expect(light.surfaceContainerLow, const Color(0xFFF8F9FB));
    expect(light.surfaceContainer, const Color(0xFFF1F3F6));
    expect(light.outlineVariant, const Color(0xFFDCE1E7));

    final dark = container.read(genColorSchemeProvider(Brightness.dark));
    expect(dark.primary, const Color(0xFF3D73FF));
    expect(dark.surface, const Color(0xFF0B0F14));
    expect(dark.surfaceContainerLow, const Color(0xFF0F141B));
    expect(dark.surfaceContainer, const Color(0xFF131A22));
  });

  test('custom colors and styles remain seeded, including pure black', () {
    const customSeed = Color(0xFF9C27B0);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(themeSettingProvider.notifier)
        .update(
          (state) => state.copyWith(
            primaryColor: customSeed.toARGB32(),
            colorStyle: ColorStyle.soft,
          ),
        );

    final custom = container.read(genColorSchemeProvider(Brightness.light));
    expect(
      custom,
      seededColorScheme(
        seedColor: customSeed,
        brightness: Brightness.light,
        style: ColorStyle.soft,
      ),
    );

    container
        .read(themeSettingProvider.notifier)
        .update((state) => state.copyWith(pureBlack: true));
    final pureBlack = container.read(genColorSchemeProvider(Brightness.dark));
    expect(
      pureBlack,
      seededColorScheme(
        seedColor: customSeed,
        brightness: Brightness.dark,
        style: ColorStyle.soft,
      ).toPureBlack(true),
    );
  });

  test('pure black darkens only the dark scheme and keeps surface order', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final light = container.read(genColorSchemeProvider(Brightness.light));
    container
        .read(themeSettingProvider.notifier)
        .update((state) => state.copyWith(pureBlack: true));

    expect(container.read(genColorSchemeProvider(Brightness.light)), light);

    final dark = container.read(genColorSchemeProvider(Brightness.dark));
    final tones = [
      dark.surfaceContainerLowest,
      dark.surface,
      dark.surfaceDim,
      dark.surfaceContainerLow,
      dark.surfaceContainer,
      dark.surfaceContainerHigh,
      dark.surfaceContainerHighest,
    ].map((color) => Hct.fromInt(color.toARGB32()).tone).toList();

    expect(dark.surface, Colors.black);
    expect(tones, orderedEquals([...tones]..sort()));
    expect(tones[3], greaterThan(tones[1]));
  });

  test('genColorScheme falls back to the accent color without a seed', () {
    const accent = Color(0xFFFF0000);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(dynamicColorProvider.notifier)
        .seed(lightSeed: null, darkSeed: null, accentColor: accent);

    expect(
      container.read(genColorSchemeProvider(Brightness.light)),
      seededColorScheme(
        seedColor: accent,
        brightness: Brightness.light,
        style: container.read(themeSettingProvider).colorStyle,
      ),
    );
  });
}
