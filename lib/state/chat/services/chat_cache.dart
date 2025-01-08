import 'package:hive/hive.dart';
import 'package:whats_clone/state/chat/models/chat.dart';

abstract class ChatCache {
  Future<void> updateChats({required List<Chat> chats});

  List<Chat> getCachedChats();

  Future<void> deleteChat({required String chatId});
}

class ChatCacheHive implements ChatCache {
  final Box<Chat> _chatBox;

  ChatCacheHive({required Box<Chat> chatBox}) : _chatBox = chatBox;

  @override
  Future<void> updateChats({required List<Chat> chats}) async {
    await _chatBox.clear();
    await _chatBox.putAll({for (final chat in chats) chat.chatId: chat});
  }

  @override
  List<Chat> getCachedChats() {
    return _chatBox.values.toList();
  }

  @override
  Future<void> deleteChat({required String chatId}) async {
    await _chatBox.delete(chatId);
  }
}
