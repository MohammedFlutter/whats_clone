import 'dart:async';

import 'package:whats_clone/state/chat/services/chat_repository.dart';
import 'package:whats_clone/state/message/models/chat_messages.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/services/chat_messages_cache.dart';
import 'package:whats_clone/state/message/services/message_service.dart';

class MessageRepository {
  MessageRepository(
      {required ChatMessagesCache chatMessagesCache,
      required MessageService messageService,
      required ChatRepository chatService})
      : _chatMessagesCache = chatMessagesCache,
        _messageService = messageService,
        _chatRepository = chatService;
  final ChatMessagesCache _chatMessagesCache;
  final MessageService _messageService;
  final ChatRepository _chatRepository;

  Stream<ChatMessages> getChatMessages({required String chatId}) async* {
    try {
      await for (final chatMessages
          in _messageService.getChatMessages(chatId: chatId)) {
        _chatMessagesCache.setChatMessages(chatMessages);
        yield chatMessages;
      }
    } catch (_) {
      final cachedMessages = _chatMessagesCache.getMessages(chatId);
      if (cachedMessages != null) {
        yield cachedMessages;
      } else {
        rethrow;
      }
    }
  }

  Future<void> sendMessage({required Message message}) async {
    await _messageService.sendMessage(message: message);
    await _chatRepository.incrementUnreadMessages(
        chatId: message.chatId, senderId: message.senderId);
    await Future.wait([
      _chatRepository.updateLastMessage(
        chatId: message.chatId,
        lastMessage: message.content,
      ),
      // _chatRepository.incrementUnreadMessages(
      //     chatId: message.chatId, senderId: message.senderId),
    ]);
  }
}
