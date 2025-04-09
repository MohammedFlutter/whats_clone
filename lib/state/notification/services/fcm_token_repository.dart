import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/notification/model/fcm_token.dart';
import 'package:whats_clone/state/notification/services/fcm_token_cache.dart';
import 'package:whats_clone/state/notification/services/fcm_token_service.dart';

class FcmTokenRepository {
  final FcmTokenService _fcmTokenService;
  final FcmTokenCache _fcmTokenCache;

  FcmTokenRepository(
      {required FcmTokenService fcmTokenService,
      required FcmTokenCache fcmTokenCache})
      : _fcmTokenService = fcmTokenService,
        _fcmTokenCache = fcmTokenCache;

  Future<void> setToken(FcmToken token) async {
    await _fcmTokenService.setToken(token);
    await _fcmTokenCache.setToken(token);
  }

  Future<FcmToken?> getTokenByUserId(String userId) async {
    final cacheToken = _fcmTokenCache.getTokenByUserId(userId);
    if (cacheToken != null) return cacheToken;
    final remoteToken = await _fcmTokenService.getTokenByUserId(userId);
    if (remoteToken != null) {
      await _fcmTokenCache.setToken(remoteToken);
      return remoteToken;
    }
    return null;
  }

  Future<void> deleteToken(String userId) async {
    try {
      await _fcmTokenService.deleteToken(userId);
      await _fcmTokenCache.deleteToken(userId);
    } catch (e, st) {
      log.e(e, stackTrace: st);
    }
  }
}
