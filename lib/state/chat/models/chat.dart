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
    @HiveField(3) DateTime? lastMessageTimestamp,
    // @Default(false) bool isGroup,
    // String? name,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
