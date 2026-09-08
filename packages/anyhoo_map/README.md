# AnyhooMap

A facade over Google Maps and flutter_map. Apps should keep calling `AnyhooMap` — engine views are not part of the public API.

`AnyhooLatLong` wraps [latlong2](https://pub.dev/packages/latlong2) so it does not clash with Google Maps' `LatLng`.

## Usage

```dart
AnyhooMap(
  mapType: AnyhooMapType.flutter,
  location: selectedItem?.location ?? userLocation,
  markers: items.map((item) => AnyhooMarker(
    id: item.id,
    location: item.location,
    title: item.title,
    description: item.subtitle,
  )).toList(),
  selectedMarkerId: selectedItem?.id,
  onMarkerTapped: (id) => selectItem(id),
  onMapTapped: (point) => pickLocation(point),
  markerBuilder: (context, marker, selected) => Pin(selected: selected),
  settings: AnyhooMapSettings(
    fitToMarkers: true,
    cameraPadding: EdgeInsets.only(bottom: peekSheetHeight, top: 48),
    flutter: AnyhooFlutterMapSettings(
      urlTemplate: 'https://your-tile-host/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.your_app',
      attribution: '© Your tile provider',
    ),
  ),
)
```

## Camera

`location` is a live target. After the first frame, changing it moves the camera. `initialZoom` is not a one-shot-only camera.

- `fitToMarkers: true` frames every pin (takes priority over `location`).
- `cameraPadding` keeps pins and flutter_map attribution clear of a peek sheet or list/map toggle.
- `AnyhooMapController.moveTo` / `fitMarkers` for add-item flows and sheet height changes.

Google applies `cameraPadding` as `GoogleMap.padding`. flutter_map applies it when moving and fitting.

## Markers

`AnyhooMarker.id` is required. Pass your item id; it is the source of truth for taps and selection.

- flutter_map: `markerBuilder`, or `AnyhooMarker.child`, otherwise a red/blue default pin.
- Google Maps: default markers only. The selected pin uses a different hue. Widget markers are not supported on Google.

## Tiles (flutter_map)

There is no public OSM default. `AnyhooMapType.flutter` requires `AnyhooFlutterMapSettings.urlTemplate` and `userAgentPackageName` (your app id, not `dev.fleaflet.flutter_map.example`).

Pass `attribution` so OSM-based hosts stay visible. It is padded with `cameraPadding` so a peek sheet does not cover it.

### Tests and goldens

Use `AnyhooNoNetworkTileProvider` so widget tests do not need `path_provider` or per-app plugin fakes:

```dart
AnyhooFlutterMapSettings(
  urlTemplate: 'https://example.invalid/{z}/{x}/{y}.png',
  userAgentPackageName: 'test',
  tileProvider: AnyhooNoNetworkTileProvider(),
)
```

## Settings

Shared: `initialZoom`, `fitToMarkers`, `cameraPadding`.

`google`: my-location, zoom controls, toolbar, optional `mapId`.

`flutter`: tile URL, user agent, attribution, optional `tileProvider`.

User location and Google toolbar flags are Google-only. They are not implemented on flutter_map.

### Google `mapId`

Off by default (`google.mapId == null`). Setting a Cloud map ID on mobile bills [Dynamic Maps](https://developers.google.com/maps/documentation/get-map-id). Leave it null unless you have a Map ID and accept that cost.

## Distance

`AnyhooLatLong.getDistance` is the single helper. Pass `AnyhooLatLongUnit.meter`, `.kilometer`, or `.mile`.
