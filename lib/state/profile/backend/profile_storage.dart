import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/constants/firebase_field_name.dart';
import 'package:whats_clone/state/profile/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileStorage {
  final _profilesCollection =
      FirebaseFirestore.instance.collection(FirebaseCollectionName.profiles);

  /// Retrieves a profile by userId.
  Future<Profile?> getProfile({String? userId}) async {
    if (userId == null) {
      return null;
    }
    final querySnapshot = await _profilesCollection
        .where(FirebaseFieldName.userId, isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return Profile.fromJson(querySnapshot.docs.first.data());
  }

  /// Adds a new profile if it doesn't exist and the phone number is unique.
  Future<void> createProfile({required Profile profile}) async {
    final existingProfile = await getProfile(userId: profile.userId);
    if (existingProfile != null) {
      throw Exception("Profile already exists.");
    }

    final isPhoneUnique = await _isPhoneUnique(phone: profile.phoneNumber!);
    if (!isPhoneUnique) {
      throw Exception("Phone number already exists.");
    }

    await _profilesCollection.add(profile.toJson());
  }

  /// Updates an existing profile if it exists.
  Future<void> updateProfile({required Profile profile}) async {
    final querySnapshot = await _profilesCollection
        .where(FirebaseFieldName.userId, isEqualTo: profile.userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception("Profile not found.");
    }

    final docRef = querySnapshot.docs.first.reference;

    // Ensure phone number uniqueness if it's updated
    final existingProfile = Profile.fromJson(querySnapshot.docs.first.data());
    if (existingProfile.phoneNumber != profile.phoneNumber) {
      final isPhoneUnique = await _isPhoneUnique(phone: profile.phoneNumber!);
      if (!isPhoneUnique) {
        throw Exception("Phone number already exists.");
      }
    }

    await docRef.update(profile.toJson());
  }

  /// Checks if the phone number is unique across profiles.
  Future<bool> _isPhoneUnique({required String phone}) async {
    final querySnapshot = await _profilesCollection
        .where(FirebaseFieldName.phoneNumber, isEqualTo: phone)
        .limit(1)
        .get();

    return querySnapshot.docs.isEmpty;
  }
}
