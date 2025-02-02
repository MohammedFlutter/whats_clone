import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/chat/services/chat_profile_cache.dart';
import 'package:whats_clone/state/chat/services/chat_service.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/services/profiles_repository.dart';

class ChatProfileRepository {
  ChatProfileRepository({required ChatService chatService,
    required ProfilesRepository profileRepository,
    required ChatProfileCache chatProfileCache})
      : _chatService = chatService,
        _profileRepository = profileRepository,
        _chatProfileCache = chatProfileCache;

  final ChatService _chatService;
  final ProfilesRepository _profileRepository;
  final ChatProfileCache _chatProfileCache;

  Stream<List<ChatProfile>> getChatProfiles({required String userId}) {
    return _chatService
        .getChatsByUserId(userId: userId)
        .switchMap((chats) => _handleChatSteam(chats, userId))
        .onErrorReturnWith(
          (e, s) {
        log.e(e, stackTrace: s);
        return _chatProfileCache.getCachedChatProfiles();
      },
    );
  }

  Stream<List<ChatProfile>> _handleChatSteam(List<Chat> chats, String userId) {
    if (chats.isEmpty) return Stream.value(<ChatProfile>[]);

    List<String> userIds = _extractUserIdsFromChat(chats, userId);

    return _profileRepository.getProfileFromCacheFirst(userIds).asStream().map(
          (profiles) {
        final chatProfiles = _mapChatToChatProfile(chats, userId, profiles);
        _chatProfileCache.updateChatProfiles(chatProfiles: chatProfiles);
        return chatProfiles;
      },
    );
  }

  List<String> _extractUserIdsFromChat(List<Chat> chats, String userId) =>
      chats
          .expand((chat) => chat.memberIds)
          .where((id) => id != userId)
          .toSet()
          .toList();

  List<ChatProfile> _mapChatToChatProfile(List<Chat> chats, String userId,
      List<Profile> profiles) {
    final profileMap = {for (var profile in profiles) profile.userId: profile};
    return chats
        .map((chat) {
      final otherUserId = chat.memberIds.firstWhere((id) => id != userId);
      final otherProfile = profileMap[otherUserId];
      if (otherProfile == null) {
        log.w('Missing profile for userId: $otherUserId');
        return null;
      }
      return ChatProfile(
        id: otherProfile.userId,
        name: otherProfile.name,
        avatarUrl: otherProfile.avatarUrl,
        phone: otherProfile.phoneNumber,
        chatId: chat.chatId,
        lastMessage: chat.lastMessage,
        lastMessageTimestamp: chat.lastMessageTimestamp,
        unreadMessageCount: chat.unreadMessageCount[userId]??0,
      );
    })
        .whereType<ChatProfile>()
        .toList();
  }
}
