import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:fast_contacts/fast_contacts.dart';

import 'package:whats_clone/core/utils/extensions/phone_number_extension.dart';

class ContactService {
  final String defaultRegionCode;
  static List<Contact>? _cachedContacts;
  static List<String>? _cachedPhones;

  ContactService({required this.defaultRegionCode});

  Future<List<Contact>> getContacts() async {
    if (_cachedContacts != null) return _cachedContacts!;
    _cachedContacts = await FastContacts.getAllContacts(fields: [
      ContactField.displayName,
      ContactField.phoneNumbers,
      ContactField.phoneLabels,
    ]);
    _cachedContacts?.removeWhere((contact) => contact.phones.isEmpty);
    return _cachedContacts!;
  }

  Future<List<String>> getPhoneNumbers() async {
    if (_cachedPhones == null) {
      final contacts = await getContacts();
      final phones = contacts
          .expand((contact) => contact.phones)
          .toList();
      _cachedPhones = formatPhoneNumbers(phones);
    }
    return _cachedPhones!;
  }

  List<String> formatPhoneNumbers(List<Phone> phones) => phones
      .map((phone) {
        final phoneNumber = PhoneNumberUtil.instance.tryParsePhoneNumber(
          numberToParse: phone.number,
          defaultRegion: defaultRegionCode,
        );
        return phoneNumber?.formattedPhoneNumber;
      })
      .where((e) => e != null)
      .cast<String>()
      .toSet()
      .toList();
}
