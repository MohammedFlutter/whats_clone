import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/services/profile_cache.dart';
import 'package:whats_clone/state/profile/services/profile_service.dart';

class ProfileRepository {
  ProfileRepository({
    required ProfileCache profileCache,
    required ProfileService profileService,
  })  : _profileCache = profileCache,
        _profileService = profileService;

  final ProfileCache _profileCache;
  final ProfileService _profileService;

  Future<Profile?> getProfile({required String userId}) async {
    final cachedProfile = _profileCache.getCurrentProfile(userId: userId);
    if (cachedProfile != null) {
      return cachedProfile;
    }

    final profile = await _profileService.getProfile(userId: userId);
    if (profile != null) {
      _profileCache.setCurrentProfile(profile: profile);
    }
    return profile;
  }

  Future<void> createProfile({required Profile profile}) async {
    await _profileService.createProfile(profile: profile);
    await _profileCache.setCurrentProfile(profile: profile);
  }

  Future<void> updateProfile({required Profile profile}) async {
    await _profileService.updateProfile(profile: profile);
    await _profileCache.setCurrentProfile(profile: profile);
  }
}
