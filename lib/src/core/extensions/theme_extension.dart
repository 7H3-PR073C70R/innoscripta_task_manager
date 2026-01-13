import 'package:flutter/material.dart';
import 'package:innoscripta_task_manager/src/core/themes/color/app_theme_colors_extension.dart';
import 'package:innoscripta_task_manager/src/core/themes/typography/typography_theme_extension.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TypographyThemeExtension get textTheme =>
      Theme.of(this).extension<TypographyThemeExtension>()!;

  AppThemeColorsExtension get colors =>
      Theme.of(this).extension<AppThemeColorsExtension>()!;
}
