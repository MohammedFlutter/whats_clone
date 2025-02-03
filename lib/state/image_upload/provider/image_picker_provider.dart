import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/image_upload/model/upload_state.dart';
import 'package:whats_clone/state/image_upload/notifier/app_image_picker.dart';
import 'package:whats_clone/state/image_upload/services/image_upload_service.dart';

final imagePickerProvider =
    StateNotifierProvider.autoDispose<ImagePickerNotifier, UploadState>((ref) =>
        ImagePickerNotifier(
            imageUploadService: ref.watch(imageUploadServiceProvider)));

final imageUploadServiceProvider = Provider<ImageUploadService>(
  (_) => ImageUploadServiceSupabase(),
);
