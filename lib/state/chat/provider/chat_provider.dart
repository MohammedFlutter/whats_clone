import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/chat/models/chat_profile.dart';
import 'package:whats_clone/state/chat/notifier/chat_notifier.dart';
import 'package:whats_clone/state/chat/services/chat_profile_cache.dart';
import 'package:whats_clone/state/chat/services/chat_profile_repository.dart';
import 'package:whats_clone/state/chat/services/chat_repository.dart';
import 'package:whats_clone/state/chat/services/chat_service.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';
import 'package:whats_clone/state/profile/providers/profile_state_provider.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(chatService: ref.watch(chatServiceProvider));
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
    NotifierProvider<ChatNotifier, void>(ChatNotifier.new);

//
// final chatProfileProvider = Provider<ChatProfile>((ref) {
//   return ChatProfile(
//     chatRepository: ref.watch(chatRepositoryProvider),
//   );
// });
