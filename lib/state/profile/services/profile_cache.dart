import 'package:hive/hive.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

abstract class ProfileCache {
  Profile? getCurrentProfile({required String userId});

  Future<void> setCurrentProfile({required Profile profile});

  bool isProfileCompleted({required String userId});
}

class ProfileCacheHive implements ProfileCache {
  final Box<Profile> profileBox;
  final Box<bool> profileCompletionBox;

  ProfileCacheHive(
      {required this.profileCompletionBox, required this.profileBox});

  @override
  Profile? getCurrentProfile({required String userId}) {
    return profileBox.get(userId);
  }

  @override
  Future<void> setCurrentProfile({required Profile profile}) async {
    await profileBox.put(profile.userId, profile);
    await profileCompletionBox.put(profile.userId, true);
  }

  @override
  bool isProfileCompleted({required String userId}) {
    return profileCompletionBox.get(userId) ?? false;
  }
}
