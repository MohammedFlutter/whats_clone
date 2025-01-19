import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/constants/firebase_field_name.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

abstract class ProfileService {
  Future<void> createProfile({required Profile profile});

  Future<void> updateProfile({required Profile profile});

  Future<Profile?> getProfile({required String userId});

  Future<List<Profile>> getProfilesByPhoneNumbers(List<String> phoneNumbers);

  Future<List<Profile>> getProfileByUsersId({required List<String> usersId});
}

class ProfileServiceFirebase implements ProfileService {
  final _profilesCollection =
      FirebaseFirestore.instance.collection(FirebaseCollectionName.profiles);

  @override
  Future<Profile?> getProfile({required String userId}) async {
    final querySnapshot = await _profilesCollection
        .where(FirebaseFieldName.userId, isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return Profile.fromJson(querySnapshot.docs.first.data());
  }

  @override
  Future<List<Profile>> getProfileByUsersId(
      {required List<String> usersId}) async {
    if (usersId.isEmpty) return [];

    final querySnapshot = await _profilesCollection
        .where(FirebaseFieldName.userId, whereIn: usersId)
        .get();

    return querySnapshot.docs
        .map((doc) => Profile.fromJson(doc.data()))
        .toList();
  }

  /// need for match contacts with profiles
  @override
  Future<List<Profile>> getProfilesByPhoneNumbers(
      List<String> phoneNumbers) async {
    if (phoneNumbers.isEmpty) return [];

    List<Profile> profiles = [];

    // Split phoneNumbers into chunks of 30
    for (var i = 0; i < phoneNumbers.length; i += 30) {
      final chunk = phoneNumbers.sublist(
        i,
        i + 30 > phoneNumbers.length ? phoneNumbers.length : i + 30,
      );

      final querySnapshot = await _profilesCollection
          .where(FirebaseFieldName.phoneNumber, whereIn: chunk)
          .get();

      profiles.addAll(querySnapshot.docs
          .map((doc) => Profile.fromJson(doc.data()))
          .toList());
    }

    return profiles;
  }

  @override
  Future<void> createProfile({required Profile profile}) async {
    final existingProfile = await getProfile(userId: profile.userId);
    if (existingProfile != null) {
      throw Exception("Profile already exists.");
    }

    final isPhoneUnique = await _isPhoneUnique(phone: profile.phoneNumber);
    if (!isPhoneUnique) {
      throw Exception("Phone number already exists.");
    }

    await _profilesCollection.add(profile.toJson());
  }

  @override
  Future<void> updateProfile({required Profile profile}) async {
    final querySnapshot = await _profilesCollection
        .where(FirebaseFieldName.userId, isEqualTo: profile.userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("Profile not found.");
    }

    final docRef = querySnapshot.docs.first.reference;

    final isPhoneUnique = await _isPhoneUnique(phone: profile.phoneNumber);
    if (!isPhoneUnique) {
      throw Exception("Phone number already exists.");
    }
    await docRef.update(profile.toJson());
  }

  Future<bool> _isPhoneUnique({required String phone}) async {
    final querySnapshot = await _profilesCollection
        .where(FirebaseFieldName.phoneNumber, isEqualTo: phone)
        .limit(1)
        .get();

    return querySnapshot.docs.isEmpty;
  }
}
