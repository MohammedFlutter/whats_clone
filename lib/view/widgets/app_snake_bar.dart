import 'package:flutter/material.dart';
import 'package:whats_clone/core/theme/app_colors.dart';

class AppSnakeBar {
  static void showErrorSnakeBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.error,
    ),);
  }

  static void showSuccessSnakeBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.success,
    ),);
  }
}
