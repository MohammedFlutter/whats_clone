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
        .getChatProfiles(userId: userId);
  }

  List<ChatProfile> search(String query) {
    final chatProfiles = state.value;
    if (chatProfiles == null || chatProfiles.isEmpty) return [];
    return chatProfiles
        .where((chatProfile) =>
                chatProfile.name.toLowerCase().contains(query.toLowerCase()) ||
                chatProfile.phone.toLowerCase().contains(query.toLowerCase())
            // nice to add more search criteria
            )
        .toList();
  }
}
