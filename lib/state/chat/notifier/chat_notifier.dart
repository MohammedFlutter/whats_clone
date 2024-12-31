import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/chat/repository/chat_repository.dart';
import 'package:whats_clone/core/utils/logger.dart';

class ChatNotifier extends StateNotifier<AsyncValue<List<Chat>>> {
  final ChatRepository _chatRepository;
  final String _userId;
  late final StreamSubscription<List<Chat>> _chatSubscription;

  ChatNotifier(this._chatRepository, this._userId)
      : super(const AsyncLoading()) {
    _fetchChats();
  }

  void _fetchChats() {
    _chatSubscription = _chatRepository.getChats(userId: _userId).listen(
      (chats) {
        state = AsyncData(chats);
      },
      onError: (error, stackTrace) {
        log.e(error);
        state = AsyncError(error, stackTrace);
      },
    );
  }

  Future<void> createChat({
    required List<String> memberIds,
    String? lastMessage,
    DateTime? lastMessageTimestamp,
  }) async {
    try {
      final newChat = await _chatRepository.createChat(
        memberIds: memberIds,
        lastMessage: lastMessage,
        lastMessageTimestamp: lastMessageTimestamp,
      );
      state = AsyncData([...?state.asData?.value, newChat]);
    } catch (error, stackTrace) {
      log.e(error.toString());

      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _chatRepository.deleteChat(chatId);
      state = AsyncData(
          state.asData?.value.where((chat) => chat.chatId != chatId).toList() ??
              []);
    } catch (error, stackTrace) {
      log.e(error);
      state = AsyncError(error, stackTrace);
    }
  }

  @override
  void dispose() {
    _chatSubscription.cancel();
    super.dispose();
  }
}
