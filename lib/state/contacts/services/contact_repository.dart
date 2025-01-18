import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whats_clone/core/utils/logger.dart';
import 'package:whats_clone/state/contacts/model/app_contact.dart';
import 'package:whats_clone/state/contacts/services/contact_service.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:whats_clone/state/profile/services/profile_service.dart';
import 'package:whats_clone/state/profile/services/profiles_cache.dart';

class ContactRepository {
  final ContactService _contactService;
  final ProfileService _profileService;
  final ProfilesCache _profileCache;

  ContactRepository(
      {required ContactService contactService,
      required ProfileService profileService,
      required ProfilesCache profileCache})
      : _contactService = contactService,
        _profileService = profileService,
        _profileCache = profileCache;

  Future<List<AppContact>> get appContacts async {
    final contacts = await _contactService.getContacts();
    final phoneNumbers = await _contactService.getPhoneNumbers();

    List<Profile> profiles;
    try {
      profiles = await _profileService.getProfilesByPhoneNumbers(phoneNumbers);
      await _profileCache.updateCacheProfiles(profiles);
    } catch (e) {
      log.e(e);
      profiles = _profileCache.getCachedProfiles(phoneNumbers);
    }

    return _mapContactsToAppContacts(contacts, profiles);
  }

  List<AppContact> _mapContactsToAppContacts(
      List<Contact> contacts, List<Profile> profiles) {
    final profileMap = {
      for (var profile in profiles) profile.phoneNumber: profile
    };

    return contacts.map((contact) {
      final phones = _contactService.formatPhoneNumbers(contact.phones);

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
        bio: matchingProfile?.bio,
        avatarUrl: matchingProfile?.avatarUrl,
      );
    }).toList();
  }
}
