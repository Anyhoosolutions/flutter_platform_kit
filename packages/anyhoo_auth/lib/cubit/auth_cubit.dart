import 'package:anyhoo_core/anyhoo_core.dart';
import 'package:anyhoo_auth/auth_service.dart';
import 'package:anyhoo_auth/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing authentication state.
///
/// Provides a reactive interface to the [AuthService] using BLoC pattern.
///
/// Example:
/// ```dart
/// final authCubit = AuthCubit<MyAppUser>(
///   authService: authService,
/// );
///
/// // In your widget
/// BlocProvider(
///   create: (_) => authCubit,
///   child: YourWidget(),
/// )
/// ```
class AuthCubit<T extends AuthUser> extends Cubit<AuthState<T>> {
  final AuthService<T> authService;

  AuthCubit({required this.authService}) : super(AuthState<T>(user: authService.currentUser));

  /// Log in with email and password.
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final user = await authService.login(email, password);
      emit(state.copyWith(user: user, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Log out the current user.
  Future<void> logout() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await authService.logout();
      emit(state.copyWith(user: null, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Refresh the current user's data.
  Future<void> refreshUser() async {
    if (!state.isAuthenticated) {
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final user = await authService.refreshUser();
      emit(state.copyWith(user: user, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      // Don't rethrow - refresh failures shouldn't break the app
    }
  }

  /// Update the state with a user (useful for restoring from storage).
  void setUser(T user) {
    authService.setUser(user);
    emit(state.copyWith(user: user));
  }

  /// Clear the current user without calling logout API.
  void clearUser() {
    authService.clearUser();
    emit(state.copyWith(user: null));
  }
}
