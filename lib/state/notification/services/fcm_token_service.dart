import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/constants/firebase_field_name.dart';
import 'package:whats_clone/state/notification/model/fcm_token.dart';

abstract class FcmTokenService {
  Future<FcmToken?> getTokenByUserId(String userId);

  Future<void> setToken(FcmToken token);

  Future<void> deleteToken(String userId);
}

class FcmTokenServiceFireBase implements FcmTokenService {
  final _collection =
      FirebaseFirestore.instance.collection(FirebaseCollectionName.fcmTokens);

  @override
  Future<FcmToken?> getTokenByUserId(String userId) async {
    final snapshot = await _collection
        .where(FirebaseFieldName.userId, isEqualTo: userId)
        .limit(1)
        .get();
    final json = snapshot.docs.firstOrNull;
    return json == null ? null : FcmToken.fromJson(json.data());
  }

  @override
  Future<void> setToken(FcmToken token) async {
    final querySnapshot = await _collection
        .where(FirebaseFieldName.userId, isEqualTo: token.userId)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      await _collection.add(token.toJson());
      return;
    }
    return querySnapshot.docs.first.reference.update(token.toJson());
  }

  @override
  Future<void> deleteToken(String userId) async {
    final querySnapshot = await _collection
        .where(FirebaseFieldName.userId, isEqualTo: userId)
        .limit(1)
        .get();
    return querySnapshot.docs.first.reference.delete();
  }
}
