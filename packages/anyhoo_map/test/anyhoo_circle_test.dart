import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnyhooCircle', () {
    test('keeps the caller-supplied id', () {
      const circle = AnyhooCircle(
        id: 'radius',
        center: AnyhooLatLong(latitude: 37.77, longitude: -122.42),
        radiusMeters: 1609.34,
      );

      expect(circle.id, 'radius');
    });

    test('boundingCoordinates expand by the radius', () {
      const center = AnyhooLatLong(latitude: 0, longitude: 0);
      const circle = AnyhooCircle(
        id: 'equator',
        center: center,
        radiusMeters: metersPerDegreeLatitude,
      );

      final bounds = circle.boundingCoordinates;
      expect(bounds, hasLength(2));
      expect(bounds.first.latitude, closeTo(-1, 0.01));
      expect(bounds.first.longitude, closeTo(-1, 0.01));
      expect(bounds.last.latitude, closeTo(1, 0.01));
      expect(bounds.last.longitude, closeTo(1, 0.01));
    });
  });
}
