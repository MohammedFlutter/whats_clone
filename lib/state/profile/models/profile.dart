import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
@HiveType(typeId: 0)
class Profile with _$Profile {
  const factory Profile({
    @HiveField(0) @JsonKey(name: 'uid') required String userId,
    @HiveField(1) required String name,
    @HiveField(3) @JsonKey(name: 'phone_number') required String phoneNumber,
    @HiveField(4) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(5) @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @HiveField(6) @JsonKey(name: 'avatar_url') String? avatarUrl,
    @HiveField(7) String? bio,
    @HiveField(2) String? email,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
