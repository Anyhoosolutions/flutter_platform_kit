import 'package:anyhoo_firebase/src/config/firebase_options_for_emulator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const options = FirebaseOptions(
    apiKey: 'key',
    appId: 'app',
    messagingSenderId: 'sender',
    projectId: 'listwhatever-ad43ed',
    storageBucket: 'listwhatever-ad43ed.appspot.com',
  );

  test('replaces only projectId when the emulator is on', () {
    final resolved = firebaseOptionsForEmulator(
      options: options,
      emulatorEnabled: true,
      emulatorProjectId: ' demo-listwhatever ',
    );

    expect(resolved.projectId, 'demo-listwhatever');
    expect(resolved.apiKey, options.apiKey);
    expect(resolved.appId, options.appId);
    expect(resolved.messagingSenderId, options.messagingSenderId);
    expect(resolved.storageBucket, options.storageBucket);
  });

  test('keeps the original projectId when the emulator is off', () {
    final resolved = firebaseOptionsForEmulator(
      options: options,
      emulatorEnabled: false,
      emulatorProjectId: 'demo-listwhatever',
    );

    expect(resolved.projectId, options.projectId);
    expect(identical(resolved, options), isTrue);
  });

  test(
    'keeps the original projectId when emulatorProjectId is null or blank',
    () {
      for (final projectId in [null, '', '   ']) {
        final resolved = firebaseOptionsForEmulator(
          options: options,
          emulatorEnabled: true,
          emulatorProjectId: projectId,
        );
        expect(resolved.projectId, options.projectId);
      }
    },
  );
}
