import 'package:hive/hive.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

abstract class ProfilesCache {
  Future<void> updateCacheProfiles(
    List<Profile> profiles,
  );

  List<Profile> getCachedProfiles(List<String> userIds);

  List<Profile> getCachedProfilesByPhoneNumbers(List<String> phoneNumbers);
}

class ProfilesCacheHive implements ProfilesCache {
  final Box<Profile> profileBox;

  ProfilesCacheHive({required this.profileBox});

  @override
  Future<void> updateCacheProfiles(
    List<Profile> profiles,
  ) async {
    await profileBox.clear();
    for (final profile in profiles) {
      await profileBox.put(profile.userId, profile);
    }
  }

  @override
  List<Profile> getCachedProfiles(List<String> userIds) {
    return userIds
        .map((phone) => profileBox.get(phone))
        .where((profile) => profile != null)
        .cast<Profile>()
        .toList();
  }

  @override
  List<Profile> getCachedProfilesByPhoneNumbers(List<String> phoneNumbers) {
    return profileBox.values
          .where(
            (profile) => phoneNumbers.contains(profile.phoneNumber),
          )
          .toList();
  }
}
