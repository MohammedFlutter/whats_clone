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
import 'package:whats_clone/state/profile/providers/profile_state_provider.dart';
import 'package:whats_clone/view/chats/chats_page.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
      chatService: ref.watch(chatServiceProvider),
      chatProfileCache: ref.watch(chatProfileCacheProvider));
});
final chatProfileRepositoryProvider = Provider<ChatProfileRepository>((ref) {
  return ChatProfileRepository(
    chatService: ref.watch(chatServiceProvider),
    profileService: ref.watch(profileServiceProvider),
    chatProfileCache: ref.watch(chatProfileCacheProvider),
  );
});

final chatProfileCacheProvider = Provider<ChatProfileCache>((_) {
  final chatProfileBox = Hive.box<ChatProfile>(HiveBoxName.chatProfiles);
  return ChatProfileCacheHive(chatProfileBox: chatProfileBox);
});
final chatServiceProvider = Provider<ChatService>(
  (_) => ChatServiceFirebase(),
);

final chatNotifierProvider =
    NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);
final chatProfileNotifierProvider =
    StreamNotifierProvider<ChatProfileNotifier, List<ChatProfile>>(
        ChatProfileNotifier.new);

final chatProfileSearchProvider =
    Provider.autoDispose<List<ChatProfile>>((ref) {
  final chatProfiles = ref.watch(chatProfileNotifierProvider).value;
  if (chatProfiles == null || chatProfiles.isEmpty) return [];
  final query = ref.watch(chatQueryProvider.notifier).state;
  return chatProfiles
      .where((chatProfile) =>
              chatProfile.name.toLowerCase().contains(query.toLowerCase()) ||
              chatProfile.phone.toLowerCase().contains(query.toLowerCase())
          // nice to add more search criteria
          )
      .toList();
});
