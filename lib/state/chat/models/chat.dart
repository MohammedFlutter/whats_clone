import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
@HiveType(typeId: 1)
class Chat with _$Chat {
  const factory Chat({
    @HiveField(0) required String chatId,
    @HiveField(1) required List<String> memberIds,
    @HiveField(2) String? lastMessage,
    @HiveField(3)
    @JsonKey(fromJson: Chat._dateFromJson)
    DateTime? lastMessageTimestamp,
    @HiveField(4)
    @JsonKey(fromJson:Chat. _mapFromJson, toJson:Chat. _mapToJson)
    @Default(<String, int>{})
    Map<String, int> unreadMessageCount,
    // @Default(false) bool isGroup,
    // String? name,
  }) = _Chat;

  static DateTime? _dateFromJson(dynamic timestamp) {
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  static Map<String, int> _mapFromJson(dynamic json) {
    if (json is Map) {
      return json.map((key, value) => MapEntry(key.toString(), value as int));
    }
    return {};
  }

  static Map<String, dynamic> _mapToJson(Map<String, int> map) => map;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
