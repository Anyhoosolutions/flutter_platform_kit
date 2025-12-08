import 'package:anyhoo_core/anyhoo_core.dart';

/// State for authentication.
class AnyhooAuthState<T extends AnyhooUser> {
  /// Current authenticated user, null if not logged in.
  final T? user;

  /// Whether a login/logout operation is in progress.
  final bool isLoading;

  /// Error message if an operation failed, null otherwise.
  final String? errorMessage;

  const AnyhooAuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Whether a user is currently authenticated.
  bool get isAuthenticated => user != null;

  /// Create a copy of this state with updated values.
  AnyhooAuthState<T> copyWith({
    T? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AnyhooAuthState<T>(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  String toString() {
    return 'AuthState(user: ${user?.getEmail()}, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}
