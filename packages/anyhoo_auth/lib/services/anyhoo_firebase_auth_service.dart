import 'package:anyhoo_auth/models/anyhoo_user_converter.dart';
import 'package:anyhoo_auth/services/anyhoo_auth_service.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
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
/// final firebaseAuthService = AnyhooFirebaseAuthService<MyAppUser>(
///   converter: MyAppUserConverter(),
/// );
/// ```
class AnyhooFirebaseAuthService<T extends AnyhooUser> implements AnyhooAuthService<T> {
  final AnyhooUserConverter<T> _converter;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Current authenticated user, null if not logged in.
  T? _currentUser;

  @override
  T? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  /// Creates a Firebase authentication service.
  ///
  /// [firebaseAuth] is optional - defaults to [FirebaseAuth.instance].
  /// Note: The converter is no longer needed here as it's used by the cubit, not the service.
  AnyhooFirebaseAuthService({
    required AnyhooUserConverter<T> converter,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _converter = converter {
    // Listen to auth state changes and update current user

    _firebaseAuth.authStateChanges().listen((firebaseUser) {
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
  Stream<T?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
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
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _log.severe('Error logging in with email and password', e);
      rethrow;
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        // For web, check if we're returning from a redirect
        final redirectResult = await _firebaseAuth.getRedirectResult();
        if (redirectResult.user != null) {
          // User just returned from redirect, use that result
          _log.info('Google Sign-In successful (user): ${redirectResult.user?.displayName}');
          return;
        }

        // Otherwise, initiate a new sign-in with redirect
        final googleProvider = firebase_auth.GoogleAuthProvider();
        await _firebaseAuth.signInWithRedirect(googleProvider);
        // The redirect will happen, and when the user returns,
        // getRedirectResult() will be called again on the next page load
        throw Exception('Google Sign-In redirect initiated. Please complete sign-in in the popup/redirect.');
      } else {
        // For mobile platforms (iOS/Android), use google_sign_in package
        final googleSignIn = GoogleSignIn.instance;

        // Initialize (required in v7)
        await googleSignIn.initialize();

        // Sign in using authenticate() method
        final googleUser = await googleSignIn.authenticate();

        // Obtain the auth details from the request
        final googleAuth = googleUser.authentication;

        // Create a new credential
        // Note: In google_sign_in v7, accessToken may not be available
        // Firebase Auth can work with just idToken for Google Sign-In
        final credential = firebase_auth.GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
      }
    } catch (e) {
      _log.severe('Error logging in with Google', e);
      throw Exception('Google Sign-In failed: $e');
    }
  }

  @override
  Future<void> loginWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthProvider = firebase_auth.OAuthProvider('apple.com');
      final credential = oauthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await _firebaseAuth.signInWithCredential(credential);
      return;
    } catch (e) {
      _log.severe('Error logging in with Apple', e);
      rethrow;
    }
  }

  @override
  Future<void> loginWithAnonymous() async {
    throw UnimplementedError(
      'Anonymous Sign-In requires additional setup. See documentation for implementation details.',
    );
  }

  @override
  Future<void> logout() async {
    _log.info('Logging out');
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      _log.severe('Error logging out', e);
      rethrow;
    }
  }

  @override
  void setUser(T user) {
    _currentUser = user;
  }

  @override
  void clearUser() {
    _currentUser = null;
  }

  /// Converts a Firebase User to a Map that can be used by the converter.
  T _firebaseUserToMap(firebase_auth.User firebaseUser) {
    final map = {
      'id': firebaseUser.uid,
      'email': firebaseUser.email ?? '',
      'displayName': firebaseUser.displayName,
      'photoURL': firebaseUser.photoURL,
      'emailVerified': firebaseUser.emailVerified,
      'phoneNumber': firebaseUser.phoneNumber,
      'metadata': {
        'creationTime': firebaseUser.metadata.creationTime?.toIso8601String(),
        'lastSignInTime': firebaseUser.metadata.lastSignInTime?.toIso8601String(),
      },
    };
    final user = _converter.fromJson(map);
    return user;
  }
}
