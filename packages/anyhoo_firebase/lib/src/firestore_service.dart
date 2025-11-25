import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class FirestoreService {
  final FirebaseFirestore firestore;
  final _log = Logger('FirestoreService');

  FirestoreService({required this.firestore});

  Stream<List<Map<String, dynamic>>> getSnapshotsStream(
    String path, {
    String? orderBy,
    bool? descending,
    List<String>? whereNullFields,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = firestore.collection(path);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending!);
    }
    if (whereNullFields != null) {
      for (var field in whereNullFields) {
        query = query.where(field, isNull: true);
      }
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((snapshot) => {...snapshot.data(), 'id': snapshot.id})
          .toList(),
    );
  }

  Stream<Map<String, dynamic>?> getSnapshotsForDocument(String path) {
    final query = firestore.doc(path).snapshots();

    return query.map((snapshot) {
      return snapshot.data();
    });
  }

  Future<List<Map<String, dynamic>>> getSnapshotsList(
    String path, {
    String? orderBy,
    bool? descending,
    List<String>? whereNullFields,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = firestore.collection(path);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending!);
    }
    if (whereNullFields != null) {
      for (var field in whereNullFields) {
        query = query.where(field, isNull: true);
      }
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.get().then(
      (snapshot) => snapshot.docs
          .map((snapshot) => {...snapshot.data(), 'id': snapshot.id})
          .toList(),
    );
  }

  Future<Map<String, dynamic>?> getDocument(String path) async {
    try {
      final docRef = await firestore.doc(path).get();
      return docRef.data();
    } catch (e) {
      _log.warning('Error getting document at $path: $e');
      rethrow;
    }
  }

  Future<String> addDocument({
    required String path,
    required Map<String, dynamic> data,
    String? docId,
    Map<String, String>? idFields,
  }) async {
    final collectionRef = FirebaseFirestore.instance.collection(path);

    String fullPath = '$path/$docId';

    if (docId == null) {
      final newDocRef = collectionRef.doc();
      docId = newDocRef.id;
      fullPath = '$path/$docId';
    }
    if (idFields?.entries != null) {
      for (final idField in idFields!.entries) {
        data[idField.key] = idField.value + docId;
      }
    }

    _log.info('fullPath: $fullPath');
    _log.info('data: $data');
    await firestore.doc(fullPath).set(data);

    return docId;
  }

  Future<void> updateDocument(
    String path,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      return firestore.collection(path).doc(id).update(data);
    } catch (e) {
      throw Exception('Failed to update document at $path $id: $e');
    }
  }

  Future<void> deleteDocument(String path, String id) async {
    return firestore.collection(path).doc(id).delete();
  }
}
