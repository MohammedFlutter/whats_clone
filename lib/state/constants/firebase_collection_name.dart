
import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseCollectionName{
  const FirebaseCollectionName._();

  static const profiles='profiles';
  static const chats='chats';
  static const chatsMessages='chats-messages';
  static const usersChats='users-chats';
  static const fcmTokens='fcm-tokens';
  static const messages='messages';


}