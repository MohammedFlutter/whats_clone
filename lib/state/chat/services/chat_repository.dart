import 'dart:async';

import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/chat/services/chat_service.dart';

class ChatRepository {
  ChatRepository({required ChatService chatService})
      : _chatService = chatService;

  final ChatService _chatService;

  Future<Chat> createChat({required String userId1, required String userId2}) {
    return _chatService.createChat(userId1: userId1, userId2: userId2);
  }

  Future<void> updateLastMessage({
    required String chatId,
    required String lastMessage,
  }) {
    return _chatService.updateLastMessage(
      chatId: chatId,
      lastMessage: lastMessage,
    );
  }

  Future<void> resetUnreadMessages({
    required String chatId,
    required String userId,
  }) {
    return _chatService.updateUnreadMessageCount(
      chatId: chatId,
      userId: userId,
      unreadMessageCount: 0,
    );
  }

  Future<void> incrementUnreadMessages({
    required String chatId,
    required String senderId,
  }) async {
    //todo make feature: to track  is other user open chat room
    // is this return;
    final chat = await _chatService.getChat(chatId: chatId);

    if (chat == null) {
      return;
    }
    final receiverId = chat.memberIds.firstWhere((id) => id != senderId);
    final currentCount = chat.unreadMessageCount[receiverId] ?? 0;
    return _chatService.updateUnreadMessageCount(
        chatId: chatId,
        userId: receiverId,
        unreadMessageCount: currentCount + 1);
  }

  Future<void> deleteChat({required String chatId}) async {
    await _chatService.deleteChat(chatId: chatId);
  }
}
