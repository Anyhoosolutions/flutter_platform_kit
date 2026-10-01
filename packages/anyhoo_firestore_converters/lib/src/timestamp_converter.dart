import 'package:json_annotation/json_annotation.dart';

/// Converts Firestore timestamp values to [DateTime] without depending on Flutter.
///
/// [fromJson] accepts the shapes produced by the client SDK, the server SDK,
/// and plain JSON: objects with `toDate()`, ISO-8601 strings, epoch milliseconds,
/// and maps with `seconds`/`nanoseconds` (or the `_seconds`/`_nanoseconds` keys).
///
/// [toJson] returns the [DateTime]. Both `cloud_firestore` and
/// `google_cloud_firestore` encode [DateTime] as a timestamp on write.
class TimestampConverter implements JsonConverter<DateTime, Object> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is DateTime) {
      return json;
    }
    if (json is String) {
      return DateTime.parse(json);
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }

    final fromTimestamp = _dateFromToDate(json);
    if (fromTimestamp != null) {
      return fromTimestamp;
    }

    final fromMap = _dateFromSecondsMap(json);
    if (fromMap != null) {
      return fromMap;
    }

    throw ArgumentError('Cannot convert $json to DateTime');
  }

  @override
  Object toJson(DateTime date) => date;
}

DateTime? _dateFromToDate(Object json) {
  try {
    final date = (json as dynamic).toDate();
    if (date is DateTime) {
      return date;
    }
  } on NoSuchMethodError {
    return null;
  }
  return null;
}

DateTime? _dateFromSecondsMap(Object json) {
  if (json is! Map) {
    return null;
  }
  final seconds = json['seconds'] ?? json['_seconds'];
  if (seconds is! int) {
    return null;
  }
  final nanos = json['nanoseconds'] ?? json['_nanoseconds'] ?? 0;
  final nanosInt = nanos is int ? nanos : 0;
  return DateTime.fromMillisecondsSinceEpoch(
    seconds * 1000 + nanosInt ~/ 1000000,
    isUtc: true,
  );
}
