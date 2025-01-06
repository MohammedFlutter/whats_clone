import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/contacts/notifier/contact_notifier.dart';
import 'package:whats_clone/state/contacts/services/contact_repository.dart';
import 'package:whats_clone/state/contacts/services/contact_service.dart';
import 'package:whats_clone/state/profile/providers/profile_state_provider.dart';

final contactServicesProvider = Provider<ContactService>(
  (ref) {
    final profile = ref.watch(profileNotifierProvider).profile;

    if (profile == null) throw Exception('Profile is null');
    final phoneNumber =
        PhoneNumberUtil.instance.parse(profile.phoneNumber, null);
    final defaultRegionCode = PhoneNumberUtil.instance
        .getRegionCodeForCountryCode(phoneNumber.countryCode);
    return ContactService(defaultRegionCode: defaultRegionCode);
  },
);

final contactRepositoryProvider =
    Provider<ContactRepository>((ref) => ContactRepository(
          profileService: ref.watch(profileServiceProvider),
          profileCache: ref.watch(profilesCacheProvider),
          contactService: ref.watch(contactServicesProvider),
        ));

final allContactsProvider =
    AsyncNotifierProvider<ContactNotifier, List<AppContact>>(
  ContactNotifier.new,
);

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
