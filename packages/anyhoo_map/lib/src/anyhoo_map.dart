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

  const AnyhooMap({
    super.key,
    required this.mapType,
    required this.location,
    required this.markers,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    if (mapType == AnyhooMapType.google) {
      return GoogleMapView(
        location: location,
        markers: markers,
        settings: settings,
      );
    } else if (mapType == AnyhooMapType.flutter) {
      return FlutterMapView(
        location: location,
        markers: markers,
        settings: settings,
      );
    } else {
      throw Exception('Invalid map type: $mapType');
    }
  }
}
