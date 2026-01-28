import 'package:latlong2/latlong.dart';

enum AnyhooLatLongUnit { meter, kilometer, mile }

class AnyhooLatLong {
  final double latitude;
  final double longitude;

  AnyhooLatLong({required this.latitude, required this.longitude});

  @override
  String toString() {
    return 'AnyhooLatLong(latitude: $latitude, longitude: $longitude)';
  }

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
