import 'package:firebase_database/firebase_database.dart';
import 'package:whats_clone/core/utils/extensions/database_reference_extension.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/message/models/chat_messages.dart';
import 'package:whats_clone/state/message/models/message.dart';

abstract class MessageService {
  Future<void> sendMessage({required Message message});

  Stream<ChatMessages> getChatMessages({required String chatId});

// Future<void> deleteMessage({required Message message});
}

class MessageServiceFirebase implements MessageService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  MessageServiceFirebase();

  @override
  Future<void> sendMessage({required Message message}) async {
    try {
      final newMessageRef = _databaseReference
          .child('${FirebaseCollectionName.chatsMessages}/${message.chatId}/'
              '${FirebaseCollectionName.messages}')
          .push();

      final json =
          _toFirestorePayload(message.copyWith(chatId: newMessageRef.key!));

      return newMessageRef.set(json);
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
  Stream<ChatMessages> getChatMessages({required String chatId}) {
    return _databaseReference.getStreamFromDatabase(
      path:
          '${FirebaseCollectionName.chatsMessages}/$chatId/${FirebaseCollectionName.messages}',
      fromJson: (json) => _fromFirestorePayload(json, chatId),
      defaultValue: ChatMessages(chatId: chatId, messages: []),
    );
  }

  ChatMessages _fromFirestorePayload(Map<String, dynamic> json, String chatId) {
    final messages = json.entries.map((entry) {
      final messageData = Map<String, dynamic>.from(entry.value);
      return Message.fromJson(messageData);
    }).toList()
      ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    return ChatMessages(chatId: chatId, messages: messages);
  }
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
