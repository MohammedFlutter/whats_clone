import 'dart:async';

import 'package:whats_clone/state/chat/services/chat_repository.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/services/chat_messages_cache.dart';
import 'package:whats_clone/state/message/services/message_service.dart';
import 'package:whats_clone/core/utils/logger.dart';


// const int messageLimit = 20;

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

  Stream<List<Message>> getChatMessages({required String chatId}) async* {
    try {
      final messages = <String?, Message>{};
      messages.addEntries((await getAllMessages(chatId: chatId))
          .map((message) => MapEntry(message.id, message)));
      yield messages.values.toList();
      await for (final message
          in _messageService.listenToNewMessage(chatId: chatId)) {
        messages[message.id] = message;
        _chatMessagesCache.setMessage(message);
        yield messages.values.toList();
      }
    } catch (e, st) {
      log.e(e, stackTrace: st);
      final cachedMessages = _chatMessagesCache.getMessages(chatId);
      if (cachedMessages != null) {
        yield cachedMessages.messages;
      } else {
        rethrow;
      }
    }
  }

  Future<List<Message>> getAllMessages({
    required String chatId,
  }) async {
    final cachedMessages = _chatMessagesCache.getMessages(chatId);
    if (cachedMessages != null) {
      var messages = List.of(cachedMessages.messages);
      final lastMessage = _getLatestMessage(messages);
      if (lastMessage == null) {
        return messages;
      }
      final newMessages = await _messageService.getMessagesAfter(
        chatId: chatId,
        message: lastMessage,
      );
      if (newMessages.isEmpty) {
        return messages;
      }
      _chatMessagesCache.addMessages(newMessages);
      messages.addAll(newMessages);
      return messages;
    } else {
      final messages = await _messageService.getMessages(chatId: chatId);
      _chatMessagesCache.addMessages(messages);
      return messages;
    }
  }

  Message? _getLatestMessage(List<Message> messages) {
    if (messages.isEmpty) {
      return null;
    }
    var lastMessage = messages.first;
    for (final message in messages) {
      if (message.createdAt!.isAfter(lastMessage.createdAt!)) {
        lastMessage = message;
      }
    }
    return lastMessage;
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
