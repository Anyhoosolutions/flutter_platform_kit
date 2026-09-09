import 'dart:math' as math;

import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:flutter/widgets.dart';

/// Mean meters per degree of latitude. Longitude is scaled by cos(latitude).
const metersPerDegreeLatitude = 111320.0;

/// A filled circle overlay. [id] is the source of truth for Google [CircleId].
class AnyhooCircle {
  final String id;
  final AnyhooLatLong center;

  /// Geographic radius, in meters.
  final double radiusMeters;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  const AnyhooCircle({
    required this.id,
    required this.center,
    required this.radiusMeters,
    this.fillColor = const Color(0x332196F3),
    this.strokeColor = const Color(0xFF2196F3),
    this.strokeWidth = 2,
  });

  /// Southwest and northeast corners of an axis-aligned box around this circle.
  List<AnyhooLatLong> get boundingCoordinates {
    if (radiusMeters <= 0) {
      return [center];
    }
    final dLat = radiusMeters / metersPerDegreeLatitude;
    final cosLat = math
        .cos(center.latitude * math.pi / 180)
        .abs()
        .clamp(0.01, 1.0);
    final dLng = radiusMeters / (metersPerDegreeLatitude * cosLat);
    return [
      AnyhooLatLong(
        latitude: center.latitude - dLat,
        longitude: center.longitude - dLng,
      ),
      AnyhooLatLong(
        latitude: center.latitude + dLat,
        longitude: center.longitude + dLng,
      ),
    ];
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AnyhooCircle &&
            id == other.id &&
            center == other.center &&
            radiusMeters == other.radiusMeters &&
            fillColor == other.fillColor &&
            strokeColor == other.strokeColor &&
            strokeWidth == other.strokeWidth;
  }

  @override
  int get hashCode => Object.hash(
    id,
    center,
    radiusMeters,
    fillColor,
    strokeColor,
    strokeWidth,
  );
}
