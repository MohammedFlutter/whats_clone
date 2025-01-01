import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/constants/firebase_field_name.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

class ContactServices {
  ContactServices({required Box<Profile> profileBox})
      : _profileBox = profileBox;

  final Box<Profile> _profileBox;

  static List<Contact>? _cachedContacts;
  static List<String>? _cachedPhones;

  static Future<List<Contact>> get cachedContacts async {
    _cachedContacts ??= await FlutterContacts.getContacts(
      withThumbnail: false,
      withPhoto: false,
      withGroups: false,
      withAccounts: false,
    );
    return _cachedContacts!;
  }

  static Future<List<String>> get cachedPhones async {
    final contacts = await cachedContacts;

    _cachedPhones ??= contacts
        .expand((contact) => contact.phones)
        .where((phone) => phone.label == PhoneLabel.mobile)
        .map((phone) => phone.number)
        .toSet()
        .toList();
    return _cachedPhones!;
  }

  Future<List<AppContact>> get appContacts async {
    final contacts = await cachedContacts;
    final phoneNumbers = await cachedPhones;

    List<Profile> profiles;
    try {
      // Try to fetch from Firebase
      profiles = await _fetchProfilesByPhoneNumbers(phoneNumbers);
      // Update cache on successful fetch
      await _updateProfileCache(profiles);
    } catch (e) {
      // Use cached profiles on error
      profiles = _getCachedProfiles(phoneNumbers);
    }

    return _mapContactsToAppContacts(contacts, profiles);
  }

  Future<List<Profile>> _fetchProfilesByPhoneNumbers(
      List<String> phoneNumbers) async {
    if (phoneNumbers.isEmpty) return [];

    final querySnapshot = await FirebaseFirestore.instance
        .collection(FirebaseCollectionName.profiles)
        .where(FirebaseFieldName.phoneNumber, whereIn: phoneNumbers.toList())
        .get();

    return querySnapshot.docs
        .map((doc) => Profile.fromJson(doc.data()))
        .toList();
  }

  // Cache management methods
  Future<void> _updateProfileCache(List<Profile> profiles) async {
    await _profileBox.clear(); // Clear old cache
    for (final profile in profiles) {
      await _profileBox.put(profile.phoneNumber, profile);
    }
  }

  List<Profile> _getCachedProfiles(List<String> phoneNumbers) {
    return phoneNumbers
        .map((phone) => _profileBox.get(phone))
        .where((profile) => profile != null)
        .cast<Profile>()
        .toList();
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
