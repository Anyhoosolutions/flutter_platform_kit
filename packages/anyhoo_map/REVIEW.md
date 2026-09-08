# AnyhooMap 0.1.0 — review notes

Not a full diff. What each file gained or lost, grouped by commit on `anyhoo-map-list-support`.

Listwhatever should keep calling `AnyhooMap`. Engine views are internal.

---

## 1. Stable marker ids and one `getDistance`

### `lib/src/anyhoo_marker.dart`
- **Removed:** optional `id` with random fallback (`AnyhooStringUtils.generateRandomString`), `getId()`, duplicate `getDistance`, `anyhoo_core` import, commented leftovers.
- **Added:** required `id`, optional `child` (flutter_map widget pin), `const` constructor.

### `lib/src/anyhoo_latlong.dart`
- **Added:** `const` constructor, `==` / `hashCode`, doc on `getDistance`.
- **Unchanged:** this is now the only distance helper.

### `lib/anyhoo_map.dart`
- **Removed exports:** `GoogleMapView`, `FlutterMapView`.
- Src files import engines directly instead of the barrel.

### `lib/src/google_map.dart`
- `MarkerId(marker.getId())` → `MarkerId(marker.id)`.

### `pubspec.yaml`
- **Removed:** `anyhoo_core` (only used for random ids).

### `example_app/.../map_page.dart`
- Markers now pass `id: 'london-1'` / `'london-2'`.

### Tests
- **New** `test/anyhoo_latlong_test.dart` — distance and equality.
- **New** `test/anyhoo_marker_test.dart` — caller id is kept.

---

## 2. Split settings and explicit tiles

### `lib/src/anyhoo_map_settings.dart` (+ generated `.freezed.dart`)
- **Removed (flat):** `showUserLocation`, `showUserLocationButton`, `showZoomControls`, `showMapToolbar`, `showMyLocationButton`.
- **Added shared:** still `initialZoom`; later commit adds `fitToMarkers` / `cameraPadding`.
- **Added `AnyhooGoogleMapSettings`:** my-location, my-location button, zoom controls, toolbar, optional `mapId` (null = off; Dynamic Maps billing note in comment).
- **Added `AnyhooFlutterMapSettings`:** required `urlTemplate` + `userAgentPackageName`, optional `attribution` and `tileProvider`.
- **Added:** `googleOrDefault` so Google flags stay enabled when `google:` is omitted.
- **No OSM default.** `flutter:` is null until the app sets it.

### `lib/src/anyhoo_tile_provider.dart` (new)
- `AnyhooNoNetworkTileProvider` — 1×1 transparent PNG, no HTTP, no `path_provider`.

### `lib/src/open_street_map_tile_layer.dart`
- **Deleted.** That getter rebuilt a `TileLayer` every frame and used public OSM + the leaflet example user-agent.

### `lib/src/flutter_map.dart`
- Became a `StatefulWidget`.
- Builds `TileLayer` once; rebuilds only if URL / user-agent / `tileProvider` change.
- Throws a `FlutterError` if `settings.flutter` is missing.
- **Removed:** `LayoutBuilder` unbounded-height fallback, `~InteractiveFlag.doubleTapZoom`.
- **Added:** `SimpleAttributionWidget` when `attribution` is set.
- Default interactions restored (including double-tap zoom).

### `lib/src/google_map.dart`
- Reads `settings.googleOrDefault` instead of the old flat flags.
- Passes `cloudMapId: google.mapId`.

### `lib/anyhoo_map.dart`
- **Export added:** `anyhoo_tile_provider.dart`.

### Example
- Explicit OSM tiles for the demo only, with `userAgentPackageName: 'example_app'` and attribution.

### Tests
- **New** `test/anyhoo_map_settings_test.dart` — Google defaults; flutter tiles are not prefilled.

---

## 3. Taps, selection, custom flutter_map markers

### `lib/src/anyhoo_marker.dart`
- **Added:** `AnyhooMarkerWidgetBuilder` typedef.

### `lib/src/anyhoo_map.dart`
- **Added fields (passed through):** `selectedMarkerId`, `onMarkerTapped`, `onMapTapped`, `markerBuilder`.

### `lib/src/flutter_map.dart`
- Marker child resolution: `marker.child` → `markerBuilder` → default pin (red / blue when selected).
- `GestureDetector` with `ValueKey(id)` for taps.
- `MapOptions.onTap` → `onMapTapped(AnyhooLatLong)`.
- Default pin size 48×48, alignment `bottomCenter`.

### `lib/src/google_map.dart`
- Marker `onTap` / `consumeTapEvents`.
- Selected pin: azure hue + higher `zIndexInt`. Widget pins ignored.
- Map `onTap` → `onMapTapped`.

### Tests
- **New** `test/anyhoo_map_test.dart` — marker tap by id; selected vs unselected default colors; later also `fitToMarkers` smoke test.

---

## 4. Camera after first frame

### `lib/src/anyhoo_map_controller.dart` (new)
- Attaches Google or flutter_map engine controller.
- `moveTo`, `fitMarkers`, `applyInitialCamera`.
- `fitToMarkers` wins over `location`.
- Empty marker list is a no-op; a single Google point uses `moveTo` (bounds need two corners).
- `markersDiffer` compares id + location so rebuilds with a new list but same pins do not re-fit.

### `lib/src/anyhoo_map_settings.dart`
- **Added:** `fitToMarkers` (default false), `cameraPadding` (default `EdgeInsets.zero`).

### `lib/src/anyhoo_map.dart`
- Became a `StatefulWidget`.
- Optional `controller`; owns one if omitted.
- Still only constructs `GoogleMapView` / `FlutterMapView` internally.

### `lib/src/flutter_map.dart`
- Owns `MapController`; `onMapReady` applies initial camera.
- `didUpdateWidget` moves or fits when `location` / markers / padding / `fitToMarkers` change.
- `initialCameraFit` when `fitToMarkers` is true.
- Attribution wrapped in `Padding(padding: cameraPadding)`.

### `lib/src/google_map.dart`
- Became a `StatefulWidget`.
- `onMapCreated` applies initial camera.
- `GoogleMap.padding = cameraPadding`.
- Same move/fit sync as flutter_map.

### `lib/anyhoo_map.dart`
- **Export added:** `anyhoo_map_controller.dart`.

### Tests
- **New** `test/anyhoo_map_controller_test.dart` — no-op before attach; `markersDiffer`; defaults.
- Widget smoke: `fitToMarkers` + padding + no-network tiles.

---

## 5. Docs and example

### `README.md` / `docs/anyhoo_map/README.md`
- Usage for list maps, camera, tiles, tests, `mapId` billing, distance.

### `CHANGELOG.md` / `pubspec.yaml`
- Version **0.1.0**, breaking-change summary.

### `example_app/.../map_page.dart`
- Stateful demo: engine switch, marker selection, `fitToMarkers`, padding.
- OSM tiles still explicit (demo only), not a package default.

---

## Listwhatever call site (expected)

```dart
AnyhooMap(
  mapType: AnyhooMapType.flutter,
  location: selected?.location ?? fallback,
  markers: items.map((item) => AnyhooMarker(
    id: item.id,
    location: item.location,
    title: item.title,
    description: item.subtitle,
  )).toList(),
  selectedMarkerId: selected?.id,
  onMarkerTapped: onItemSelected, // or wrap to look up the item
  settings: AnyhooMapSettings(
    fitToMarkers: true,
    cameraPadding: EdgeInsets.only(bottom: peekHeight, top: toggleHeight),
    flutter: AnyhooFlutterMapSettings(
      urlTemplate: yourTiles,
      userAgentPackageName: 'your.app.id',
      attribution: '© …',
    ),
  ),
)
```

When the selected list item changes, either update `location` to that item (camera follows) or keep `fitToMarkers: true` (all pins stay in view) and only change `selectedMarkerId` (appearance).

---

## Intentionally not done

- User location / my-location button on flutter_map (needs extra plugins).
- Widget-to-bitmap custom markers on Google.
- Listwhatever app code (this package only).
