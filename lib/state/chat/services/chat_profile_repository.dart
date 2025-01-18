import 'dart:async';

import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/chat/services/chat_profile_cache.dart';
import 'package:whats_clone/state/chat/services/chat_service.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/services/profile_service.dart';

class ChatProfileRepository {
  ChatProfileRepository(
      {required ChatService chatService,
      required ProfileService profileService,
      required ChatProfileCache chatProfileCache})
      : _chatService = chatService,
        _profileService = profileService,
        _chatProfileCache = chatProfileCache;

  final ChatService _chatService;
  final ProfileService _profileService;
  final ChatProfileCache _chatProfileCache;

  Stream<List<ChatProfile>> getChatProfiles({required String userId}) {
    final currentProfiles = <Profile>[];

    return _chatService
        .getChatsByUserId(userId: userId)
        .asyncMap((chats) async {
      try {
        if (chats.isEmpty) return [];

        final userIds = chats
            .expand((chat) => chat.memberIds)
            .where((id) => id != userId)
            .toSet();

        final newUserIds = userIds
            .where(
                (id) => !currentProfiles.any((profile) => profile.userId == id))
            .toList();

        if (newUserIds.isNotEmpty) {
          final newProfiles =
              await _profileService.getProfileByUsersId(usersId: newUserIds);
          currentProfiles.addAll(newProfiles);
        }

        final profileMap = {
          for (var profile in currentProfiles) profile.userId: profile
        };

        final chatProfiles = chats.map((chat) {
          final otherUserId = chat.memberIds.firstWhere((id) => id != userId);
          final otherProfile = profileMap[otherUserId];

          if (otherProfile == null) {
            throw StateError('Profile for user $otherUserId not found.');
          }

          return ChatProfile(
            id: otherProfile.userId,
            name: otherProfile.name,
            avatarUrl: otherProfile.avatarUrl,
            phone: otherProfile.phoneNumber,
            chatId: chat.chatId,
            lastMessage: chat.lastMessage,
            lastMessageTimestamp: chat.lastMessageTimestamp,
          );
        }).toList();

        await _chatProfileCache.updateChatProfiles(chatProfiles: chatProfiles);
        return chatProfiles;
      } catch (e) {
        log.e(e);
        return _chatProfileCache.getCachedChatProfiles();
      }
    });
  }
}
