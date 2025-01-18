import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
import 'package:whats_clone/state/providers/time_ago_provider.dart';
import 'package:whats_clone/view/constants/strings.dart';
import 'package:whats_clone/view/widgets/app_list_tile.dart';
import 'package:whats_clone/view/widgets/app_search_bar.dart';

final chatQueryProvider = StateProvider<String>((ref) {
  return '';
});

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatProfilesAsync = ref.watch(chatProfileNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.chats)),
      body: Column(
        children: [
          AppSearchBar(
            hintText: Strings.searchChat,
            onChanged: (query) {
              ref.read(chatQueryProvider.notifier).state = query;
            },
          ),
          chatProfilesAsync.when(
            data: (chatProfiles) {
              if (ref.watch(chatQueryProvider).isEmpty) {
                return _buildChatList(chatProfiles, ref);
              } else {
                final filteredChatProfiles =
                    ref.watch(chatProfileSearchProvider);

                return _buildChatList(filteredChatProfiles, ref);
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(List<ChatProfile> chatProfiles, WidgetRef ref) {
    return Expanded(
      child: ListView.builder(
        itemCount: chatProfiles.length,
        itemBuilder: (context, index) {
          final chatProfile = chatProfiles[index];
          final timeAgo =
              ref.watch(timeAgoProvider(chatProfile.lastMessageTimestamp!));
          return AppListTile(
            onPressed: () {
              context.goNamed(RouteName.chatRoom, extra: chatProfile);
            },
            avatarUrl: chatProfile.avatarUrl,
            title: chatProfile.name,
            subtitle: chatProfile.lastMessage ?? "",
            trailing: timeAgo,
          );
        },
      ),
    );
  }
}
