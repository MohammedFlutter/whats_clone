import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/auth/provider/auth.dart';
import 'package:whats_clone/state/onboarding/onboarding_provider.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_state_provider.dart';

class SplashNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<String> initialize() async {
    state = const AsyncValue.loading();

    try {
      // Check onboarding status
      final isFirstTime = ref.read(onboardingProvider);
      if (isFirstTime) {
        return RouteName.onboarding;
      }

      // Check authentication status
      final authState = ref.read(authProvider);
      if (authState.userId == null) {
        return RouteName.login;
      }

      // Load user profile
      final userId = authState.userId!;
      await ref
          .read(profileNotifierProvider.notifier)
          .loadProfile(userId: userId);

      final profileStatus = ref.read(profileNotifierProvider).status;
      if (profileStatus == ProfileStatus.noProfile) {
        return RouteName.createProfile;
      }

      return RouteName.home;
    } catch (e, st) {
      log.e(
        'Error initializing app: $e',
      );
      state = AsyncValue.error(e, st);
      return RouteName.login;
    }
  }
}
