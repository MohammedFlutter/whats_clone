import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/profile/backend/profile_storage.dart';
import 'package:whats_clone/state/profile/models/profile_state.dart';
import 'package:whats_clone/state/profile/notifiers/profile_notifier.dart';

final profileStorageProvider = Provider<ProfileStorage>((ref) {
  return ProfileStorage();
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final profileStorage = ref.watch(profileStorageProvider);
  return ProfileNotifier(profileStorage);
});