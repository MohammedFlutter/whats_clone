import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/image_upload/model/upload_state.dart';
import 'package:whats_clone/state/image_upload/services/image_upload_service.dart';

class ImagePickerNotifier extends StateNotifier<UploadState> {
  ImagePickerNotifier({required ImageUploadService imageUploadService})
      : _imageUploadService = imageUploadService,
        super(const UploadState(status: UploadStatus.initial));
  final ImageUploadService _imageUploadService;

  static final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      state = state.copyWith(file: File(pickedImage.path));
    }
  }

  Future<void> captureImageFromCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      state = state.copyWith(file: File(pickedImage.path));
    }
  }

  Future<String?> uploadImage() async {
    if (state.file == null) {
      return null;
    }
    try {
      state = state.copyWith(status: UploadStatus.loading);
      // await Future.delayed(const Duration(milliseconds: 60));
      // Read the image file
      File resizedFile = await _processImage();

      // Generate a unique file name
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

      final String publicUrl =
          await _imageUploadService.uploadImage(fileName, resizedFile);

      state = state.copyWith(
        status: UploadStatus.success,
      );

      return publicUrl;
    } catch (e) {
      log.e('Error uploading image: $e');
      state = state.copyWith(
          status: UploadStatus.error, errorMessage: e.toString());
      return null;
    }
  }

  Future<File> _processImage() async {
    final File file = state.file!;
    final img.Image? image = img.decodeImage(await (file.readAsBytes()));
    if (image == null) {
      throw Exception('Could not decode image');
    }

    // Resize the image to a thumbnail (e.g., 200x200 pixels)
    final img.Image resizedImage = img.copyResize(image, width: 200);

    // Save the resized image to a temporary file
    final String tempPath =
        '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    final File resizedFile = File(tempPath)
      ..writeAsBytesSync(img.encodePng(resizedImage));
    return resizedFile;
  }
}
