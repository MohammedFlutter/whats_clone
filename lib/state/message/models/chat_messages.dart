import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whats_clone/state/message/models/message.dart';

part 'chat_messages.freezed.dart';
part 'chat_messages.g.dart';

@HiveType(typeId: 4)
@freezed
class ChatMessages with _$ChatMessages {
  const factory ChatMessages({
    @HiveField(0)
    required String chatId,
    @HiveField(1)
    required List<Message> message,
  }) = _ChatMessages;

  factory ChatMessages.fromJson(Map<String, dynamic> json) =>
      _$ChatMessagesFromJson(json);
}
