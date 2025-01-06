import 'package:flutter/material.dart';
import 'package:whats_clone/core/theme/app_colors.dart';

class AppSnakeBar {
  static void showErrorSnakeBar(
      {required BuildContext context, required String message, VoidCallback? onRetry}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.error,
      action:onRetry!=null?  SnackBarAction(
        label: 'Retry',
        onPressed: onRetry,
      ):null,
    ),);
  }

  static void showSuccessSnakeBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.success,
    ),);
  }
}
