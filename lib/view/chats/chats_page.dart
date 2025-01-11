import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
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
                return _buildChatList(chatProfiles);
              } else {
                final filteredChatProfiles = ref
                    .watch(chatProfileSearchProvider);

                return _buildChatList(filteredChatProfiles);
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

  String timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildChatList(List<ChatProfile> chatProfiles) {
    return ListView.builder(
      itemCount: chatProfiles.length,
      itemBuilder: (context, index) {
        final chatProfile = chatProfiles[index];
        return AppListTile(
          onPressed: () {},
          title: chatProfile.name,
          subtitle: chatProfile.lastMessage ?? "",
          trailing: timeAgo(chatProfile.lastMessageTimestamp!),
        );
      },
    );
  }
}
