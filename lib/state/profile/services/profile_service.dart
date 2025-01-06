import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/constants/firebase_field_name.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

abstract class ProfileService {
  Future<Profile?> getProfile({required String userId});

  Future<void> createProfile({required Profile profile});

  Future<void> updateProfile({required Profile profile});

  Future<List<Profile>> getProfiles(List<String> phoneNumbers);
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

  /// need for match contacts with profiles
  @override
  Future<List<Profile>> getProfiles(List<String> phoneNumbers) async {
    if (phoneNumbers.isEmpty) return [];

    final querySnapshot = await _profilesCollection
        .where(FirebaseFieldName.phoneNumber, whereIn: phoneNumbers)
        .get();

    return querySnapshot.docs
        .map((doc) => Profile.fromJson(doc.data()))
        .toList();
  }

  @override
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

    final isPhoneUnique = await _isPhoneUnique(phone: profile.phoneNumber!);
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
