import 'package:flutter/material.dart';
import 'package:whats_clone/core/theme/app_colors.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Stack(
      children: [
        SizedBox.square(
          dimension: 100,
          child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(50),
              child: const Icon(Icons.person_outline_rounded, size: 50),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 1,
          child: Card(
            color: isLight ? AppColors.textPrimary : AppColors.textPrimaryDark,
            elevation: 0,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}
