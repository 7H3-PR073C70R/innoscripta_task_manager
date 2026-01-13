import 'package:flutter/material.dart';
import 'package:innoscripta_task_manager/src/core/themes/color/app_theme_colors.dart';
import 'package:innoscripta_task_manager/src/core/themes/typography/app_typography.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  AppTypography get textTheme => theme.extension<AppTypography>()!;

  AppThemeColors get colors => theme.extension<AppThemeColors>()!;
}
