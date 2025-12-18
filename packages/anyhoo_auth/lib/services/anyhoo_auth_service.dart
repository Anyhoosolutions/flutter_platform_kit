import 'package:anyhoo_core/models/anyhoo_user.dart';

/// Abstract interface for authentication services.
///
/// Implement this interface to create custom authentication services.
/// This makes it easy to extend and create new authentication implementations.
///
/// Example:
/// ```dart
/// class MyCustomAuthService implements AnyhooAuthService {
///   @override
///   Future<Map<String, dynamic>> loginWithEmailAndPassword(String email, String password) async {
///     // Your custom login implementation
///   }
///
///   // Implement other required methods...
/// }
/// ```
abstract class AnyhooAuthService<T extends AnyhooUser> {
  /// Current authenticated user, null if not logged in.
  T? get currentUser;

  /// Whether a user is currently logged in.
  bool get isAuthenticated => currentUser != null;

  Stream<T?> get authStateChanges;

  /// Log in with email and password.
  ///
  /// Throws an exception if login fails.
  Future<void> loginWithEmailAndPassword(String email, String password);

  /// Log in with Google.
  ///
  /// Throws an exception if login fails or if Google login is not supported.
  Future<void> loginWithGoogle();

  /// Log in with Apple.
  ///
  /// Throws an exception if login fails or if Apple login is not supported.
  Future<void> loginWithApple();

  /// Log in with anonymous provider.
  ///
  /// Returns a Map with user data that can be converted by a [UserConverter].
  /// Throws an exception if login fails or if anonymous login is not supported.
  Future<void> loginWithAnonymous();

  /// Log out the current user.
  ///
  /// Clears the current user and optionally calls the logout API.
  Future<void> logout();

  /// Set the current user (useful for restoring from storage).
  void setUser(T user);

  /// Clear the current user without calling logout API.
  void clearUser();
}
