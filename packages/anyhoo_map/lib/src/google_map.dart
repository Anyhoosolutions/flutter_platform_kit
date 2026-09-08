import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:anyhoo_map/src/anyhoo_map_settings.dart';
import 'package:anyhoo_map/src/anyhoo_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatelessWidget {
  final AnyhooLatLong location;
  final List<AnyhooMarker> markers;
  final AnyhooMapSettings settings;
  final String? selectedMarkerId;
  final ValueChanged<String>? onMarkerTapped;
  final ValueChanged<AnyhooLatLong>? onMapTapped;

  const GoogleMapView({
    super.key,
    required this.location,
    this.markers = const [],
    required this.settings,
    this.selectedMarkerId,
    this.onMarkerTapped,
    this.onMapTapped,
  });

  @override
  Widget build(BuildContext context) {
    final google = settings.googleOrDefault;
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: settings.initialZoom,
      ),
      markers: markers.map((marker) {
        final selected = marker.id == selectedMarkerId;
        return Marker(
          markerId: MarkerId(marker.id),
          position: LatLng(marker.location.latitude, marker.location.longitude),
          infoWindow: InfoWindow(
            title: marker.title,
            snippet: marker.description,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            selected ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueRed,
          ),
          zIndexInt: selected ? 1 : 0,
          consumeTapEvents: onMarkerTapped != null,
          onTap: onMarkerTapped == null
              ? null
              : () => onMarkerTapped!(marker.id),
        );
      }).toSet(),
      myLocationEnabled: google.showUserLocation,
      myLocationButtonEnabled: google.showMyLocationButton,
      zoomControlsEnabled: google.showZoomControls,
      mapToolbarEnabled: google.showMapToolbar,
      cloudMapId: google.mapId,
      onTap: onMapTapped == null
          ? null
          : (latLng) => onMapTapped!(
              AnyhooLatLong(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              ),
            ),
    );
  }
}
