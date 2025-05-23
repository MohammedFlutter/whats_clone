import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:whats_clone/core/routes/route_name.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/main.dart';
import 'package:whats_clone/state/auth/backend/authenticator.dart';
import 'package:whats_clone/state/auth/models/auth_result.dart';
import 'package:whats_clone/state/auth/models/auth_state.dart';
import 'package:whats_clone/state/chat/provider/chat_provider.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';
import 'package:whats_clone/state/message/provider/message_provider.dart';
import 'package:whats_clone/state/notification/providers/fcm_token_provider.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/state/providers/app_initializer.dart';

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  final Authenticator _authenticator = Authenticator();

  // Auth({required this.authenticator});

  @override
  AuthState build() {
    if (_authenticator.isAlreadyLoggedIn) {
      return AuthState(
          authResult: AuthResult.success,
          userId: _authenticator.userId,
          email: _authenticator.email,
          isLoading: false);
    }

    return AuthState.unknown();
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);

    final result = await _authenticator.signInWithGoogle();
    final userId = _authenticator.userId;
    final email = _authenticator.email;
    if (result == AuthResult.success && userId != null) {
      state = AuthState(
          authResult: result, userId: userId, email: email, isLoading: false);
    } else {
      log.i(result.toString());
      state = AuthState.unknown();
    }
  }

  Future<String> handleSuccessfulLogin() async {
    final userId = state.userId!;
    await ref
        .read(profileNotifierProvider.notifier)
        .loadProfile(userId: userId);

    final profileStatus = ref.read(profileNotifierProvider).status;

    if (profileStatus == ProfileStatus.loaded) {
      await ref.read(appInitializerProvider.notifier).initialize();
      return RouteName.chats;
    } else if (profileStatus == ProfileStatus.noProfile) {
      return RouteName.createProfile;
    } else if (profileStatus == ProfileStatus.error) {
      throw Exception('Error loading profile');
    } else {
      log.e('Unknown profile status: $profileStatus');
      return '';
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    var userId = state.userId;
    if (userId == null) return;
    await ref.read(fcmTokenRepositoryProvider).deleteToken(userId);
    await _authenticator.logout();
    await _cleanStorage();
    state = state.copyWith(isLoading: false, authResult: null);
  }

  Future<void> _cleanStorage() async {
    state = state.copyWith(isLoading: true);
    ref.invalidateSelf();
    await Hive.deleteBoxFromDisk(HiveBoxName.chats);
    await Hive.deleteBoxFromDisk(HiveBoxName.chatProfiles);
    await Hive.deleteBoxFromDisk(HiveBoxName.chatMessages);
    await Hive.deleteBoxFromDisk(HiveBoxName.fcmToken);
    await Hive.deleteBoxFromDisk(HiveBoxName.profiles);
    await Hive.deleteBoxFromDisk(HiveBoxName.profileCompletion);
    await openHiveBoxes();
    ref.invalidate(fcmTokenCacheProvider);
    ref.invalidate(profileCacheProvider);
    ref.invalidate(chatMessagesCacheProvider);
    ref.invalidate(chatProfileCacheProvider);
    ref.invalidate(profilesCacheProvider);
    state = state.copyWith(isLoading: false);

  }
}
