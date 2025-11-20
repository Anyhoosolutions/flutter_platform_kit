import 'package:anyhoo_core/anyhoo_core.dart';
import 'package:anyhoo_auth/auth_service.dart';
import 'package:anyhoo_auth/models/user_converter.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

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
class FirebaseAuthService<T extends AuthUser> extends AuthService<T> {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Creates a Firebase authentication service.
  ///
  /// [converter] is required to convert Firebase user data to your app's user model.
  /// [firebaseAuth] is optional - defaults to [FirebaseAuth.instance].
  FirebaseAuthService({
    required UserConverter<T> converter,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        super(
          converter: converter,
          emailLoginFunction: _createLoginFunction(firebaseAuth ?? firebase_auth.FirebaseAuth.instance),
          logoutFunction: _createLogoutFunction(firebaseAuth ?? firebase_auth.FirebaseAuth.instance),
          refreshUserFunction: _createRefreshUserFunction(firebaseAuth ?? firebase_auth.FirebaseAuth.instance),
        ) {
    // Listen to auth state changes and update current user
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        final userData = _firebaseUserToMap(firebaseUser);
        setUser(this.converter.fromJson(userData));
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
  ///
  /// This is a placeholder - you'll need to implement Google Sign-In separately
  /// and then call [setUser] with the converted user data.
  ///
  /// Example:
  /// ```dart
  /// final googleSignIn = GoogleSignIn();
  /// final googleUser = await googleSignIn.signIn();
  /// if (googleUser != null) {
  ///   final googleAuth = await googleUser.authentication;
  ///   final credential = GoogleAuthProvider.credential(
  ///     accessToken: googleAuth.accessToken,
  ///     idToken: googleAuth.idToken,
  ///   );
  ///   final firebaseCredential = await firebaseAuth.signInWithCredential(credential);
  ///   // User will be automatically set via authStateChanges listener
  /// }
  /// ```
  Future<void> signInWithGoogle() async {
    throw UnimplementedError(
      'Google Sign-In requires additional setup. See documentation for implementation details.',
    );
  }

  /// Sign in with Apple (requires additional setup).
  ///
  /// This is a placeholder - you'll need to implement Apple Sign-In separately.
  Future<void> signInWithApple() async {
    throw UnimplementedError(
      'Apple Sign-In requires additional setup. See documentation for implementation details.',
    );
  }

  /// Sign in with Apple (requires additional setup).
  ///
  /// This is a placeholder - you'll need to implement Apple Sign-In separately.
  Future<void> signInAnonymously() async {
    throw UnimplementedError(
      'Anonymous Sign-In requires additional setup. See documentation for implementation details.',
    );
  }
}
