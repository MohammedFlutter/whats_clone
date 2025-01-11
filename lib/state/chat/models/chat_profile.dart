import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'chat_profile.freezed.dart';
part 'chat_profile.g.dart';

@freezed
@HiveType(typeId: 2)
class ChatProfile with _$ChatProfile {
  const factory ChatProfile({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String phone,
    @HiveField(3) required String chatId,
    @HiveField(4) required String? lastMessage,
    @HiveField(5) required DateTime? lastMessageTimestamp,
  }) = _ChatProfile;

  factory ChatProfile.fromJson(Map<String, dynamic> json) =>
      _$ChatProfileFromJson(json);
}
