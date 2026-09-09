import 'dart:math' as math;

import 'package:anyhoo_map/src/anyhoo_circle.dart';
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
/// When [AnyhooMapSettings.fitToMarkers] is true, circles are included in the fit.
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
    List<AnyhooMarker> markers, {
    List<AnyhooCircle> circles = const [],
  }) {
    if (_settings.fitToMarkers) {
      return fitMarkers(markers, circles: circles);
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
    List<AnyhooCircle> circles = const [],
    EdgeInsets? padding,
  }) async {
    final coordinates = fitCoordinates(markers: markers, circles: circles);
    if (coordinates.isEmpty) {
      return;
    }
    final pad = padding ?? _settings.cameraPadding;

    if (_google != null) {
      final bounds = _googleBoundsFrom(coordinates);
      if (bounds == null) {
        await moveTo(
          AnyhooLatLong(
            latitude: coordinates.first.latitude,
            longitude: coordinates.first.longitude,
          ),
        );
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
      CameraFit.coordinates(coordinates: coordinates, padding: pad),
    );
  }

  static List<LatLng> fitCoordinates({
    required List<AnyhooMarker> markers,
    List<AnyhooCircle> circles = const [],
  }) {
    return [
      for (final marker in markers)
        LatLng(marker.location.latitude, marker.location.longitude),
      for (final circle in circles)
        for (final point in circle.boundingCoordinates)
          LatLng(point.latitude, point.longitude),
    ];
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

  static bool circlesDiffer(List<AnyhooCircle> a, List<AnyhooCircle> b) {
    if (a.length != b.length) {
      return true;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id ||
          a[i].center != b[i].center ||
          a[i].radiusMeters != b[i].radiusMeters) {
        return true;
      }
    }
    return false;
  }

  static gmaps.LatLngBounds? _googleBoundsFrom(List<LatLng> coordinates) {
    if (coordinates.isEmpty) {
      return null;
    }
    var minLat = coordinates.first.latitude;
    var maxLat = minLat;
    var minLng = coordinates.first.longitude;
    var maxLng = minLng;
    for (final point in coordinates.skip(1)) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
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
