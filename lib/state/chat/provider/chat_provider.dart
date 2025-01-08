import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/chat/notifier/chat_notifier.dart';
import 'package:whats_clone/state/chat/services/chat_cache.dart';
import 'package:whats_clone/state/chat/services/chat_repository.dart';
import 'package:whats_clone/state/chat/services/chat_service.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
      chatCache: ref.watch(chatCacheProvider),
      chatService: ref.watch(chatServiceProvider));
});

final chatCacheProvider = Provider<ChatCache>((_) {
  final chatBox = Hive.box<Chat>(HiveBoxName.chats);
  return ChatCacheHive(chatBox: chatBox);
});
final chatServiceProvider = Provider<ChatService>(
  (_) => ChatServiceFirebase(),
);

final chatNotifierProvider =
    StreamNotifierProvider<ChatNotifier, List<Chat>>(ChatNotifier.new);
