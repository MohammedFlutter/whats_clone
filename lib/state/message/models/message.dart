import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@HiveType(typeId: 3)
@freezed
class Message with _$Message {
  const factory Message({
    @HiveField(0)  String? messageId,
    @HiveField(1) required String senderId,
    @HiveField(2) required String chatId,
    @HiveField(3) required String content,
    @HiveField(4) required DateTime createdAt,
    // @HiveField(5) @Default(MessageState.wait) MessageState state,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
//
// enum MessageState {
//   wait,
//   receivedServer,
//   receivedClient,
//   viewed,
// }
