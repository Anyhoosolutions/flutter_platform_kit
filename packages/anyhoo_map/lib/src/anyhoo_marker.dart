import 'package:anyhoo_core/utils/string_utils.dart';
import 'package:anyhoo_map/anyhoo_map.dart';

import 'package:latlong2/latlong.dart';

class AnyhooMarker {
  final String _id;
  final AnyhooLatLong location;
  final String title;
  final String description;
  // final AnyhooMapSettings settings;

  AnyhooMarker({
    String? id,
    required this.location,
    required this.title,
    required this.description,
    // required this.settings,
  }) : _id = id ?? _generateId();

  static String _generateId() {
    return AnyhooStringUtils.generateRandomString(10);
  }

  String getId() {
    return _id;
  }

  // @override
  // String toString() {
  //   return 'AnyhooMarker(latitude: $latitude, longitude: $longitude)';
  // }

  static double getDistance(AnyhooLatLong point1, AnyhooLatLong point2, AnyhooLatLongUnit unit) {
    final Distance distance = Distance();
    final LengthUnit lengthUnit = switch (unit) {
      AnyhooLatLongUnit.meter => LengthUnit.Meter,
      AnyhooLatLongUnit.kilometer => LengthUnit.Kilometer,
      AnyhooLatLongUnit.mile => LengthUnit.Mile,
    };
    final double d = distance.as(
      lengthUnit,
      LatLng(point1.latitude, point1.longitude),
      LatLng(point2.latitude, point2.longitude),
    );
    return d;
  }
}
