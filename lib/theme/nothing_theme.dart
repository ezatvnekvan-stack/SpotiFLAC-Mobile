import 'package:flutter/material.dart';
import 'package:spotiflac_android/theme/app_theme.dart';
import 'package:spotiflac_android/theme/app_tokens.dart';

/// The monochrome system used by this edition, including nested routes/modals.
@immutable
class NothingTheme extends ThemeExtension<NothingTheme> {
  const NothingTheme();

  static const red = Color(0xFFD71920);
  static const dotFont = 'Nothing Dot';

  static final tokens = AppTokens.standard.copyWith(
    radiusBadge: 4,
    radiusThumb: 8,
    radiusCover: 16,
    radiusControl: 24,
    radiusCard: 24,
    radiusSheet: 28,
    headerExpandedHeight: 132,
    headerExpandedTitleSize: 32,
    headerCollapsedTitleSize: 22,
    motionFast: const Duration(milliseconds: 120),
    motionMedium: const Duration(milliseconds: 200),
    motionSlow: const Duration(milliseconds: 300),
  );

  static ColorScheme scheme(Brightness brightness, {bool amoled = true}) {
    final dark = brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF1F0ED) : const Color(0xFF181818);
    final paper = dark
        ? (amoled ? Colors.black : const Color(0xFF101010))
        : const Color(0xFFF4F3EF);
    return ColorScheme.fromSeed(seedColor: red, brightness: brightness).copyWith(
      primary: dark ? const Color(0xFFFF554E) : red,
      onPrimary: dark ? const Color(0xFF210000) : Colors.white,
      primaryContainer: ink,
      onPrimaryContainer: paper,
      primaryFixed: const Color(0xFFF1F0ED),
      primaryFixedDim: const Color(0xFFD7D6D2),
      onPrimaryFixed: const Color(0xFF181818),
      onPrimaryFixedVariant: const Color(0xFF414141),
      secondary: ink,
      onSecondary: paper,
      secondaryContainer: dark ? const Color(0xFF303030) : const Color(0xFFE3E2DE),
      onSecondaryContainer: ink,
      secondaryFixed: const Color(0xFFE3E2DE),
      secondaryFixedDim: const Color(0xFFC6C5C1),
      onSecondaryFixed: const Color(0xFF181818),
      onSecondaryFixedVariant: const Color(0xFF414141),
      tertiary: ink,
      onTertiary: paper,
      tertiaryContainer: dark ? const Color(0xFF252525) : const Color(0xFFEAE9E5),
      onTertiaryContainer: ink,
      tertiaryFixed: const Color(0xFFEAE9E5),
      tertiaryFixedDim: const Color(0xFFC6C5C1),
      onTertiaryFixed: const Color(0xFF181818),
      onTertiaryFixedVariant: const Color(0xFF414141),
      surface: paper,
      onSurface: ink,
      surfaceDim: dark ? Colors.black : const Color(0xFFE0DFDB),
      surfaceBright: dark ? const Color(0xFF303030) : const Color(0xFFFAF9F6),
      surfaceContainerLowest: dark ? Colors.black : const Color(0xFFFAF9F6),
      surfaceContainerLow: dark ? const Color(0xFF141414) : const Color(0xFFEEEDE9),
      surfaceContainer: dark ? const Color(0xFF1B1B1B) : const Color(0xFFEAE9E5),
      surfaceContainerHigh: dark ? const Color(0xFF242424) : const Color(0xFFE3E2DE),
      surfaceContainerHighest: dark ? const Color(0xFF303030) : const Color(0xFFDAD9D5),
      onSurfaceVariant: dark ? const Color(0xFFA6A6A2) : const Color(0xFF60605D),
      outline: dark ? const Color(0xFF72726E) : const Color(0xFF858580),
      outlineVariant: dark ? const Color(0xFF333330) : const Color(0xFFCECDC8),
      inverseSurface: ink,
      onInverseSurface: paper,
      inversePrimary: dark ? red : const Color(0xFFFF554E),
      surfaceTint: Colors.transparent,
      error: dark ? const Color(0xFFFF7770) : const Color(0xFFB31319),
      onError: dark ? const Color(0xFF290000) : Colors.white,
      errorContainer: dark ? const Color(0xFF3A1515) : const Color(0xFFFFDAD6),
      onErrorContainer: dark ? const Color(0xFFFFDAD6) : const Color(0xFF410002),
    );
  }

  static ThemeData build(
    Brightness brightness, {
    bool amoled = true,
    bool useSystemFont = false,
    String? fontFamily,
  }) {
    final c = scheme(brightness, amoled: amoled);
    final bodyFont = fontFamily ?? (useSystemFont ? null : 'Inter');
    final base = brightness == Brightness.dark
        ? AppTheme.dark(dynamicScheme: c, isAmoled: amoled, useSystemFont: useSystemFont, fontFamily: bodyFont)
        : AppTheme.light(dynamicScheme: c, useSystemFont: useSystemFont, fontFamily: bodyFont);
    final text = base.textTheme;
    TextStyle heading(TextStyle? style, double size) => (style ?? const TextStyle()).copyWith(
      fontFamily: dotFont,
      fontFamilyFallback: const ['Inter', 'sans-serif'],
      fontSize: size,
      fontWeight: FontWeight.w400,
      letterSpacing: 1,
      height: 1.2,
      color: c.onSurface,
    );
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: BorderSide(color: c.outlineVariant),
    );
    return base.copyWith(
      scaffoldBackgroundColor: c.surface,
      splashFactory: InkRipple.splashFactory,
      extensions: <ThemeExtension<dynamic>>[tokens, const NothingTheme()],
      textTheme: text.copyWith(
        displayLarge: heading(text.displayLarge, 56),
        displayMedium: heading(text.displayMedium, 44),
        displaySmall: heading(text.displaySmall, 36),
        headlineLarge: heading(text.headlineLarge, 32),
        headlineMedium: heading(text.headlineMedium, 28),
        headlineSmall: heading(text.headlineSmall, 24),
        titleLarge: heading(text.titleLarge, 22),
        labelLarge: text.labelLarge?.copyWith(letterSpacing: 0.7, fontWeight: FontWeight.w600),
        labelSmall: text.labelSmall?.copyWith(letterSpacing: 1.2),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: c.surface,
        titleTextStyle: heading(text.titleLarge, 22),
      ),
      cardTheme: CardThemeData(elevation: 0, color: c.surfaceContainerLow, surfaceTintColor: Colors.transparent, shape: border),
      dialogTheme: base.dialogTheme.copyWith(elevation: 0, backgroundColor: c.surfaceContainerLow, shape: border),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        elevation: 0,
        backgroundColor: c.surfaceContainerLow,
        modalBackgroundColor: c.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        dragHandleColor: c.outline,
        dragHandleSize: const Size(36, 4),
        shape: RoundedRectangleBorder(borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), side: BorderSide(color: c.outlineVariant)),
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        height: 76,
        backgroundColor: c.surface,
        indicatorColor: c.onSurface,
        indicatorShape: const CircleBorder(),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? c.surface : c.onSurfaceVariant,
          size: 22,
        )),
        labelTextStyle: WidgetStatePropertyAll(TextStyle(fontFamily: bodyFont, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.7, color: c.onSurface)),
      ),
      navigationRailTheme: NavigationRailThemeData(backgroundColor: c.surface, indicatorColor: c.onSurface, selectedIconTheme: IconThemeData(color: c.surface), unselectedIconTheme: IconThemeData(color: c.onSurfaceVariant)),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(elevation: 0, backgroundColor: c.primary, foregroundColor: c.onPrimary, shape: const CircleBorder()),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: c.onSurface, foregroundColor: c.surface, minimumSize: const Size(48, 48), shape: const StadiumBorder())),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(minimumSize: const Size(48, 48), shape: const StadiumBorder())),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: c.onSurface, side: BorderSide(color: c.outlineVariant), minimumSize: const Size(48, 48), shape: const StadiumBorder())),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(minimumSize: const Size(48, 48), shape: const CircleBorder())),
      listTileTheme: base.listTileTheme.copyWith(iconColor: c.onSurface, selectedColor: c.primary, minVerticalPadding: 16, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: c.surfaceContainerLow,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: c.outlineVariant)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: c.outlineVariant)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: c.onSurface, width: 2)),
      ),
      sliderTheme: base.sliderTheme.copyWith(activeTrackColor: c.onSurface, inactiveTrackColor: c.surfaceContainerHighest, thumbColor: c.primary, overlayColor: c.primary.withValues(alpha: 0.12), trackHeight: 3),
      switchTheme: base.switchTheme.copyWith(thumbIcon: const WidgetStatePropertyAll(null)),
      checkboxTheme: CheckboxThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      chipTheme: base.chipTheme.copyWith(shape: const StadiumBorder(), side: BorderSide(color: c.outlineVariant), backgroundColor: c.surfaceContainerLow, selectedColor: c.onSurface, secondaryLabelStyle: TextStyle(color: c.surface)),
      popupMenuTheme: base.popupMenuTheme.copyWith(elevation: 0, shape: border, color: c.surfaceContainerLow),
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: c.inverseSurface, borderRadius: BorderRadius.circular(12)), textStyle: TextStyle(fontFamily: bodyFont, color: c.onInverseSurface, fontSize: 12)),
      badgeTheme: BadgeThemeData(backgroundColor: c.primary, textColor: c.onPrimary),
      progressIndicatorTheme: base.progressIndicatorTheme.copyWith(color: c.primary, linearMinHeight: 2),
      textSelectionTheme: TextSelectionThemeData(cursorColor: c.primary, selectionColor: c.primary.withValues(alpha: 0.2), selectionHandleColor: c.primary),
    );
  }

  @override
  NothingTheme copyWith() => this;

  @override
  NothingTheme lerp(covariant NothingTheme? other, double t) => this;
}

extension NothingThemeContext on BuildContext {
  bool get isNothing => Theme.of(this).extension<NothingTheme>() != null;
}
