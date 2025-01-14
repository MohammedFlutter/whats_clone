import 'package:hive/hive.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';

abstract class ChatProfileCache {
  Future<void> updateChatProfiles({required List<ChatProfile> chatProfiles});

  List<ChatProfile> getCachedChatProfiles();

  Future<void> updateSingleChatProfile(
      {required String chatId,
      required String lastMessage,
      required DateTime lastMessageTimestamp});
}

class ChatProfileCacheHive implements ChatProfileCache {
  final Box<ChatProfile> _chatProfileBox;

  ChatProfileCacheHive({required Box<ChatProfile> chatProfileBox})
      : _chatProfileBox = chatProfileBox;

  @override
  Future<void> updateChatProfiles(
      {required List<ChatProfile> chatProfiles}) async {
    await _chatProfileBox.clear();
    await _chatProfileBox
        .putAll({for (final chat in chatProfiles) chat.chatId: chat});
  }

  @override
  List<ChatProfile> getCachedChatProfiles() {
    return _chatProfileBox.values.toList();
  }

  @override
  Future<void> updateSingleChatProfile({
    required String chatId,
    required String lastMessage,
    required DateTime lastMessageTimestamp,
  }) async {
    final chatProfileInCache = _chatProfileBox.get(chatId);
    if (chatProfileInCache != null) {
      final newChatProfile = chatProfileInCache.copyWith(
        lastMessage: lastMessage,
        lastMessageTimestamp: lastMessageTimestamp,
      );

      return _chatProfileBox.put(chatId, newChatProfile);
    }
  }
}
