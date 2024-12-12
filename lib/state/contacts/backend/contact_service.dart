import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/constants/firebase_field_name.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

// Future<List<Profile>> searchByPhoneOrName(String query) async {}
class ContactServices {
  Future<List<AppContact>> get appContacts async {
    final phoneNumbers = await _getPhonesFromContacts();

    final profiles = await _fetchProfilesByPhoneNumbers(phoneNumbers);

    final contacts = await _getAllContacts();

    return _mapContactsToAppContacts(contacts, profiles);
  }

  Future<List<AppContact>> searchContacts({String? name, String? phone}) async {
    final contacts = await _getAllContacts();

    final filteredContacts = contacts.where((contact) {
      final matchesName = name != null &&
          contact.displayName.toLowerCase().contains(name.toLowerCase());
      final matchesPhone =
          phone != null && contact.phones.any((p) => p.number.contains(phone));
      return (name != null && matchesName) || (phone != null && matchesPhone);
    }).toList();

    final phoneNumbers = filteredContacts
        .expand((contact) => contact.phones.map((phone) => phone.number))
        .toSet();

    final profiles = await _fetchProfilesByPhoneNumbers(phoneNumbers);

    return _mapContactsToAppContacts(filteredContacts, profiles);
  }

  Future<Set<String>> _getPhonesFromContacts() async {
    final contacts = await FlutterContacts.getContacts(
      withThumbnail: false,
      withPhoto: false,
      deduplicateProperties: false,
    );

    return contacts
        .expand((contact) => contact.phones)
        .where((phone) => phone.label == PhoneLabel.mobile)
        .map((phone) => phone.number)
        .toSet();
  }

  Future<List<Profile>> _fetchProfilesByPhoneNumbers(
      Set<String> phoneNumbers) async {
    if (phoneNumbers.isEmpty) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.profiles)
        .where(FirebaseFieldName.phoneNumber, whereIn: phoneNumbers.toList())
        .get();

    return querySnapshot.docs
        .map((doc) => Profile.fromJson(doc.data()))
        .toList();
  }

  Future<List<Contact>> _getAllContacts() async {
    return FlutterContacts.getContacts(
      withThumbnail: false,
      withPhoto: false,
      deduplicateProperties: false,
    );
  }

  List<AppContact> _mapContactsToAppContacts(
      List<Contact> contacts, List<Profile> profiles) {
    final profileMap = {
      for (var profile in profiles) profile.phoneNumber: profile
    };

    return contacts.map((contact) {
      final phones = contact.phones.map((phone) => phone.number).toList();
      final matchingProfile =
          phones.map((phone) => profileMap[phone]).firstWhere(
                (profile) => profile != null,
                orElse: () => null,
              );

      return AppContact(
        id: contact.id,
        displayName: contact.displayName,
        phoneNumbers: phones,
        isRegistered: matchingProfile != null,
        userId: matchingProfile?.userId,
        avatarUrl: matchingProfile?.avatarUrl,
      );
    }).toList();
  }
}
