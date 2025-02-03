import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
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
    @HiveField(4)
    @JsonKey(name: 'created_at', fromJson: Profile._timestampFromJson)
    DateTime? createdAt,
    @HiveField(5)
    @JsonKey(name: 'updated_at', fromJson: Profile._timestampFromJson)
    DateTime? updatedAt,
    @HiveField(6) @JsonKey(name: 'avatar_url') String? avatarUrl,
    @HiveField(7) String? bio,
    @HiveField(2) String? email,
  }) = _Profile;

  static DateTime? _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return null;
  }

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
