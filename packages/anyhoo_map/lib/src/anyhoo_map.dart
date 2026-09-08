import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:anyhoo_map/src/anyhoo_map_settings.dart';
import 'package:anyhoo_map/src/anyhoo_map_type.dart';
import 'package:anyhoo_map/src/anyhoo_marker.dart';
import 'package:anyhoo_map/src/flutter_map.dart';
import 'package:anyhoo_map/src/google_map.dart';
import 'package:flutter/material.dart';

class AnyhooMap extends StatelessWidget {
  final AnyhooMapType mapType;
  final AnyhooLatLong location;
  final List<AnyhooMarker> markers;
  final AnyhooMapSettings settings;
  final String? selectedMarkerId;
  final ValueChanged<String>? onMarkerTapped;
  final ValueChanged<AnyhooLatLong>? onMapTapped;
  final AnyhooMarkerWidgetBuilder? markerBuilder;

  const AnyhooMap({
    super.key,
    required this.mapType,
    required this.location,
    required this.markers,
    required this.settings,
    this.selectedMarkerId,
    this.onMarkerTapped,
    this.onMapTapped,
    this.markerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (mapType == AnyhooMapType.google) {
      return GoogleMapView(
        location: location,
        markers: markers,
        settings: settings,
        selectedMarkerId: selectedMarkerId,
        onMarkerTapped: onMarkerTapped,
        onMapTapped: onMapTapped,
      );
    } else if (mapType == AnyhooMapType.flutter) {
      return FlutterMapView(
        location: location,
        markers: markers,
        settings: settings,
        selectedMarkerId: selectedMarkerId,
        onMarkerTapped: onMarkerTapped,
        onMapTapped: onMapTapped,
        markerBuilder: markerBuilder,
      );
    } else {
      throw Exception('Invalid map type: $mapType');
    }
  }
}
