import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

AnyhooMapSettings get _testSettings => AnyhooMapSettings(
  flutter: AnyhooFlutterMapSettings(
    urlTemplate: 'https://example.invalid/{z}/{x}/{y}.png',
    userAgentPackageName: 'test',
    tileProvider: AnyhooNoNetworkTileProvider(),
  ),
);

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: SizedBox(width: 400, height: 400, child: child)),
  );
}

void main() {
  testWidgets('flutter map reports marker taps by id', (tester) async {
    String? tappedId;
    await tester.pumpWidget(
      _wrap(
        AnyhooMap(
          mapType: AnyhooMapType.flutter,
          location: const AnyhooLatLong(latitude: 0, longitude: 0),
          markers: const [
            AnyhooMarker(
              id: 'pin-1',
              location: AnyhooLatLong(latitude: 0, longitude: 0),
              title: 'Pin',
              description: '',
            ),
          ],
          settings: _testSettings,
          onMarkerTapped: (id) => tappedId = id,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('pin-1')));
    expect(tappedId, 'pin-1');
  });

  testWidgets('selected marker uses a different default pin color', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AnyhooMap(
          mapType: AnyhooMapType.flutter,
          location: const AnyhooLatLong(latitude: 0, longitude: 0),
          selectedMarkerId: 'selected',
          markers: const [
            AnyhooMarker(
              id: 'selected',
              location: AnyhooLatLong(latitude: 0, longitude: 0),
              title: 'Selected',
              description: '',
            ),
            AnyhooMarker(
              id: 'other',
              location: AnyhooLatLong(latitude: 0, longitude: 0),
              title: 'Other',
              description: '',
            ),
          ],
          settings: _testSettings,
        ),
      ),
    );
    await tester.pump();

    final icons = tester
        .widgetList<Icon>(find.byIcon(Icons.location_on))
        .toList();
    expect(icons, hasLength(2));
    expect(icons.any((icon) => icon.color == Colors.blue), isTrue);
    expect(icons.any((icon) => icon.color == Colors.red), isTrue);
  });
}
