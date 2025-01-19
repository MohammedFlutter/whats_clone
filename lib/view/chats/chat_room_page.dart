import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/provider/message_provider.dart';
import 'package:whats_clone/view/chats/widgets/footer_chat_room.dart';
import 'package:whats_clone/view/chats/widgets/message_card.dart';

class ChatRoomPage extends ConsumerWidget {
  ChatRoomPage({super.key, required this.chatProfile});

  final ChatProfile chatProfile;
  final ScrollController _scrollController = ScrollController();
  final _messageFieldController = TextEditingController();

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
                  .read(messageNotifierProvider(chatProfile.chatId).notifier)
                  .sendMessage(chatProfile.chatId, ref.read(draftText));
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
