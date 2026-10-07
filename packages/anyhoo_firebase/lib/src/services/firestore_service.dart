import 'package:anyhoo_firebase/src/services/firestore_where.dart';
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

export 'firestore_where.dart' show FirestoreWhere;

class FirestoreService {
  final FirebaseFirestore _firestore;
  final _log = Logger('FirestoreService');

  FirestoreService({required this._firestore});

  Stream<List<Map<String, dynamic>>> watchCollection(
    String path, {
    String? orderBy,
    bool? descending,
    List<FirestoreWhere>? where,
    List<String>? whereNullFields,
    int? limit,
  }) {
    return _collectionQuery(
      path,
      orderBy: orderBy,
      descending: descending,
      where: where,
      whereNullFields: whereNullFields,
      limit: limit,
    ).snapshots().map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  Stream<Map<String, dynamic>?> watchDocument(String path) {
    return _firestore
        .doc(path)
        .snapshots()
        .map((snapshot) => snapshot.data() != null ? {'id': snapshot.id, ...snapshot.data()!} : null);
  }

  Future<List<Map<String, dynamic>>> getCollection(
    String path, {
    String? orderBy,
    bool? descending,
    List<FirestoreWhere>? where,
    List<String>? whereNullFields,
    int? limit,
  }) {
    return _collectionQuery(
      path,
      orderBy: orderBy,
      descending: descending,
      where: where,
      whereNullFields: whereNullFields,
      limit: limit,
    ).get().then((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  Future<Map<String, dynamic>?> getDocument(String path) async {
    try {
      final docRef = await _firestore.doc(path).get();
      if (docRef.data() == null) {
        return null;
      }
      return {'id': docRef.id, ...docRef.data()!};
    } catch (e, stackTrace) {
      _log.warning('Error getting document at $path: $e');
      SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
      rethrow;
    }
  }

  Future<String> addDocument({
    required String path,
    required Map<String, dynamic> data,
    String? docId,
    Map<String, String>? idFields,
  }) async {
    try {
      final collectionRef = _firestore.collection(path);

      var fullPath = fullTrimmedPath(path, docId ?? '');

      if (docId == null) {
        final newDocRef = collectionRef.doc();
        docId = newDocRef.id;
        fullPath = fullTrimmedPath(path, docId);
      }
      if (idFields?.entries != null) {
        for (final idField in idFields!.entries) {
          data[idField.key] = idField.value + docId;
        }
      }

      _log.info('fullPath: $fullPath');
      _log.info('data: $data');
      await _firestore.doc(fullPath).set(data);

      return docId;
    } catch (e, stackTrace) {
      SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
      // ignore: avoid_print
      print('Failed to add document at $path: $e');
      throw Exception('Failed to add document at $path: $e');
    }
  }

  Future<void> updateDocument(String path, String id, Map<String, dynamic> data) async {
    try {
      final fullPath = fullTrimmedPath(path, id);
      final ref = _firestore.doc(fullPath);
      await ref.update(data);
    } catch (e, stackTrace) {
      SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
      throw Exception('Failed to update document at $path $id: $e');
    }
  }

  Future<void> deleteDocument(String path, String id) async {
    return _firestore.collection(path).doc(id).delete();
  }

  Query<Map<String, dynamic>> _collectionQuery(
    String path, {
    String? orderBy,
    bool? descending,
    List<FirestoreWhere>? where,
    List<String>? whereNullFields,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(path);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending!);
    }
    if (where != null) {
      for (final clause in where) {
        query = clause.apply(query);
      }
    }
    if (whereNullFields != null) {
      for (var field in whereNullFields) {
        query = query.where(field, isNull: true);
      }
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query;
  }

  String _trimPath(String path) {
    return path.trim().replaceAll(RegExp(r'/+$'), '');
  }

  String fullTrimmedPath(String path, String id) {
    final trimmedPath = _trimPath(path);
    final trimmedId = id.trim();
    return '$trimmedPath/$trimmedId';
  }
}
