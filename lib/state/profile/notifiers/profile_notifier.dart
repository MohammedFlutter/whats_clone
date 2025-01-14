import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/services/profile_repository.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _profileService;

  ProfileNotifier({
    required ProfileRepository profileService,
  }) : _profileService = profileService, super(const ProfileState());

  /// Load a profile by userId.
  Future<void> loadProfile({required String userId}) async {
    state = state.copyWith(status: ProfileStatus.loading);
    try {
      final profile = await _profileService.getProfile(userId: userId);

      if (profile == null) {
        state = state.copyWith(
          status: ProfileStatus.noProfile,
        );
        return;
      }
      state = state.copyWith(
        profile: profile,
        status: ProfileStatus.loaded,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        status: ProfileStatus.error,
      );
    }
  }

  /// Create a new profile.
  Future<void> createProfile(Profile profile) async {
    state = state.copyWith(status: ProfileStatus.loading);
    try {
      await _profileService.createProfile(profile: profile);

      state = state.copyWith(
        profile: profile,
        status: ProfileStatus.created,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        status: ProfileStatus.error,
      );
    }
  }

  /// Update an existing profile.
  Future<void> updateProfile(Profile profile) async {
    state = state.copyWith(status: ProfileStatus.loading);
    try {
      await _profileService.updateProfile(profile: profile);

      state = state.copyWith(
        profile: profile,
        status: ProfileStatus.updated,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        status: ProfileStatus.error,
      );
    }
  }
}
