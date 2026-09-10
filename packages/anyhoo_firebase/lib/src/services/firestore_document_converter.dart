import 'package:cloud_firestore/cloud_firestore.dart';

/// Thrown when a Firestore document field cannot be converted.
class FirestoreConversionException implements Exception {
  const FirestoreConversionException({
    required this.message,
    this.documentPath,
    this.fieldPath,
    this.value,
    this.cause,
  });

  final String message;
  final String? documentPath;
  final String? fieldPath;
  final Object? value;
  final Object? cause;

  @override
  String toString() {
    final parts = <String>[message];
    if (documentPath != null) {
      parts.add('document: $documentPath');
    }
    if (fieldPath != null) {
      parts.add('field: $fieldPath');
    }
    if (value != null) {
      parts.add('value type: ${value.runtimeType}');
    }
    if (cause != null) {
      parts.add('cause: $cause');
    }
    return 'FirestoreConversionException: ${parts.join(', ')}';
  }
}

/// Converts a Firestore document to app-facing values and adds [id].
///
/// Returns null when [data] is null (the document does not exist).
///
/// Conversions:
/// - [Timestamp] → UTC ISO-8601 string (`...Z`)
/// - [GeoPoint] → `{latitude, longitude}`
/// - nested maps and lists, recursively
Map<String, dynamic>? fromFirestoreDocument(
  Map<String, dynamic>? data,
  String id, {
  String? documentPath,
}) {
  if (data == null) return null;
  return _convertDocument(
    documentPath: documentPath,
    convert: () => {
      for (final entry in data.entries)
        entry.key: _fromFirestoreValue(entry.value, path: entry.key, documentPath: documentPath),
      'id': id,
    },
  );
}

/// Converts app-facing document values to Firestore types.
///
/// Conversions:
/// - [DateTime] → [Timestamp]
/// - UTC/offset ISO-8601 strings → [Timestamp]
/// - `{latitude, longitude}` maps → [GeoPoint]
/// - nested maps and lists, recursively
/// - [FieldValue] sentinels left unchanged
Map<String, dynamic> toFirestoreDocument(
  Map<String, dynamic> data, {
  String? documentPath,
}) {
  return _convertDocument(
    documentPath: documentPath,
    convert: () => {
      for (final entry in data.entries)
        entry.key: _toFirestoreValue(entry.value, path: entry.key, documentPath: documentPath),
    },
  );
}

Map<String, dynamic> _convertDocument({
  required String? documentPath,
  required Map<String, dynamic> Function() convert,
}) {
  try {
    return convert();
  } on FirestoreConversionException {
    rethrow;
  } catch (e) {
    throw FirestoreConversionException(
      message: 'Failed to convert document',
      documentPath: documentPath,
      cause: e,
    );
  }
}

dynamic _fromFirestoreValue(
  dynamic value, {
  required String path,
  String? documentPath,
}) {
  return _convertValue(value, path: path, documentPath: documentPath, convert: () {
    if (value is Timestamp) {
      return value.toDate().toUtc().toIso8601String();
    }
    if (value is GeoPoint) {
      return {'latitude': value.latitude, 'longitude': value.longitude};
    }
    if (value is Map) {
      return {
        for (final entry in value.entries)
          entry.key.toString(): _fromFirestoreValue(
            entry.value,
            path: '$path.${entry.key}',
            documentPath: documentPath,
          ),
      };
    }
    if (value is List) {
      return [
        for (var i = 0; i < value.length; i++)
          _fromFirestoreValue(value[i], path: '$path[$i]', documentPath: documentPath),
      ];
    }
    return value;
  });
}

dynamic _toFirestoreValue(
  dynamic value, {
  required String path,
  String? documentPath,
}) {
  return _convertValue(value, path: path, documentPath: documentPath, convert: () {
    if (value is FieldValue || value is Timestamp || value is GeoPoint) {
      return value;
    }
    if (value is DateTime) {
      return Timestamp.fromDate(value);
    }
    if (value is String && _isIsoDateTimeString(value)) {
      return Timestamp.fromDate(DateTime.parse(value));
    }
    if (value is Map) {
      if (_isGeoMap(value)) {
        return GeoPoint((value['latitude'] as num).toDouble(), (value['longitude'] as num).toDouble());
      }
      return {
        for (final entry in value.entries)
          entry.key.toString(): _toFirestoreValue(
            entry.value,
            path: '$path.${entry.key}',
            documentPath: documentPath,
          ),
      };
    }
    if (value is List) {
      return [
        for (var i = 0; i < value.length; i++)
          _toFirestoreValue(value[i], path: '$path[$i]', documentPath: documentPath),
      ];
    }
    return value;
  });
}

T _convertValue<T>(
  dynamic value, {
  required String path,
  String? documentPath,
  required T Function() convert,
}) {
  try {
    return convert();
  } on FirestoreConversionException {
    rethrow;
  } catch (e) {
    throw FirestoreConversionException(
      message: 'Failed to convert field',
      documentPath: documentPath,
      fieldPath: path,
      value: value,
      cause: e,
    );
  }
}

bool _isIsoDateTimeString(String value) {
  return value.contains('T') && DateTime.tryParse(value) != null;
}

bool _isGeoMap(Map<dynamic, dynamic> value) {
  return value.length == 2 && value['latitude'] is num && value['longitude'] is num;
}
