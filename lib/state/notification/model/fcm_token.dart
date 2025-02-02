import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'fcm_token.freezed.dart';
part 'fcm_token.g.dart';

@HiveType(typeId: 5)
@freezed
class FcmToken with _$FcmToken {
  const factory FcmToken({
    @HiveField(0)@JsonKey(name: 'uid')required String userId,
    @HiveField(1) String? token,
  }) = _FcmToken;

  factory FcmToken.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenFromJson(json);
}
