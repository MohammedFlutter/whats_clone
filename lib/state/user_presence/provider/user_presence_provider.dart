import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/providers/time_ago_provider.dart';
import 'package:whats_clone/state/user_presence/model/user_presence.dart';
import 'package:whats_clone/state/user_presence/service/user_presence_service.dart';
import 'package:whats_clone/view/constants/strings.dart';

final userPresenceServiceProvider =
    Provider<UserPresenceService>((ref) => UserPresenceServiceFirebase());

final userPresenceProvider = StreamProviderFamily<UserPresence?, String>(
  (ref, arg) => ref.watch(userPresenceServiceProvider).getUserPresence(arg),
);

final subtitleChatRoomProvider = ProviderFamily<String, String>(
  (ref, arg) {
    final userPresence = ref.watch(userPresenceProvider(arg)).value;
    if (userPresence == null ) return '';
    if (userPresence.isOnline ?? false) return Strings.online;
    if( userPresence.lastSeen == null)return '';
    final timeAgo = ref.watch(timeAgoProvider(userPresence.lastSeen!));
    return timeAgo;
  },
);
