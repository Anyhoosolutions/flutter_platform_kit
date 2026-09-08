import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:anyhoo_map/src/anyhoo_map_controller.dart';
import 'package:anyhoo_map/src/anyhoo_map_settings.dart';
import 'package:anyhoo_map/src/anyhoo_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  final AnyhooLatLong location;
  final List<AnyhooMarker> markers;
  final AnyhooMapSettings settings;
  final AnyhooMapController mapController;
  final String? selectedMarkerId;
  final ValueChanged<String>? onMarkerTapped;
  final ValueChanged<AnyhooLatLong>? onMapTapped;

  const GoogleMapView({
    super.key,
    required this.location,
    this.markers = const [],
    required this.settings,
    required this.mapController,
    this.selectedMarkerId,
    this.onMarkerTapped,
    this.onMapTapped,
  });

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  var _ready = false;
  GoogleMapController? _google;

  @override
  void didUpdateWidget(covariant GoogleMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_ready || _google == null) {
      return;
    }
    if (!identical(oldWidget.mapController, widget.mapController)) {
      widget.mapController.attachGoogle(_google!, widget.settings);
    } else {
      widget.mapController.updateSettings(widget.settings);
    }
    _syncCamera(oldWidget);
  }

  @override
  void dispose() {
    widget.mapController.detach();
    super.dispose();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _google = controller;
    _ready = true;
    widget.mapController.attachGoogle(controller, widget.settings);
    await widget.mapController.applyInitialCamera(
      widget.location,
      widget.markers,
    );
  }

  void _syncCamera(GoogleMapView oldWidget) {
    final paddingChanged =
        oldWidget.settings.cameraPadding != widget.settings.cameraPadding;
    if (widget.settings.fitToMarkers) {
      if (AnyhooMapController.markersDiffer(
            oldWidget.markers,
            widget.markers,
          ) ||
          paddingChanged ||
          !oldWidget.settings.fitToMarkers) {
        widget.mapController.fitMarkers(widget.markers);
      }
      return;
    }
    if (oldWidget.location != widget.location) {
      widget.mapController.moveTo(widget.location);
    }
  }

  @override
  Widget build(BuildContext context) {
    final google = widget.settings.googleOrDefault;
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.location.latitude, widget.location.longitude),
        zoom: widget.settings.initialZoom,
      ),
      padding: widget.settings.cameraPadding,
      markers: widget.markers.map((marker) {
        final selected = marker.id == widget.selectedMarkerId;
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
          consumeTapEvents: widget.onMarkerTapped != null,
          onTap: widget.onMarkerTapped == null
              ? null
              : () => widget.onMarkerTapped!(marker.id),
        );
      }).toSet(),
      myLocationEnabled: google.showUserLocation,
      myLocationButtonEnabled: google.showMyLocationButton,
      zoomControlsEnabled: google.showZoomControls,
      mapToolbarEnabled: google.showMapToolbar,
      cloudMapId: google.mapId,
      onMapCreated: _onMapCreated,
      onTap: widget.onMapTapped == null
          ? null
          : (latLng) => widget.onMapTapped!(
              AnyhooLatLong(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              ),
            ),
    );
  }
}
