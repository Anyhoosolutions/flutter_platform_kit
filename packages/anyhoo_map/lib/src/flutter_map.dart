import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:anyhoo_map/src/anyhoo_map_settings.dart';
import 'package:anyhoo_map/src/anyhoo_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:latlong2/latlong.dart';

class FlutterMapView extends StatefulWidget {
  final AnyhooLatLong location;
  final List<AnyhooMarker> markers;
  final AnyhooMapSettings settings;

  const FlutterMapView({
    super.key,
    required this.location,
    this.markers = const [],
    required this.settings,
  });

  @override
  State<FlutterMapView> createState() => _FlutterMapViewState();
}

class _FlutterMapViewState extends State<FlutterMapView> {
  late TileLayer _tileLayer;
  RetryClient? _httpClient;

  AnyhooFlutterMapSettings get _flutterSettings {
    final flutter = widget.settings.flutter;
    if (flutter == null) {
      throw FlutterError.fromParts([
        ErrorSummary(
          'AnyhooMapType.flutter requires AnyhooMapSettings.flutter.',
        ),
        ErrorDescription(
          'Pass urlTemplate and userAgentPackageName. Do not use public OSM tiles as a default; '
          'configure a tile host for your app.',
        ),
      ]);
    }
    return flutter;
  }

  @override
  void initState() {
    super.initState();
    _tileLayer = _buildTileLayer(_flutterSettings);
  }

  @override
  void didUpdateWidget(covariant FlutterMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _flutterSettings;
    final previous = oldWidget.settings.flutter;
    if (previous == null ||
        previous.urlTemplate != next.urlTemplate ||
        previous.userAgentPackageName != next.userAgentPackageName ||
        !identical(previous.tileProvider, next.tileProvider)) {
      _tileLayer = _buildTileLayer(next);
    }
  }

  @override
  void dispose() {
    _httpClient?.close();
    super.dispose();
  }

  TileLayer _buildTileLayer(AnyhooFlutterMapSettings flutter) {
    return TileLayer(
      urlTemplate: flutter.urlTemplate,
      userAgentPackageName: flutter.userAgentPackageName,
      tileProvider:
          flutter.tileProvider ??
          NetworkTileProvider(
            httpClient: _httpClient ??= RetryClient(Client()),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flutter = _flutterSettings;
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
          widget.location.latitude,
          widget.location.longitude,
        ),
        initialZoom: widget.settings.initialZoom,
      ),
      children: [
        _tileLayer,
        MarkerLayer(
          markers: widget.markers
              .map(
                (marker) => Marker(
                  point: LatLng(
                    marker.location.latitude,
                    marker.location.longitude,
                  ),
                  width: 80,
                  height: 80,
                  alignment: Alignment.bottomCenter,
                  child: Tooltip(
                    message: '${marker.title}\n${marker.description}',
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if (flutter.attribution != null)
          SimpleAttributionWidget(
            source: Text(flutter.attribution!),
            alignment: Alignment.bottomLeft,
          ),
      ],
    );
  }
}
