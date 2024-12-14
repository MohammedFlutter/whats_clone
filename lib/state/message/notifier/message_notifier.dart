import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/repository/message_repository.dart';

class MessageNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final MessageRepository _repository;

  MessageNotifier(this._repository) : super(const AsyncValue.loading());

  /// Loads messages for a specific chat and listens to updates.
  void loadMessages(String chatId) {
    _repository.listenToMessages(chatId).listen(
      (messages) {
        state = AsyncValue.data(messages);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  /// Sends a new message.
  Future<void> sendMessage(Message message) async {
    try {
      await _repository.sendMessage(message);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Deletes a specific message.
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _repository.deleteMessage(chatId, messageId);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
