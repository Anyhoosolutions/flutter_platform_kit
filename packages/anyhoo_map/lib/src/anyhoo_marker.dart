import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:flutter/widgets.dart';

/// A map pin. [id] is the source of truth for selection and tap callbacks.
class AnyhooMarker {
  final String id;
  final AnyhooLatLong location;
  final String title;
  final String description;

  /// Optional flutter_map widget. Ignored by the Google engine.
  final Widget? child;

  const AnyhooMarker({
    required this.id,
    required this.location,
    required this.title,
    required this.description,
    this.child,
  });
}
