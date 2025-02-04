import 'package:flutter/material.dart';

class MoreCard extends StatelessWidget {
  const MoreCard({
    super.key,
    required this.icon,
    required this.title,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
