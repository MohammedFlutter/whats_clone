import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(ChatStatus.initial) ChatStatus status,
    String? error,
  }) = _ChatState;
}

enum ChatStatus { initial, loading, created, deleted, error }
