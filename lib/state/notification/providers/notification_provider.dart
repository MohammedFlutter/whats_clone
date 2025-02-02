import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/notification/providers/fcm_token_provider.dart';
import 'package:whats_clone/state/notification/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(
    userId: ref.watch(authProvider).userId!,
    fcmTokenRepository: ref.watch(fcmTokenRepositoryProvider),
  ),
);
