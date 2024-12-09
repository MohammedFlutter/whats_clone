import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    @JsonKey(name: 'uid') required String userId,
    required String name,
    required String email,
    required String phone,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? bio,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
