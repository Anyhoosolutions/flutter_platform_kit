import 'package:anyhoo_auth/auth_service.dart';
import 'package:anyhoo_auth/models/user_converter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Firebase implementation of [AuthService].
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
class FirebaseAuthService extends AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Creates a Firebase authentication service.
  ///
  /// [converter] is required to convert Firebase user data to your app's user model.
  /// [firebaseAuth] is optional - defaults to [FirebaseAuth.instance].
  FirebaseAuthService({
    required UserConverter converter,
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
        final userData = _firebaseUserToMap(firebaseUser);
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
      // Trigger the authentication flow
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In canceled by user');
      }

      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      return _firebaseUserToMap(userCredential.user!);
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
