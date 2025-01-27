import 'package:hive/hive.dart';
import 'package:whats_clone/state/notification/model/fcm_token.dart';

abstract class FcmTokenCache {
  Future<void> setToken(FcmToken token);

  FcmToken? getTokenByUserId(String userId);

  Future<void> deleteToken(String userId);
}

class FcmTokenCacheHive implements FcmTokenCache {
  final Box<FcmToken> _fcmTokenBox;

  FcmTokenCacheHive({required Box<FcmToken> fcmTokenBox})
      : _fcmTokenBox = fcmTokenBox;

  @override
  FcmToken? getTokenByUserId(String userId) => _fcmTokenBox.get(userId);

  @override
  Future<void> setToken(FcmToken token) =>
      _fcmTokenBox.put(token.userId, token);

  @override
  Future<void> deleteToken(String userId) => _fcmTokenBox.delete(
        userId,
      );
}
