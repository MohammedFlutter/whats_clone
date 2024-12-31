
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_state.freezed.dart';

@freezed
class UploadState with _$UploadState {
  const factory UploadState({
    File? file,
    required UploadStatus status,
    String? errorMessage,
  }) = _UploadState;

}
enum UploadStatus { initial, loading, success, error }
