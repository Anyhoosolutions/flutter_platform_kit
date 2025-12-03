import 'package:anyhoo_auth/services/anyhoo_auth_service.dart';

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
class AnyhooMockAuthService implements AnyhooAuthService {
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

  /// Current authenticated user, null if not logged in.
  Map<String, dynamic>? _currentUser;

  @override
  Map<String, dynamic>? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  /// Creates a mock authentication service.
  ///
  /// [loginDelay], [logoutDelay], and [refreshDelay] control simulation delays.
  /// [credentialValidator] can be used to validate test credentials.
  /// [userDataGenerator] can be used to customize mock user data.
  AnyhooMockAuthService({
    this.loginDelay = const Duration(seconds: 1),
    this.logoutDelay = const Duration(milliseconds: 500),
    this.refreshDelay = const Duration(milliseconds: 500),
    this.credentialValidator,
    this.userDataGenerator,
  });

  @override
  Future<Map<String, dynamic>> loginWithEmailAndPassword(String email, String password) async {
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
    Map<String, dynamic> userData;
    if (userDataGenerator != null) {
      userData = userDataGenerator!(email);
    } else {
      // Default mock user data
      userData = {
        'id': 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'displayName': email.split('@').first,
        'photoURL': null,
        'emailVerified': true,
      };
    }

    _currentUser = userData;
    return userData;
  }

  @override
  Future<Map<String, dynamic>> loginWithGoogle() async {
    await Future.delayed(loginDelay);
    final userData = {
      'id': 'mock_google_user_${DateTime.now().millisecondsSinceEpoch}',
      'email': 'google.user@example.com',
      'displayName': 'Google User',
      'photoURL': null,
      'emailVerified': true,
    };
    _currentUser = userData;
    return userData;
  }

  @override
  Future<Map<String, dynamic>> loginWithApple() async {
    await Future.delayed(loginDelay);
    final userData = {
      'id': 'mock_apple_user_${DateTime.now().millisecondsSinceEpoch}',
      'email': 'apple.user@example.com',
      'displayName': 'Apple User',
      'photoURL': null,
      'emailVerified': true,
    };
    _currentUser = userData;
    return userData;
  }

  @override
  Future<Map<String, dynamic>> loginWithAnonymous() async {
    await Future.delayed(loginDelay);
    final userData = {
      'id': 'mock_anonymous_user_${DateTime.now().millisecondsSinceEpoch}',
      'email': '',
      'displayName': 'Anonymous User',
      'photoURL': null,
      'emailVerified': false,
    };
    _currentUser = userData;
    return userData;
  }

  @override
  Future<void> logout() async {
    // Simulate API delay
    await Future.delayed(logoutDelay);
    _currentUser = null;
  }

  @override
  Future<Map<String, dynamic>> refreshUser() async {
    if (!isAuthenticated) {
      throw StateError('Cannot refresh user: no user is logged in');
    }

    // Simulate API delay
    await Future.delayed(refreshDelay);

    // Use current user's email for more realistic mock data
    final currentEmail = currentUser?['email'] ?? 'refreshed@example.com';
    final currentId = currentUser?['id'] ?? 'mock_user_refreshed';

    // Generate refreshed user data
    Map<String, dynamic> refreshedData;
    if (userDataGenerator != null) {
      refreshedData = userDataGenerator!(currentEmail);
    } else {
      // Default refreshed user data, preserving current user's email and ID
      refreshedData = {
        'id': currentId,
        'email': currentEmail,
        'displayName': currentEmail.split('@').first,
        'photoURL': null,
        'emailVerified': true,
      };
    }

    // Update current user with refreshed data
    _currentUser = refreshedData;
    return refreshedData;
  }

  @override
  void setUser(Map<String, dynamic> user) {
    _currentUser = user;
  }

  @override
  void clearUser() {
    _currentUser = null;
  }

  /// Set a mock user directly (useful for testing).
  ///
  /// This bypasses the login flow and sets the user directly.
  void setMockUser(Map<String, dynamic> user) {
    setUser(user);
  }
}
