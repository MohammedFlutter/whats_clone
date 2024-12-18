import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/profile/backend/profile_storage.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileStorage profileStorage;
  final Box<Profile> profileBox;
  final Box<bool> profileCompletionBox;

  ProfileNotifier({
    required this.profileStorage,
    required this.profileBox,
    required this.profileCompletionBox,
  }) : super(const ProfileState());

  /// Load a profile by userId.
  Future<void> loadProfile({required String userId}) async {
    state = state.copyWith(status: ProfileStatus.loading);
    try {
      Profile? localProfile = profileBox.get(userId);

      if (localProfile == null) {
        // If no local profile, fetch from backend
        final profile = await profileStorage.getProfile(userId: userId);

        if (profile == null) {
          state = state.copyWith(
            status: ProfileStatus.noProfile,
          );
          return;
        }

        // Save to local storage
        await profileBox.put(userId, profile);
        localProfile = profile;
      }

      state = state.copyWith(
        profile: localProfile,
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
      // Create profile in backend
      await profileStorage.createProfile(profile: profile);

      // Save to local Hive storage
      await profileBox.put(profile.userId, profile);

      // Mark profile as incomplete by default
      await profileCompletionBox.put(profile.userId, true);

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
      // Update profile in backend
      await profileStorage.updateProfile(profile: profile);

      // Update local Hive storage
      await profileBox.put(profile.userId, profile);

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
