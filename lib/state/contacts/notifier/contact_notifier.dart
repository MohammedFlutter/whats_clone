import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/contacts/providers/contacts_provider.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/state/providers/permission_provider.dart';

class ContactNotifier extends AsyncNotifier<List<AppContact>> {
  @override
  FutureOr<List<AppContact>> build() async {
    final contactPermissionNotifier =
        ref.read(permissionNotifierProvider(Permission.contacts).notifier);

    bool isGranted = false;
    while (!isGranted) {
      await contactPermissionNotifier.handlePermissionStatus(
        onPermissionGranted: () => isGranted = true,
      );
    }
    final contactServices = ref.watch(contactRepositoryProvider);
    final contacts = await contactServices.appContacts;
    contacts.removeWhere(
      (contact) =>
          contact.userId == ref.read(profileNotifierProvider).profile?.userId,
    );
    return contacts;
  }

  Future<void> refreshContacts() async {
    // state = const AsyncValue.loading();
    try {
      final contactServices = ref.watch(contactRepositoryProvider);

      final contacts = await contactServices.appContacts;
      contacts.removeWhere(
            (contact) =>
        contact.userId == ref.read(profileNotifierProvider).profile?.userId,
      );
      state = AsyncValue.data(contacts);
    } catch (error, stackTrace) {
      log.e(error);
      state = AsyncValue.error(error.toString(), stackTrace);
    }
  }
}
