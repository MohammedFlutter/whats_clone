import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/chat/notifier/chat_notifier.dart';
import 'package:whats_clone/state/chat/repository/chat_repository.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final chatBox = Hive.box<Chat>(HiveBoxName.chats);
  return ChatRepository(chatBox);
});

final chatNotifierProvider =
    StateNotifierProvider.autoDispose.family<ChatNotifier, AsyncValue<List<Chat>>, String>(
  (ref, userId) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatNotifier(chatRepository, userId);
  },
);
