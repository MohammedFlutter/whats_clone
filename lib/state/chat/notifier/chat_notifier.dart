import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/chat/models/chat_state.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
import 'package:whats_clone/state/profile/providers/profile_state_provider.dart';

class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() => const ChatState();

  Future<ChatProfile?> createChat({required String antherUserId}) async {
    try {
      state = const ChatState(status: ChatStatus.loading);
      final chatProfilesState = ref.watch(chatProfileNotifierProvider);
      if (chatProfilesState.hasValue) {
        final chatProfile = chatProfilesState.value!
            .where((element) => element.id == antherUserId)
            .firstOrNull;
        if (chatProfile != null) {
          return chatProfile;
        }
      }

      final userId = ref.read(authProvider).userId!;
      final newChat = await ref
          .read(chatRepositoryProvider)
          .createChat(userId1: userId, userId2: antherUserId);
      state = const ChatState(status: ChatStatus.created);
      //todo must be modify this code
      final profile = await ref
          .read(profileRepositoryProvider)
          .getProfile(userId: antherUserId);
      return ChatProfile(
          id: profile!.userId,
          name: profile.name,
          phone: profile.phoneNumber,
          chatId: newChat.chatId,
      avatarUrl: profile.avatarUrl,);
    } catch (error, stackTrace) {
      log.e(error, stackTrace: stackTrace);
      state = ChatState(status: ChatStatus.error, error: error.toString());
    }
    return null;
  }

  Future<void> deleteChat({required String chatId}) async {
    try {
      state = const ChatState(status: ChatStatus.loading);
      await ref.read(chatRepositoryProvider).deleteChat(chatId: chatId);
      state = const ChatState(status: ChatStatus.deleted);
    } catch (error, stackTrace) {
      log.e(error, stackTrace: stackTrace);
      state = ChatState(status: ChatStatus.error, error: error.toString());
    }
  }
}
