import 'package:flutter/material.dart';

class AppFillButton extends StatelessWidget {
  const AppFillButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: onPressed,
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}
