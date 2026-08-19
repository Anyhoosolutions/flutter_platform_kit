# anyhoo_firebase

Sets up Firebase (Auth, Firestore, Storage, Analytics, Crashlytics) from an `Arguments` object and an optional emulator config. It also wraps Firestore and Storage so apps do not have to deal with Firestore-specific types.

## Setup

```dart
final arguments = await ArgumentsParser.getArguments();
final emulatorConfig = EmulatorConfig(
  hostIp: '192.168.1.10', // LAN IP when using a physical device
  authPort: 9099,
  firestorePort: 8080,
  storagePort: 9199,
);
final firebaseInitializer = FirebaseInitializer(
  arguments: arguments,
  emulatorConfig: emulatorConfig,
);
await firebaseInitializer.initialize(DefaultFirebaseOptions.currentPlatform);

final firestoreService = FirestoreService(firestore: firebaseInitializer.getFirestore());
final storageService = AnyhooFirebaseStorageService(storage: firebaseInitializer.getStorage());
```

`Arguments.shouldUseFirebaseEmulator()` decides whether emulators are used, unless `EmulatorConfig.overrideUseFirebaseEmulator` is set. `arguments.useFakeData` skips Firebase initialization entirely.

## FirestoreService

Pass collection paths (`users`) or document paths (`users/abc`). Collection reads always include an `id` field. Document reads do the same.

| Method | What it does |
| --- | --- |
| `watchCollection` | Live list of documents |
| `getCollection` | One-shot list |
| `watchDocument` | Live single document (`null` if missing) |
| `getDocument` | One-shot document (`null` if missing) |
| `addDocument` | Create; generates an id when `docId` is omitted |
| `updateDocument` | Patch fields |
| `deleteDocument` | Delete |

```dart
final places = await firestoreService.getCollection(
  'places',
  orderBy: 'name',
  descending: false,
  whereNullFields: ['deletedAt'],
  limit: 20,
);

await for (final docs in firestoreService.watchCollection('places')) {
  // ...
}

final place = await firestoreService.getDocument('places/abc');

final id = await firestoreService.addDocument(
  path: 'places',
  data: {'name': 'Cafe', 'updatedAt': DateTime.now().toUtc()},
);

await firestoreService.updateDocument('places', id, {'name': 'Cafe updated'});
await firestoreService.deleteDocument('places', id);
```

## Type conversions

Reads and writes convert Firestore types so the app can use Dart / JSON-shaped values. Nested maps and lists are converted recursively. Input maps are not mutated.

| Firestore | In the app (read) | Written back |
| --- | --- | --- |
| `Timestamp` | UTC ISO-8601 string (`2024-06-01T13:00:00.000Z`) | `DateTime` or that ISO string → `Timestamp` |
| `GeoPoint` | `{latitude, longitude}` | that map → `GeoPoint` |
| `FieldValue` (write only) | — | left unchanged (`serverTimestamp`, `increment`, `delete`, …) |

Timestamps are stored as instants (Unix epoch, UTC). The ISO string always includes `Z`. Show local time in the UI with `DateTime.parse(iso).toLocal()`.

Date-only strings such as `'2024-06-01'` are not treated as timestamps. A map is only turned into a `GeoPoint` when it has exactly `latitude` and `longitude` (ints or doubles). Extra keys keep it as a map.

This is meant to work with Freezed / `json_serializable` with no Timestamp converters:

```dart
@freezed
abstract class Place with _$Place {
  const factory Place({
    required String id,
    required String name,
    required DateTime updatedAt,
    required AnyhooLatLong location,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

final data = await firestoreService.getDocument('places/abc');
final place = Place.fromJson(data!);

await firestoreService.addDocument(path: 'places', data: place.toJson());
```

`DateTime` is parsed from the UTC ISO string. Give `AnyhooLatLong` (or any lat/lng POJO) `fromJson` / `toJson` using `latitude` and `longitude`; you do not need a Freezed `Location` type.

Use `FieldValue.serverTimestamp()` when the time must be the server clock at commit (ordering, billing). For a rough “when was this saved?” display, `DateTime.now()` is enough.

```dart
await firestoreService.addDocument(
  path: 'places',
  data: {
    ...place.toJson(),
    'createdAt': FieldValue.serverTimestamp(),
  },
);
```

Until the write is acknowledged, a local snapshot may have `null` for that field.

## AnyhooStorageService

Wrapper for Firebase Storage, with `AnyhooFakeStorageService` for tests. `AnyhooFirebaseStorageService` is the real implementation.
