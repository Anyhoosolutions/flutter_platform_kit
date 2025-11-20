import 'package:anyhoo_core/anyhoo_core.dart';

/// State for authentication.
class AuthState<T extends AuthUser> {
  /// Current authenticated user, null if not logged in.
  final T? user;

  /// Whether a login/logout operation is in progress.
  final bool isLoading;

  /// Error message if an operation failed, null otherwise.
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Whether a user is currently authenticated.
  bool get isAuthenticated => user != null;

  /// Create a copy of this state with updated values.
  AuthState<T> copyWith({
    T? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState<T>(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  String toString() {
    return 'AuthState(user: ${user?.email}, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}
