import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'anyhoo_map_settings.freezed.dart';

@freezed
abstract class AnyhooMapSettings with _$AnyhooMapSettings {
  const AnyhooMapSettings._();

  const factory AnyhooMapSettings({
    @Default(15) double initialZoom,

    /// Frames markers and circles after the first frame.
    @Default(false) bool fitToMarkers,
    @Default(EdgeInsets.zero) EdgeInsets cameraPadding,
    AnyhooGoogleMapSettings? google,
    AnyhooFlutterMapSettings? flutter,
  }) = _AnyhooMapSettings;

  AnyhooGoogleMapSettings get googleOrDefault =>
      google ?? const AnyhooGoogleMapSettings();
}

@freezed
abstract class AnyhooGoogleMapSettings with _$AnyhooGoogleMapSettings {
  const factory AnyhooGoogleMapSettings({
    @Default(true) bool showUserLocation,
    @Default(true) bool showMyLocationButton,
    @Default(true) bool showZoomControls,
    @Default(true) bool showMapToolbar,

    /// Cloud-based map style id. Off by default.
    ///
    /// Setting this on mobile bills Google Dynamic Maps. Leave null unless you
    /// have a Map ID and accept that cost.
    String? mapId,
  }) = _AnyhooGoogleMapSettings;
}

@freezed
abstract class AnyhooFlutterMapSettings with _$AnyhooFlutterMapSettings {
  const factory AnyhooFlutterMapSettings({
    required String urlTemplate,
    required String userAgentPackageName,
    String? attribution,
    TileProvider? tileProvider,
  }) = _AnyhooFlutterMapSettings;
}
