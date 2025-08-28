import 'package:flutter/material.dart';
import 'package:whats_clone/core/theme/app_colors.dart';
import 'package:whats_clone/core/theme/app_text_style.dart';

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
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints:
            constraints.copyWith(maxWidth: MediaQuery.sizeOf(context).width),
        child: InkWell(
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
                trailing ?? const SizedBox(),
              ],
            ),
          ),
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
    String firstTwoLetters = '';
    if (url == null) {
      if (name.isNotEmpty) {
        List<String> words = name.trim().split(' ');
        firstTwoLetters = words
            .take(2) // Take at most 2 words
            .map((word) =>
                word.isNotEmpty ? word[0].toUpperCase() : '') // Check each word
            .join('');
      }
    }

    return ClipRRect(
      borderRadius: _borderRadius,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
        //   borderRadius: _borderRadius,
          color: Theme.of(context).colorScheme.primary,
        //   image: (url != null)
        //       ? DecorationImage(
        //           image: NetworkImage(
        //             url!,
        //           ),
        //           fit: BoxFit.cover,
        //         )
        //       : null,
        ),
        child: (url == null)
            ? Center(
                child: Text(
                  firstTwoLetters,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.offWhite),
                ),
              )
            : Image.network(url!,fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) =>Center(
          child: Text(
            firstTwoLetters,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.offWhite),
          ),
        ) ,),
      ),
    );
  }
}
