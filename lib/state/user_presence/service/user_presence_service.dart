import 'package:firebase_database/firebase_database.dart';
import 'package:whats_clone/core/utils/extensions/database_reference_extension.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/user_presence/model/user_presence.dart';

abstract class UserPresenceService {
  Stream<UserPresence?> getUserPresence(String userId);

  Future<void> autoUserPresence(
    String userId,
  );

  Future<void> updateUserPresence(String userId, {bool isOnline = true});
}

class UserPresenceServiceFirebase implements UserPresenceService {
  final ref =
      FirebaseDatabase.instance.ref(FirebaseCollectionName.usersPresence);

  @override
  Future<void> autoUserPresence(String userId) async {
    final userPresenceRef = ref.child(userId);
    await userPresenceRef.set(const UserPresence(isOnline: true).toJson());

    const userOffline = UserPresence(isOnline: false);
    final json = userOffline.toJson()
      ..addAll({'lastSeen': ServerValue.timestamp});
    await userPresenceRef.onDisconnect().set(json);
  }

  @override
  Stream<UserPresence?> getUserPresence(String userId) {
    return ref.getStreamFromDatabase<UserPresence?>(
        path: userId, fromJson: UserPresence.fromJson, defaultValue: null);
  }

  @override
  Future<void> updateUserPresence(String userId, {bool isOnline = true}) {
    final userPresenceRef = ref.child(userId);
    if (isOnline) {
      return userPresenceRef.set(const UserPresence(isOnline: true).toJson());
    } else {
      const userOffline = UserPresence(isOnline: false);
      final json = userOffline.toJson()
        ..addAll({'lastSeen': ServerValue.timestamp});
      return userPresenceRef.set(json);
    }
  }
}
