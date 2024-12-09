import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {

  const factory ProfileState({
    Profile? profile,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ProfileState;

  const ProfileState._();

  bool get hasError => errorMessage != null;
  bool get isLoaded => profile != null && !isLoading && errorMessage == null;

}
