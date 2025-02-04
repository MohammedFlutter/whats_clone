import 'package:flutter/material.dart';

class AppAlertDialog {
  AppAlertDialog._();

  static Future<void> showDialog({
    required BuildContext context,
    required String title,
    String? content,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    String? confirmText,
    String? cancelText,
  }) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
          title: Text(title),
          content: (content != null) ? Text(content) : null,
          actions: [
            if (onCancel != null)
              TextButton(
                onPressed: onCancel,
                child: Text(cancelText ?? 'Cancel'),
              ),
            if (onConfirm != null)
              TextButton(
                onPressed: onConfirm,
                child: Text(confirmText ?? 'Confirm'),
              ),
          ]),
    );
  }
}
