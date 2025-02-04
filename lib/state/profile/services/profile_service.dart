import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_clone/state/constants/firebase_collection_name.dart';
import 'package:whats_clone/state/constants/firebase_field_name.dart';
import 'package:whats_clone/state/profile/models/profile.dart';

abstract class ProfileService {
  Future<void> createProfile({required Profile profile});

  Future<void> updateProfile({required Profile profile});

  Future<Profile?> getProfile({required String userId});

  Future<List<Profile>> getProfilesByPhoneNumbers(List<String> phoneNumbers);

  Future<List<Profile>> getProfileByUserIds({required List<String> userIds});
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
  Future<List<Profile>> getProfileByUserIds(
      {required List<String> userIds}) async {
    return _getProfiles(
      firebaseFieldName: FirebaseFieldName.userId,
      values: userIds,
    );
  }

  /// need for match contacts with profiles
  @override
  Future<List<Profile>> getProfilesByPhoneNumbers(
      List<String> phoneNumbers) async {
    return _getProfiles(
      firebaseFieldName: FirebaseFieldName.phoneNumber,
      values: phoneNumbers,
    );
  }

  Future<List<Profile>> _getProfiles({
    required String firebaseFieldName,
    required List<String> values,
  }) async {
    if (values.isEmpty) return [];

    // Create chunks of 30 values, 30 it is max of firebase
    final chunks = <List<String>>[];
    for (var i = 0; i < values.length; i += 30) {
      chunks.add(values.sublist(
        i,
        i + 30 > values.length ? values.length : i + 30,
      ));
    }

    // Run all queries in parallel
    final querySnapshots = await Future.wait(
      chunks.map((chunk) =>
          _profilesCollection.where(firebaseFieldName, whereIn: chunk).get()),
    );

    // Combine all results
    return querySnapshots
        .expand((snapshot) =>
            snapshot.docs.map((doc) => Profile.fromJson(doc.data())))
        .toList();
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

    final json = profile.toJson()
      ..addAll({'created_at': FieldValue.serverTimestamp()});

    await _profilesCollection.add(json);
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

    final isPhoneUnique = await _isPhoneUnique(
        phone: profile.phoneNumber, userId: profile.userId);
    if (!isPhoneUnique) {
      throw Exception("Phone number already exists.");
    }
    final json = profile.toJson()
      ..addAll({'updated_at': FieldValue.serverTimestamp()});

    await _profilesCollection.doc(docRef.id).update(json);
  }

  Future<bool> _isPhoneUnique({required String phone, String? userId}) async {
    final querySnapshot = await _profilesCollection
        .where(FirebaseFieldName.phoneNumber, isEqualTo: phone)
        .limit(2)
        .get();
    if (querySnapshot.docs.isEmpty) return true;
    if (userId == null || querySnapshot.docs.length >= 2) return false;

    final profile = Profile.fromJson(querySnapshot.docs.first.data());

    return profile.userId == userId;
  }
}
