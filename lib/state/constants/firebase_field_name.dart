import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  const FirebaseFieldName._();

  static const userId = 'uid';
  static const name = 'name';
  static const avatarUrl = 'avatar_url';
  static const email = 'email';
  static const phoneNumber  = 'phone_number';
  static const updatedAt = 'updated_at';
  static const createdAt = 'created_at';
  static const unreadMessageCount = 'unreadMessageCount';

}
