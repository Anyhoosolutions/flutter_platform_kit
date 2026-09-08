import 'package:latlong2/latlong.dart';

enum AnyhooLatLongUnit { meter, kilometer, mile }

class AnyhooLatLong {
  final double latitude;
  final double longitude;

  const AnyhooLatLong({required this.latitude, required this.longitude});

  /// Distance between [point1] and [point2] in [unit].
  static double getDistance(
    AnyhooLatLong point1,
    AnyhooLatLong point2,
    AnyhooLatLongUnit unit,
  ) {
    final Distance distance = Distance();
    final LengthUnit lengthUnit = switch (unit) {
      AnyhooLatLongUnit.meter => LengthUnit.Meter,
      AnyhooLatLongUnit.kilometer => LengthUnit.Kilometer,
      AnyhooLatLongUnit.mile => LengthUnit.Mile,
    };
    return distance.as(
      lengthUnit,
      LatLng(point1.latitude, point1.longitude),
      LatLng(point2.latitude, point2.longitude),
    );
  }

  @override
  String toString() =>
      'AnyhooLatLong(latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AnyhooLatLong &&
            latitude == other.latitude &&
            longitude == other.longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
