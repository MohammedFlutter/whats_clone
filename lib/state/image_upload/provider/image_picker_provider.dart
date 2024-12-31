import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/image_upload/model/upload_state.dart';
import 'package:whats_clone/state/image_upload/notifier/app_image_picker.dart';

final imagePickerProvider =
    StateNotifierProvider.autoDispose<ImagePickerNotifier, UploadState>(
        (_) => ImagePickerNotifier());
