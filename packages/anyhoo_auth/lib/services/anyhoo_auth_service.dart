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
abstract class AnyhooAuthService {
  /// Current authenticated user, null if not logged in.
  Map<String, dynamic>? get currentUser;

  /// Whether a user is currently logged in.
  bool get isAuthenticated => currentUser != null;

  /// Log in with email and password.
  ///
  /// Returns a Map with user data that can be converted by a [UserConverter].
  /// Throws an exception if login fails.
  Future<Map<String, dynamic>> loginWithEmailAndPassword(String email, String password);

  /// Log in with Google.
  ///
  /// Returns a Map with user data that can be converted by a [UserConverter].
  /// Throws an exception if login fails or if Google login is not supported.
  Future<Map<String, dynamic>> loginWithGoogle();

  /// Log in with Apple.
  ///
  /// Returns a Map with user data that can be converted by a [UserConverter].
  /// Throws an exception if login fails or if Apple login is not supported.
  Future<Map<String, dynamic>> loginWithApple();

  /// Log in with anonymous provider.
  ///
  /// Returns a Map with user data that can be converted by a [UserConverter].
  /// Throws an exception if login fails or if anonymous login is not supported.
  Future<Map<String, dynamic>> loginWithAnonymous();

  /// Log out the current user.
  ///
  /// Clears the current user and optionally calls the logout API.
  Future<void> logout();

  /// Refresh the current user's data from the server.
  ///
  /// Updates [currentUser] with fresh data from the API.
  /// Throws an exception if refresh fails or if no user is logged in.
  Future<Map<String, dynamic>> refreshUser();

  /// Set the current user (useful for restoring from storage).
  void setUser(Map<String, dynamic> user);

  /// Clear the current user without calling logout API.
  void clearUser();
}
