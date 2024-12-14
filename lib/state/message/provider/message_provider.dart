import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/message/models/message.dart';
import 'package:whats_clone/state/message/notifier/message_notifier.dart';
import 'package:whats_clone/state/message/repository/message_repository.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository();
});

final messageNotifierProvider =
    StateNotifierProvider<MessageNotifier, AsyncValue<List<Message>>>((ref) {
  final repository = ref.read(messageRepositoryProvider);
  return MessageNotifier(repository);
});
