import 'package:anyhoo_auth/anyhoo_auth.dart';

/// Creates a mock AuthService for demonstration purposes.
///
/// In a real app, this would make actual API calls.
AuthService createMockAuthService() {
  return AuthService(
    emailLoginFunction: (email, password) async {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation - accept any email/password for demo
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      // Return mock user data
      return {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'name': email.split('@').first, // Use email prefix as name
        'avatarUrl': null,
      };
    },
    logoutFunction: () async {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));
    },
    refreshUserFunction: () async {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // In a real app, this would fetch fresh user data
      // For demo, we'll just return the same structure
      return {'id': 'user_refreshed', 'email': 'refreshed@example.com', 'name': 'Refreshed User', 'avatarUrl': null};
    },
  );
}
