import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Emulator-only Firebase options — matches `*.emulator.json` / `*.emulator.plist`.
///
/// Replace with output from `flutterfire configure` before shipping to production.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      TargetPlatform.macOS => macos,
      TargetPlatform.windows => android,
      TargetPlatform.linux => throw UnsupportedError('DefaultFirebaseOptions have not been configured for linux.'),
      _ => throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.'),
    };
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyEmulatorOnlyNotARealKey1234567890',
    appId: '1:123456789012:web:0000000000000000000000',
    messagingSenderId: '123456789012',
    projectId: 'demo-firebase_prod_project_id_to_replace',
    authDomain: 'demo-firebase_prod_project_id_to_replace.firebaseapp.com',
    storageBucket: 'demo-firebase_prod_project_id_to_replace.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyEmulatorOnlyNotARealKey1234567890',
    appId: '1:123456789012:android:0000000000000000000000',
    messagingSenderId: '123456789012',
    projectId: 'demo-firebase_prod_project_id_to_replace',
    storageBucket: 'demo-firebase_prod_project_id_to_replace.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyEmulatorOnlyNotARealKey1234567890',
    appId: '1:123456789012:ios:0000000000000000000000',
    messagingSenderId: '123456789012',
    projectId: 'demo-firebase_prod_project_id_to_replace',
    storageBucket: 'demo-firebase_prod_project_id_to_replace.appspot.com',
    iosBundleId: 'com.anyhoosolutions.firebase_prod_project_id_to_replace',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyEmulatorOnlyNotARealKey1234567890',
    appId: '1:123456789012:ios:0000000000000000000000',
    messagingSenderId: '123456789012',
    projectId: 'demo-firebase_prod_project_id_to_replace',
    storageBucket: 'demo-firebase_prod_project_id_to_replace.appspot.com',
    iosBundleId: 'com.anyhoosolutions.firebase_prod_project_id_to_replace',
  );
}
