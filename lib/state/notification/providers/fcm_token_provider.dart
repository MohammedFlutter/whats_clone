import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';
import 'package:whats_clone/state/notification/model/fcm_token.dart';
import 'package:whats_clone/state/notification/services/fcm_token_cache.dart';
import 'package:whats_clone/state/notification/services/fcm_token_repository.dart';
import 'package:whats_clone/state/notification/services/fcm_token_service.dart';

final fcmTokenRepositoryProvider = Provider<FcmTokenRepository>(
  (ref) => FcmTokenRepository(
      fcmTokenService: ref.watch(fcmTokenServiceProvider),
      fcmTokenCache: ref.watch(fcmTokenCacheProvider)),
);
final fcmTokenServiceProvider = Provider<FcmTokenService>(
  (_) => FcmTokenServiceFireBase(),
);

final fcmTokenCacheProvider = AutoDisposeProvider<FcmTokenCache>(
  (_) =>
      FcmTokenCacheHive(fcmTokenBox: Hive.box<FcmToken>(HiveBoxName.fcmToken)),
);
