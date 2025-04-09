import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/chat/models/chat_state.dart';
import 'package:whats_clone/state/chat/notifier/chat_notifier.dart';
import 'package:whats_clone/state/chat/notifier/chat_profile_notifier.dart';
import 'package:whats_clone/state/chat/services/chat_profile_cache.dart';
import 'package:whats_clone/state/chat/services/chat_profile_repository.dart';
import 'package:whats_clone/state/chat/services/chat_repository.dart';
import 'package:whats_clone/state/chat/services/chat_service.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/view/chats/chats_page.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    chatService: ref.watch(chatServiceProvider),
  );
});
final chatProfileRepositoryProvider = Provider<ChatProfileRepository>((ref) {
  return ChatProfileRepository(
    chatService: ref.watch(chatServiceProvider),
    profileRepository: ref.watch(profilesRepositoryProvider),
    chatProfileCache: ref.watch(chatProfileCacheProvider),
  );
});

final chatProfileCacheProvider = AutoDisposeProvider<ChatProfileCache>((_) {
  final chatProfileBox = Hive.box<ChatProfile>(HiveBoxName.chatProfiles);
  return ChatProfileCacheHive(chatProfileBox: chatProfileBox);
});
final chatServiceProvider = Provider<ChatService>(
  (_) => ChatServiceFirebase(),
);

final chatNotifierProvider =
    NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);
final chatProfilesNotifierProvider =
    AutoDisposeStreamNotifierProvider<ChatProfileNotifier, List<ChatProfile>>(
        ChatProfileNotifier.new);
final chatProfilesDisplayedProvider = Provider<AsyncValue<List<ChatProfile>>>(
  (ref) {
    AsyncValue<List<ChatProfile>> chatProfiles =
        ref.watch(chatProfilesNotifierProvider);
    return chatProfiles.map(
      data: (data) => AsyncData(data.value
          .where(
            (chatProfile) =>
                chatProfile.lastMessageTimestamp != null &&
                chatProfile.lastMessage != null,
          )
          .toList()),
      error: (error) => error,
      loading: (loading) => loading,
    );
  },
);

final chatProfileSearchProvider =
    Provider.autoDispose<List<ChatProfile>>((ref) {
  final chatProfiles = ref.watch(chatProfilesDisplayedProvider).value;
  if (chatProfiles == null || chatProfiles.isEmpty) return [];
  final query = ref.watch(chatQueryProvider.notifier).state;
  return chatProfiles
      .where((chatProfile) =>
              chatProfile.name.toLowerCase().contains(query.toLowerCase()) ||
              chatProfile.phone.toLowerCase().contains(query.toLowerCase())
          // add more search criteria
          )
      .toList();
});

final chatProfileProvider = AutoDisposeProviderFamily<ChatProfile?, String>(
  (ref, arg) => ref
      .read(chatProfilesNotifierProvider.notifier)
      .getChatProfileByChatId(arg),
);
