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
///   enhanceUserServices: [
///     AnyhooFirebaseEnhanceUserService(
///       path: 'users',
///       firestore: firebaseInitializer.getFirestore(),
///     ),
///   ],
///   converter: converter,
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
  final List<AnyhooEnhanceUserService<T>> enhanceUserServices;
  StreamSubscription<Map<String, dynamic>?>? _authStateSubscription;

  AnyhooAuthCubit({required this.authService, required this.converter, this.enhanceUserServices = const []})
      : super(AnyhooAuthState<T>(user: null)) {
    init();
  }

  void init() {
    _authStateSubscription = authService.authStateChanges.listen(
      (Map<String, dynamic>? user) async {
        _log.info('Auth state changed (user): $user');
        if (user == null) {
          emit(state.copyWith(clearUser: true, isLoading: false));
        } else {
          var enhancedUserData = {...user};
          for (final enhanceUserService in enhanceUserServices) {
            enhancedUserData = await enhanceUserService.enhanceUser(enhancedUserData);
            _log.info('Enhanced user data: $enhancedUserData');
          }
          final enhancedUser = converter.fromJson(enhancedUserData);
          emit(state.copyWith(user: enhancedUser, isLoading: false));
        }
      },
      onError: (error) {
        _log.severe('Error in auth state stream', error);
        emit(state.copyWith(errorMessage: error.toString(), isLoading: false));
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
      // Don't manually emit user: null here - let the authStateChanges stream handle it
      // The stream listener will emit the updated state with user: null and isLoading: false
    } catch (e) {
      _log.severe('Error logging out', e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      rethrow;
    }
  }

  Future<void> saveUser(T user) async {
    _log.info('Saving user');
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      var enhancedUserData = copyAnyhooUser(user);
      for (final enhanceUserService in enhanceUserServices) {
        enhancedUserData = await enhanceUserService.saveUser(enhancedUserData);
      }
      emit(state.copyWith(isLoading: false, clearError: true, user: enhancedUserData));
    } catch (e) {
      _log.severe('Error saving user', e);
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      rethrow;
    }
  }

  Future<void> refreshUser(T user) async {
    emit(state.copyWith(user: null, isLoading: true));

    var enhancedUserData = {...user.toJson()};
    for (final enhanceUserService in enhanceUserServices) {
      enhancedUserData = await enhanceUserService.enhanceUser(enhancedUserData);
    }

    final updatedUser = converter.fromJson(enhancedUserData);
    emit(state.copyWith(user: updatedUser, isLoading: false));
  }

  T copyAnyhooUser(T user) {
    return converter.fromJson(user.toJson());
  }
}
