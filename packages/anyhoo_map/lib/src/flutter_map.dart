import 'package:anyhoo_map/anyhoo_map.dart';
import 'package:anyhoo_map/src/open_street_map_tile_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FlutterMapView extends StatelessWidget {
  final AnyhooLatLong location;
  final double initialZoom;
  final List<AnyhooMarker> markers;

  const FlutterMapView({super.key, required this.location, this.initialZoom = 15, this.markers = const []});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If constraints are unbounded (e.g., in SingleChildScrollView), use a reasonable default height
        final height = constraints.maxHeight.isInfinite
            ? MediaQuery.of(context).size.height * 0.7
            : constraints.maxHeight;

        return SizedBox(
          height: height,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(location.latitude, location.longitude),
              initialZoom: initialZoom,
              // onTap: (_, p) => setState(() => customMarkers.add(buildPin(p))),
              interactionOptions: const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
            ),
            children: [
              openStreetMapTileLayer,
              MarkerLayer(
                markers: markers
                    .map(
                      (marker) => Marker(
                        point: LatLng(marker.location.latitude, marker.location.longitude),
                        width: 80,
                        height: 80,
                        child: Tooltip(
                          message: '${marker.title}\n${marker.description}',
                          child: Icon(Icons.location_on, color: Colors.red, size: 40),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
