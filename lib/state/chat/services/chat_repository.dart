import 'dart:async';

import 'package:whats_clone/state/chat/services/chat_service.dart';

class ChatRepository {
  ChatRepository({required ChatService chatService})
      : _chatService = chatService;

  final ChatService _chatService;

  Future<void> createChat({required String userId1, required String userId2}) {
    return _chatService.createChat(userId1: userId1, userId2: userId2);
  }

  Future<void> deleteChat(String chatId) async {
    await _chatService.deleteChat(chatId: chatId);
  }
}
