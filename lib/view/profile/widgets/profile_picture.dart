import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/core/theme/app_colors.dart';
import 'package:whats_clone/state/image_upload/provider/image_picker_provider.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/view/profile/widgets/photo_bottom_sheet.dart';

class ProfilePicture extends ConsumerWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final file = ref.watch(imagePickerProvider).file;
    final avatarUrl = ref.watch(profileNotifierProvider).profile?.avatarUrl;

    return Stack(
      children: [
        SizedBox.square(
          dimension: 100,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: InkWell(
              onTap: () => pickImage(context),
              borderRadius: BorderRadius.circular(50),
              child: file != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        file,
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : avatarUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            avatarUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person_outline_rounded,
                                    size: 50),
                          ),
                        )
                      : const Icon(Icons.person_outline_rounded, size: 50),
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
              (file == null && avatarUrl == null) ? Icons.add : Icons.edit,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }

  void pickImage(BuildContext context) => showModalBottomSheet(
        context: context,
        enableDrag: true,
        barrierColor: Colors.black.withOpacity(0.5),
        isDismissible: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        builder: (context) => const PhotoBottomSheet(),
      );
}
