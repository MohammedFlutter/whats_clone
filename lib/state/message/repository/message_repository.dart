import 'package:firebase_database/firebase_database.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/message/models/message.dart';

class MessageRepository {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  MessageRepository();

  /// Sends a message to the Firebase Realtime Database.
  ///
  /// [message] - The message object to be sent.
  Future<void> sendMessage(Message message) async {
    try {
      final newMessageRef = _databaseReference
          .child('${FirebaseCollectionName.chats}/${message.chatId}/'
              '${FirebaseCollectionName.messages}')
          .push();

      await newMessageRef.set(message.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes a message from the Firebase Realtime Database.
  ///
  /// [chatId] - The ID of the chat.
  /// [messageId] - The unique ID of the message to delete.
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _databaseReference
          .child('${FirebaseCollectionName.chats}/$chatId/'
              '${FirebaseCollectionName.messages}/$messageId')
          .remove();
    } catch (e) {
      rethrow;
    }
  }

  /// Listens for messages in a specific chat.
  ///
  /// [chatId] - The ID of the chat.
  /// Returns a stream of messages as a list of [Message] objects.
  Stream<List<Message>> listenToMessages(String chatId) {
    return _databaseReference
        .child('${FirebaseCollectionName.chats}/$chatId/'
            '${FirebaseCollectionName.messages}')
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      return data.entries.map((entry) {
        final messageData = Map<String, dynamic>.from(entry.value);
        return Message.fromJson({
          // 'messageId': entry.key,
          ...messageData,
        });
      }).toList();
    });
  }

// /// Sends a message and ensures offline support by writing to the local cache.
// ///
// /// [message] - The message object to be sent.
// Future<void> sendMessageWithOfflineSupport(Message message) async {
//   try {
//     await _databaseReference
//         .child('${FirebaseCollectionName.chats}/${message.chatId}/'
//             '${FirebaseCollectionName.messages}/${message.messageId}')
//         .set(message.toJson())
//         .then((_) {
//       _databaseReference.keepSynced(true);
//     });
//   } catch (e) {
//     rethrow;
//   }
// }
}
