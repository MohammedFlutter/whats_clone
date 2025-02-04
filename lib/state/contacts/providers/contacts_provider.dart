import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/contacts/notifier/contact_notifier.dart';
import 'package:whats_clone/state/contacts/services/contact_repository.dart';
import 'package:whats_clone/state/contacts/services/contact_service.dart';
import 'package:whats_clone/state/profile/providers/profile_provider.dart';
import 'package:whats_clone/view/contacts/contacts_page.dart';

final defaultRegionCodeProvider = Provider<String>((ref) {
  final phone = ref.watch(profileNotifierProvider).profile?.phoneNumber;
  final phoneNumberUtil = PhoneNumberUtil.instance;

  if (phone == null) throw Exception('Profile is null');

  final second = DateTime.now();
  final phoneNumber = phoneNumberUtil.parse('+$phone', null);
  log.i('contact provider 2: ${DateTime.now().difference(second)}');

  return phoneNumberUtil.getRegionCodeForCountryCode(phoneNumber.countryCode);
});

final contactServicesProvider = Provider<ContactService>(
  (ref) {
    return ContactService(defaultRegionCode: ref.watch(defaultRegionCodeProvider));
  },
);

final contactRepositoryProvider =
    Provider<ContactRepository>((ref) => ContactRepository(
          profileService: ref.read(profileServiceProvider),
          profileCache: ref.read(profilesCacheProvider),
          contactService: ref.read(contactServicesProvider),
        ));

final allContactsProvider =
    AsyncNotifierProvider<ContactNotifier, List<AppContact>>(
  ContactNotifier.new,
);

final searchContactsProvider =
    FutureProvider.autoDispose<List<AppContact>>((ref) {
  final contactsState = ref.watch(allContactsProvider);
  if (!contactsState.hasValue) return [];
  final query = ref.watch(contactSearchQueryProvider.notifier).state;

  final contacts = contactsState.value!;
  if (contacts.isEmpty) return [];
  if (query.isEmpty) return contacts;

  final filteredContacts = contacts.where((contact) {
    final matchesName =
        contact.displayName.toLowerCase().contains(query.toLowerCase());
    final matchesPhone =
        contact.phoneNumbers.any((phone) => phone.contains(query));
    return matchesName || matchesPhone;
  }).toList();

  return filteredContacts;
});
