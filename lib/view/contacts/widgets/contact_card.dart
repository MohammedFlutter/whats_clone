import 'package:flutter/material.dart';
import 'package:whats_clone/core/theme/app_colors.dart';
import 'package:whats_clone/core/theme/app_text_style.dart';
import 'package:whats_clone/core/utils/extensions/list_extension.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';

final _borderRadius = BorderRadius.circular(16);

class ContactCard extends StatelessWidget {
  const ContactCard(
      {super.key, required this.contact, required this.onPressed});

  final AppContact contact;
  final VoidCallback onPressed;

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
              url: contact.avatarUrl,
              name: contact.displayName,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.displayName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // if (contact.isRegistered && contact.bio != null)
                Text(
                  contact.phoneNumbers.sublist(0,2).join(', '),
                  style: AppTextStyles.metadata1
                      .copyWith(color: AppColors.disable),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )
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
