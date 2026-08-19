import 'package:cloud_firestore/cloud_firestore.dart';

/// Converts a Firestore document to app-facing values and adds [id].
///
/// Returns null when [data] is null (the document does not exist).
///
/// Conversions:
/// - [Timestamp] → UTC ISO-8601 string (`...Z`)
/// - [GeoPoint] → `{latitude, longitude}`
/// - nested maps and lists, recursively
Map<String, dynamic>? fromFirestoreDocument(Map<String, dynamic>? data, String id) {
  if (data == null) return null;
  return {
    for (final entry in data.entries) entry.key: _fromFirestoreValue(entry.value),
    'id': id,
  };
}

/// Converts app-facing document values to Firestore types.
///
/// Conversions:
/// - [DateTime] → [Timestamp]
/// - UTC/offset ISO-8601 strings → [Timestamp]
/// - `{latitude, longitude}` maps → [GeoPoint]
/// - nested maps and lists, recursively
/// - [FieldValue] sentinels left unchanged
Map<String, dynamic> toFirestoreDocument(Map<String, dynamic> data) {
  return {for (final entry in data.entries) entry.key: _toFirestoreValue(entry.value)};
}

dynamic _fromFirestoreValue(dynamic value) {
  if (value is Timestamp) {
    return value.toDate().toUtc().toIso8601String();
  }
  if (value is GeoPoint) {
    return {'latitude': value.latitude, 'longitude': value.longitude};
  }
  if (value is Map) {
    return {for (final entry in value.entries) entry.key.toString(): _fromFirestoreValue(entry.value)};
  }
  if (value is List) {
    return value.map(_fromFirestoreValue).toList();
  }
  return value;
}

dynamic _toFirestoreValue(dynamic value) {
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
    return {for (final entry in value.entries) entry.key.toString(): _toFirestoreValue(entry.value)};
  }
  if (value is List) {
    return value.map(_toFirestoreValue).toList();
  }
  return value;
}

bool _isIsoDateTimeString(String value) {
  return value.contains('T') && DateTime.tryParse(value) != null;
}

bool _isGeoMap(Map<dynamic, dynamic> value) {
  return value.length == 2 && value['latitude'] is num && value['longitude'] is num;
}
