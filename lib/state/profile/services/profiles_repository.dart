import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/services/profile_service.dart';
import 'package:whats_clone/state/profile/services/profiles_cache.dart';

class ProfilesRepository {
  ProfilesRepository(
      {required ProfileService profileService,
      required ProfilesCache profilesCache})
      : _profileService = profileService,
        _profilesCache = profilesCache;

  final ProfileService _profileService;
  final ProfilesCache _profilesCache;

  Future<List<Profile>> getProfiles(List<String> userIds) async {
    return _fetchProfiles(
      fetchFunction: () =>
          _profileService.getProfileByUserIds(userIds: userIds),
      fallback: () => _profilesCache.getCachedProfiles(userIds),
    );
  }

  //
  Future<List<Profile>> getProfilesByPhoneNumbers(
      List<String> phoneNumbers) async {
    return _fetchProfiles(
      fetchFunction: () =>
          _profileService.getProfilesByPhoneNumbers(phoneNumbers),
      fallback: () =>
          _profilesCache.getCachedProfilesByPhoneNumbers(phoneNumbers),
    );
  }

  Future<List<Profile>> getProfileFromCacheFirst(List<String> userIds) async {
    final cachedProfiles = _profilesCache.getCachedProfiles(userIds);
    final cachedIds = cachedProfiles.map((profile) => profile.userId).toSet();
    final missingIds = userIds.where((id) => !cachedIds.contains(id)).toList();

    final missingProfiles = await _fetchProfiles(
      fetchFunction: () =>
          _profileService.getProfileByUserIds(userIds: missingIds),
      fallback: () => <Profile>[],
    );

    return [...cachedProfiles, ...missingProfiles];
  }

  Future<List<Profile>> _fetchProfiles({
    required Future<List<Profile>> Function() fetchFunction,
    required List<Profile> Function() fallback,
  }) async {
    try {
      final profiles = await fetchFunction();
      _profilesCache.updateCacheProfiles(profiles);
      return profiles;
    } catch (e, s) {
      log.e(e, stackTrace: s);
      return fallback();
    }
  }
}
