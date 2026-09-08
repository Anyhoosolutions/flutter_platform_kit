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

  test('fitToMarkers and cameraPadding default off / zero', () {
    const settings = AnyhooMapSettings();
    expect(settings.fitToMarkers, isFalse);
    expect(settings.cameraPadding, EdgeInsets.zero);
  });
}
