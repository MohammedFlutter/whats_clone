import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/l10n/app_localizations.dart';
import 'package:whats_clone/state/providers/time_ago_provider.dart';
import 'package:whats_clone/state/user_presence/model/user_presence.dart';
import 'package:whats_clone/state/user_presence/service/user_presence_service.dart';

final userPresenceServiceProvider =
    Provider<UserPresenceService>((ref) => UserPresenceServiceFirebase());

final userPresenceProvider = StreamProviderFamily<UserPresence?, String>(
  (ref, arg) => ref.watch(userPresenceServiceProvider).getUserPresence(arg),
);

final subtitleChatRoomProvider = ProviderFamily<String, (String uid, AppLocalizations l10n)>(
        (ref, args) {
        final uid = args.$1;
        final l10n = args.$2;

        final userPresence = ref.watch(userPresenceProvider(uid)).value;
        if (userPresence == null) return '';
        if (userPresence.isOnline ?? false) return l10n.online;
        if (userPresence.lastSeen == null) return '';
        final timeAgo = ref.watch(timeAgoProvider((userPresence.lastSeen!, l10n)));
        return timeAgo;
    },
);