import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    Profile? profile,
    String? errorMessage,
    @Default(ProfileStatus.initial) ProfileStatus status,
  }) = _ProfileState;

  const ProfileState._();
}

enum ProfileStatus {
  initial,
  loading,
  loaded,
  noProfile,
  created,
  updated,
  error,
}
