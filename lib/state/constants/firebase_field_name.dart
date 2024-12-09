import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  const FirebaseFieldName._();

  static const userId = 'uid';
  static const name = 'name';
  static const avatarUrl = 'avatar_url';
  static const email = 'email';
  static const phone  = 'phone';
  static const updatedAt = 'updatedAt';
  static const createdAt = 'createdAt';
}
