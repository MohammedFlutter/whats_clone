import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/theme/app_text_style.dart';
import 'package:whats_clone/state/image_upload/provider/image_picker_provider.dart';
import 'package:whats_clone/view/constants/strings.dart';

class PhotoBottomSheet extends ConsumerWidget {
  const PhotoBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePickerNotifier = ref.read(imagePickerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close),
              ),
              const Text(
                Strings.profilePhoto,
                style: AppTextStyles.subHeadline1,
              ),
              const SizedBox(
                width: 24,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _ProfileBottomSheetItem(
                  onPressed:()async{
                    await imagePickerNotifier.captureImageFromCamera();
                    if(context.mounted)context.pop();
                  },
                  icon: Icons.camera_alt_outlined,
                  text: Strings.camera),
              _ProfileBottomSheetItem(
                  onPressed: () async {
                    await imagePickerNotifier.pickImageFromGallery();
                    if(context.mounted)context.pop();
                  },
                  icon: Icons.photo_outlined,
                  text: Strings.gallery),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileBottomSheetItem extends StatelessWidget {
  const _ProfileBottomSheetItem(
      {required this.onPressed, required this.icon, required this.text});

  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
