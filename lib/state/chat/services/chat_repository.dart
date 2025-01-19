import 'dart:async';

import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/chat/services/chat_service.dart';

class ChatRepository {
  ChatRepository({
    required ChatService chatService,
  }) : _chatService = chatService;

  final ChatService _chatService;

  Future<Chat> createChat({required String userId1, required String userId2}) {
    return _chatService.createChat(userId1: userId1, userId2: userId2);
  }

  Future<void> updateLastMessage({
    required String chatId,
    required String lastMessage,
  }) async {
    await _chatService.updateChat(
      chatId: chatId,
      lastMessage: lastMessage,
    );
  }

  Future<void> deleteChat({required String chatId}) async {
    await _chatService.deleteChat(chatId: chatId);
  }
}
