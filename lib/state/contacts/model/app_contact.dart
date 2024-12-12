import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_contact.freezed.dart';
// part 'app_contact.g.dart';

@freezed
class AppContact with _$AppContact {
  const factory AppContact({
    required String id,
    required String displayName,
    @Default([]) List<String> phoneNumbers,
    String? avatarUrl,

    // App-specific fields
    String? userId, // Firebase user ID if registered in app
    @Default(false) bool isRegistered,
    // DateTime? lastInteracted,
  }) = _AppContact;

}

