import 'dart:math' as math;

import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:anyhoo_map/src/anyhoo_map_settings.dart';
import 'package:anyhoo_map/src/anyhoo_marker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';

/// Moves and fits the camera after the first frame.
///
/// [AnyhooMap.location] also updates the camera when [AnyhooMapSettings.fitToMarkers]
/// is false. Use this controller for peek-sheet padding changes and add-item flows.
class AnyhooMapController {
  gmaps.GoogleMapController? _google;
  MapController? _flutter;
  AnyhooMapSettings _settings = const AnyhooMapSettings();

  void attachGoogle(
    gmaps.GoogleMapController controller,
    AnyhooMapSettings settings,
  ) {
    _google = controller;
    _flutter = null;
    _settings = settings;
  }

  void attachFlutter(MapController controller, AnyhooMapSettings settings) {
    _flutter = controller;
    _google = null;
    _settings = settings;
  }

  void updateSettings(AnyhooMapSettings settings) {
    _settings = settings;
  }

  void detach() {
    _google = null;
    _flutter = null;
  }

  Future<void> applyInitialCamera(
    AnyhooLatLong location,
    List<AnyhooMarker> markers,
  ) {
    if (_settings.fitToMarkers) {
      return fitMarkers(markers);
    }
    return moveTo(location, zoom: _settings.initialZoom);
  }

  Future<void> moveTo(AnyhooLatLong target, {double? zoom}) async {
    final padding = _settings.cameraPadding;
    if (_google != null) {
      await _google!.animateCamera(
        gmaps.CameraUpdate.newLatLngZoom(
          gmaps.LatLng(target.latitude, target.longitude),
          zoom ?? _settings.initialZoom,
        ),
      );
      return;
    }

    final flutter = _flutter;
    if (flutter == null) {
      return;
    }
    flutter.fitCamera(
      CameraFit.coordinates(
        coordinates: [LatLng(target.latitude, target.longitude)],
        padding: padding,
        maxZoom: zoom ?? _settings.initialZoom,
      ),
    );
  }

  Future<void> fitMarkers(
    List<AnyhooMarker> markers, {
    EdgeInsets? padding,
  }) async {
    if (markers.isEmpty) {
      return;
    }
    final pad = padding ?? _settings.cameraPadding;

    if (_google != null) {
      final bounds = _googleBounds(markers);
      if (bounds == null) {
        await moveTo(markers.first.location);
        return;
      }
      await _google!.animateCamera(
        gmaps.CameraUpdate.newLatLngBounds(bounds, 0),
      );
      return;
    }

    final flutter = _flutter;
    if (flutter == null) {
      return;
    }
    flutter.fitCamera(
      CameraFit.coordinates(
        coordinates: [
          for (final marker in markers)
            LatLng(marker.location.latitude, marker.location.longitude),
        ],
        padding: pad,
      ),
    );
  }

  static bool markersDiffer(List<AnyhooMarker> a, List<AnyhooMarker> b) {
    if (a.length != b.length) {
      return true;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].location != b[i].location) {
        return true;
      }
    }
    return false;
  }

  static gmaps.LatLngBounds? _googleBounds(List<AnyhooMarker> markers) {
    var minLat = markers.first.location.latitude;
    var maxLat = minLat;
    var minLng = markers.first.location.longitude;
    var maxLng = minLng;
    for (final marker in markers.skip(1)) {
      minLat = math.min(minLat, marker.location.latitude);
      maxLat = math.max(maxLat, marker.location.latitude);
      minLng = math.min(minLng, marker.location.longitude);
      maxLng = math.max(maxLng, marker.location.longitude);
    }
    if (minLat == maxLat && minLng == maxLng) {
      return null;
    }
    if (minLat == maxLat) {
      minLat -= 0.0001;
      maxLat += 0.0001;
    }
    if (minLng == maxLng) {
      minLng -= 0.0001;
      maxLng += 0.0001;
    }
    return gmaps.LatLngBounds(
      southwest: gmaps.LatLng(minLat, minLng),
      northeast: gmaps.LatLng(maxLat, maxLng),
    );
  }
}
