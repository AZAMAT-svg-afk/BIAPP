import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTheme {
  static ThemeData light() {
    const palette = AppPalette(
      emerald: Color(0xFF0C8F6C),
      gold: Color(0xFFD7A642),
      card: Color(0xFFFFFFFF),
      softCard: Color(0xFFF1F7F3),
      glass: Color(0xCCFFFFFF),
      background: Color(0xFFF7FAF8),
      backgroundAlt: Color(0xFFEAF5EF),
      textMuted: Color(0xFF60736B),
      shadow: Color(0x1A0F3D34),
      success: Color(0xFF20A36B),
      warning: Color(0xFFD9982F),
      danger: Color(0xFFE45656),
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: palette.emerald,
      brightness: Brightness.light,
      primary: palette.emerald,
      secondary: palette.gold,
      surface: palette.background,
      surfaceContainer: palette.softCard,
      surfaceContainerHighest: const Color(0xFFE1EDE7),
      outlineVariant: const Color(0xFFD8E4DE),
    );

    return _base(scheme, palette).copyWith(
      scaffoldBackgroundColor: palette.background,
      brightness: Brightness.light,
    );
  }

  static ThemeData dark() {
    const palette = AppPalette(
      emerald: Color(0xFF35D99F),
      gold: Color(0xFFE7BD62),
      card: Color(0xFF101B23),
      softCard: Color(0xFF172833),
      glass: Color(0xCC101B23),
      background: Color(0xFF071017),
      backgroundAlt: Color(0xFF0C1B22),
      textMuted: Color(0xFFA8B8B1),
      shadow: Color(0x66000000),
      success: Color(0xFF45D58E),
      warning: Color(0xFFE3B454),
      danger: Color(0xFFFF7373),
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: palette.emerald,
      brightness: Brightness.dark,
      primary: palette.emerald,
      secondary: palette.gold,
      surface: palette.background,
      surfaceContainer: palette.softCard,
      surfaceContainerHighest: const Color(0xFF233640),
      outlineVariant: const Color(0xFF28404B),
    );

    return _base(scheme, palette).copyWith(
      scaffoldBackgroundColor: palette.background,
      brightness: Brightness.dark,
    );
  }

  static ThemeData _base(ColorScheme scheme, AppPalette palette) {
    final baseTextTheme = scheme.brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;
    final textTheme = baseTextTheme.apply(
      fontFamily: 'Roboto',
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: [palette],
      textTheme: textTheme.copyWith(
        displaySmall: textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.04,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.08,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.12,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.14,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.18,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(height: 1.36),
        bodySmall: textTheme.bodySmall?.copyWith(
          height: 1.34,
          color: palette.textMuted,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
        labelMedium: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: palette.card,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        elevation: 0,
        backgroundColor: Colors.transparent,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: selected ? 25 : 23,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer.withValues(alpha: 0.78),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainer.withValues(alpha: 0.82),
        selectedColor: scheme.primary.withValues(alpha: 0.16),
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: textTheme.labelMedium,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.7),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(scheme.primary),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary.withValues(alpha: 0.34)
              : scheme.outlineVariant,
        ),
      ),
    );
  }
}
