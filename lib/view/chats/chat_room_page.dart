import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/provider/message_provider.dart';
import 'package:whats_clone/view/chats/widgets/footer_chat_room.dart';
import 'package:whats_clone/view/chats/widgets/message_card.dart';

class ChatRoomPage extends ConsumerWidget {
  final ChatProfile chatProfile;

  const ChatRoomPage({super.key, required this.chatProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesState =
        ref.watch(messageNotifierProvider(chatProfile.chatId));
    return Scaffold(
      appBar: AppBar(
        title: Text(chatProfile.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesState.when(
              data: (data) => _buildListMessage(data.messages),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
          FooterChatRoom(
            () => ref
                .read(messageNotifierProvider(chatProfile.chatId).notifier)
                .sendMessage(chatProfile.chatId, ref.read(draftText)),
          ),
        ],
      ),
    );
  }

  Widget _buildListMessage(List<Message> messages) {
    return ListView.builder(
      reverse: true,
      // controller: ScrollController().,
      itemCount: messages.length,
      itemBuilder: (context, index) => MessageCard(message: messages[index]),
    );
  }
}
