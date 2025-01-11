import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/notifiers/profile_notifier.dart';
import 'package:whats_clone/state/profile/services/profile_cache.dart';
import 'package:whats_clone/state/profile/services/profile_repository.dart';
import 'package:whats_clone/state/profile/services/profile_service.dart';
import 'package:whats_clone/state/profile/services/profiles_cache.dart';

final profileServiceProvider = Provider<ProfileService>(
  (_) => ProfileServiceFirebase(),
);

final profileCacheProvider = Provider<ProfileCache>(
  (_) => ProfileCacheHive(
    profileBox: Hive.box<Profile>(HiveBoxName.profiles),
    profileCompletionBox: Hive.box<bool>(HiveBoxName.profileCompletion),
  ),
);

final profilesCacheProvider = Provider<ProfilesCache>(
  (_) => ProfilesCacheHive(
    profileBox: Hive.box<Profile>(HiveBoxName.profiles),
  ),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(
    profileService: ref.watch(profileServiceProvider),
    profileCache: ref.watch(profileCacheProvider),
  ),
);

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(
    profileService: ref.watch(profileRepositoryProvider),
  ),
);
