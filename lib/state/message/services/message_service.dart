import 'package:firebase_database/firebase_database.dart';
import 'package:whats_clone/core/utils/extensions/database_reference_extension.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/constants/firebase_field_name.dart';
import 'package:whats_clone/state/message/models/message.dart';

abstract class MessageService {
  Future<void> sendMessage({required Message message});

  Stream<Message> listenToNewMessage({required String chatId});

  Future<List<Message>> getMessages({required String chatId});

  Future<List<Message>> getMessagesAfter(
      {required String chatId, required Message message});
// Future<void> deleteMessage({required Message message});
}

class MessageServiceFirebase implements MessageService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  MessageServiceFirebase();

  @override
  Future<void> sendMessage({required Message message}) async {
    try {
      final messagesRef = _databaseReference
          .child('${FirebaseCollectionName.chatsMessages}/${message.chatId}/'
              '${FirebaseCollectionName.messages}');
      final newMessageRef = messagesRef.push();

      final updatedMessage = message.copyWith(id: newMessageRef.key!);

      final json = _toFirestorePayload(updatedMessage);

      await newMessageRef.set(json);
    } catch (e, s) {
      log.e(e, stackTrace: s);
      rethrow;
    }
  }

  Map<String, dynamic> _toFirestorePayload(Message message) {
    final json = message.toJson();
    json['createdAt'] = ServerValue.timestamp;
    return json;
  }

  @override
  Stream<Message> listenToNewMessage({
    required String chatId,
  }) {
    return _databaseReference.getStreamFromDatabase(
      path:
          '${FirebaseCollectionName.chatsMessages}/$chatId/${FirebaseCollectionName.messages}',
      fromJson: (json) => Message.fromJson(json),
      orderPath: FirebaseFieldName.createdAt,
      limit: 1,
      isChangeAdded: true
    );
  }

  Message _messageFromFirestorePayload(
    Map<String, dynamic> json,
  ) {
    final messageData = Map<String, dynamic>.from(json.entries.first.value);
    return Message.fromJson(messageData);
  }

  List<Message> _messagesFromFirestorePayload(
    Map<String, dynamic> json,
  ) {
    return json.entries.map((entry) {
      // final messageData = Map<String, dynamic>.from(entry.value);
      return _messageFromFirestorePayload({entry.key: entry.value});
    }).toList()
      ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
  }

  @override
  Future<List<Message>> getMessagesAfter(
      {required String chatId, required Message message}) async {
    final snapshot = await _databaseReference
        .child(
            '${FirebaseCollectionName.chatsMessages}/$chatId/${FirebaseCollectionName.messages}')
        .orderByChild(FirebaseFieldName.createdAt)
        .startAfter(message.createdAt?.millisecondsSinceEpoch)
        .get();
    final json = snapshot.value;
    if (json is Map) {
      return _messagesFromFirestorePayload(json.cast<String, dynamic>());
    }
    return [];
  }

  @override
  Future<List<Message>> getMessages({required String chatId}) async {
    final snapshot = await _databaseReference
        .child(
            '${FirebaseCollectionName.chatsMessages}/$chatId/${FirebaseCollectionName.messages}')
        .orderByChild(FirebaseFieldName.createdAt)
        .get();
    final json = snapshot.value;
    if (json is Map) {
      return _messagesFromFirestorePayload(json.cast<String, dynamic>());
    }
    return [];
  }

// Future<List<Message>> getMessagesBefore(
//     {required String chatId ,Message? message}) async {
//
//   final snapshot = await _databaseReference
//       .child(
//           '${FirebaseCollectionName.chatsMessages}/$chatId/${FirebaseCollectionName.messages}')
//       .orderByChild(FirebaseFieldName.createdAt)
//       .endBefore(message)
//       .limitToLast(messageLimit)
//       .get();
//   final json = snapshot.value;
//   if (json is Map) {
//     final messages = json.entries.map((entry) {
//       final messageData = Map<String, dynamic>.from(entry.value);
//       return Message.fromJson(messageData);
//     }).toList()
//       ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
//     return messages;
//   }
//   return [];
// }

//
// @override
// Future<void> deleteMessage({required Message message}) {
//   try {
//     return _databaseReference
//         .child('${FirebaseCollectionName.chatsMessages}/${message.chatId}/'
//             '${FirebaseCollectionName.messages}/${message.messageId}')
//         .remove();
//   } catch (e) {
//     rethrow;
//   }
// }

// /// Sends a message and ensures offline support by writing to the local cache.
// ///
// /// [message] - The message object to be sent.
// Future<void> sendMessageWithOfflineSupport(Message message) async {
//   try {
//     await _databaseReference
//         .child('${FirebaseCollectionName.chatsMessages}/${message.chatId}/'
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
