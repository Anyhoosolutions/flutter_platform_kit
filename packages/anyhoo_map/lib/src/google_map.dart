import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:anyhoo_map/src/anyhoo_map_settings.dart';
import 'package:anyhoo_map/src/anyhoo_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatelessWidget {
  final AnyhooLatLong location;
  final List<AnyhooMarker> markers;
  final AnyhooMapSettings settings;

  const GoogleMapView({
    super.key,
    required this.location,
    this.markers = const [],
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final google = settings.googleOrDefault;
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: settings.initialZoom,
      ),
      markers: markers
          .map(
            (marker) => Marker(
              markerId: MarkerId(marker.id),
              position: LatLng(
                marker.location.latitude,
                marker.location.longitude,
              ),
              infoWindow: InfoWindow(
                title: marker.title,
                snippet: marker.description,
              ),
            ),
          )
          .toSet(),
      myLocationEnabled: google.showUserLocation,
      myLocationButtonEnabled: google.showMyLocationButton,
      zoomControlsEnabled: google.showZoomControls,
      mapToolbarEnabled: google.showMapToolbar,
      cloudMapId: google.mapId,
    );
  }
}
