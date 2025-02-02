import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
import 'package:whats_clone/state/notification/providers/fcm_token_provider.dart';
import 'package:whats_clone/state/notification/services/send_notification.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';

final sendNotificationProvider = Provider<SendNotification>(
  (ref) => SendNotification(
      fcmTokenRepository: ref.watch(fcmTokenRepositoryProvider)),
);

final sendMessageNotificationProvider =
    ProviderFamily<void, ({String chatId, String content})>(
  (ref, arg) {
    final recipientChatProfile = ref
        .read(chatProfilesNotifierProvider.notifier)
        .getChatProfileByChatId(arg.chatId)!;
    final name = ref.watch(profileNotifierProvider).profile?.name;



    ref.read(sendNotificationProvider).sendNotification(
      title: name!,
      recipientId: recipientChatProfile.id,
      description: arg.content,
      data: {"chatId": arg.chatId, "type": "message"},
    );
  },
);
