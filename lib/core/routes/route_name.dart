
import 'package:flutter/foundation.dart' show immutable;

@immutable
class RouteName{
  const RouteName._();

  static const onboarding='onboarding';
  static const splash='splash';
  static const login='login';
  static const createProfile = 'create-profile';
  static const updateProfile = 'update-profile';
  static const chats = 'chats';
  static const chatRoom = 'chat-room';
  static const contacts = 'contacts';
  static const more = 'more';
}