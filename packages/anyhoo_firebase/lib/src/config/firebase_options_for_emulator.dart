import 'package:firebase_core/firebase_core.dart';

/// Returns [options] with [FirebaseOptions.projectId] replaced when the
/// emulator is on and [emulatorProjectId] is a non-empty project id.
///
/// Other option fields are left as passed in. This keeps the default
/// [FirebaseApp] (the one Auth, Firestore, and Storage `.instance` use).
FirebaseOptions firebaseOptionsForEmulator({
  required FirebaseOptions options,
  required bool emulatorEnabled,
  required String? emulatorProjectId,
}) {
  if (!emulatorEnabled) {
    return options;
  }
  final projectId = emulatorProjectId?.trim();
  if (projectId == null || projectId.isEmpty) {
    return options;
  }
  return options.copyWith(projectId: projectId);
}
