import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_clone/state/chat/models/chat.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:hive/hive.dart';

class ChatRepository {
  final _chatsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollectionName.chats);
  final Uuid _uuid = const Uuid();

  final Box<Chat> _chatBox;

  ChatRepository(this._chatBox);

  Stream<List<Chat>> getChats({required String userId}) async* {
    try {
      // Attempt to listen to Firestore updates in real time with filter
      await for (final querySnapshot in _chatsCollection
          .where('memberId', arrayContains: userId)
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots()) {
        final remoteChats =
            querySnapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList();

        // Update local Hive storage with the latest data
        await _chatBox.clear();
        for (var chat in remoteChats) {
          await _chatBox.put(chat.chatId, chat);
        }

        yield remoteChats;
      }
    } catch (e) {
      // If an error occurs (e.g., offline), fallback to local Hive storage
      yield _chatBox.values.toList();
    }
  }

  Future<Chat> createChat({
    required List<String> memberIds,
    String? lastMessage,
    DateTime? lastMessageTimestamp,
  }) async {
    final newChat = Chat(
      chatId: _uuid.v4(),
      memberIds: memberIds,
      lastMessage: lastMessage,
      lastMessageTimestamp: lastMessageTimestamp ?? DateTime.now(),
    );

    // Save chat to Firestore
    await _chatsCollection.doc(newChat.chatId).set(newChat.toJson());

    // Save chat locally
    await _chatBox.put(newChat.chatId, newChat);

    return newChat;
  }

  Future<void> deleteChat(String chatId) async {
    // Delete chat from Firestore
    await _chatsCollection.doc(chatId).delete();

    // Delete chat locally
    await _chatBox.delete(chatId);
  }
}
