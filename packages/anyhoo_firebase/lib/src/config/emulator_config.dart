import 'package:freezed_annotation/freezed_annotation.dart';

part 'emulator_config.freezed.dart';

/// Hosts, ports, and project id used when the app talks to local Firebase emulators.
@freezed
abstract class EmulatorConfig with _$EmulatorConfig {
  factory EmulatorConfig({
    @Default('localhost') String host,
    @Default(null) String? hostIp,
    @Default(true) bool useDeviceEmulator,
    @Default(null) bool? overrideUseFirebaseEmulator,
    @Default(true) bool useFirebaseAuth,
    @Default(true) bool useFirebaseFirestore,
    @Default(true) bool useFirebaseStorage,
    @Default(9099) int authPort,
    @Default(8080) int firestorePort,
    @Default(9199) int storagePort,

    /// Project id sent to the emulators.
    ///
    /// Applied only while the emulator is enabled (`Arguments.shouldUseFirebaseEmulator`
    /// or [overrideUseFirebaseEmulator]). `FirebaseInitializer` keeps the
    /// `FirebaseOptions` passed to `initialize` and replaces `projectId` with this
    /// value, so Auth, Firestore, and Storage stay on the default app.
    ///
    /// Match the project the emulator was started with (`.firebaserc`, or
    /// `firebase emulators:start --project …`). `firebase.json` does not hold this
    /// id. A `demo-` prefix marks a demo project that does not need a real Firebase
    /// project. When null or blank, the project id from `FirebaseOptions` is used
    /// unchanged.
    @Default(null) String? emulatorProjectId,
  }) = _EmulatorConfig;
}
