import 'package:anyhoo_map/src/anyhoo_circle.dart';
import 'package:anyhoo_map/src/anyhoo_latlong.dart';
import 'package:anyhoo_map/src/anyhoo_map_controller.dart';
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
  final List<AnyhooCircle> circles;
  final AnyhooMapSettings settings;
  final AnyhooMapController mapController;
  final String? selectedMarkerId;
  final ValueChanged<String>? onMarkerTapped;
  final ValueChanged<AnyhooLatLong>? onMapTapped;
  final AnyhooMarkerWidgetBuilder? markerBuilder;

  const FlutterMapView({
    super.key,
    required this.location,
    this.markers = const [],
    this.circles = const [],
    required this.settings,
    required this.mapController,
    this.selectedMarkerId,
    this.onMarkerTapped,
    this.onMapTapped,
    this.markerBuilder,
  });

  @override
  State<FlutterMapView> createState() => _FlutterMapViewState();
}

class _FlutterMapViewState extends State<FlutterMapView> {
  late final MapController _flutterController;
  late TileLayer _tileLayer;
  RetryClient? _httpClient;
  var _ready = false;

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
    _flutterController = MapController();
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

    if (!_ready) {
      return;
    }
    if (!identical(oldWidget.mapController, widget.mapController)) {
      widget.mapController.attachFlutter(_flutterController, widget.settings);
    } else {
      widget.mapController.updateSettings(widget.settings);
    }
    _syncCamera(oldWidget);
  }

  @override
  void dispose() {
    widget.mapController.detach();
    _flutterController.dispose();
    _httpClient?.close();
    super.dispose();
  }

  void _onMapReady() {
    _ready = true;
    widget.mapController.attachFlutter(_flutterController, widget.settings);
    widget.mapController.applyInitialCamera(
      widget.location,
      widget.markers,
      circles: widget.circles,
    );
  }

  void _syncCamera(FlutterMapView oldWidget) {
    final paddingChanged =
        oldWidget.settings.cameraPadding != widget.settings.cameraPadding;
    if (widget.settings.fitToMarkers) {
      if (AnyhooMapController.markersDiffer(
            oldWidget.markers,
            widget.markers,
          ) ||
          AnyhooMapController.circlesDiffer(
            oldWidget.circles,
            widget.circles,
          ) ||
          paddingChanged ||
          !oldWidget.settings.fitToMarkers) {
        widget.mapController.fitMarkers(
          widget.markers,
          circles: widget.circles,
        );
      }
      return;
    }
    if (oldWidget.location != widget.location || paddingChanged) {
      widget.mapController.moveTo(widget.location);
    }
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

  Widget _markerChild(BuildContext context, AnyhooMarker marker) {
    final selected = marker.id == widget.selectedMarkerId;
    final Widget pin;
    if (marker.child != null) {
      pin = marker.child!;
    } else if (widget.markerBuilder != null) {
      pin = widget.markerBuilder!(context, marker, selected);
    } else {
      pin = Tooltip(
        message: '${marker.title}\n${marker.description}',
        child: Icon(
          Icons.location_on,
          color: selected ? Colors.blue : Colors.red,
          size: selected ? 48 : 40,
        ),
      );
    }

    return GestureDetector(
      key: ValueKey(marker.id),
      onTap: widget.onMarkerTapped == null
          ? null
          : () => widget.onMarkerTapped!(marker.id),
      child: pin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final flutter = _flutterSettings;
    final coordinates = AnyhooMapController.fitCoordinates(
      markers: widget.markers,
      circles: widget.circles,
    );
    return FlutterMap(
      mapController: _flutterController,
      options: MapOptions(
        initialCenter: LatLng(
          widget.location.latitude,
          widget.location.longitude,
        ),
        initialZoom: widget.settings.initialZoom,
        initialCameraFit: widget.settings.fitToMarkers && coordinates.isNotEmpty
            ? CameraFit.coordinates(
                coordinates: coordinates,
                padding: widget.settings.cameraPadding,
              )
            : null,
        onMapReady: _onMapReady,
        onTap: widget.onMapTapped == null
            ? null
            : (tapPosition, point) => widget.onMapTapped!(
                AnyhooLatLong(
                  latitude: point.latitude,
                  longitude: point.longitude,
                ),
              ),
      ),
      children: [
        _tileLayer,
        if (widget.circles.isNotEmpty)
          CircleLayer(
            circles: [
              for (final circle in widget.circles)
                CircleMarker(
                  point: LatLng(
                    circle.center.latitude,
                    circle.center.longitude,
                  ),
                  radius: circle.radiusMeters,
                  useRadiusInMeter: true,
                  color: circle.fillColor,
                  borderColor: circle.strokeColor,
                  borderStrokeWidth: circle.strokeWidth,
                ),
            ],
          ),
        MarkerLayer(
          markers: widget.markers
              .map(
                (marker) => Marker(
                  point: LatLng(
                    marker.location.latitude,
                    marker.location.longitude,
                  ),
                  width: 48,
                  height: 48,
                  alignment: Alignment.bottomCenter,
                  child: _markerChild(context, marker),
                ),
              )
              .toList(),
        ),
        if (flutter.attribution != null)
          Padding(
            padding: widget.settings.cameraPadding,
            child: SimpleAttributionWidget(
              source: Text(flutter.attribution!),
              alignment: Alignment.bottomLeft,
            ),
          ),
      ],
    );
  }
}
