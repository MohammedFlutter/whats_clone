import 'package:whats_clone/state/auth/backend/authenticator.dart';
import 'package:whats_clone/state/auth/models/auth_result.dart';
import 'package:whats_clone/state/auth/models/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:whats_clone/utils/logger.dart';

part 'auth.g.dart';

@riverpod
class Auth extends _$Auth {
  final Authenticator _authenticator = Authenticator();

  // Auth({required this.authenticator});

  @override
  AuthState build() {
    return AuthState.unknown();
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true);

    final result = await _authenticator.signInWithGoogle();
    final userId = _authenticator.userId;
    if (result == AuthResult.success && userId != null) {
      state = AuthState(authResult: result, userId: userId, isLoading: false);
    } else {
      log.i(result.toString());
      state = AuthState.unknown();
    }
  }
}
