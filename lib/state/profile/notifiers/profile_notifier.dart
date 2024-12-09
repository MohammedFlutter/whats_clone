import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/profile/backend/profile_storage.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';


class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileStorage _profileStorage;

  ProfileNotifier(this._profileStorage) : super(const ProfileState());

  /// Load a profile by userId.
  Future<void> loadProfile({required String userId}) async {
    state = state.copyWith(isLoading: true);
    try {
      final profile = await _profileStorage.getProfile(userId: userId);
      if (profile == null) {
        state = state.copyWith(
          errorMessage: 'Profile not found.',
          isLoading: false,
        );
        return;
      }
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Create a new profile.
  Future<void> createProfile(Profile profile) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _profileStorage.createProfile(profile: profile);
      if (!success) {
        state = state.copyWith(
          errorMessage: 'Profile already exists.',
          isLoading: false,
        );
        return;
      }
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Update an existing profile.
  Future<void> updateProfile(Profile profile) async {
    state = state.copyWith(isLoading: true);
    try {
      await _profileStorage.updateProfile(profile: profile);
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Clear errors in the state.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset the state to its initial values.
  void resetState() {
    state = const ProfileState();
  }
}
