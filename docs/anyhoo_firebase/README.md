
# anyhoo_firebase

This package helps setting up Firebase, using an optional `Arguments` object to tell if it should use a Firebase emulator or not.
It will also initiate the `Firestore`, `Firebase auth`, and `Firebase storage` themselves.

## Usage

### Emulator project id

`EmulatorConfig.emulatorProjectId` is optional. When the emulator is enabled and this is set, `FirebaseInitializer.initialize` keeps the `FirebaseOptions` you passed in and replaces only `projectId`. Auth, Firestore, and Storage still use the default app. When it is null or blank, the project id from `FirebaseOptions` is unchanged.

Use the project id the emulator was started with (`.firebaserc`, or `firebase emulators:start --project …`). `firebase.json` does not contain it. A `demo-` prefix marks a demo project that does not need a real Firebase project.

```dart
final emulatorConfig = EmulatorConfig(
  hostIp: 'localhost',
  firestorePort: 8080,
  emulatorProjectId: 'demo-listwhatever',
);
```

### AnyhooStorageService

This is basically a wrapper for FirebaseStorage (for now), but also exposes a fake implementation that can be used for testing (`AnyhooFakeStorageService`).
It also provides the ability to later support other storage platforms as needed.


---

## Changelog

### 0.0.20

* Add optional `EmulatorConfig.emulatorProjectId` so emulator runs can use a different Firebase project id than production `FirebaseOptions`

### 0.0.19

* Add `FirestoreWhere` filters for `getCollection` / `watchCollection`
* Stop exposing `FirestoreService.firestore` so callers stay on the converted API

### 0.0.18

* Convert ISO-8601 strings to Firestore `Timestamp` on write and `Timestamp` to UTC ISO-8601 strings on read so Freezed models can keep `DateTime` without converters

### 0.0.17

* Convert Firestore `Timestamp` to UTC `DateTime` and back
* Wrap document conversions in `FirestoreConversionException` with document and field path

### 0.0.16

* Resolve Firebase emulator host for macOS, Windows, Linux, and Fuchsia (`localhost`)
* Log chosen emulator host with platform and `useDeviceEmulator`; warn when Auth/Firestore/Storage emulator is enabled but host is null

### 0.0.15

* Allow _shouldSetupErrorHandling

### 0.0.14

* Allow uploading to Storage with mime type

### 0.0.13

* Add Sentry logging

### 0.0.12

* Small fix for Google log in
* Logging

### 0.0.11
 
* Update UploadTask API

### 0.0.10
 
* Add isComplete method and change name getPath => getDownloadUrl

### 0.0.9
 
* AnyhooStorageService

### 0.0.8
 
* EmulatorConfig

### 0.0.7
 
* Expose methods for JSON for FirestoreService

### 0.0.6
 
* Export firestore_service.dart

### 0.0.5
 
* Change class names

### 0.0.4

* Revert to have references using path

### 0.0.3

* Reference anyhoo_core using Git

### 0.0.2 

* Analytics
* Crashlytics

### 0.0.1

* FirebaseInitializer
