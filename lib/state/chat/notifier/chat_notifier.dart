import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';

class ChatNotifier extends StreamNotifier<List<Chat>> {
  @override
  Stream<List<Chat>> build() {
    final userId = ref.read(authProvider).userId!;

    return ref.read(chatRepositoryProvider).getChats(userId: userId);
  }

  Future<void> createChat({required String antherUserId}) async {
    try {
      final userId = ref.read(authProvider).userId!;
      await ref
          .read(chatRepositoryProvider)
          .createChat(userId1: userId, userId2: antherUserId);
    } catch (error, stackTrace) {
      log.e(error, stackTrace: stackTrace);
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await ref.read(chatRepositoryProvider).deleteChat(chatId);
    } catch (error, stackTrace) {
      log.e(error, stackTrace: stackTrace);
    }
  }
}
