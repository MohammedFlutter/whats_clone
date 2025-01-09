import 'package:hive/hive.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';

abstract class ChatProfileCache {
  Future<void> updateChatProfiles({required List<ChatProfile> chatProfiles});

  List<ChatProfile> getCachedChatProfiles();
}

class ChatProfileCacheHive implements ChatProfileCache {
  final Box<ChatProfile> _chatProfileBox;

  ChatProfileCacheHive({required Box<ChatProfile> chatProfileBox})
      : _chatProfileBox = chatProfileBox;

  @override
  Future<void> updateChatProfiles({required List<ChatProfile> chatProfiles}) async {
    await _chatProfileBox.clear();
    await _chatProfileBox
        .putAll({for (final chat in chatProfiles) chat.chatId: chat});
  }

  @override
  List<ChatProfile> getCachedChatProfiles() {
    return _chatProfileBox.values.toList();
  }
}
