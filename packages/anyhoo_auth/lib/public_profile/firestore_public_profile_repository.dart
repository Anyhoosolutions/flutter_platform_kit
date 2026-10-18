import 'package:anyhoo_auth/public_profile/public_profile.dart';
import 'package:anyhoo_auth/public_profile/public_profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePublicProfileRepository implements PublicProfileRepository {
  FirestorePublicProfileRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<PublicProfile?> get(String userId) async {
    final snapshot = await _firestore
        .collection(PublicProfile.collection)
        .doc(userId)
        .get();
    return _fromSnapshot(snapshot);
  }

  @override
  Stream<PublicProfile?> watch(String userId) {
    return _firestore
        .collection(PublicProfile.collection)
        .doc(userId)
        .snapshots()
        .map(_fromSnapshot);
  }

  @override
  Future<void> save(PublicProfile profile) async {
    await _firestore
        .collection(PublicProfile.collection)
        .doc(profile.id)
        .set(profile.toJson(), SetOptions(merge: true));
  }

  PublicProfile? _fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }
    return PublicProfile.fromJson({'id': snapshot.id, ...data});
  }
}
