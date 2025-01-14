import 'package:flutter/foundation.dart' show immutable;

@immutable
class HiveBoxName {
  const HiveBoxName._();

  static const chats = 'chats';
  static const onboarding = 'onboarding';
  static const profiles = 'profile';
  static const chatProfiles = 'chat-profiles';
  static const profileCompletion = 'profile_completion';
  static const chatMessages = 'chat-messages';
}
