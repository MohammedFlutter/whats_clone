import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/contacts/backend/contact_service.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/core/utils/logger.dart';

class ContactNotifier extends StateNotifier<AsyncValue<List<AppContact>>> {
  final ContactServices _contactServices;

  ContactNotifier(this._contactServices) : super(const AsyncValue.loading());

  Future<void> loadContacts() async {
    try {
      final contacts = await _contactServices.appContacts;
      state = AsyncValue.data(contacts);
    } catch (error, stackTrace) {
      log.e(error);
      state = AsyncValue.error(error.toString(), stackTrace);
    }
  }

  Future<void> refreshContacts() async {
    state = const AsyncValue.loading();
    await loadContacts();
  }
}
