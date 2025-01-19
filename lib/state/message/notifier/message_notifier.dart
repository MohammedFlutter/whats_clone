import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/message/models/chat_messages.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/provider/message_provider.dart';

class MessageNotifier
    extends AutoDisposeFamilyStreamNotifier<ChatMessages, String> {
  @override
  Stream<ChatMessages> build(arg) {
    return ref.read(messageRepositoryProvider).getChatMessages(chatId: arg);
  }

  void sendMessage(String chatId, String content) {
    final message = Message(
      chatId: arg,
      content: content,
      senderId: ref.read(authProvider).userId!,
      // createdAt: DateTime.now(),
    );


    ref.read(messageRepositoryProvider).sendMessage(message: message);
  }
}
