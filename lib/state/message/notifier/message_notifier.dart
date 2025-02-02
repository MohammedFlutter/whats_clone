import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
import 'package:whats_clone/state/message/models/chat_messages.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/provider/message_provider.dart';
import 'package:whats_clone/state/notification/providers/send_notification_provider.dart';

class MessageNotifier
    extends AutoDisposeFamilyStreamNotifier<ChatMessages, String> {
  @override
  Stream<ChatMessages> build(arg) {
    final userId = ref.read(authProvider).userId!;
    setupMessageCleanup(arg, userId);
    return ref.read(messageRepositoryProvider).getChatMessages(chatId: arg);
  }

  void setupMessageCleanup(
    String chatId,
    String userId,
  ) {
    cleanup() => ref
        .read(chatRepositoryProvider)
        .resetUnreadMessages(chatId: chatId, userId: userId);

    cleanup();
    ref.onDispose(cleanup);
    ref.onResume(cleanup);
    ref.onCancel(cleanup);
  }

  void sendMessage(String chatId, String content) {
    final senderId = ref.read(authProvider).userId!;

    final message = Message(
      chatId: chatId,
      content: content,
      senderId: senderId,
    );

    ref.read(messageRepositoryProvider).sendMessage(message: message);
    ref.read(
        sendMessageNotificationProvider((content: content, chatId: chatId)));
  }
}
