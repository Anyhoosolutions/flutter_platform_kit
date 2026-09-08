import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var _mapType = AnyhooMapType.flutter;
  String? _selectedMarkerId;

  static const _markers = [
    AnyhooMarker(
      id: 'london-1',
      location: AnyhooLatLong(latitude: 51.5094, longitude: -0.1278),
      title: 'London',
      description: 'This is a marker in London',
    ),
    AnyhooMarker(
      id: 'london-2',
      location: AnyhooLatLong(latitude: 51.5070, longitude: -0.1260),
      title: 'London',
      description: 'Here is another marker',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<AnyhooMapType>(
              segments: const [
                ButtonSegment(
                  value: AnyhooMapType.flutter,
                  label: Text('flutter_map'),
                ),
                ButtonSegment(
                  value: AnyhooMapType.google,
                  label: Text('Google'),
                ),
              ],
              selected: {_mapType},
              onSelectionChanged: (selection) {
                setState(() => _mapType = selection.single);
              },
            ),
          ),
          Expanded(
            child: AnyhooMap(
              mapType: _mapType,
              location: const AnyhooLatLong(
                latitude: 51.5074,
                longitude: -0.1278,
              ),
              markers: _markers,
              selectedMarkerId: _selectedMarkerId,
              onMarkerTapped: (id) => setState(() => _selectedMarkerId = id),
              settings: AnyhooMapSettings(
                fitToMarkers: true,
                cameraPadding: const EdgeInsets.all(32),
                flutter: AnyhooFlutterMapSettings(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'example_app',
                  attribution: 'OpenStreetMap contributors',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
