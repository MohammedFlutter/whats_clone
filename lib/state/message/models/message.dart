import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String messageId,
    required String senderId,
    required String chatId,
    required String content,
    required DateTime createdAt,
    @Default(MessageState.wait) MessageState state,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

enum MessageState {
  wait,
  receivedServer,
  receivedClient,
  viewed,
}
