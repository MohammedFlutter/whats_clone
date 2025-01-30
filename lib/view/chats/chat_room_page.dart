import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/provider/message_provider.dart';
import 'package:whats_clone/state/user_presence/provider/user_presence_provider.dart';
import 'package:whats_clone/view/chats/widgets/footer_chat_room.dart';
import 'package:whats_clone/view/chats/widgets/message_card.dart';

class ChatRoomPage extends ConsumerWidget {
  ChatRoomPage({required this.chatId, super.key});

  final String chatId;
  final ScrollController _scrollController = ScrollController();
  final _messageFieldController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesState = ref.watch(messageNotifierProvider(chatId));
    final chatProfile = ref.watch(chatProfileProvider(chatId));
    if (chatProfile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(chatProfile.name),
            Text(
              ref.watch(subtitleChatRoomProvider(chatProfile.id)),
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesState.when(
              data: (data) {
                return _buildListMessage(data.messages.reversed.toList());
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
          FooterChatRoom(
            controller: _messageFieldController,
            onSend: () {
              ref
                  .read(messageNotifierProvider(chatId).notifier)
                  .sendMessage(chatId, ref.read(draftText));
              _resetDraft(ref);
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }

  void _resetDraft(WidgetRef ref) {
    _messageFieldController.text = '';
    ref.read(draftText.notifier).state = '';
  }

  Widget _buildListMessage(List<Message> messages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        reverse: true,
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) => MessageCard(message: messages[index]),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
