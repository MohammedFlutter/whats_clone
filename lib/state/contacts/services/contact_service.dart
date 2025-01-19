import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whats_clone/core/utils/extensions/phone_number_extension.dart';

class ContactService {
  final String defaultRegionCode;
  static List<Contact>? _cachedContacts;
  static List<String>? _cachedPhones;

  ContactService({required this.defaultRegionCode});

  Future<List<Contact>> getContacts() async {


    _cachedContacts ??= await FlutterContacts.getContacts(
      deduplicateProperties: true,
      withProperties: true,
    );
    _cachedContacts?.removeWhere((contact) => contact.phones.isEmpty);
    return _cachedContacts!;
  }

  Future<List<String>> getPhoneNumbers() async {
    if (_cachedPhones == null) {
      final contacts = await getContacts();
      final phones = contacts
          .expand((contact) => contact.phones)
          .where((phone) => phone.label == PhoneLabel.mobile)
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
      .toList();
}
