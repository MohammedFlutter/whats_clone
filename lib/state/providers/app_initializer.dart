import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/notification/providers/notification_provider.dart';
import 'package:whats_clone/state/user_presence/provider/user_presence_provider.dart';

/// initialize mandatory functions after user register
final appInitializerProvider = NotifierProvider<AppInitializer, bool>(
  AppInitializer.new,
);

class AppInitializer extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> initialize() async {
    state = true;
    final userId = ref.read(authProvider).userId!;
    await ref.read(notificationServiceProvider).initialize();
    await ref.read(userPresenceServiceProvider).autoUserPresence(userId);
    // await Future.wait([
    //   ref.read(notificationServiceProvider).initialize(),
    //   // ref
    //   //     .read(permissionNotifierProvider(Permission.contacts).notifier)
    //   //     .handlePermissionStatus(onPermissionGranted: () {}),
    //   ref.read(userPresenceServiceProvider).autoUserPresence(userId),
    // ]);
    state = false;
  }
}
