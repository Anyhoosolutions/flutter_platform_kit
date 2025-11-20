import 'package:anyhoo_auth/enhance_user_service.dart';
import 'package:anyhoo_auth/models/user_converter.dart';
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
  final AuthService authService;
  final UserConverter<T> converter;
  final EnhanceUserService? enhanceUserService;

  AuthCubit({required this.authService, required this.converter, this.enhanceUserService})
      : super(
            AuthState<T>(user: authService.currentUser == null ? null : converter.fromJson(authService.currentUser!)));

  /// Log in with email and password.
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final userData = await authService.loginWithEmailAndPassword(email, password);
      final enhancedUserData = await enhanceUserService?.enhanceUser(userData) ?? userData;
      final enhancedUser = converter.fromJson(enhancedUserData);
      emit(state.copyWith(user: enhancedUser, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Log in with Google.
  Future<void> loginWithGoogle() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final userData = await authService.loginWithGoogle();
      final enhancedUserData = await enhanceUserService?.enhanceUser(userData) ?? userData;
      final enhancedUser = converter.fromJson(enhancedUserData);
      emit(state.copyWith(user: enhancedUser, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Log in with Apple.
  Future<void> loginWithApple() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final userData = await authService.loginWithApple();
      final enhancedUserData = await enhanceUserService?.enhanceUser(userData) ?? userData;
      final enhancedUser = converter.fromJson(enhancedUserData);
      emit(state.copyWith(user: enhancedUser, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Log in with anonymous.
  Future<void> loginWithAnonymous() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final userData = await authService.loginWithAnonymous();
      final enhancedUserData = await enhanceUserService?.enhanceUser(userData) ?? userData;
      final enhancedUser = converter.fromJson(enhancedUserData);
      emit(state.copyWith(user: enhancedUser, isLoading: false));
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
      final userData = await authService.refreshUser();
      final enhancedUserData = await enhanceUserService?.enhanceUser(userData) ?? userData;
      final enhancedUser = converter.fromJson(enhancedUserData);
      emit(state.copyWith(user: enhancedUser, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      // Don't rethrow - refresh failures shouldn't break the app
    }
  }

  /// Update the state with a user (useful for restoring from storage).
  void setUser(Map<String, dynamic> user) {
    authService.setUser(user);
    emit(state.copyWith(user: converter.fromJson(user)));
  }

  /// Clear the current user without calling logout API.
  void clearUser() {
    authService.clearUser();
    emit(state.copyWith(user: null));
  }
}
