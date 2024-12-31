import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>(
  (_) => OnboardingNotifier(),
);

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(_getOnboardingStatus());
  static const _keyName = 'isFirstTime';

  Box<bool> get _onboardingBox => Hive.box<bool>(HiveBoxName.onboarding);

  static bool _getOnboardingStatus() {
    final box = Hive.box<bool>(HiveBoxName.onboarding);
    return box.get(_keyName) ?? true; // Default to true (first time)
  }

  Future<void> setOnboardingComplete() async {
    await _onboardingBox.put(_keyName, false);
    state = false;
  }
}
