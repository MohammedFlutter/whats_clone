import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/contacts/providers/contacts_provider.dart';
import 'package:whats_clone/state/contacts/services/contact_repository.dart';

class ContactNotifier extends AsyncNotifier<List<AppContact>> {
  late final ContactRepository _contactServices;

  @override
  FutureOr<List<AppContact>> build() async {
    _contactServices = ref.watch(contactRepositoryProvider);
    final contacts = await _contactServices.appContacts;
    return contacts;
  }

  Future<void> refreshContacts() async {
    state = const AsyncValue.loading();
    try {
      final contacts = await _contactServices.appContacts;
      state = AsyncValue.data(contacts);
    } catch (error, stackTrace) {
      log.e(error);
      state = AsyncValue.error(error.toString(), stackTrace);
    }
  }
}
