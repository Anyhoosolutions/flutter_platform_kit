import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnyhooMapSettings', () {
    test(
      'google flags default to enabled when google settings are omitted',
      () {
        const settings = AnyhooMapSettings();

        expect(settings.google, isNull);
        expect(settings.googleOrDefault.showUserLocation, isTrue);
        expect(settings.googleOrDefault.showMyLocationButton, isTrue);
        expect(settings.googleOrDefault.mapId, isNull);
      },
    );

    test('flutter tiles are not defaulted to public OSM', () {
      const settings = AnyhooMapSettings();

      expect(settings.flutter, isNull);
    });
  });
}
