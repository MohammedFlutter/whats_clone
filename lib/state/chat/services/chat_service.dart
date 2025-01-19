import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';

abstract class ChatService {
  Future<Chat> createChat({required String userId1, required String userId2});

  Stream<List<Chat>> getChatsByUserId({required String userId});

  Future<void> updateChat({
    required String chatId,
    required String lastMessage,
  });

  Future<void> deleteChat({required String chatId});
}

class ChatServiceFirebase implements ChatService {
  final _chatsCollection = FirebaseDatabase.instance.ref();

  @override
  Future<Chat> createChat(
      {required String userId1, required String userId2}) async {
    final chatId =
        _chatsCollection.child(FirebaseCollectionName.chats).push().key;
    if (chatId == null) {
      throw Exception('Chat ID is null');
    }
    final chat = Chat(chatId: chatId, memberIds: [userId1, userId2]);

    final update = <String, Object?>{};
    update['${FirebaseCollectionName.chats}/$chatId'] = chat.toJson();
    update['${FirebaseCollectionName.usersChats}/$userId2/$chatId'] = true;
    update['${FirebaseCollectionName.usersChats}/$userId1/$chatId'] = true;

    await _chatsCollection.update(update);
    return chat;
  }

  @override
  Stream<List<Chat>> getChatsByUserId({required String userId}) {
    final streamOfChatIds = _chatsCollection
        .child(FirebaseCollectionName.usersChats)
        .child(userId)
        .onValue
        .map(
      (event) {
        try {
          var value = event.snapshot.value;

          if (value is Map) {
            final data = value.cast<String, dynamic>();
            return data.keys.toList();
          }
          if (value == null) return <String>[];

          throw Exception('Invalid data type');
        } catch (e, s) {
          log.e(e, stackTrace: s);
        }
      },
    );

    return _mapChatIdsToChats(streamOfChatIds);
  }

  // todo must be [Steam<Chat>]
  Stream<Chat?> _getChatById(String chatId) {
    return _chatsCollection
        .child(FirebaseCollectionName.chats)
        .child(chatId)
        .onValue
        .map(
      (event) {
        try {
          final value = event.snapshot.value;

          if (value is Map) {
            final json = value.cast<String, dynamic>();
            return Chat.fromJson(json);
          } else {
            return null;
          }
        } catch (e) {
          log.e(e);
          rethrow;
        }
      },
    );
  }

  Stream<List<Chat>> _mapChatIdsToChats(Stream<List<String>?> streamOfChatIds) {
    return streamOfChatIds.map(
      (chatIds) {
        final listSteamOfChats =
            chatIds?.map((chatId) => _getChatById(chatId)) ?? [];
        if (listSteamOfChats.isEmpty) {
          return Stream.value(<Chat>[]);
        }

        return CombineLatestStream.list<Chat?>(listSteamOfChats).map(
          (chats) {
            final validChats = chats.whereType<Chat>().toList();

            validChats.sort((a, b) {
              final aTimestamp = a.lastMessageTimestamp;
              final bTimestamp = b.lastMessageTimestamp;
              if (aTimestamp == null && bTimestamp == null) return 0; // Both are null
              if (aTimestamp == null) return 1; // Null values go last
              if (bTimestamp == null) return -1; // Null values go last

              return bTimestamp.compareTo(aTimestamp); // Compare non-null timestamps
            });
            return validChats;
          },
        );
      },
    ).flatMap(
      (value) => value,
    );
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
  Future<void> updateChat({
    required String chatId,
    required String lastMessage,
  }) {
    final update = <String, dynamic>{
      'lastMessage': lastMessage,
      'lastMessageTimestamp': ServerValue.timestamp,
    };

    return _chatsCollection
        .child(FirebaseCollectionName.chats)
        .child(chatId)
        .update(update);
  }
}
