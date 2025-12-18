import 'dart:async';
import 'package:anyhoo_auth/models/anyhoo_user_converter.dart';
import 'package:anyhoo_auth/services/anyhoo_auth_service.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';

/// Mock implementation of [AnyhooAuthService] for testing and development.
///
/// Provides a ready-to-use authentication service that simulates API calls
/// without requiring actual backend services. Useful for development, testing,
/// and demos.
///
/// Example:
/// ```dart
/// final mockAuthService = AnyhooMockAuthService();
/// ```
class AnyhooMockAuthService<T extends AnyhooUser> implements AnyhooAuthService<T> {
  /// Default delay for login operations (1 second).
  final Duration loginDelay;

  /// Default delay for logout operations (500ms).
  final Duration logoutDelay;

  /// Default delay for refresh operations (500ms).
  final Duration refreshDelay;

  /// Optional validator function for login credentials.
  ///
  /// If provided, this function will be called to validate email/password.
  /// Should return true if credentials are valid, false otherwise.
  /// If null, any non-empty credentials will be accepted.
  final bool Function(String email, String password)? credentialValidator;

  /// Optional function to generate mock user data from email.
  ///
  /// If provided, this function will be used to generate user data during login.
  /// If null, a default mock user structure will be used.
  final Map<String, dynamic> Function(String email)? userDataGenerator;

  final AnyhooUserConverter<T> _converter;

  /// Current authenticated user, null if not logged in.
  T? _currentUser;

  /// Stream controller for auth state changes.
  final StreamController<T?> _authStateController = StreamController<T?>.broadcast();

  @override
  T? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  @override
  Stream<T?> get authStateChanges {
    // Return a stream that starts with the current value, then continues with updates
    return Stream.multi((controller) {
      // Emit current value immediately
      controller.add(_currentUser);
      // Then listen to future changes
      _authStateController.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
        cancelOnError: false,
      );
    });
  }

  /// Emits the current user state to the stream.
  void _emitAuthState() {
    if (!_authStateController.isClosed) {
      _authStateController.add(_currentUser);
    }
  }

  /// Creates a mock authentication service.
  ///
  /// [loginDelay], [logoutDelay], and [refreshDelay] control simulation delays.
  /// [credentialValidator] can be used to validate test credentials.
  /// [userDataGenerator] can be used to customize mock user data.
  AnyhooMockAuthService({
    this.loginDelay = const Duration(seconds: 1),
    this.logoutDelay = const Duration(milliseconds: 500),
    this.refreshDelay = const Duration(milliseconds: 500),
    required AnyhooUserConverter<T> converter,
    this.credentialValidator,
    this.userDataGenerator,
  }) : _converter = converter;

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    // Simulate API delay
    await Future.delayed(loginDelay);

    // Validate credentials
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    // Use custom validator if provided, otherwise accept any non-empty credentials
    if (credentialValidator != null && !credentialValidator!(email, password)) {
      throw Exception('Invalid email or password');
    }

    // Generate user data
    T user;
    if (userDataGenerator != null) {
      user = _converter.fromJson(userDataGenerator!(email));
    } else {
      // Default mock user data
      user = _converter.fromJson({
        'id': 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'displayName': email.split('@').first,
        'photoURL': null,
        'emailVerified': true,
      });
    }

    _currentUser = user;
    _emitAuthState();
  }

  @override
  Future<void> loginWithGoogle() async {
    await Future.delayed(loginDelay);
    final user = _converter.fromJson({
      'id': 'mock_google_user_${DateTime.now().millisecondsSinceEpoch}',
      'email': 'google.user@example.com',
      'displayName': 'Google User',
      'photoURL': null,
      'emailVerified': true,
    });
    _currentUser = user;
    _emitAuthState();
  }

  @override
  Future<void> loginWithApple() async {
    await Future.delayed(loginDelay);
    final user = _converter.fromJson({
      'id': 'mock_apple_user_${DateTime.now().millisecondsSinceEpoch}',
      'email': 'apple.user@example.com',
      'displayName': 'Apple User',
      'photoURL': null,
      'emailVerified': true,
    });
    _currentUser = user;
    _emitAuthState();
  }

  @override
  Future<void> loginWithAnonymous() async {
    await Future.delayed(loginDelay);
    final user = _converter.fromJson({
      'id': 'mock_anonymous_user_${DateTime.now().millisecondsSinceEpoch}',
      'email': '',
      'displayName': 'Anonymous User',
      'photoURL': null,
      'emailVerified': false,
    });
    _currentUser = user;
    _emitAuthState();
  }

  @override
  Future<void> logout() async {
    // Simulate API delay
    await Future.delayed(logoutDelay);
    _currentUser = null;
    _emitAuthState();
  }

  @override
  void setUser(T user) {
    _currentUser = user;
    _emitAuthState();
  }

  @override
  void clearUser() {
    _currentUser = null;
    _emitAuthState();
  }

  /// Dispose the stream controller.
  ///
  /// Call this when the service is no longer needed to free resources.
  void dispose() {
    _authStateController.close();
  }

  /// Set a mock user directly (useful for testing).
  ///
  /// This bypasses the login flow and sets the user directly.
  void setMockUser(T user) {
    _currentUser = user;
    _emitAuthState();
  }
}
