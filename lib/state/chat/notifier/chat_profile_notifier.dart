import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';

class ChatProfileNotifier extends StreamNotifier<List<ChatProfile>> {
  @override
  Stream<List<ChatProfile>> build() {
    final userId = ref.watch(authProvider).userId!;

    return ref
        .watch(chatProfileRepositoryProvider)
        .getChatProfiles(userId: userId)
      //   .map(
      // (chatProfiles) {
      //   return chatProfiles
      //       .where(
      //         (chat) =>
      //             chat.lastMessage != null && chat.lastMessageTimestamp != null,
      //       )
      //       .toList();
      // },
    // )
    ;
  }

  ChatProfile? getChatProfileByChatId(String chatId) =>
      state.asData?.value
          .where(
            (element) => element.chatId == chatId,
          )
          .firstOrNull;
}
