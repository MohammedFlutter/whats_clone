import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whats_clone/state/auth/models/auth_result.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthResult? authResult,
    required String? userId,
    required bool isLoading,
  }) = _AuthState;

  factory AuthState.unknown() => const AuthState(
        isLoading: false,
        userId: null,
        authResult: null,
      );
}
