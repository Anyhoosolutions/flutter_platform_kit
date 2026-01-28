import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter/material.dart';

class AnyhooMap extends StatelessWidget {
  final AnyhooMapType mapType;
  final AnyhooLatLong location;
  final double initialZoom;
  final List<AnyhooMarker> markers;

  const AnyhooMap({
    super.key,
    required this.mapType,
    required this.location,
    required this.initialZoom,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    if (mapType == AnyhooMapType.google) {
      return GoogleMapView(location: location, initialZoom: initialZoom, markers: markers);
    } else if (mapType == AnyhooMapType.flutter) {
      return FlutterMapView(location: location, initialZoom: initialZoom, markers: markers);
    } else {
      throw Exception('Invalid map type: $mapType');
    }
  }
}
