// ignore_for_file: deprecated_member_use, document_ignores

import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.primary,
    required this.success,
    required this.error,
    required this.warning,
    required this.gray,
    required this.surface,
    required this.background,
    required this.accent,
  });

  final MaterialColor primary;
  final MaterialColor success;
  final MaterialColor error;
  final MaterialColor warning;
  final MaterialColor gray;
  final MaterialColor surface;
  final MaterialColor background;
  final MaterialColor accent;

  @override
  AppThemeColors copyWith({
    MaterialColor? primary,
    MaterialColor? success,
    MaterialColor? error,
    MaterialColor? warning,
    MaterialColor? gray,
    MaterialColor? surface,
    MaterialColor? background,
    MaterialColor? accent,
  }) {
    return AppThemeColors(
      primary: primary ?? this.primary,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      gray: gray ?? this.gray,
      surface: surface ?? this.surface,
      background: background ?? this.background,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      primary: primary.lerp(other.primary, t),
      success: success.lerp(other.success, t),
      error: error.lerp(other.error, t),
      warning: warning.lerp(other.warning, t),
      gray: gray.lerp(other.gray, t),
      surface: surface.lerp(other.surface, t),
      background: background.lerp(other.background, t),
      accent: accent.lerp(other.accent, t),
    );
  }
}

extension MaterialColorLerp on MaterialColor {
  MaterialColor lerp(MaterialColor target, double t) {
    return MaterialColor(
      value,
      {
        50: Color.lerp(this[50], target[50], t) ?? this[50]!,
        100: Color.lerp(this[100], target[100], t) ?? this[100]!,
        200: Color.lerp(this[200], target[200], t) ?? this[200]!,
        300: Color.lerp(this[300], target[300], t) ?? this[300]!,
        400: Color.lerp(this[400], target[400], t) ?? this[400]!,
        500: Color.lerp(this[500], target[500], t) ?? this[500]!,
        600: Color.lerp(this[600], target[600], t) ?? this[600]!,
        700: Color.lerp(this[700], target[700], t) ?? this[700]!,
        800: Color.lerp(this[800], target[800], t) ?? this[800]!,
        900: Color.lerp(this[900], target[900], t) ?? this[900]!,
      },
    );
  }
}
