// import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/notification/providers/notification_provider.dart';
import 'package:whats_clone/state/providers/permission_provider.dart';
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

    await Future.wait([
      ref.read(notificationServiceProvider).initialize(),
      ref
          .read(permissionNotifierProvider(Permission.contacts).notifier)
          .handlePermissionStatus(onPermissionGranted: () {}),
      _initializeHive(),
      ref.read(userPresenceServiceProvider).autoUserPresence(userId),
    ]);
    state = false;
  }

  Future<void> _initializeHive() {
    return Future.wait([
      // Hive.openBox<ChatProfile>(HiveBoxName.chatProfiles),
      // Hive.openBox<ChatMessages>(HiveBoxName.chatMessages),
    ]);
  }
//       await Hive.openBox<ChatProfile>(HiveBoxName.chatProfiles);
// await Hive.openBox<ChatMessages>(HiveBoxName.chatMessages);
//
}
