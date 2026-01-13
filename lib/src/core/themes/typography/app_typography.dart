import 'package:flutter/material.dart';

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.heading,
    required this.subHeading,
    required this.taskTitle,
    required this.body,
    required this.caption,
  });

  final TextStyle heading;
  final TextStyle subHeading;
  final TextStyle taskTitle;
  final TextStyle body;
  final TextStyle caption;

  @override
  AppTypography copyWith({
    TextStyle? heading,
    TextStyle? subHeading,
    TextStyle? taskTitle,
    TextStyle? body,
    TextStyle? caption,
  }) {
    return AppTypography(
      heading: heading ?? this.heading,
      subHeading: subHeading ?? this.subHeading,
      taskTitle: taskTitle ?? this.taskTitle,
      body: body ?? this.body,
      caption: caption ?? this.caption,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      heading: TextStyle.lerp(heading, other.heading, t)!,
      subHeading: TextStyle.lerp(subHeading, other.subHeading, t)!,
      taskTitle: TextStyle.lerp(taskTitle, other.taskTitle, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}
