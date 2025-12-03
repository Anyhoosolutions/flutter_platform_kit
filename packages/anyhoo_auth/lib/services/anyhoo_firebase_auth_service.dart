import 'package:anyhoo_auth/services/anyhoo_auth_service.dart';
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
class AnyhooFirebaseAuthService implements AnyhooAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Current authenticated user, null if not logged in.
  Map<String, dynamic>? _currentUser;

  @override
  Map<String, dynamic>? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  /// Creates a Firebase authentication service.
  ///
  /// [firebaseAuth] is optional - defaults to [FirebaseAuth.instance].
  /// Note: The converter is no longer needed here as it's used by the cubit, not the service.
  AnyhooFirebaseAuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance {
    // Listen to auth state changes and update current user
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        _log.info('Auth state changed (uid): ${firebaseUser.uid}');
        final userData = _firebaseUserToMap(firebaseUser);
        _log.info('Auth state changed (name): ${userData['displayName']}');
        setUser(userData);
      } else {
        clearUser();
      }
    });
  }

  @override
  Future<Map<String, dynamic>> loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userData = _firebaseUserToMap(credential.user!);
      _currentUser = userData;
      return userData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        // For web, check if we're returning from a redirect
        final redirectResult = await _firebaseAuth.getRedirectResult();
        if (redirectResult.user != null) {
          // User just returned from redirect, use that result
          final userData = _firebaseUserToMap(redirectResult.user!);
          _currentUser = userData;
          return userData;
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

        // Once signed in, return the UserCredential
        final userCredential = await _firebaseAuth.signInWithCredential(credential);
        final userData = _firebaseUserToMap(userCredential.user!);
        _currentUser = userData;
        return userData;
      }
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> loginWithApple() async {
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

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final userData = _firebaseUserToMap(userCredential.user!);
      _currentUser = userData;
      return userData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> loginWithAnonymous() async {
    throw UnimplementedError(
      'Anonymous Sign-In requires additional setup. See documentation for implementation details.',
    );
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  @override
  Future<Map<String, dynamic>> refreshUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('No user is currently logged in');
    }
    // Refresh the user's token and data
    await user.reload();
    final refreshedUser = _firebaseAuth.currentUser!;
    final userData = _firebaseUserToMap(refreshedUser);
    _currentUser = userData;
    return userData;
  }

  @override
  void setUser(Map<String, dynamic> user) {
    _currentUser = user;
  }

  @override
  void clearUser() {
    _currentUser = null;
  }

  /// Converts a Firebase User to a Map that can be used by the converter.
  Map<String, dynamic> _firebaseUserToMap(firebase_auth.User firebaseUser) {
    return {
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
  }

  /// Get the underlying Firebase Auth instance.
  ///
  /// Useful for accessing Firebase-specific features like OAuth providers.
  firebase_auth.FirebaseAuth get firebaseAuth => _firebaseAuth;

  /// Sign in with Google (convenience method).
  Future<void> signInWithGoogle() async {
    await loginWithGoogle();
  }

  /// Sign in with Apple (convenience method).
  Future<void> signInWithApple() async {
    await loginWithApple();
  }

  /// Sign in anonymously (convenience method).
  Future<void> signInAnonymously() async {
    await loginWithAnonymous();
  }
}
