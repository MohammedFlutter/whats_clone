import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/core/theme/app_colors.dart';
import 'package:whats_clone/state/image_upload/provider/image_picker_provider.dart';
import 'package:whats_clone/view/profile/widgets/photo_bottom_sheet.dart';

class ProfilePicture extends ConsumerWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final file = ref.watch(imagePickerProvider).file;
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
              onTap: () => pickImage(context),
              borderRadius: BorderRadius.circular(50),
              child: file == null
                  ? const Icon(Icons.person_outline_rounded, size: 50)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        file,
                        width: 100,
                        fit: BoxFit.fitWidth,
                      )),
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

  void pickImage(BuildContext context) => showModalBottomSheet(
        context: context,
        enableDrag: true,
        barrierColor: Colors.black.withOpacity(0.5),
        isDismissible: true,

        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        builder: (context) => const PhotoBottomSheet(),
      );
}
