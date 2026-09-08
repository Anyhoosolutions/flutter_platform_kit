import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:anyhoo_map/src/anyhoo_map_controller.dart';
import 'package:anyhoo_map/src/anyhoo_map_settings.dart';
import 'package:anyhoo_map/src/anyhoo_map_type.dart';
import 'package:anyhoo_map/src/anyhoo_marker.dart';
import 'package:anyhoo_map/src/flutter_map.dart';
import 'package:anyhoo_map/src/google_map.dart';
import 'package:flutter/material.dart';

class AnyhooMap extends StatefulWidget {
  final AnyhooMapType mapType;
  final AnyhooLatLong location;
  final List<AnyhooMarker> markers;
  final AnyhooMapSettings settings;
  final AnyhooMapController? controller;
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
    this.controller,
    this.selectedMarkerId,
    this.onMarkerTapped,
    this.onMapTapped,
    this.markerBuilder,
  });

  @override
  State<AnyhooMap> createState() => _AnyhooMapState();
}

class _AnyhooMapState extends State<AnyhooMap> {
  late final AnyhooMapController _ownedController;

  AnyhooMapController get _controller => widget.controller ?? _ownedController;

  @override
  void initState() {
    super.initState();
    _ownedController = AnyhooMapController();
  }

  @override
  void dispose() {
    _controller.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mapType == AnyhooMapType.google) {
      return GoogleMapView(
        location: widget.location,
        markers: widget.markers,
        settings: widget.settings,
        mapController: _controller,
        selectedMarkerId: widget.selectedMarkerId,
        onMarkerTapped: widget.onMarkerTapped,
        onMapTapped: widget.onMapTapped,
      );
    } else if (widget.mapType == AnyhooMapType.flutter) {
      return FlutterMapView(
        location: widget.location,
        markers: widget.markers,
        settings: widget.settings,
        mapController: _controller,
        selectedMarkerId: widget.selectedMarkerId,
        onMarkerTapped: widget.onMarkerTapped,
        onMapTapped: widget.onMapTapped,
        markerBuilder: widget.markerBuilder,
      );
    } else {
      throw Exception('Invalid map type: ${widget.mapType}');
    }
  }
}
