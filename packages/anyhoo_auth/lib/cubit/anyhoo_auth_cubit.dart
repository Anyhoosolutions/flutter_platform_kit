import 'dart:async';

import 'package:anyhoo_auth/services/anyhoo_enhance_user_service.dart';
import 'package:anyhoo_auth/models/anyhoo_user_converter.dart';
import 'package:anyhoo_core/anyhoo_core.dart';
import 'package:anyhoo_auth/services/anyhoo_auth_service.dart';
import 'package:anyhoo_auth/cubit/anyhoo_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

/// Cubit for managing authentication state.
///
/// Provides a reactive interface to the [AnyhooAuthService] using BLoC pattern.
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
///
final _log = Logger('AnyhooAuthCubit');

class AnyhooAuthCubit<T extends AnyhooUser> extends Cubit<AnyhooAuthState<T>> {
  final AnyhooAuthService authService;
  final AnyhooUserConverter<T> converter;
  final AnyhooEnhanceUserService? enhanceUserService;
  StreamSubscription<Map<String, dynamic>?>? _authStateSubscription;

  AnyhooAuthCubit({required this.authService, required this.converter, this.enhanceUserService})
      : super(AnyhooAuthState<T>(
            user: authService.currentUser == null ? null : converter.fromJson(authService.currentUser!))) {
    init();
  }

  void init() {
    _authStateSubscription = authService.authStateChanges.listen(
      (user) {
        final convertedUser = user == null ? null : converter.fromJson(user);
        _log.info('Auth state changed (user): ${convertedUser?.id ?? 'null'}');

        //   final enhancedUserData = await enhanceUserService?.enhanceUser(userData) ?? userData;
        // final enhancedUser = converter.fromJson(enhancedUserData);
        // emit(state.copyWith(user: enhancedUser, isLoading: false));

        emit(state.copyWith(user: convertedUser));
      },
      onError: (error) {
        _log.severe('Error in auth state stream', error);
        emit(state.copyWith(errorMessage: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  /// Log in with email and password.
  Future<void> login(String email, String password) async {
    _log.info('Logging in with email and password');

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await authService.loginWithEmailAndPassword(email, password);
    } catch (e) {
      _log.severe('Error logging in with email and password', e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Log in with Google.
  Future<void> loginWithGoogle() async {
    _log.info('Logging in with Google');

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await authService.loginWithGoogle();
    } catch (e) {
      _log.severe('Error logging in with Google', e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Log in with Apple.
  Future<void> loginWithApple() async {
    _log.info('Logging in with Apple');

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await authService.loginWithApple();
    } catch (e) {
      _log.severe('Error logging in with Apple', e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Log in with anonymous.
  Future<void> loginWithAnonymous() async {
    _log.info('Logging in with anonymous');

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await authService.loginWithAnonymous();
    } catch (e) {
      _log.severe('Error logging in with anonymous', e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  /// Log out the current user.
  Future<void> logout() async {
    _log.info('Logging out');
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await authService.logout();
      emit(state.copyWith(user: null, isLoading: false));
    } catch (e) {
      _log.severe('Error logging out', e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }
}
