import 'package:hive/hive.dart';
import 'package:whats_clone/state/message/models/chat_messages.dart';
import 'package:whats_clone/state/message/models/message.dart';

abstract class ChatMessagesCache {
  ChatMessages? getMessages(String chatId);

  Future<void> setChatMessages(ChatMessages messages);

  Future<void> setMessage(Message message);

  Future<void> addMessages(List<Message> message);
}

class ChatMessagesCacheHive implements ChatMessagesCache {
  ChatMessagesCacheHive({required Box<ChatMessages> chatMessagesBox})
      : _chatMessageBox = chatMessagesBox;
  final Box<ChatMessages> _chatMessageBox;

  @override
  ChatMessages? getMessages(String chatId) {
    return _chatMessageBox.get(chatId);
  }

  @override
  Future<void> setChatMessages(ChatMessages messages) {
    return _chatMessageBox.put(messages.chatId, messages);
  }

  @override
  Future<void> setMessage(Message message) {
    final chatId = message.chatId;
    final chatMessages = _chatMessageBox.get(chatId);
    if (chatMessages != null) {
      final oldMessage = chatMessages.messages
          .where(
            (e) => e.id == message.id,
          )
          .indexed
          .firstOrNull;
      if (oldMessage != null) {
        final oldMessages = List.of(chatMessages.messages);
        oldMessages.replaceRange(oldMessage.$1, oldMessage.$1 + 1, [message]);
        final updatedChatMessages = chatMessages.copyWith(
          messages: oldMessages,
        );
        return setChatMessages(updatedChatMessages);
      }

      final updatedChatMessages = chatMessages.copyWith(
        messages: [...chatMessages.messages, message],
      );
      return setChatMessages(updatedChatMessages);
    } else {
      return setChatMessages(ChatMessages(
        chatId: chatId,
        messages: [message],
      ));
    }
  }

  @override
  Future<void> addMessages(List<Message> message) {
    if (message.isEmpty) return Future.value();
    final chatId = message.last.chatId;
    final chatMessages = _chatMessageBox.get(chatId);
    if (chatMessages != null) {
      final updatedMessages = chatMessages.copyWith(
        messages: [...chatMessages.messages, ...message],
      );
      return setChatMessages(updatedMessages);
    } else {
      return setChatMessages(ChatMessages(
        chatId: chatId,
        messages: message,
      ));
    }
  }
}
