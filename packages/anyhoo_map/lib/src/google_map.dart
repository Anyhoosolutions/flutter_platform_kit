import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatelessWidget {
  final AnyhooLatLong location;
  final double initialZoom;
  final List<AnyhooMarker> markers;

  const GoogleMapView({super.key, required this.location, this.initialZoom = 15, this.markers = const []});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(location.latitude, location.longitude), zoom: initialZoom),
      markers: markers
          .map(
            (marker) => Marker(
              markerId: MarkerId(marker.getId()),
              position: LatLng(marker.location.latitude, marker.location.longitude),
              infoWindow: InfoWindow(title: marker.title, snippet: marker.description),
            ),
          )
          .toSet(),

      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}
