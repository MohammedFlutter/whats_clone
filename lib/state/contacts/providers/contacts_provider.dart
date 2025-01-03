import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/constants/hive_box_name.dart';
import 'package:whats_clone/state/contacts/backend/contact_service.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/contacts/notifier/contact_notifier.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

final contactServicesProvider = Provider((ref) =>
    ContactServices(profileBox: Hive.box<Profile>(HiveBoxName.profiles)));

final allContactsProvider =
    StateNotifierProvider<ContactNotifier, AsyncValue<List<AppContact>>>((ref) {
  final contactServices = ref.watch(contactServicesProvider);
  return ContactNotifier(contactServices);
});

final searchContactsProvider = FutureProvider.autoDispose
    .family<List<AppContact>, String?>((ref, nameOrPhone) {
  final contactsState = ref.watch(allContactsProvider);
  if (!contactsState.hasValue) return [];

  final contacts = contactsState.value!;
  if (contacts.isEmpty) return [];
  if (nameOrPhone == null || nameOrPhone.isEmpty) return contacts;

  final filteredContacts = contacts.where((contact) {
    final matchesName =
        contact.displayName.toLowerCase().contains(nameOrPhone.toLowerCase());
    final matchesPhone =
        contact.phoneNumbers.any((phone) => phone.contains(nameOrPhone));
    return matchesName || matchesPhone;
  }).toList();

  return filteredContacts;
});
