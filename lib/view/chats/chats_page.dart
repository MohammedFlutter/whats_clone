import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/core/routes/route_params.dart';
import 'package:whats_clone/core/theme/app_colors.dart';
import 'package:whats_clone/core/theme/app_text_style.dart';
import 'package:whats_clone/core/utils/extensions/localization_extension.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
import 'package:whats_clone/state/providers/time_ago_provider.dart';
import 'package:whats_clone/view/widgets/app_list_tile.dart';
import 'package:whats_clone/view/widgets/app_search_bar.dart';

final chatQueryProvider = StateProvider<String>((ref) {
  return '';
});

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatProfilesAsync = ref.watch(chatProfilesDisplayedProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.chats)),
      body: Column(
        children: [
          AppSearchBar(
            hintText: context.l10n.searchChat,
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
    if (chatProfiles.isEmpty) {
      return Expanded(
          child: Center(child: Text(ref.context.l10n.noChatAvailable)));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: chatProfiles.length,
        itemBuilder: (context, index) {
          final chatProfile = chatProfiles[index];
          final timeAgo = ref.watch(timeAgoProvider(
              (chatProfile.lastMessageTimestamp!, context.l10n)));
          return AppListTile(
            onPressed: () {
              context.goNamed(
                RouteName.chatRoom,
                pathParameters: {RouteParams.chatId: chatProfile.chatId},
              );
            },
            avatarUrl: chatProfile.avatarUrl,
            title: chatProfile.name,
            subtitle: chatProfile.lastMessage ?? "",
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeAgo,
                  style: AppTextStyles.metadata1
                      .copyWith(color: AppColors.disable),
                ),
                const SizedBox(
                  height: 2,
                ),
                if (chatProfile.unreadMessageCount > 0)
                  Badge(
                    backgroundColor: AppColors.badgeBackground,
                    label: Text(
                      chatProfile.unreadMessageCount.toString(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
