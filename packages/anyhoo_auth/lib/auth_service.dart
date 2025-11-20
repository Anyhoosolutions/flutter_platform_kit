import 'package:anyhoo_core/anyhoo_core.dart';
import 'package:anyhoo_auth/models/user_converter.dart';

/// Authentication service that handles login, logout, and user management.
///
/// Uses generics to support custom user types. Apps must provide a [UserConverter]
/// to convert API responses to their user model.
///
/// Example:
/// ```dart
/// final authService = AuthService<MyAppUser>(
///   converter: MyAppUserConverter(),
///   loginFunction: (email, password) async {
///     // Your login API call
///     final response = await http.post(...);
///     return response.data;
///   },
/// );
/// ```
class AuthService<T extends AuthUser> {
  /// Converter for transforming JSON to user objects.
  final UserConverter<T> converter;

  /// Functions that performs the actual login API call.
  ///
  /// Logging in with email and password
  /// Should return a Map with user data that can be converted by [converter].
  final Future<Map<String, dynamic>> Function(String email, String password) emailLoginFunction;

  /// Logging in with Google provider (optional).
  /// Should return a Map with user data that can be converted by [converter].
  final Future<Map<String, dynamic>> Function()? googleLoginFunction;

  /// Logging in with Apple provider (optional).
  /// Should return a Map with user data that can be converted by [converter].
  final Future<Map<String, dynamic>> Function()? appleLoginFunction;

  /// Logging in with anonymous provider (optional).
  /// Should return a Map with user data that can be converted by [converter].
  final Future<Map<String, dynamic>> Function()? anonymousLoginFunction;

  /// Function that performs the logout API call (optional).
  final Future<void> Function()? logoutFunction;

  /// Function that refreshes the current user's data (optional).
  final Future<Map<String, dynamic>> Function()? refreshUserFunction;

  /// Current authenticated user, null if not logged in.
  T? _currentUser;

  /// Current authenticated user, null if not logged in.
  T? get currentUser => _currentUser;

  /// Whether a user is currently logged in.
  bool get isAuthenticated => _currentUser != null;

  AuthService({
    required this.converter,
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
  Future<T?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final responseData = await emailLoginFunction(email, password);
      _currentUser = converter.fromJson(responseData);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Log in with Google.
  ///
  /// Returns the authenticated user on success, or null on failure.
  /// Throws an exception if login fails.
  Future<T?> loginWithGoogle() async {
    try {
      final responseData = await googleLoginFunction!();
      _currentUser = converter.fromJson(responseData);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Log in with Apple.
  ///
  /// Returns the authenticated user on success, or null on failure.
  /// Throws an exception if login fails.
  Future<T?> loginWithApple() async {
    try {
      final responseData = await appleLoginFunction!();
      _currentUser = converter.fromJson(responseData);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Log in with anonymous.
  ///
  /// Returns the authenticated user on success, or null on failure.
  /// Throws an exception if login fails.
  Future<T?> loginWithAnonymous() async {
    try {
      final responseData = await anonymousLoginFunction!();
      _currentUser = converter.fromJson(responseData);
      return _currentUser;
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
  Future<T?> refreshUser() async {
    if (refreshUserFunction == null) {
      throw UnsupportedError('refreshUserFunction not provided');
    }
    if (!isAuthenticated) {
      throw StateError('Cannot refresh user: no user is logged in');
    }

    try {
      final responseData = await refreshUserFunction!();
      _currentUser = converter.fromJson(responseData);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Set the current user (useful for restoring from storage).
  void setUser(T user) {
    _currentUser = user;
  }

  /// Clear the current user without calling logout API.
  void clearUser() {
    _currentUser = null;
  }
}
