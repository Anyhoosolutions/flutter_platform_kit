import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_firebase/src/os_tool.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class FirebaseInitializer {
  final _log = Logger('FirebaseInitializer');
  final Arguments arguments;

  FirebaseApp? _firebaseApp;
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  FirebaseStorage? _storage;

  bool useFirebaseAuth;
  bool useFirebaseFirestore;
  bool useFirebaseStorage;
  String? hostIp;
  bool? overrideUseFirebaseEmulator;

  FirebaseInitializer({
    required this.arguments,
    this.useFirebaseAuth = true,
    this.useFirebaseFirestore = true,
    this.useFirebaseStorage = true,
    this.hostIp,
    this.overrideUseFirebaseEmulator,
  });

  Future<void> initialize(FirebaseOptions firebaseOptions) async {
    if (arguments.useFakeData) {
      _log.info('!! Using fake data, skipping Firebase initialization');
      return;
    }

    // If we already have a Firebase app instance, return it
    if (_firebaseApp != null) {
      _log.info('!! Returning cached Firebase app');
    }

    try {
      // Try to get the existing app first
      try {
        final existingApp = Firebase.app();
        _log.info('!! Firebase already initialized, returning existing app');
        _firebaseApp = existingApp;
      } catch (e) {
        // No existing app found, proceed with initialization
        _log.info('!! No existing Firebase app found, initializing new app');
      }

      final firebase = await Firebase.initializeApp(options: firebaseOptions);
      _log.info('!! Firebase initialized');
      _firebaseApp = firebase;

      if (useFirebaseAuth) {
        setupFirebaseAuth();
      }
      if (useFirebaseFirestore) {
        setupFirebaseFirestore();
      }
      if (useFirebaseStorage) {
        setupFirebaseStorage();
      }

      _log.info('!! Firebase initialized and setup');
    } catch (e, stackTrace) {
      // If we get a duplicate app error, try to get the existing app
      if (e.toString().contains('duplicate-app') || e.toString().contains('already exists')) {
        _log.info('!! Caught duplicate app error, returning existing app');
        try {
          final existingApp = Firebase.app();
          _firebaseApp = existingApp;
        } catch (getAppError) {
          _log.severe('!! Failed to get existing app after duplicate error: $getAppError');
          rethrow;
        }
      }

      _log.severe('!! Error initializing Firebase: $e');
      _log.severe('!! Stack trace: $stackTrace');
      rethrow;
    }
  }

  bool isEmulatorEnabled() {
    if (overrideUseFirebaseEmulator != null) {
      _log.info('Firebase emulator is ${overrideUseFirebaseEmulator! ? 'enabled' : 'disabled'}');
      return overrideUseFirebaseEmulator!;
    }
    final isEnabled = arguments.shouldUseFirebaseEmulator();
    _log.info('Firebase emulator is ${isEnabled ? 'enabled' : 'disabled'}');
    return isEnabled;
  }

  Future<void> setupFirebaseAuth() async {
    _log.info('!! Setting up Firebase Auth');
    if (arguments.useFakeData) {
      _log.info('!! Using fake data, skipping Firebase Auth setup');
      return;
    }
    if (_auth != null) {
      _log.info('!! Firebase Auth already setup, skipping');
      return;
    }
    try {
      _auth = FirebaseAuth.instance;
      if (isEmulatorEnabled()) {
        final host = getHost();
        if (host != null) {
          _log.info('!! Configuring Auth emulator with host: $host, port: 9099');
          await _auth!.useAuthEmulator(host, 9099);
          _log.info('!! Successfully configured Auth emulator');
          // On web, ensure emulator is fully ready before proceeding
          if (kIsWeb) {
            await Future.delayed(const Duration(milliseconds: 200));
            _log.info('!! Web emulator ready delay completed');
          }
        } else {
          _log.warning('!! Emulator enabled but host is null');
        }
      }
    } catch (e, stackTrace) {
      _log.info('!! Error: $e');
      _log.info('!! Stack trace: $stackTrace');
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.log('Error: $e');
      }
      rethrow;
    }
  }

  FirebaseAuth getAuth() {
    if (_auth == null) {
      throw Exception('Firebase Auth not initialized');
    }
    return _auth!;
  }

  Future<void> setupFirebaseFirestore() async {
    _log.info('!! Setting up Firebase Firestore');
    if (arguments.useFakeData) {
      _log.info('!! Using fake data, skipping Firebase Firestore setup');
      return;
    }
    if (_firestore != null) {
      _log.info('!! Firebase Firestore already setup, skipping');
      return;
    }

    try {
      _firestore = FirebaseFirestore.instance;
      if (isEmulatorEnabled()) {
        final host = getHost();
        if (host != null) {
          _firestore!.useFirestoreEmulator(host, 8080);
          _log.info('!! Successfully configured Firestore emulator');
        }
      }
      _log.info('!! Firestore configured: ${_firestore!.settings}');
    } catch (e, stackTrace) {
      _log.info('!! Error: $e');
      _log.info('!! Stack trace: $stackTrace');
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.log('Error: $e');
      }
      rethrow;
    }
  }

  FirebaseFirestore getFirestore() {
    if (_firestore == null) {
      throw Exception('Firestore not initialized');
    }
    return _firestore!;
  }

  String? getHost() {
    if (hostIp == null) {
      _log.info("!! hostIp is null, using 'localhost'");
      return 'localhost';
    }

    _log.info('!! hostIp: $hostIp');
    _log.info('!! arguments.shouldUseEmulator(): ${arguments.shouldUseFirebaseEmulator()}');
    _log.info('!! OSTool.getPlatformType(): ${OSTool.getPlatformType()}');
    _log.info('!! arguments.useDeviceEmulator(): ${arguments.useDeviceEmulator}');
    if (arguments.shouldUseFirebaseEmulator()) {
      final host = switch ((OSTool.getPlatformType(), arguments.useDeviceEmulator)) {
        // Web platform - always use localhost regardless of other parameters
        (PlatformType.web, _) => 'localhost',

        // Android emulator
        (PlatformType.android, true) => 'localhost',
        // Real Android device
        (PlatformType.android, false) => hostIp,

        // Real iOS device
        (PlatformType.ios, false) => hostIp,
        // Simulator iOS device
        (PlatformType.ios, true) => hostIp,

        // Default case
        (_, _) => null,
      };
      _log.info('!! host: $host');
      return host;
    } else {
      _log.info('!! host: null');
      return null;
    }
  }

  Future<void> setupFirebaseStorage() async {
    _log.info('!! Setting up Firebase Storage');
    if (arguments.useFakeData) {
      _log.info('!! Using fake data, skipping Firebase Storage setup');
      return;
    }
    if (_storage != null) {
      _log.info('!! Firebase Storage already setup, skipping');
      return;
    }

    try {
      _storage = FirebaseStorage.instance;
      if (isEmulatorEnabled()) {
        final host = getHost();
        if (host != null) {
          _storage!.useStorageEmulator(host, 9199);
          _log.info('!! Successfully configured Storage emulator');
        }
      }
      _log.info('!! Storage configured: ${_storage!}');
    } catch (e, stackTrace) {
      _log.info('!! Error: $e');
      _log.info('!! Stack trace: $stackTrace');
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.log('Error: $e');
      }
      rethrow;
    }
  }

  FirebaseStorage getStorage() {
    if (_storage == null) {
      throw Exception('Storage not initialized');
    }
    return _storage!;
  }
}
