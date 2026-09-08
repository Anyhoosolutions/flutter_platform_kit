import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnyhooMarker', () {
    test('keeps the caller-supplied id as the source of truth', () {
      final marker = AnyhooMarker(
        id: 'item-42',
        location: const AnyhooLatLong(latitude: 51.5, longitude: -0.12),
        title: 'Title',
        description: 'Description',
      );

      expect(marker.id, 'item-42');
    });
  });
}
