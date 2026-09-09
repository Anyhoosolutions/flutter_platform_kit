## 0.2.0

* Add `AnyhooCircle` overlays (`AnyhooMap.circles`) on flutter_map and Google Maps.
* `fitToMarkers` also frames circles so a radius preview can show the whole area.

## 0.1.0

* Require `AnyhooMarker.id` (no random ids).
* Keep a single `getDistance` on `AnyhooLatLong`.
* Stop exporting engine views; `AnyhooMap` is the public facade.
* Split settings into shared / Google / flutter_map.
* Require an explicit flutter_map tile host (no public OSM default).
* Add marker taps, map taps, selected marker styling, and a flutter_map marker builder.
* Move the camera after the first frame (`location`, `fitToMarkers`, `cameraPadding`, `AnyhooMapController`).
* Add visible flutter_map attribution and `AnyhooNoNetworkTileProvider` for tests.
* Optional Google `mapId` (off by default; Dynamic Maps billing on mobile).

## 0.0.2

* Change Dart SDK version

## 0.0.1

* Create AnyhooMap
