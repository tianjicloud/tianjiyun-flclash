part of '../state.dart';

typedef DynamicColorSeeds = ({
  Color? lightSeed,
  Color? darkSeed,
  Color accentColor,
});

extension DynamicColorSeedsExt on DynamicColorSeeds {
  Color seedOf(Brightness brightness) =>
      switch (brightness) {
        Brightness.light => lightSeed,
        Brightness.dark => darkSeed,
      } ??
      accentColor;
}

@Riverpod(keepAlive: true)
class DynamicColor extends _$DynamicColor {
  @override
  DynamicColorSeeds build() {
    return (
      lightSeed: null,
      darkSeed: null,
      accentColor: const Color(defaultPrimaryColor),
    );
  }

  void seed({Color? lightSeed, Color? darkSeed, required Color accentColor}) {
    state = (
      lightSeed: lightSeed,
      darkSeed: darkSeed,
      accentColor: accentColor,
    );
  }
}

@riverpod
ColorScheme genColorScheme(
  Ref ref,
  Brightness brightness, {
  Color? color,
  bool ignoreConfig = false,
  bool? pureBlack,
}) {
  final themeSetting = ref.watch(
    themeSettingProvider.select(
      (state) => (
        primaryColor: state.primaryColor,
        followSystemAccent: state.followSystemAccent,
        colorStyle: state.colorStyle,
        pureBlack: state.pureBlack,
      ),
    ),
  );
  final dynamicColor = ref.watch(dynamicColorProvider);
  final Color seedColor;
  final followsSystemAccent = defaultTargetPlatform == TargetPlatform.macOS
      ? themeSetting.followSystemAccent
      : themeSetting.primaryColor == null;
  if (color == null && (ignoreConfig == true || followsSystemAccent)) {
    seedColor = dynamicColor.seedOf(brightness);
  } else {
    seedColor =
        color ?? Color(themeSetting.primaryColor ?? defaultPrimaryColor);
  }
  return _cachedColorScheme(
    seedColor,
    brightness,
    themeSetting.colorStyle,
    pureBlack ?? themeSetting.pureBlack,
  );
}

const _maxCachedColorSchemes = 64;

final _colorSchemes = <(Color, Brightness, ColorStyle, bool), ColorScheme>{};

ColorScheme _cachedColorScheme(
  Color seedColor,
  Brightness brightness,
  ColorStyle style,
  bool pureBlack,
) {
  final key = (seedColor, brightness, style, pureBlack);
  final colorScheme =
      _colorSchemes.remove(key) ??
      _tianjiDefaultColorScheme(
        seededColorScheme(
          seedColor: seedColor,
          brightness: brightness,
          style: style,
        ),
        seedColor: seedColor,
        style: style,
        pureBlack: pureBlack,
      );
  _colorSchemes[key] = colorScheme;
  if (_colorSchemes.length > _maxCachedColorSchemes) {
    _colorSchemes.remove(_colorSchemes.keys.first);
  }
  return colorScheme;
}

ColorScheme _tianjiDefaultColorScheme(
  ColorScheme scheme, {
  required Color seedColor,
  required ColorStyle style,
  required bool pureBlack,
}) {
  final dark = scheme.brightness == Brightness.dark;
  if (seedColor.toARGB32() != defaultPrimaryColor ||
      style != ColorStyle.vivid) {
    return scheme.toPureBlack(pureBlack && dark);
  }
  if (pureBlack && dark) return scheme.toPureBlack(true);
  final primary = dark ? const Color(0xFF3D73FF) : BusinessPalette.blue;
  return scheme.copyWith(
    primary: primary,
    onPrimary: const Color(0xFFFFFFFF),
    primaryContainer: dark ? const Color(0xFF1D376E) : const Color(0xFFE6EEFE),
    onPrimaryContainer: dark
        ? const Color(0xFFD5E2FF)
        : const Color(0xFF0842C2),
    surfaceTint: primary,
    onSurface: dark ? const Color(0xFFEDF0F7) : BusinessPalette.deep,
    onSurfaceVariant: dark
        ? const Color(0xFFADB6C2)
        : BusinessPalette.secondary,
    surface: dark ? const Color(0xFF0B0F14) : const Color(0xFFFFFFFF),
    surfaceBright: dark ? const Color(0xFF2A3442) : const Color(0xFFFFFFFF),
    surfaceDim: dark ? const Color(0xFF080B0F) : const Color(0xFFF1F3F6),
    surfaceContainerLowest: dark
        ? const Color(0xFF0B0F14)
        : const Color(0xFFFFFFFF),
    surfaceContainerLow: dark
        ? const Color(0xFF0F141B)
        : const Color(0xFFF8F9FB),
    surfaceContainer: dark ? const Color(0xFF131A22) : const Color(0xFFF1F3F6),
    surfaceContainerHigh: dark
        ? const Color(0xFF1A2330)
        : const Color(0xFFEEF1F4),
    surfaceContainerHighest: dark
        ? const Color(0xFF232D3A)
        : const Color(0xFFE6E9ED),
    outlineVariant: dark ? const Color(0xFF323C48) : const Color(0xFFDCE1E7),
    error: dark ? const Color(0xFFFF6B74) : const Color(0xFFB42335),
  );
}

typedef WindowBlurRequest = ({bool enabled, Brightness brightness, Color tint});

@riverpod
WindowBlurRequest windowBlurRequest(Ref ref) {
  final enabled = ref.watch(
    themeSettingProvider.select((state) => state.sidebarBlur),
  );
  final brightness = ref.watch(currentBrightnessProvider);
  final colorScheme = ref.watch(genColorSchemeProvider(brightness));
  return (
    enabled: enabled || defaultTargetPlatform == TargetPlatform.macOS,
    brightness: brightness,
    tint: colorScheme.surfaceContainer,
  );
}

@riverpod
Brightness currentBrightness(Ref ref) {
  final themeMode = ref.watch(
    themeSettingProvider.select((state) => state.themeMode),
  );
  final systemBrightness = ref.watch(systemBrightnessProvider);
  return switch (themeMode) {
    ThemeMode.system => systemBrightness,
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
  };
}
