import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whats_clone/core/utils/extensions/database_reference_extension.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/constants/firebase_field_name.dart';

abstract class ChatService {
  Future<Chat> createChat({required String userId1, required String userId2});

  Future<Chat?> getChat({required String chatId});

  Stream<List<Chat>> getChatsByUserId({required String userId});

  Future<void> updateLastMessage({
    required String chatId,
    required String lastMessage,
  });

  Future<void> deleteChat({required String chatId});

  Future<void> updateUnreadMessageCount({
    required String chatId,
    required String userId,
    int unreadMessageCount = 0,
  });
}

class ChatServiceFirebase implements ChatService {
  final _databaseRef = FirebaseDatabase.instance.ref();

  @override
  Future<Chat> createChat(
      {required String userId1, required String userId2}) async {
    final chatId = _databaseRef.child(FirebaseCollectionName.chats).push().key;
    if (chatId == null) {
      throw Exception('Chat ID is null');
    }
    final chat = Chat(chatId: chatId, memberIds: [userId1, userId2]);

    final update = <String, Object?>{};
    update['${FirebaseCollectionName.chats}/$chatId'] = chat.toJson();
    update['${FirebaseCollectionName.usersChats}/$userId2/$chatId'] = true;
    update['${FirebaseCollectionName.usersChats}/$userId1/$chatId'] = true;

    await _databaseRef.update(update);
    return chat;
  }

  @override
  Stream<List<Chat>> getChatsByUserId({required String userId}) {
    final streamOfChatIds = _databaseRef.getStreamFromDatabase(
      path: '${FirebaseCollectionName.usersChats}/$userId',
      fromJson: (json) => json.keys.toList(),
      defaultValue: <String>[],
    );
    return _mapChatIdsToChats(streamOfChatIds);
  }

  Stream<Chat?> _getChatById(String chatId) {
    return _databaseRef.getStreamFromDatabase(
      path: '${FirebaseCollectionName.chats}/$chatId',
      fromJson: (json) => Chat.fromJson(json),
      defaultValue: null,
    );
  }

  Stream<List<Chat>> _mapChatIdsToChats(Stream<List<String>?> streamOfChatIds) {
    return streamOfChatIds.switchMap(
      (chatIds) {
        final listSteamOfChats =
            chatIds?.map((chatId) => _getChatById(chatId)) ?? [];
        if (listSteamOfChats.isEmpty) {
          return Stream.value(<Chat>[]);
        }

        return CombineLatestStream.list<Chat?>(listSteamOfChats).map(
          (chats) {
            final validChats = chats.whereType<Chat>().toList();

            validChats.sort(_sortChats);
            return validChats;
          },
        );
      },
    );
  }

  int _sortChats(a, b) {
    final aTimestamp = a.lastMessageTimestamp;
    final bTimestamp = b.lastMessageTimestamp;
    if (aTimestamp == null && bTimestamp == null) return 0;
    if (aTimestamp == null) return 1;
    if (bTimestamp == null) return -1;

    return bTimestamp.compareTo(aTimestamp); // Compare non-null timestamps
  }

  @override
  Future<void> deleteChat({required String chatId}) async {
    final chat = await _getChatById(chatId).last;
    if (chat == null) {
      return;
    }

    _databaseRef.child(FirebaseCollectionName.chats).child(chatId).remove();
    for (final memberId in chat.memberIds) {
      _databaseRef
          .child(FirebaseCollectionName.usersChats)
          .child(memberId)
          .child(chatId)
          .remove();
    }
  }

  @override
  Future<void> updateLastMessage({
    required String chatId,
    required String lastMessage,
  }) {
    final update = <String, dynamic>{
      'lastMessage': lastMessage,
      'lastMessageTimestamp': ServerValue.timestamp,
    };

    return _databaseRef
        .child(FirebaseCollectionName.chats)
        .child(chatId)
        .update(update);
  }

  @override
  Future<void> updateUnreadMessageCount({
    required String chatId,
    required String userId,
    int unreadMessageCount = 0,
  }) {
    final update = <String, dynamic>{userId: unreadMessageCount};

    return _databaseRef
        .child(
            '${FirebaseCollectionName.chats}/$chatId/${FirebaseFieldName.unreadMessageCount}')
        .update(update);
  }

  @override
  Future<Chat?> getChat({required String chatId}) async {
    final snapshot = await _databaseRef
        .child('${FirebaseCollectionName.chats}/$chatId')
        .get();
    final value = snapshot.value;

    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return Chat.fromJson(json);
    }
    return null;
  }
}
