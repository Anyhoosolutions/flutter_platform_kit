
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

