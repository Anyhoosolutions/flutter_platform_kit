import 'package:anyhoo_firestore_converters/anyhoo_firestore_converters.dart';
import 'package:test/test.dart';

void main() {
  const converter = TimestampConverter();
  final date = DateTime.utc(2026, 9, 28, 20);

  test('reads DateTime, ISO strings, and epoch milliseconds', () {
    expect(converter.fromJson(date), date);
    expect(converter.fromJson(date.toIso8601String()), date);
    expect(converter.fromJson(date.millisecondsSinceEpoch).toUtc(), date);
  });

  test('reads seconds maps and objects with toDate', () {
    final seconds = date.millisecondsSinceEpoch ~/ 1000;
    expect(converter.fromJson({'seconds': seconds, 'nanoseconds': 0}), date);
    expect(converter.fromJson({'_seconds': seconds, '_nanoseconds': 0}), date);
    expect(converter.fromJson(_FakeTimestamp(date)), date);
  });

  test('writes the DateTime through unchanged', () {
    expect(converter.toJson(date), date);
  });

  test('rejects values that are not timestamps', () {
    expect(() => converter.fromJson(true), throwsArgumentError);
  });
}

class _FakeTimestamp {
  _FakeTimestamp(this.date);

  final DateTime date;

  DateTime toDate() => date;
}
