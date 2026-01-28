import 'package:freezed_annotation/freezed_annotation.dart';

part 'anyhoo_map_settings.freezed.dart';

@freezed
abstract class AnyhooMapSettings with _$AnyhooMapSettings {
  const factory AnyhooMapSettings({
    @Default(15) double initialZoom,
    @Default(true) bool showUserLocation,
    @Default(true) bool showUserLocationButton,
    @Default(true) bool showZoomControls,
    @Default(true) bool showMapToolbar,
    @Default(true) bool showMyLocationButton,
  }) = _AnyhooMapSettings;
}
