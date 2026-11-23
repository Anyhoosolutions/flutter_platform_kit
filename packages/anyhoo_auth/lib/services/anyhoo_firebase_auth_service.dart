import 'dart:async';

import 'package:anyhoo_auth/services/anyhoo_auth_exception.dart';
import 'package:anyhoo_auth/services/anyhoo_auth_service.dart';
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:anyhoo_models/anyhoo_models.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final _log = Logger('AnyhooFirebaseAuthService');

/// Firebase implementation of [AnyhooAuthService].
///
/// Provides a ready-to-use authentication service that integrates with Firebase Authentication.
/// Handles email/password login, logout, user refresh, and listens to auth state changes.
///
/// Example:
/// ```dart
/// final firebaseAuthService = AnyhooFirebaseAuthService(
///   firebaseAuth: FirebaseAuth.instance,
///   googleServerClientId: 'xxxx.apps.googleusercontent.com',
/// );
/// ```
class AnyhooFirebaseAuthService<T extends AnyhooUser> implements AnyhooAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final String? _googleClientId;
  final String? _googleServerClientId;

  /// Current authenticated user, null if not logged in.
  Map<String, dynamic>? _currentUser;

  @override
  Map<String, dynamic>? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  /// Creates a Firebase authentication service.
  ///
  /// [firebaseAuth] is optional - defaults to [FirebaseAuth.instance].
  ///
  /// [googleServerClientId] is the **Web** OAuth client ID from Firebase /
  /// Google Cloud (`….apps.googleusercontent.com`). Required for Google
  /// Sign-In on Android with `google_sign_in` 7. If omitted, falls back to
  /// `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`, then to
  /// `default_web_client_id` from `google-services.json`.
  ///
  /// [googleClientId] is the iOS (or other) client ID when not provided via
  /// `GoogleService-Info.plist`. Falls back to `--dart-define=GOOGLE_CLIENT_ID=...`.
  AnyhooFirebaseAuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    String? googleClientId,
    String? googleServerClientId,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleClientId = _nonEmpty(googleClientId) ?? _nonEmpty(const String.fromEnvironment('GOOGLE_CLIENT_ID')),
        _googleServerClientId =
            _nonEmpty(googleServerClientId) ?? _nonEmpty(const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID')) {
    // userChanges includes profile updates such as display name and email verification.
    _firebaseAuth.userChanges().listen((firebaseUser) {
      _log.info('Auth state changed (uid): ${firebaseUser?.uid ?? 'null'}');
      if (firebaseUser != null) {
        final userData = _firebaseUserToMap(firebaseUser);
        setUser(userData);
      } else {
        clearUser();
      }
    });
  }

  @override
  Stream<Map<String, dynamic>?> get authStateChanges {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      _log.info('Auth state changed (uid): ${firebaseUser?.uid ?? 'null'}');
      if (firebaseUser != null) {
        return _firebaseUserToMap(firebaseUser);
      }
      return null;
    });
  }

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final existing = _firebaseAuth.currentUser;
      if (existing != null && existing.email?.toLowerCase() == email.toLowerCase()) {
        _log.info(
          'Already signed in as $email; skipping signInWithEmailAndPassword',
        );
        return;
      }
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e, stackTrace) {
      _log.severe('Error logging in with email and password', e);
      if (e is firebase_auth.FirebaseAuthException) {
        _log.info('FirebaseAuthException code: ${e.code}, message: ${e.message}');
      }
      _log.info('stackTrace: $stackTrace');
      SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
      rethrow;
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    try {
      _log.info('=== Starting Google Sign-In process ===');
      if (_firebaseAuth.currentUser != null) {
        _log.info('User already logged in, logging out first');
        logout();
      }

      if (kIsWeb) {
        _log.info('Platform: Web');
        // Use signInWithPopup on web. signInWithRedirect requires
        // getRedirectResult() to be invoked on the next page load to consume
        // the pending redirect, which we don't currently do — that flow
        // strands the user back on the login page after a successful Google
        // sign-in. Popup keeps the user in our origin and authStateChanges
        // fires automatically when it completes.
        final googleProvider = firebase_auth.GoogleAuthProvider();
        _log.info('Initiating Google Sign-In popup...');
        try {
          final userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
          _log.info('✓ Google Sign-In popup completed. User ID: ${userCredential.user?.uid ?? 'null'}');
        } on firebase_auth.FirebaseAuthException catch (e, stackTrace) {
          final extraInfo = {
            'authDomain': _firebaseAuth.app.options.authDomain,
            'options': _firebaseAuth.app.options,
          };
          _log.severe(
              'FirebaseAuthException during signInWithPopup: code=${e.code} message=${e.message}', e, stackTrace);
          _log.severe(extraInfo.toString());
          SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false, extraInfo: extraInfo);
          rethrow;
        }
        return;
      } else {
        _log.info('Platform: Mobile (iOS/Android)');
        final credential = await _googleMobileCredential();
        _log.info('Signing in to Firebase with credential...');
        _log.info('Firebase Auth instance: ${_firebaseAuth.app.name}');
        _log.info('Firebase Auth app options: ${_firebaseAuth.app.options.projectId}');
        _log.info('Firebase Auth current user before sign-in: ${_firebaseAuth.currentUser?.uid ?? 'null'}');

        // Try to catch the actual error before timeout
        try {
          const timeoutSeconds = 15;
          final userCredential = await _firebaseAuth.signInWithCredential(credential).timeout(
            const Duration(seconds: timeoutSeconds),
            onTimeout: () {
              _log.severe('Firebase signInWithCredential timed out after $timeoutSeconds seconds');
              _log.severe('This might indicate a network connectivity issue or Firebase project configuration problem');
              _log.severe('Check if Firebase Auth is configured to use emulator (it should NOT be)');
              final timeoutError =
                  TimeoutException('Firebase authentication timed out', const Duration(seconds: timeoutSeconds));
              SentryHelper.captureException(timeoutError, fatal: false);
              throw timeoutError;
            },
          );
          _log.info('✓✓✓ Google Sign-In completed successfully! User ID: ${userCredential.user?.uid} ===');
        } catch (e, stackTrace) {
          _log.severe('Error during Firebase signInWithCredential', e, stackTrace);
          _log.severe('Error type: ${e.runtimeType}');
          _log.severe('Error message: ${e.toString()}');
          SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
          rethrow;
        }
      }
    } catch (e, stackTrace) {
      _log.severe('✗✗✗ Error logging in with Google', e, stackTrace);
      SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Runs the native Google Sign-In flow (google_sign_in v7) and returns the
  /// Firebase credential. Shared by sign-in and account linking.
  Future<firebase_auth.AuthCredential> _googleMobileCredential() async {
    final googleSignIn = GoogleSignIn.instance;

    // Initialize (required in v7). Android Credential Manager needs the
    // Web OAuth client as serverClientId; without it sign-in fails with
    // "serverClientId must be provided on Android".
    if (_googleServerClientId == null) {
      _log.warning(
        'Google Sign-In has no serverClientId. On Android this often fails. '
        'Pass googleServerClientId (Firebase Web OAuth client) or '
        '--dart-define=GOOGLE_SERVER_CLIENT_ID=...',
      );
    }
    await googleSignIn.initialize(
      clientId: _googleClientId,
      serverClientId: _googleServerClientId,
    );
    final googleUser = await googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;

    // In google_sign_in v7 accessToken may not be available; Firebase Auth
    // works with just the idToken.
    return firebase_auth.GoogleAuthProvider.credential(idToken: googleAuth.idToken);
  }

  Future<firebase_auth.AuthCredential> _appleCredential() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    return firebase_auth.OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
  }

  @override
  Future<void> loginWithApple() async {
    try {
      final credential = await _appleCredential();
      await _firebaseAuth.signInWithCredential(credential);
      return;
    } catch (e, stackTrace) {
      _log.severe('Error logging in with Apple', e);
      SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
      rethrow;
    }
  }

  @override
  Future<void> loginWithAnonymous() async {
    try {
      final existing = _firebaseAuth.currentUser;
      if (existing != null && existing.isAnonymous) {
        _log.info('Already signed in anonymously; skipping signInAnonymously');
        return;
      }
      await _firebaseAuth.signInAnonymously();
    } catch (e, stackTrace) {
      _log.severe('Error logging in anonymously', e);
      SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
      rethrow;
    }
  }

  @override
  Future<void> linkWithGoogle() async {
    final user = _requireUser();
    try {
      if (kIsWeb) {
        await user.linkWithPopup(firebase_auth.GoogleAuthProvider());
      } else {
        await user.linkWithCredential(await _googleMobileCredential());
      }
      await _refreshCurrentUser(user);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _authException(error);
    }
  }

  @override
  Future<void> linkWithApple() async {
    final user = _requireUser();
    try {
      if (kIsWeb) {
        await user.linkWithPopup(firebase_auth.OAuthProvider('apple.com'));
      } else {
        await user.linkWithCredential(await _appleCredential());
      }
      await _refreshCurrentUser(user);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _authException(error);
    }
  }

  @override
  Future<void> linkWithEmailAndPassword(String email, String password) async {
    final user = _requireUser();
    try {
      final credential = firebase_auth.EmailAuthProvider.credential(email: email, password: password);
      await user.linkWithCredential(credential);
      await _refreshCurrentUser(user);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _authException(error);
    }
  }

  /// Linking changes `isAnonymous` and the provider list on the same user
  /// object, so reload and publish the new snapshot.
  Future<void> _refreshCurrentUser(firebase_auth.User user) async {
    await user.reload();
    final refreshed = _firebaseAuth.currentUser;
    if (refreshed != null) {
      setUser(_firebaseUserToMap(refreshed));
    }
  }

  @override
  Future<void> logout() async {
    _log.info('Logging out');
    try {
      await _firebaseAuth.signOut();
    } catch (e, stackTrace) {
      _log.severe('Error logging out', e);
      SentryHelper.captureException(e, stackTrace: stackTrace, fatal: false);
      rethrow;
    }
  }

  @override
  void setUser(Map<String, dynamic> user) {
    _currentUser = user;
  }

  @override
  void clearUser() {
    _currentUser = null;
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    final user = _requireUser();
    try {
      await user.updateDisplayName(displayName);
      await user.reload();
      final refreshed = _firebaseAuth.currentUser;
      if (refreshed != null) {
        setUser(_firebaseUserToMap(refreshed));
      }
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _authException(error);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _requireUser();
    try {
      await user.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _authException(error);
    }
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _requireUser();
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw const AnyhooAuthException('no-email');
    }
    try {
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _authException(error);
    }
  }

  @override
  Future<void> deleteAccount({String? currentPassword}) async {
    final user = _requireUser();
    try {
      final email = user.email;
      if (currentPassword != null && email != null && email.isNotEmpty) {
        final credential = firebase_auth.EmailAuthProvider.credential(
          email: email,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
      }
      await user.delete();
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _authException(error);
    }
  }

  firebase_auth.User _requireUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AnyhooAuthException('no-user');
    }
    return user;
  }

  /// Converts a Firebase User to a Map that can be used by the converter.
  Map<String, dynamic> _firebaseUserToMap(firebase_auth.User firebaseUser) {
    final map = {
      'id': firebaseUser.uid,
      'email': firebaseUser.email ?? '',
      'displayName': firebaseUser.displayName,
      'photoURL': firebaseUser.photoURL,
      'emailVerified': firebaseUser.emailVerified,
      'isAnonymous': firebaseUser.isAnonymous,
      'providerIds': firebaseUser.providerData.map((info) => info.providerId).toList(),
      'phoneNumber': firebaseUser.phoneNumber,
      'metadata': {
        'creationTime': firebaseUser.metadata.creationTime?.toIso8601String(),
        'lastSignInTime': firebaseUser.metadata.lastSignInTime?.toIso8601String(),
      },
    };
    return map;
  }
}

AnyhooAuthException _authException(firebase_auth.FirebaseAuthException error) {
  final code = switch (error.code) {
    'invalid-credential' => 'wrong-password',
    _ => error.code,
  };
  return AnyhooAuthException(code, message: error.message);
}

String? _nonEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return value;
}
