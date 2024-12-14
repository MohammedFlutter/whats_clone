import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String chatId,
    required List<String> memberIds,
    // @Default(false) bool isGroup,
    // String? name,
    String? lastMessage,
    DateTime? lastMessageTimestamp,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
