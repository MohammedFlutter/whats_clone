import 'dart:async';

import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/chat/services/chat_profile_cache.dart';
import 'package:whats_clone/state/chat/services/chat_service.dart';

class ChatRepository {
  ChatRepository(
      {required ChatService chatService,
      required ChatProfileCache chatProfileCache})
      : _chatService = chatService,
        _chatProfileCache = chatProfileCache;

  final ChatService _chatService;
  final ChatProfileCache _chatProfileCache;

  Future<Chat> createChat({required String userId1, required String userId2}) {
    return _chatService.createChat(userId1: userId1, userId2: userId2);
  }

  Future<void> updateLastMessage(
      {required String chatId,
      required String lastMessage,
     }) async {
    // await _chatProfileCache.updateSingleChatProfile(
    //     chatId: chatId,
    //     lastMessage: lastMessage,
    //     lastMessageTimestamp: lastMessageTimestamp);
    await _chatService.updateChat(
        chatId: chatId,
        lastMessage: lastMessage,
   );
  }

  Future<void> deleteChat({required String chatId}) async {
    await _chatService.deleteChat(chatId: chatId);
  }
}
