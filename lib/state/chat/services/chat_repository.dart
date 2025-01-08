import 'dart:async';

import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/chat/services/chat_cache.dart';
import 'package:whats_clone/state/chat/services/chat_service.dart';

class ChatRepository {
  ChatRepository(
      {required ChatCache chatCache, required ChatService chatService})
      : _chatCache = chatCache,
        _chatService = chatService;

  final ChatCache _chatCache;
  final ChatService _chatService;

  Stream<List<Chat>> getChats({required String userId}) async* {
    // Emit cached chats first
    yield _chatCache.getCachedChats();

    try {
      await for (final chats in _chatService.getChatsByUserId(userId: userId)) {
        _chatCache.updateChats(chats: chats);
        yield chats;
      }
    } catch (error, stackTrace) {
      log.e('Error fetching chats: $error', stackTrace: stackTrace);
      yield _chatCache.getCachedChats();
    }
  }

  Future<void> createChat({required String userId1, required String userId2}) {
    return _chatService.createChat(userId1: userId1, userId2: userId2);
  }

  Future<void> deleteChat(String chatId) async {
    await _chatService.deleteChat(chatId: chatId);
    await _chatCache.deleteChat(chatId: chatId);
  }
}
