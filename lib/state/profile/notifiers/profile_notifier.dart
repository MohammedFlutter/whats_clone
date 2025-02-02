import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/state/providers/app_initializer.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }

  /// Load a profile by userId.
  Future<void> loadProfile({required String userId}) async {
    state = state.copyWith(status: ProfileStatus.loading);
    try {
      final profile =
          await ref.watch(profileServiceProvider).getProfile(userId: userId);

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
      log.e(e);
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
      await ref.watch(profileServiceProvider).createProfile(profile: profile);

      state = state.copyWith(
        profile: profile,
        status: ProfileStatus.created,
      );
      await ref.read(appInitializerProvider.notifier).initialize();
    } catch (e) {
      log.e(e);
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
      await ref.watch(profileServiceProvider).updateProfile(profile: profile);

      state = state.copyWith(
        profile: profile,
        status: ProfileStatus.updated,
      );
    } catch (e) {
      log.e(e);
      state = state.copyWith(
        errorMessage: e.toString(),
        status: ProfileStatus.error,
      );
    }
  }
}
