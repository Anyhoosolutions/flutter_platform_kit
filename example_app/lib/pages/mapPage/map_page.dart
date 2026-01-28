import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

// ignore: unused_element
final _log = Logger('MapPage');

/// Home page that serves as a navigation hub for package demos.
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Page'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("TODO: Should have a switch between GoogleMap and FlutterMap"),
            Center(
              child: SizedBox(
                height: 400,
                width: 600,
                child: AnyhooMap(
                  settings: AnyhooMapSettings(initialZoom: 15),
                  mapType: AnyhooMapType.flutter,
                  location: AnyhooLatLong(latitude: 51.5074, longitude: -0.1278),
                  markers: [
                    AnyhooMarker(
                      location: AnyhooLatLong(latitude: 51.5094, longitude: -0.1278),
                      title: 'London',
                      description: 'This is a marker in London',
                    ),
                    AnyhooMarker(
                      location: AnyhooLatLong(latitude: 51.5070, longitude: -0.1260),
                      title: 'London',
                      description: 'Here is another marker',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
