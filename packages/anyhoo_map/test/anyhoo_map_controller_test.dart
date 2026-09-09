import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('camera methods are no-ops before an engine is attached', () async {
    final controller = AnyhooMapController();
    await controller.moveTo(const AnyhooLatLong(latitude: 1, longitude: 2));
    await controller.fitMarkers(const []);
    await controller.fitMarkers([
      AnyhooMarker(
        id: 'a',
        location: const AnyhooLatLong(latitude: 1, longitude: 2),
        title: 'A',
        description: '',
      ),
    ]);
  });

  test('markersDiffer compares id and location', () {
    const a = AnyhooMarker(
      id: 'a',
      location: AnyhooLatLong(latitude: 1, longitude: 2),
      title: 'A',
      description: '',
    );
    const moved = AnyhooMarker(
      id: 'a',
      location: AnyhooLatLong(latitude: 3, longitude: 4),
      title: 'A',
      description: '',
    );

    expect(AnyhooMapController.markersDiffer([a], [a]), isFalse);
    expect(AnyhooMapController.markersDiffer([a], [moved]), isTrue);
    expect(AnyhooMapController.markersDiffer([a], []), isTrue);
  });

  test('circlesDiffer compares id, center, and radius', () {
    const a = AnyhooCircle(
      id: 'r',
      center: AnyhooLatLong(latitude: 1, longitude: 2),
      radiusMeters: 100,
    );
    const moved = AnyhooCircle(
      id: 'r',
      center: AnyhooLatLong(latitude: 3, longitude: 4),
      radiusMeters: 100,
    );
    const larger = AnyhooCircle(
      id: 'r',
      center: AnyhooLatLong(latitude: 1, longitude: 2),
      radiusMeters: 200,
    );

    expect(AnyhooMapController.circlesDiffer([a], [a]), isFalse);
    expect(AnyhooMapController.circlesDiffer([a], [moved]), isTrue);
    expect(AnyhooMapController.circlesDiffer([a], [larger]), isTrue);
  });

  test('fitCoordinates includes marker and circle corners', () {
    const marker = AnyhooMarker(
      id: 'a',
      location: AnyhooLatLong(latitude: 0, longitude: 0),
      title: 'A',
      description: '',
    );
    const circle = AnyhooCircle(
      id: 'r',
      center: AnyhooLatLong(latitude: 0, longitude: 0),
      radiusMeters: metersPerDegreeLatitude,
    );

    final coords = AnyhooMapController.fitCoordinates(
      markers: [marker],
      circles: [circle],
    );

    expect(coords, hasLength(3));
  });

  test('fitToMarkers and cameraPadding default off / zero', () {
    const settings = AnyhooMapSettings();
    expect(settings.fitToMarkers, isFalse);
    expect(settings.cameraPadding, EdgeInsets.zero);
  });
}
