import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.emerald,
    required this.gold,
    required this.card,
    required this.softCard,
    required this.glass,
    required this.background,
    required this.backgroundAlt,
    required this.textMuted,
    required this.shadow,
    required this.success,
    required this.warning,
    required this.danger,
  });

  final Color emerald;
  final Color gold;
  final Color card;
  final Color softCard;
  final Color glass;
  final Color background;
  final Color backgroundAlt;
  final Color textMuted;
  final Color shadow;
  final Color success;
  final Color warning;
  final Color danger;

  @override
  AppPalette copyWith({
    Color? emerald,
    Color? gold,
    Color? card,
    Color? softCard,
    Color? glass,
    Color? background,
    Color? backgroundAlt,
    Color? textMuted,
    Color? shadow,
    Color? success,
    Color? warning,
    Color? danger,
  }) {
    return AppPalette(
      emerald: emerald ?? this.emerald,
      gold: gold ?? this.gold,
      card: card ?? this.card,
      softCard: softCard ?? this.softCard,
      glass: glass ?? this.glass,
      background: background ?? this.background,
      backgroundAlt: backgroundAlt ?? this.backgroundAlt,
      textMuted: textMuted ?? this.textMuted,
      shadow: shadow ?? this.shadow,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }

    return AppPalette(
      emerald: Color.lerp(emerald, other.emerald, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      card: Color.lerp(card, other.card, t)!,
      softCard: Color.lerp(softCard, other.softCard, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      background: Color.lerp(background, other.background, t)!,
      backgroundAlt: Color.lerp(backgroundAlt, other.backgroundAlt, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
