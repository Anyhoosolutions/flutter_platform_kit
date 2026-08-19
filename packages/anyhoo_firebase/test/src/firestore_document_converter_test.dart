import 'package:anyhoo_firebase/src/services/firestore_document_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final utc = DateTime.utc(2024, 6, 1, 13, 0, 0);
  final timestamp = Timestamp.fromDate(utc);
  final iso = utc.toIso8601String();
  final geoPoint = GeoPoint(59.3293, 18.0686);
  final geoMap = {'latitude': 59.3293, 'longitude': 18.0686};

  group('fromFirestoreDocument', () {
    test('returns null when data is null', () {
      expect(fromFirestoreDocument(null, 'doc1'), isNull);
    });

    test('adds snapshot id', () {
      final result = fromFirestoreDocument({'name': 'Test'}, 'doc1');

      expect(result, {'name': 'Test', 'id': 'doc1'});
    });

    test('snapshot id overwrites an existing id field', () {
      final result = fromFirestoreDocument({'id': timestamp, 'name': 'Test'}, 'doc1');

      expect(result!['id'], 'doc1');
      expect(result['name'], 'Test');
    });

    test('does not mutate the original map', () {
      final original = {'updatedAt': timestamp};

      fromFirestoreDocument(original, 'doc1');

      expect(original.containsKey('id'), isFalse);
      expect(original['updatedAt'], timestamp);
    });

    test('converts Timestamp to a UTC ISO-8601 string', () {
      final result = fromFirestoreDocument({'updatedAt': timestamp}, 'doc1');

      expect(result!['updatedAt'], iso);
      expect(iso, endsWith('Z'));
    });

    test('converts Timestamp nested in a map', () {
      final result = fromFirestoreDocument({
        'meta': {'updatedAt': timestamp},
      }, 'doc1');

      expect(result!['meta'], {'updatedAt': iso});
    });

    test('converts Timestamp nested in a list', () {
      final result = fromFirestoreDocument({
        'history': [timestamp, 'ok', 1],
      }, 'doc1');

      expect(result!['history'], [iso, 'ok', 1]);
    });

    test('converts GeoPoint to a latitude/longitude map', () {
      final result = fromFirestoreDocument({'location': geoPoint}, 'doc1');

      expect(result!['location'], geoMap);
    });

    test('converts GeoPoint nested in a list', () {
      final result = fromFirestoreDocument({
        'places': [geoPoint],
      }, 'doc1');

      expect(result!['places'], [geoMap]);
    });

    test('leaves strings, numbers, bools, and null unchanged', () {
      final result = fromFirestoreDocument({
        'name': 'Test',
        'count': 3,
        'ratio': 1.5,
        'active': true,
        'deletedAt': null,
      }, 'doc1');

      expect(result, {
        'name': 'Test',
        'count': 3,
        'ratio': 1.5,
        'active': true,
        'deletedAt': null,
        'id': 'doc1',
      });
    });
  });

  group('toFirestoreDocument', () {
    test('converts DateTime to Timestamp', () {
      final result = toFirestoreDocument({'updatedAt': utc});

      expect(result['updatedAt'], timestamp);
    });

    test('converts a UTC ISO-8601 string to Timestamp', () {
      final result = toFirestoreDocument({'updatedAt': iso});

      expect(result['updatedAt'], timestamp);
    });

    test('converts a local DateTime to Timestamp of the same instant', () {
      final local = utc.toLocal();

      final result = toFirestoreDocument({'updatedAt': local});

      expect(result['updatedAt'], Timestamp.fromDate(local));
    });

    test('converts an unqualified ISO-8601 string as local time', () {
      final local = DateTime(2024, 6, 1, 15, 0, 0);
      final localIso = local.toIso8601String();

      expect(localIso.contains('Z'), isFalse);

      final result = toFirestoreDocument({'updatedAt': localIso});

      expect(result['updatedAt'], Timestamp.fromDate(local));
    });

    test('leaves date-only strings unchanged', () {
      final result = toFirestoreDocument({'day': '2024-06-01'});

      expect(result['day'], '2024-06-01');
    });

    test('leaves non-date strings unchanged', () {
      final result = toFirestoreDocument({'name': 'Test', 'note': 'not a date'});

      expect(result['name'], 'Test');
      expect(result['note'], 'not a date');
    });

    test('converts a latitude/longitude map to GeoPoint', () {
      final result = toFirestoreDocument({'location': geoMap});

      expect(result['location'], geoPoint);
    });

    test('converts integer latitude/longitude to GeoPoint', () {
      final result = toFirestoreDocument({
        'location': {'latitude': 59, 'longitude': 18},
      });

      expect(result['location'], GeoPoint(59, 18));
    });

    test('does not treat maps with extra keys as GeoPoint', () {
      final location = {'latitude': 59.3293, 'longitude': 18.0686, 'label': 'home'};

      final result = toFirestoreDocument({'location': location});

      expect(result['location'], isNot(isA<GeoPoint>()));
      expect(result['location'], location);
    });

    test('converts DateTime nested in a map and list', () {
      final result = toFirestoreDocument({
        'meta': {'updatedAt': utc},
        'history': [utc, 'ok'],
      });

      expect(result['meta'], {'updatedAt': timestamp});
      expect(result['history'], [timestamp, 'ok']);
    });

    test('leaves FieldValue sentinels unchanged', () {
      final serverTimestamp = FieldValue.serverTimestamp();
      final increment = FieldValue.increment(1);
      final delete = FieldValue.delete();

      final result = toFirestoreDocument({
        'createdAt': serverTimestamp,
        'count': increment,
        'obsolete': delete,
      });

      expect(result['createdAt'], same(serverTimestamp));
      expect(result['count'], same(increment));
      expect(result['obsolete'], same(delete));
    });

    test('leaves existing Timestamp and GeoPoint unchanged', () {
      final result = toFirestoreDocument({
        'updatedAt': timestamp,
        'location': geoPoint,
      });

      expect(result['updatedAt'], timestamp);
      expect(result['location'], geoPoint);
    });

    test('does not mutate the original map', () {
      final original = {'updatedAt': utc};

      toFirestoreDocument(original);

      expect(original['updatedAt'], utc);
    });

    test('leaves numbers, bools, and null unchanged', () {
      final result = toFirestoreDocument({
        'count': 3,
        'active': true,
        'deletedAt': null,
      });

      expect(result, {'count': 3, 'active': true, 'deletedAt': null});
    });
  });

  group('round trip', () {
    test('Timestamp survives fromFirestore then toFirestore', () {
      final converted = fromFirestoreDocument({
        'updatedAt': timestamp,
        'location': geoPoint,
      }, 'doc1');
      final back = toFirestoreDocument(converted!);

      expect(back['updatedAt'], timestamp);
      expect(back['location'], geoPoint);
      expect(back['id'], 'doc1');
    });
  });
}
