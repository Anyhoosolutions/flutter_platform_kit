import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnyhooLatLong', () {
    test('getDistance returns about 111 km between 0,0 and 0,1', () {
      const a = AnyhooLatLong(latitude: 0, longitude: 0);
      const b = AnyhooLatLong(latitude: 0, longitude: 1);

      expect(
        AnyhooLatLong.getDistance(a, b, AnyhooLatLongUnit.kilometer),
        closeTo(111.19, 0.5),
      );
    });

    test('getDistance converts units', () {
      const a = AnyhooLatLong(latitude: 0, longitude: 0);
      const b = AnyhooLatLong(latitude: 0, longitude: 1);
      final km = AnyhooLatLong.getDistance(a, b, AnyhooLatLongUnit.kilometer);
      final meters = AnyhooLatLong.getDistance(a, b, AnyhooLatLongUnit.meter);
      final miles = AnyhooLatLong.getDistance(a, b, AnyhooLatLongUnit.mile);

      expect(meters, greaterThan(km));
      expect(miles, lessThan(km));
      expect(meters / km, closeTo(1000, 5));
    });

    test('equality is by coordinates', () {
      expect(
        const AnyhooLatLong(latitude: 1, longitude: 2),
        const AnyhooLatLong(latitude: 1, longitude: 2),
      );
      expect(
        const AnyhooLatLong(latitude: 1, longitude: 2),
        isNot(const AnyhooLatLong(latitude: 1, longitude: 3)),
      );
    });
  });
}
