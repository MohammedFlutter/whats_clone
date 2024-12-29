import 'package:flutter/material.dart';
import 'package:whats_clone/view/constants/strings.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onPressed,
            child: const Text(Strings.save),
          ),
        ),
      ],
    );
  }
}