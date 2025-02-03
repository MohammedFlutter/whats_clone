import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ImageUploadService {
  Future<void> deleteImage(String url);

  Future<String> uploadImage(
    String fileName,
    File file,
  );
}

class ImageUploadServiceSupabase implements ImageUploadService {
  final  client = Supabase.instance.client.storage;

  @override
  Future<void> deleteImage(String url) {
    final fileName= url.split('/').last;
    return client.from('images').remove([fileName]);
  }

  @override
  Future<String> uploadImage(String fileName, File file)async{
    await client.from('images').upload(
      fileName,
      file,
    );
    return client.from('images').getPublicUrl(fileName);
  }
}
