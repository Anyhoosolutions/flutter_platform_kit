import 'package:anyhoo_auth/services/anyhoo_auth_service.dart';
import 'package:anyhoo_auth/models/anyhoo_user_converter.dart';
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
/// final firebaseAuthService = FirebaseAuthService<MyAppUser>(
///   converter: MyAppUserConverter(),
/// );
/// ```
class AnyhooFirebaseAuthService extends AnyhooAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Creates a Firebase authentication service.
  ///
  /// [converter] is required to convert Firebase user data to your app's user model.
  /// [firebaseAuth] is optional - defaults to [FirebaseAuth.instance].
  AnyhooFirebaseAuthService({
    required AnyhooUserConverter converter,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        super(
          emailLoginFunction: _createLoginFunction(firebaseAuth ?? firebase_auth.FirebaseAuth.instance),
          logoutFunction: _createLogoutFunction(firebaseAuth ?? firebase_auth.FirebaseAuth.instance),
          refreshUserFunction: _createRefreshUserFunction(firebaseAuth ?? firebase_auth.FirebaseAuth.instance),
          googleLoginFunction: _createGoogleLoginFunction(firebaseAuth ?? firebase_auth.FirebaseAuth.instance),
          appleLoginFunction: _createAppleLoginFunction(firebaseAuth ?? firebase_auth.FirebaseAuth.instance),
        ) {
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

  /// Creates a login function that uses Firebase Authentication.
  static Future<Map<String, dynamic>> Function(String, String) _createLoginFunction(
    firebase_auth.FirebaseAuth firebaseAuth,
  ) {
    return (String email, String password) async {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _firebaseUserToMap(credential.user!);
    };
  }

  /// Creates a logout function that uses Firebase Authentication.
  static Future<void> Function() _createLogoutFunction(
    firebase_auth.FirebaseAuth firebaseAuth,
  ) {
    return () async {
      await firebaseAuth.signOut();
    };
  }

  /// Creates a refresh user function that uses Firebase Authentication.
  static Future<Map<String, dynamic>> Function() _createRefreshUserFunction(
    firebase_auth.FirebaseAuth firebaseAuth,
  ) {
    return () async {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw StateError('No user is currently logged in');
      }
      // Refresh the user's token and data
      await user.reload();
      final refreshedUser = firebaseAuth.currentUser!;
      return _firebaseUserToMap(refreshedUser);
    };
  }

  /// Creates a Google login function that uses Firebase Authentication.
  static Future<Map<String, dynamic>> Function() _createGoogleLoginFunction(
    firebase_auth.FirebaseAuth firebaseAuth,
  ) {
    return () async {
      try {
        if (kIsWeb) {
          // For web, check if we're returning from a redirect
          final redirectResult = await firebaseAuth.getRedirectResult();
          if (redirectResult.user != null) {
            // User just returned from redirect, use that result
            return _firebaseUserToMap(redirectResult.user!);
          }

          // Otherwise, initiate a new sign-in with redirect
          final googleProvider = firebase_auth.GoogleAuthProvider();
          await firebaseAuth.signInWithRedirect(googleProvider);
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
          final userCredential = await firebaseAuth.signInWithCredential(credential);
          return _firebaseUserToMap(userCredential.user!);
        }
      } catch (e) {
        throw Exception('Google Sign-In failed: $e');
      }
    };
  }

  /// Creates an Apple login function that uses Firebase Authentication.
  static Future<Map<String, dynamic>> Function() _createAppleLoginFunction(
    firebase_auth.FirebaseAuth firebaseAuth,
  ) {
    return () async {
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

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      return _firebaseUserToMap(userCredential.user!);
    };
  }

  /// Converts a Firebase User to a Map that can be used by the converter.
  static Map<String, dynamic> _firebaseUserToMap(firebase_auth.User firebaseUser) {
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

  /// Sign in with Google (requires additional setup with google_sign_in package).
  Future<void> signInWithGoogle() async {
    await loginWithGoogle();
  }

  /// Sign in with Apple (requires additional setup).
  Future<void> signInWithApple() async {
    await loginWithApple();
  }

  /// Sign in anonymously (requires additional setup).
  Future<void> signInAnonymously() async {
    throw UnimplementedError(
      'Anonymous Sign-In requires additional setup. See documentation for implementation details.',
    );
  }
}
