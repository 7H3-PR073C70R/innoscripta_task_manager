import 'package:flutter/material.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';

class TaskField extends StatelessWidget {
  const TaskField({
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: textTheme.body.copyWith(color: colors.gray[900]),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: textTheme.body.copyWith(color: colors.gray[600]),
        hintStyle: textTheme.body.copyWith(color: colors.gray[400]),
        alignLabelWithHint: maxLines > 1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.gray[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.gray[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary[500]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error[500]!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error[500]!, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
