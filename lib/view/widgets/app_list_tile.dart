import 'package:flutter/material.dart';
import 'package:whats_clone/core/theme/app_colors.dart';
import 'package:whats_clone/core/theme/app_text_style.dart';
import 'package:whats_clone/core/utils/extensions/list_extension.dart';

final _borderRadius = BorderRadius.circular(16);

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.onPressed,
    this.avatarUrl,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final VoidCallback onPressed;
  final String? avatarUrl;
  final String title;
  final String? subtitle;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageAvatar(
              url: avatarUrl,
              name: title,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.metadata1
                        .copyWith(color: AppColors.disable),
                  )
              ],
            ),
            const Spacer(),
            if (trailing != null)
              Text(
                trailing!,
                style:
                    AppTextStyles.metadata1.copyWith(color: AppColors.disable),
              ),
          ],
        ),
      ),
    );
  }
}

class ImageAvatar extends StatelessWidget {
  const ImageAvatar({
    super.key,
    this.url,
    required this.name,
  });

  final String? url;
  final String name;

  @override
  Widget build(BuildContext context) {
    final firstTwoLetter = name.isEmpty
        ? ''
        : name
            .trim()
            .split(' ')
            .safeSubRange(0, 2)
            .map(
              (word) => word.substring(0, 1).toUpperCase(),
            )
            .join('');

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
        color: Theme.of(context).colorScheme.primary,
        image: (url != null)
            ? DecorationImage(
                image: NetworkImage(
                  url!,
                ),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: (url == null)
          ? Center(
              child: Text(
                firstTwoLetter,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.offWhite),
              ),
            )
          : null,
    );
  }
}
