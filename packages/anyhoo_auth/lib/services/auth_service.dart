import 'package:anyhoo_auth/models/user_converter.dart';

/// Authentication service that handles login, logout, and user management.
///
/// Uses generics to support custom user types. Apps must provide a [UserConverter]
/// to convert API responses to their user model.
///
/// Example:
/// ```dart
/// final authService = AuthService(
///   loginFunction: (email, password) async {
///     // Your login API call
///     final response = await http.post(...);
///     return response.data;
///   },
/// );
/// ```
class AuthService {
  /// Functions that performs the actual login API call.
  ///
  /// Logging in with email and password
  /// Should return a Map with user data that can be converted by a [UserConverter].
  final Future<Map<String, dynamic>> Function(String email, String password) emailLoginFunction;

  /// Logging in with Google provider (optional).
  /// Should return a Map with user data that can be converted by a [UserConverter].
  final Future<Map<String, dynamic>> Function()? googleLoginFunction;

  /// Logging in with Apple provider (optional).
  /// Should return a Map with user data that can be converted by a [UserConverter].
  final Future<Map<String, dynamic>> Function()? appleLoginFunction;

  /// Logging in with anonymous provider (optional).
  /// Should return a Map with user data that can be converted by a [UserConverter].
  final Future<Map<String, dynamic>> Function()? anonymousLoginFunction;

  /// Function that performs the logout API call (optional).
  final Future<void> Function()? logoutFunction;

  /// Function that refreshes the current user's data (optional).
  final Future<Map<String, dynamic>> Function()? refreshUserFunction;

  /// Current authenticated user, null if not logged in.
  Map<String, dynamic>? _currentUser;

  /// Current authenticated user, null if not logged in.
  Map<String, dynamic>? get currentUser => _currentUser;

  /// Whether a user is currently logged in.
  bool get isAuthenticated => _currentUser != null;

  AuthService({
    required this.emailLoginFunction,
    this.logoutFunction,
    this.refreshUserFunction,
    this.googleLoginFunction,
    this.appleLoginFunction,
    this.anonymousLoginFunction,
  });

  /// Log in with email and password.
  ///
  /// Returns the authenticated user on success, or null on failure.
  /// Throws an exception if login fails.
  Future<Map<String, dynamic>> loginWithEmailAndPassword(String email, String password) async {
    try {
      final responseData = await emailLoginFunction(email, password);
      return responseData;
    } catch (e) {
      rethrow;
    }
  }

  /// Log in with Google.
  ///
  /// Returns the authenticated user on success, or null on failure.
  /// Throws an exception if login fails.
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final responseData = await googleLoginFunction!();
      return responseData;
    } catch (e) {
      rethrow;
    }
  }

  /// Log in with Apple.
  ///
  /// Returns the authenticated user on success, or null on failure.
  /// Throws an exception if login fails.
  Future<Map<String, dynamic>> loginWithApple() async {
    try {
      final responseData = await appleLoginFunction!();
      return responseData;
    } catch (e) {
      rethrow;
    }
  }

  /// Log in with anonymous.
  ///
  /// Returns the authenticated user on success, or null on failure.
  /// Throws an exception if login fails.
  Future<Map<String, dynamic>> loginWithAnonymous() async {
    try {
      final responseData = await anonymousLoginFunction!();
      return responseData;
    } catch (e) {
      rethrow;
    }
  }

  /// Log out the current user.
  ///
  /// Clears the current user and optionally calls the logout API.
  Future<void> logout() async {
    if (logoutFunction != null) {
      await logoutFunction!();
    }
    _currentUser = null;
  }

  /// Refresh the current user's data from the server.
  ///
  /// Updates [currentUser] with fresh data from the API.
  Future<Map<String, dynamic>> refreshUser() async {
    if (refreshUserFunction == null) {
      throw UnsupportedError('refreshUserFunction not provided');
    }
    if (!isAuthenticated) {
      throw StateError('Cannot refresh user: no user is logged in');
    }

    try {
      final responseData = await refreshUserFunction!();
      return responseData;
    } catch (e) {
      rethrow;
    }
  }

  /// Set the current user (useful for restoring from storage).
  void setUser(Map<String, dynamic> user) {
    _currentUser = user;
  }

  /// Clear the current user without calling logout API.
  void clearUser() {
    _currentUser = null;
  }
}
