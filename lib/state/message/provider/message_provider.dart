import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';
import 'package:whats_clone/state/message/models/chat_messages.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/notifier/message_notifier.dart';
import 'package:whats_clone/state/message/services/chat_messages_cache.dart';
import 'package:whats_clone/state/message/services/message_repository.dart';
import 'package:whats_clone/state/message/services/message_service.dart';

final chatMessagesCacheProvider = AutoDisposeProvider<ChatMessagesCache>((ref) {
  final chatMessagesBox = Hive.box<ChatMessages>(HiveBoxName.chatMessages);
  return ChatMessagesCacheHive(
    chatMessagesBox: chatMessagesBox,
  );
});
final messageServiceProvider = Provider<MessageService>((ref) {
  return MessageServiceFirebase();
});

final messageRepositoryProvider = AutoDisposeProvider<MessageRepository>((ref) {
  return MessageRepository(
    chatMessagesCache: ref.watch(chatMessagesCacheProvider),
    messageService: ref.watch(messageServiceProvider),
    chatService: ref.watch(chatRepositoryProvider),
  );
});

final messageNotifierProvider = AutoDisposeStreamNotifierProviderFamily<
    MessageNotifier, List<Message>, String>(
  () => MessageNotifier(),
);
