import 'package:flutter/material.dart';
import 'package:innoscripta_task_manager/src/core/extensions/num_extension.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/animated_loader.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

extension BuildContextExtension on BuildContext {
  void showSnackBar({
    required String message,
    SnackBarType type = SnackBarType.success,
  }) {
    return showTopSnackBar(
      Overlay.of(this),
      switch (type) {
        SnackBarType.error => CustomSnackBar.error(
          message: message,
          backgroundColor: colors.error,
          textStyle: TextStyle(
            fontSize: 12.fontSize,
            fontWeight: FontWeight.w500,
            color: colors.background,
          ),
          borderRadius: BorderRadius.circular(8.radius),
        ),
        SnackBarType.success => CustomSnackBar.success(
          message: message,
          backgroundColor: colors.success,
          textStyle: TextStyle(
            fontSize: 12.fontSize,
            fontWeight: FontWeight.w500,
            color: colors.background,
          ),
          borderRadius: BorderRadius.circular(8.radius),
        ),
        SnackBarType.info => CustomSnackBar.info(
          message: message,
          backgroundColor: colors.gray,
          textStyle: TextStyle(
            fontSize: 12.fontSize,
            fontWeight: FontWeight.w500,
            color: colors.background,
          ),
          borderRadius: BorderRadius.circular(8.radius),
        ),
      },
    );
  }

  Future<void> showLoadingModal() {
    return showDialog<void>(
      context: this,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return const Center(
          child: Material(
            color: Colors.transparent,
            child: AnimatedLoader(isBig: true),
          ),
        );
      },
    );
  }
}

enum SnackBarType {
  error,
  success,
  info,
}
