import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/image_upload/model/upload_state.dart';
import 'package:image/image.dart'as img;

class ImagePickerNotifier extends StateNotifier<UploadState> {
  ImagePickerNotifier()
      : super(const UploadState(status: UploadStatus.initial));

  static final ImagePicker _picker = ImagePicker();
  final SupabaseClient _client = Supabase.instance.client;

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

  Future<String?> uploadImage1() async {
    if (state.file == null) {
      return null;
    }
    try {
      state = state.copyWith(status: UploadStatus.loading);

      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final File file = state.file!;
      await _client.storage.from('images').upload(
            fileName,
            file,
          );
      final String publicUrl =
          _client.storage.from('images').getPublicUrl(fileName);
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

  Future<String?> uploadImage() async {
    if (state.file == null) {
      return null;
    }
    try {
      state = state.copyWith(status: UploadStatus.loading);

      // Read the image file
      final File file = state.file!;
      final img.Image? image = img.decodeImage(file.readAsBytesSync());
      if (image == null) {
        throw Exception('Could not decode image');
      }

      // Resize the image to a thumbnail (e.g., 200x200 pixels)
      final img.Image resizedImage = img.copyResize(image, width: 200);

      // Save the resized image to a temporary file
      final String tempPath = '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final File resizedFile = File(tempPath)
        ..writeAsBytesSync(img.encodePng(resizedImage));

      // Generate a unique file name
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

      // Upload the resized image
      await _client.storage.from('images').upload(
        fileName,
        resizedFile,
      );

      // Get the public URL
      final String publicUrl =
      _client.storage.from('images').getPublicUrl(fileName);

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
}
