import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    @JsonKey(name: 'uid') required String userId,
     String? name,
    String? email,
    @JsonKey(name: 'phone_number')  String? phoneNumber,
    @JsonKey(name: 'created_at')  DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? bio,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
