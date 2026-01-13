import 'package:flutter/material.dart';
import 'package:innoscripta_task_manager/src/core/extensions/color_extension.dart';
import 'package:innoscripta_task_manager/src/core/themes/color/app_theme_colors.dart';
import 'package:innoscripta_task_manager/src/core/themes/typography/app_typography.dart';

class AppTheme {
  // --- LIGHT MODE ---
  static ThemeData get light {
    final colors = AppThemeColors(
      primary: const Color(0xFF4F46E5).toMaterialColor, // Indigo
      success: const Color(0xFF10B981).toMaterialColor, // Emerald
      error: const Color(0xFFEF4444).toMaterialColor, // Red
      warning: const Color(0xFFF59E0B).toMaterialColor, // Amber
      gray: const Color(0xFF64748B).toMaterialColor, // Slate
      surface: Colors.white.toMaterialColor,
      background: const Color(0xFFF8FAFC).toMaterialColor,
      accent: const Color(0xFF8B5CF6).toMaterialColor, // Violet
    );

    final typography = AppTypography(
      heading: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: colors.gray[900],
      ),
      subHeading: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colors.gray[800],
      ),
      taskTitle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.gray[900],
      ),
      body: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: colors.gray[700],
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colors.gray[500],
      ),
    );

    return ThemeData(
      brightness: Brightness.light,
      extensions: [colors, typography],
      scaffoldBackgroundColor: colors.background[50],
    );
  }

  // --- DARK MODE ---
  static ThemeData get dark {
    final colors = AppThemeColors(
      primary: const Color(0xFF818CF8).toMaterialColor, // Light Indigo
      success: const Color(0xFF34D399).toMaterialColor, // Light Emerald
      error: const Color(0xFFFB7185).toMaterialColor, // Rose
      warning: const Color(0xFFFBBF24).toMaterialColor, // Amber
      gray: const Color(0xFF94A3B8).toMaterialColor, // Slate 400
      surface: const Color(0xFF1E293B).toMaterialColor, // Slate 800
      background: const Color(0xFF0F172A).toMaterialColor, // Slate 900
      accent: const Color(0xFFA78BFA).toMaterialColor,
    );

    const typography = AppTypography(
      heading: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      subHeading: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF1F5F9),
      ),
      taskTitle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      body: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Color(0xFFCBD5E1),
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF94A3B8),
      ),
    );

    return ThemeData(
      brightness: Brightness.dark,
      extensions: [colors, typography],
      scaffoldBackgroundColor: colors.background.shade900,
    );
  }
}
