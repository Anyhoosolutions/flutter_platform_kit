import 'package:anyhoo_auth/services/auth_service.dart';

/// Mock implementation of [AuthService] for testing and development.
///
/// Provides a ready-to-use authentication service that simulates API calls
/// without requiring actual backend services. Useful for development, testing,
/// and demos.
///
/// Example:
/// ```dart
/// final mockAuthService = MockAuthService<MyAppUser>(
///   converter: MyAppUserConverter(),
/// );
/// ```
class MockAuthService extends AuthService {
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

  /// Creates a mock authentication service.
  ///
  /// [converter] is required to convert mock user data to your app's user model.
  /// [loginDelay], [logoutDelay], and [refreshDelay] control simulation delays.
  /// [credentialValidator] can be used to validate test credentials.
  /// [userDataGenerator] can be used to customize mock user data.
  MockAuthService({
    this.loginDelay = const Duration(seconds: 1),
    this.logoutDelay = const Duration(milliseconds: 500),
    this.refreshDelay = const Duration(milliseconds: 500),
    this.credentialValidator,
    this.userDataGenerator,
  }) : super(
          emailLoginFunction: _createMockLoginFunction(
            loginDelay,
            credentialValidator,
            userDataGenerator,
          ),
          logoutFunction: _createMockLogoutFunction(logoutDelay),
          refreshUserFunction: _createMockRefreshUserFunction(
            refreshDelay,
            userDataGenerator,
          ),
        );

  /// Creates a mock login function.
  static Future<Map<String, dynamic>> Function(String, String) _createMockLoginFunction(
    Duration delay,
    bool Function(String, String)? validator,
    Map<String, dynamic> Function(String)? dataGenerator,
  ) {
    return (String email, String password) async {
      // Simulate API delay
      await Future.delayed(delay);

      // Validate credentials
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      // Use custom validator if provided, otherwise accept any non-empty credentials
      if (validator != null && !validator(email, password)) {
        throw Exception('Invalid email or password');
      }

      // Generate user data
      if (dataGenerator != null) {
        return dataGenerator(email);
      }

      // Default mock user data
      return {
        'id': 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'displayName': email.split('@').first,
        'photoURL': null,
        'emailVerified': true,
      };
    };
  }

  /// Creates a mock logout function.
  static Future<void> Function() _createMockLogoutFunction(Duration delay) {
    return () async {
      // Simulate API delay
      await Future.delayed(delay);
    };
  }

  /// Creates a mock refresh user function.
  static Future<Map<String, dynamic>> Function() _createMockRefreshUserFunction(
    Duration delay,
    Map<String, dynamic> Function(String)? dataGenerator,
  ) {
    return () async {
      // Simulate API delay
      await Future.delayed(delay);

      // Generate refreshed user data
      if (dataGenerator != null) {
        return dataGenerator('refreshed@example.com');
      }

      // Default refreshed user data
      return {
        'id': 'mock_user_refreshed',
        'email': 'refreshed@example.com',
        'displayName': 'Refreshed User',
        'photoURL': null,
        'emailVerified': true,
      };
    };
  }

  /// Override refreshUser to use current user's email if available.
  ///
  /// This provides more realistic mock behavior by preserving the current user's
  /// email and ID when refreshing, rather than using hardcoded values.
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

    // Update current user with refreshed data using setUser
    setUser(refreshedData);
    return refreshedData;
  }

  /// Set a mock user directly (useful for testing).
  ///
  /// This bypasses the login flow and sets the user directly.
  void setMockUser(Map<String, dynamic> user) {
    setUser(user);
  }
}
