import 'package:hive/hive.dart';
import 'package:whats_clone/state/message/models/chat_messages.dart';

abstract class ChatMessagesCache {
  ChatMessages? getMessages(String chatId);

  Future<void> setChatMessages(ChatMessages messages);
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
}
