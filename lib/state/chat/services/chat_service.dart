import 'package:firebase_database/firebase_database.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';

abstract class ChatService {
  Future<void> createChat({required String userId1, required String userId2});

  Stream<List<Chat>> getChatsByUserId({required String userId});

  Future<void> updateChat({required Chat chat});

  Future<void> deleteChat({required String chatId});
}

class ChatServiceFirebase implements ChatService {
  final _chatsCollection = FirebaseDatabase.instance.ref();

  @override
  Future<void> createChat({required String userId1, required String userId2}) {
    final chatId = _chatsCollection.push().key;
    if (chatId == null) {
      throw Exception('Chat ID is null');
    }

    final update = <String, Object?>{};
    update['${FirebaseCollectionName.chats}/$chatId'] =
        Chat(chatId: chatId, memberIds: [userId1, userId2]).toJson();
    update['${FirebaseCollectionName.usersChats}/$userId1}'] = true;
    update['${FirebaseCollectionName.usersChats}/$userId2}'] = true;

    return _chatsCollection.update(update);
  }

  @override
  Stream<List<Chat>> getChatsByUserId({required String userId}) {
    final streamOfChatIds =
        _chatsCollection.child(FirebaseCollectionName.usersChats).onValue.map(
      (event) {
        final data = event.snapshot.value as Map<String, dynamic>?;
        return data?.keys.toList();
      },
    );

    return _mapChatIdsToChats(streamOfChatIds);
  }

  Future<Chat?> _getChatById(String chatId) async {
    var dataSnapshot = await _chatsCollection
        .child(FirebaseCollectionName.chats)
        .child(chatId)
        .get();
    final json = dataSnapshot.value as Map<String, dynamic>?;

    if (json == null) {
      return null;
    } else {
      return Chat.fromJson(json);
    }
  }

  Stream<List<Chat>> _mapChatIdsToChats(
      Stream<List<String>?> streamOfChatIds) async* {
    List<Chat> previousChats = [];

    await for (final chatIds in streamOfChatIds) {
      if (chatIds == null || chatIds.isEmpty) {
        // Yield an empty list if no chat IDs are present
        if (previousChats.isNotEmpty) {
          previousChats = [];
          yield [];
        }
        continue;
      }

      // Fetch chats in parallel
      final chats = await Future.wait(
        chatIds.map((chatId) => _getChatById(chatId)),
      );

      // Remove any null values
      final validChats = chats.whereType<Chat>().toList();

      validChats.sort((a, b) {
        final aTimestamp = a.lastMessageTimestamp ?? DateTime(0);
        final bTimestamp = b.lastMessageTimestamp ?? DateTime(0);
        return bTimestamp.compareTo(aTimestamp);
      });

      // Yield only if chats have changed
      if (previousChats != validChats) {
        previousChats = validChats;
        yield validChats;
      }
    }
  }

  @override
  Future<void> deleteChat({required String chatId}) async {
    final chat = await _chatsCollection
        .child(FirebaseCollectionName.chats)
        .child(chatId)
        .get()
        .then(
      (value) {
        final json = value.value as Map<String, dynamic>?;
        if (json == null) {
          return null;
        } else {
          return Chat.fromJson(json);
        }
      },
    );
    if (chat == null) {
      return;
    }

    _chatsCollection.child(FirebaseCollectionName.chats).child(chatId).remove();
    for (final memberId in chat.memberIds) {
      _chatsCollection
          .child(FirebaseCollectionName.usersChats)
          .child(memberId)
          .child(chatId)
          .remove();
    }
  }

  @override
  Future<void> updateChat({required Chat chat}) => _chatsCollection
      .child(FirebaseCollectionName.chats)
      .child(chat.chatId)
      .update(chat.toJson());
}
