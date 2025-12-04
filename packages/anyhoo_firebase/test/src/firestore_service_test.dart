// ignore_for_file: subtype_of_sealed_class

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:anyhoo_firebase/src/firestore_service.dart';

// Mock classes
// Note: Some classes are sealed but we use Mock for testing purposes
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late FirestoreService firestoreService;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockQuery mockQuery;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockDocumentSnapshot mockDocumentSnapshot;

  setUpAll(() async {
    // Initialize Firebase for tests that use FirebaseFirestore.instance
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'test-api-key',
          appId: 'test-app-id',
          messagingSenderId: 'test-sender-id',
          projectId: 'test-project-id',
        ),
      );
    } catch (e) {
      // Firebase might already be initialized, try to get existing app
      try {
        Firebase.app();
      } catch (_) {
        // If we can't get an app either, the tests using FirebaseFirestore.instance will fail
        // This is expected due to the implementation using static instance instead of injected one
      }
    }
  });

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockQuery = MockQuery();
    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentSnapshot = MockDocumentSnapshot();

    firestoreService = FirestoreService(firestore: mockFirestore);
  });

  group('FirestoreService', () {
    group('getSnapshotsStream', () {
      test('returns stream of documents with id field', () async {
        final doc1 = MockQueryDocumentSnapshot();
        final doc2 = MockQueryDocumentSnapshot();

        when(() => doc1.id).thenReturn('doc1');
        when(() => doc1.data()).thenReturn({'name': 'Test 1', 'value': 10});
        when(() => doc2.id).thenReturn('doc2');
        when(() => doc2.data()).thenReturn({'name': 'Test 2', 'value': 20});

        when(() => mockQuerySnapshot.docs).thenReturn([doc1, doc2]);
        when(() => mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
        // Collection returns query when no filters applied
        when(() => mockCollection.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
        when(() => mockFirestore.collection(any())).thenReturn(mockCollection);

        final stream = firestoreService.getSnapshotsStream('test_collection');
        final result = await stream.first;

        expect(result.length, 2);
        expect(result[0]['id'], 'doc1');
        expect(result[0]['name'], 'Test 1');
        expect(result[0]['value'], 10);
        expect(result[1]['id'], 'doc2');
        expect(result[1]['name'], 'Test 2');
        expect(result[1]['value'], 20);

        verify(() => mockFirestore.collection('test_collection')).called(1);
      });

      test('applies orderBy when provided', () async {
        final doc1 = MockQueryDocumentSnapshot();
        when(() => doc1.id).thenReturn('doc1');
        when(() => doc1.data()).thenReturn({'name': 'Test'});
        when(() => mockQuerySnapshot.docs).thenReturn([doc1]);
        when(() => mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
        when(() => mockCollection.orderBy(any(), descending: any(named: 'descending'))).thenReturn(mockQuery);
        when(() => mockFirestore.collection(any())).thenReturn(mockCollection);

        await firestoreService.getSnapshotsStream('test_collection', orderBy: 'name', descending: true).first;

        verify(() => mockCollection.orderBy('name', descending: true)).called(1);
      });

      test('applies whereNullFields when provided', () async {
        final doc1 = MockQueryDocumentSnapshot();
        when(() => doc1.id).thenReturn('doc1');
        when(() => doc1.data()).thenReturn({'name': 'Test'});
        when(() => mockQuerySnapshot.docs).thenReturn([doc1]);
        when(() => mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
        when(() => mockQuery.where(any(), isNull: any(named: 'isNull'))).thenReturn(mockQuery);
        when(() => mockCollection.where(any(), isNull: any(named: 'isNull'))).thenReturn(mockQuery);
        when(() => mockFirestore.collection(any())).thenReturn(mockCollection);

        await firestoreService.getSnapshotsStream('test_collection', whereNullFields: ['deletedAt']).first;

        verify(() => mockCollection.where('deletedAt', isNull: true)).called(1);
      });

      test('applies limit when provided', () async {
        final doc1 = MockQueryDocumentSnapshot();
        when(() => doc1.id).thenReturn('doc1');
        when(() => doc1.data()).thenReturn({'name': 'Test'});
        when(() => mockQuerySnapshot.docs).thenReturn([doc1]);
        when(() => mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
        when(() => mockQuery.limit(any())).thenReturn(mockQuery);
        when(() => mockCollection.limit(any())).thenReturn(mockQuery);
        when(() => mockFirestore.collection(any())).thenReturn(mockCollection);

        await firestoreService.getSnapshotsStream('test_collection', limit: 5).first;

        verify(() => mockCollection.limit(5)).called(1);
      });
    });

    group('getDocumentIdsStreamAsJson', () {
      test('returns stream of JSON encoded documents', () async {
        final doc1 = MockQueryDocumentSnapshot();
        when(() => doc1.id).thenReturn('doc1');
        when(() => doc1.data()).thenReturn({'name': 'Test 1'});
        when(() => mockQuerySnapshot.docs).thenReturn([doc1]);
        when(() => mockCollection.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
        when(() => mockFirestore.collection(any())).thenReturn(mockCollection);

        final stream = firestoreService.getDocumentIdsStreamAsJson('test_collection');
        final result = await stream.first;

        expect(result.length, 1);
        expect(result[0], contains('"id":"doc1"'));
        expect(result[0], contains('"name":"Test 1"'));
      });
    });

    group('getSnapshotsForDocument', () {
      test('returns stream of document data', () async {
        when(() => mockDocumentSnapshot.data()).thenReturn({'name': 'Test', 'value': 42});
        when(() => mockDocument.snapshots()).thenAnswer((_) => Stream.value(mockDocumentSnapshot));
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);

        final stream = firestoreService.getSnapshotsForDocument('test_collection/doc1');
        final result = await stream.first;

        expect(result, {'name': 'Test', 'value': 42});
        verify(() => mockFirestore.doc('test_collection/doc1')).called(1);
      });

      test('returns null when document does not exist', () async {
        when(() => mockDocumentSnapshot.data()).thenReturn(null);
        when(() => mockDocument.snapshots()).thenAnswer((_) => Stream.value(mockDocumentSnapshot));
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);

        final stream = firestoreService.getSnapshotsForDocument('test_collection/doc1');
        final result = await stream.first;

        expect(result, isNull);
      });
    });

    group('getDocumentIdStreamAsJson', () {
      test('returns stream of JSON encoded document', () async {
        when(() => mockDocumentSnapshot.data()).thenReturn({'name': 'Test', 'value': 42});
        when(() => mockDocument.snapshots()).thenAnswer((_) => Stream.value(mockDocumentSnapshot));
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);

        final stream = firestoreService.getDocumentIdStreamAsJson('test_collection/doc1');
        final result = await stream.first;

        expect(result, contains('"name":"Test"'));
        expect(result, contains('"value":42'));
      });
    });

    group('getSnapshotsList', () {
      test('returns list of documents with id field', () async {
        final doc1 = MockQueryDocumentSnapshot();
        final doc2 = MockQueryDocumentSnapshot();

        when(() => doc1.id).thenReturn('doc1');
        when(() => doc1.data()).thenReturn({'name': 'Test 1', 'value': 10});
        when(() => doc2.id).thenReturn('doc2');
        when(() => doc2.data()).thenReturn({'name': 'Test 2', 'value': 20});

        when(() => mockQuerySnapshot.docs).thenReturn([doc1, doc2]);
        when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockFirestore.collection(any())).thenReturn(mockCollection);

        final result = await firestoreService.getSnapshotsList('test_collection');

        expect(result.length, 2);
        expect(result[0]['id'], 'doc1');
        expect(result[0]['name'], 'Test 1');
        expect(result[1]['id'], 'doc2');
        expect(result[1]['name'], 'Test 2');

        verify(() => mockFirestore.collection('test_collection')).called(1);
      });

      test('applies query parameters correctly', () async {
        final doc1 = MockQueryDocumentSnapshot();
        when(() => doc1.id).thenReturn('doc1');
        when(() => doc1.data()).thenReturn({'name': 'Test'});
        when(() => mockQuerySnapshot.docs).thenReturn([doc1]);
        when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        // After orderBy returns a Query, subsequent calls are on that Query
        when(() => mockQuery.where(any(), isNull: any(named: 'isNull'))).thenReturn(mockQuery);
        when(() => mockQuery.limit(any())).thenReturn(mockQuery);
        when(() => mockCollection.orderBy(any(), descending: any(named: 'descending'))).thenReturn(mockQuery);
        when(() => mockFirestore.collection(any())).thenReturn(mockCollection);

        await firestoreService.getSnapshotsList(
          'test_collection',
          orderBy: 'name',
          descending: true,
          whereNullFields: ['deletedAt'],
          limit: 10,
        );

        // Verify orderBy is called on collection (returns a Query)
        verify(() => mockCollection.orderBy('name', descending: true)).called(1);
        // Verify where and limit are called on the Query returned from orderBy
        verify(() => mockQuery.where('deletedAt', isNull: true)).called(1);
        verify(() => mockQuery.limit(10)).called(1);
      });
    });

    group('getSnapshotsListAsJson', () {
      test('returns JSON encoded list of documents', () async {
        final doc1 = MockQueryDocumentSnapshot();
        when(() => doc1.id).thenReturn('doc1');
        when(() => doc1.data()).thenReturn({'name': 'Test 1'});
        when(() => mockQuerySnapshot.docs).thenReturn([doc1]);
        when(() => mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(() => mockFirestore.collection(any())).thenReturn(mockCollection);

        final result = await firestoreService.getSnapshotsListAsJson('test_collection');

        expect(result, contains('"id":"doc1"'));
        expect(result, contains('"name":"Test 1"'));
      });
    });

    group('getDocument', () {
      test('returns document data when document exists', () async {
        when(() => mockDocumentSnapshot.data()).thenReturn({'name': 'Test', 'value': 42});
        when(() => mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);

        final result = await firestoreService.getDocument('test_collection/doc1');

        expect(result, {'name': 'Test', 'value': 42});
        verify(() => mockFirestore.doc('test_collection/doc1')).called(1);
        verify(() => mockDocument.get()).called(1);
      });

      test('returns null when document does not exist', () async {
        when(() => mockDocumentSnapshot.data()).thenReturn(null);
        when(() => mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);

        final result = await firestoreService.getDocument('test_collection/doc1');

        expect(result, isNull);
      });

      test('rethrows exception on error', () async {
        when(() => mockDocument.get()).thenThrow(Exception('Firestore error'));
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);

        expect(() => firestoreService.getDocument('test_collection/doc1'), throwsException);
      });
    });

    group('getDocumentAsJson', () {
      test('returns JSON encoded document', () async {
        when(() => mockDocumentSnapshot.data()).thenReturn({'name': 'Test', 'value': 42});
        when(() => mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);

        final result = await firestoreService.getDocumentAsJson('test_collection/doc1');

        expect(result, contains('"name":"Test"'));
        expect(result, contains('"value":42'));
      });
    });

    group('addDocument', () {
      test('creates document with provided docId', () async {
        when(() => mockFirestore.collection('test_collection')).thenReturn(mockCollection);
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);
        when(() => mockDocument.set(any())).thenAnswer((_) async => {});

        final docId = await firestoreService.addDocument(
          path: 'test_collection',
          data: {'name': 'Test', 'value': 42},
          docId: 'doc1',
        );

        expect(docId, 'doc1');
        verify(() => mockFirestore.collection('test_collection')).called(1);
        verify(() => mockFirestore.doc('test_collection/doc1')).called(1);
        verify(() => mockDocument.set({'name': 'Test', 'value': 42})).called(1);
      });

      test('generates docId when not provided', () async {
        final newDocRef = MockDocumentReference();
        when(() => newDocRef.id).thenReturn('generated_id');

        when(() => mockFirestore.collection('test_collection')).thenReturn(mockCollection);
        when(() => mockCollection.doc()).thenReturn(newDocRef);
        when(() => mockFirestore.doc('test_collection/generated_id')).thenReturn(mockDocument);
        when(() => mockDocument.set(any())).thenAnswer((_) async => {});

        final docId = await firestoreService.addDocument(path: 'test_collection', data: {'name': 'Test'});

        expect(docId, 'generated_id');
        verify(() => mockFirestore.collection('test_collection')).called(1);
        verify(() => mockCollection.doc()).called(1);
        verify(() => mockFirestore.doc('test_collection/generated_id')).called(1);
        verify(() => mockDocument.set({'name': 'Test'})).called(1);
      });

      test('adds idFields to data', () async {
        when(() => mockFirestore.collection('test_collection')).thenReturn(mockCollection);
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);
        when(() => mockDocument.set(any())).thenAnswer((_) async => {});

        await firestoreService.addDocument(
          path: 'test_collection',
          data: {'name': 'Test'},
          docId: 'doc1',
          idFields: {'refId': 'ref_'},
        );

        verify(() => mockFirestore.collection('test_collection')).called(1);
        verify(() => mockFirestore.doc('test_collection/doc1')).called(1);
        verify(() => mockDocument.set({'name': 'Test', 'refId': 'ref_doc1'})).called(1);
      });
    });

    group('addDocumentAsJson', () {
      test('decodes JSON and calls addDocument', () async {
        when(() => mockFirestore.collection('test_collection')).thenReturn(mockCollection);
        when(() => mockFirestore.doc('test_collection/doc1')).thenReturn(mockDocument);
        when(() => mockDocument.set(any())).thenAnswer((_) async => {});

        await firestoreService.addDocumentAsJson(
          path: 'test_collection',
          data: '{"name":"Test","value":42}',
          docId: 'doc1',
        );

        verify(() => mockFirestore.collection('test_collection')).called(1);
        verify(() => mockFirestore.doc('test_collection/doc1')).called(1);
        verify(() => mockDocument.set({'name': 'Test', 'value': 42})).called(1);
      });
    });

    group('updateDocument', () {
      test('updates document successfully', () async {
        when(() => mockCollection.doc('doc1')).thenReturn(mockDocument);
        when(() => mockDocument.update(any())).thenAnswer((_) async => {});
        when(() => mockFirestore.collection('test_collection')).thenReturn(mockCollection);

        await firestoreService.updateDocument('test_collection', 'doc1', {'name': 'Updated', 'value': 100});

        verify(() => mockFirestore.collection('test_collection')).called(1);
        verify(() => mockCollection.doc('doc1')).called(1);
        verify(() => mockDocument.update({'name': 'Updated', 'value': 100})).called(1);
      });

      test('throws exception on error', () async {
        when(() => mockCollection.doc(any())).thenReturn(mockDocument);
        when(() => mockDocument.update(any())).thenThrow(Exception('Update failed'));
        when(() => mockFirestore.collection('test_collection')).thenReturn(mockCollection);

        expect(
          () => firestoreService.updateDocument('test_collection', 'doc1', {'name': 'Updated'}),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateDocumentAsJson', () {
      test('decodes JSON and calls updateDocument', () async {
        when(() => mockCollection.doc('doc1')).thenReturn(mockDocument);
        when(() => mockDocument.update(any())).thenAnswer((_) async => {});
        when(() => mockFirestore.collection('test_collection')).thenReturn(mockCollection);

        await firestoreService.updateDocumentAsJson('test_collection', 'doc1', '{"name":"Updated","value":100}');

        verify(() => mockDocument.update({'name': 'Updated', 'value': 100})).called(1);
      });
    });

    group('deleteDocument', () {
      test('deletes document successfully', () async {
        when(() => mockCollection.doc(any())).thenReturn(mockDocument);
        when(() => mockDocument.delete()).thenAnswer((_) async => {});
        when(() => mockFirestore.collection('test_collection')).thenReturn(mockCollection);

        await firestoreService.deleteDocument('test_collection', 'doc1');

        verify(() => mockFirestore.collection('test_collection')).called(1);
        verify(() => mockCollection.doc('doc1')).called(1);
        verify(() => mockDocument.delete()).called(1);
      });
    });
  });
}
