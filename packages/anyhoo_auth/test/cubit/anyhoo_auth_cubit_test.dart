import 'dart:async';

import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_auth/cubit/anyhoo_auth_state.dart';
import 'package:anyhoo_auth/models/anyhoo_user_converter.dart';
import 'package:anyhoo_auth/services/anyhoo_auth_service.dart';
import 'package:anyhoo_auth/services/anyhoo_enhance_user_service.dart';
import 'package:anyhoo_core/anyhoo_core.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

class MockAnyhooAuthService extends Mock implements AnyhooAuthService {}

class SimpleAnyhooEnhanceUserService extends AnyhooEnhanceUserService<TestUser> {
  SimpleAnyhooEnhanceUserService({
    Future<Map<String, dynamic>> Function(Map<String, dynamic>)? enhanceUserCallback,
    Future<TestUser> Function(TestUser)? saveUserCallback,
  })  : _enhanceUserCallback = enhanceUserCallback,
        _saveUserCallback = saveUserCallback;

  final Future<Map<String, dynamic>> Function(Map<String, dynamic>)? _enhanceUserCallback;
  final Future<TestUser> Function(TestUser)? _saveUserCallback;

  @override
  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user) async {
    if (_enhanceUserCallback != null) {
      return _enhanceUserCallback!(user);
    }
    return user;
  }

  @override
  Future<TestUser> saveUser(TestUser user) async {
    if (_saveUserCallback != null) {
      return _saveUserCallback!(user);
    }
    return user;
  }
}

class TestUserConverter implements AnyhooUserConverter<TestUser> {
  @override
  TestUser fromJson(Map<String, dynamic> json) {
    return TestUser(id: json['id'], email: json['email'], extra: json['extra']);
  }

  @override
  Map<String, dynamic> toJson(TestUser user) => user.toJson();
}

class TestUser implements AnyhooUser {
  final String id;
  final String email;
  final String? extra;

  TestUser({required this.id, required this.email, this.extra});

  @override
  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'extra': extra};
}

void main() {
  setUpAll(() {
    registerFallbackValue(TestUser(id: 'fallback', email: 'fallback@example.com'));
  });

  group('AnyhooAuthCubit', () {
    late MockAnyhooAuthService mockAuthService;
    late TestUserConverter testConverter;
    late SimpleAnyhooEnhanceUserService enhanceUserService;
    late AnyhooAuthCubit<TestUser> cubit;

    setUp(() {
      mockAuthService = MockAnyhooAuthService();
      testConverter = TestUserConverter();
      enhanceUserService = SimpleAnyhooEnhanceUserService();

      when(() => mockAuthService.authStateChanges).thenAnswer((_) => const Stream.empty());
      when(() => mockAuthService.currentUser).thenReturn(null);

      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        // ignore: avoid_print
        // print('${record.level.name}: ${record.time}: ${record.message}');
      });
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct when no user is logged in', () {
      cubit = AnyhooAuthCubit(
        authService: mockAuthService,
        converter: testConverter,
      );
      expect(cubit.state.user, isNull);
      expect(cubit.state.isLoading, false);
      expect(cubit.state.errorMessage, isNull);
    });

    test('initial state is correct when user is logged in', () {
      final testUser = TestUser(id: '123', email: 'test@example.com');
      when(() => mockAuthService.currentUser).thenReturn(testUser.toJson());

      cubit = AnyhooAuthCubit(
        authService: mockAuthService,
        converter: testConverter,
      );
      expect(cubit.state.isLoading, equals(false));
      expect(cubit.state.user?.email, equals("test@example.com"));
    });

    group('Auth State Changes', () {
      test('emits state with new user when auth state changes to signed in', () async {
        final testUser = TestUser(id: '123', email: 'test@example.com');
        final enhancedTestUser = TestUser(id: testUser.id, email: testUser.email, extra: 'here is more');

        // Mock stream controller to emit events
        final controller = StreamController<Map<String, dynamic>?>();
        when(() => mockAuthService.authStateChanges).thenAnswer((_) => controller.stream);

        // Configure enhancements
        enhanceUserService = SimpleAnyhooEnhanceUserService(
          enhanceUserCallback: (_) async => enhancedTestUser.toJson(),
        );

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
          enhanceUserServices: [enhanceUserService],
        );

        // Wait for init to listen
        await Future.delayed(Duration.zero);

        controller.add(testUser.toJson());

        await expectLater(
          cubit.stream,
          emits(isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.user?.toJson(), 'user', enhancedTestUser.toJson())
              .having((s) => s.isLoading, 'isLoading', false)),
        );

        await controller.close();
      });

      test('emits state with null user when auth state changes to signed out', () async {
        // Mock stream controller
        final controller = StreamController<Map<String, dynamic>?>();
        when(() => mockAuthService.authStateChanges).thenAnswer((_) => controller.stream);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
        );

        // Wait for init
        await Future.delayed(Duration.zero);

        controller.add(null);

        await expectLater(
          cubit.stream,
          emits(isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.user, 'user', isNull)
              .having((s) => s.isLoading, 'isLoading', false)),
        );

        await controller.close();
      });

      test('emits error state when auth state stream has error', () async {
        final controller = StreamController<Map<String, dynamic>?>();
        when(() => mockAuthService.authStateChanges).thenAnswer((_) => controller.stream);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
        );

        await Future.delayed(Duration.zero);

        controller.addError(Exception('Stream error'));

        await expectLater(
          cubit.stream,
          emits(isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Stream error'))),
        );

        await controller.close();
      });

      test('calls multiple enhance user services in sequence', () async {
        final testUser = TestUser(id: '123', email: 'test@example.com');
        final enhancedUser1 = TestUser(id: testUser.id, email: testUser.email, extra: 'enhanced1');
        final enhancedUser2 = TestUser(id: enhancedUser1.id, email: enhancedUser1.email, extra: 'enhanced2');

        final enhanceUserService2 = SimpleAnyhooEnhanceUserService(
          enhanceUserCallback: (_) async => enhancedUser2.toJson(),
        );

        final controller = StreamController<Map<String, dynamic>?>();
        when(() => mockAuthService.authStateChanges).thenAnswer((_) => controller.stream);

        enhanceUserService = SimpleAnyhooEnhanceUserService(
          enhanceUserCallback: (_) async => enhancedUser1.toJson(),
        );

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
          enhanceUserServices: [enhanceUserService, enhanceUserService2],
        );

        await Future.delayed(Duration.zero);

        controller.add(testUser.toJson());

        await expectLater(
          cubit.stream,
          emits(isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.user?.toJson(), 'user', enhancedUser2.toJson())
              .having((s) => s.isLoading, 'isLoading', false)),
        );

        await controller.close();
      });
    });

    group('Login Methods', () {
      setUp(() {
        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
        );
      });

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'login emits loading then completes on success',
        build: () {
          when(() => mockAuthService.loginWithEmailAndPassword(any(), any())).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.login('test@email.com', 'password'),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'login emits loading then error on failure',
        build: () {
          when(() => mockAuthService.loginWithEmailAndPassword(any(), any())).thenThrow(Exception('Login failed'));
          return cubit;
        },
        act: (cubit) => cubit.login('test@email.com', 'password'),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Login failed')),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'loginWithGoogle emits loading then completes on success',
        build: () {
          when(() => mockAuthService.loginWithGoogle()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.loginWithGoogle(),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'loginWithGoogle emits error on failure',
        build: () {
          when(() => mockAuthService.loginWithGoogle()).thenThrow(Exception('Google login failed'));
          return cubit;
        },
        act: (cubit) => cubit.loginWithGoogle(),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Google login failed')),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'loginWithApple emits loading then completes on success',
        build: () {
          when(() => mockAuthService.loginWithApple()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.loginWithApple(),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'loginWithApple emits error on failure',
        build: () {
          when(() => mockAuthService.loginWithApple()).thenThrow(Exception('Apple login failed'));
          return cubit;
        },
        act: (cubit) => cubit.loginWithApple(),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Apple login failed')),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'loginWithAnonymous emits loading then completes on success',
        build: () {
          when(() => mockAuthService.loginWithAnonymous()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.loginWithAnonymous(),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'loginWithAnonymous emits error on failure',
        build: () {
          when(() => mockAuthService.loginWithAnonymous()).thenThrow(Exception('Anonymous login failed'));
          return cubit;
        },
        act: (cubit) => cubit.loginWithAnonymous(),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Anonymous login failed')),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('Logout', () {
      setUp(() {
        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
        );
      });

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'logout emits loading then completes',
        build: () {
          when(() => mockAuthService.logout()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>().having((s) => s.isLoading, 'isLoading', true),
        ],
      );

      blocTest<AnyhooAuthCubit<TestUser>, AnyhooAuthState<TestUser>>(
        'logout emits error on failure',
        build: () {
          when(() => mockAuthService.logout()).thenThrow(Exception('Logout failed'));
          return cubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [
          isA<AnyhooAuthState<TestUser>>().having((s) => s.isLoading, 'isLoading', true),
          isA<AnyhooAuthState<TestUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Logout failed')),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('User Management', () {
      test('saveUser calls enhance services and updates state', () async {
        final testUser = TestUser(id: '123', email: 'test@example.com');
        final savedUser = TestUser(id: testUser.id, email: testUser.email, extra: 'saved');

        enhanceUserService = SimpleAnyhooEnhanceUserService(
          saveUserCallback: (_) async => savedUser,
        );

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
          enhanceUserServices: [enhanceUserService],
        );

        // Clear initial state emission
        await Future.delayed(Duration.zero);

        await cubit.saveUser(testUser);
        expect(cubit.state.user, equals(savedUser));
        expect(cubit.state.isLoading, false);
        expect(cubit.state.errorMessage, isNull);
      });

      test('saveUser calls multiple enhance services in sequence', () async {
        final testUser = TestUser(id: '123', email: 'test@example.com');
        final savedUser1 = TestUser(id: testUser.id, email: testUser.email, extra: 'saved1');
        final savedUser2 = TestUser(id: savedUser1.id, email: savedUser1.email, extra: 'saved2');
        final enhanceUserService2 = SimpleAnyhooEnhanceUserService(
          saveUserCallback: (_) async => savedUser2,
        );

        enhanceUserService = SimpleAnyhooEnhanceUserService(
          saveUserCallback: (_) async => savedUser1,
        );

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
          enhanceUserServices: [enhanceUserService, enhanceUserService2],
        );

        await Future.delayed(Duration.zero);

        await cubit.saveUser(testUser);
        expect(cubit.state.user, equals(savedUser2));
        expect(cubit.state.isLoading, false);
      });

      test('saveUser emits error on failure', () async {
        final testUser = TestUser(id: '123', email: 'test@example.com');

        enhanceUserService = SimpleAnyhooEnhanceUserService(
          saveUserCallback: (_) async => throw Exception('Save failed'),
        );

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
          enhanceUserServices: [enhanceUserService],
        );

        await Future.delayed(Duration.zero);

        await expectLater(
          cubit.saveUser(testUser),
          throwsA(isA<Exception>()),
        );

        expect(cubit.state.isLoading, false);
        expect(cubit.state.errorMessage, contains('Save failed'));
      });

      test('refreshUser calls enhance services and updates state', () async {
        final testUser = TestUser(id: '123', email: 'test@example.com');
        final enhancedUser = TestUser(id: testUser.id, email: testUser.email, extra: 'refreshed');

        enhanceUserService = SimpleAnyhooEnhanceUserService(
          enhanceUserCallback: (_) async => enhancedUser.toJson(),
        );

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
          enhanceUserServices: [enhanceUserService],
        );

        await cubit.refreshUser(testUser);
        expect(cubit.state.user?.toJson(), equals(enhancedUser.toJson()));
        expect(cubit.state.isLoading, false);
      });

      test('refreshUser calls multiple enhance services in sequence', () async {
        final testUser = TestUser(id: '123', email: 'test@example.com');
        final enhancedUser1 = TestUser(id: testUser.id, email: testUser.email, extra: 'refreshed1');
        final enhancedUser2 = TestUser(id: enhancedUser1.id, email: enhancedUser1.email, extra: 'refreshed2');
        final enhanceUserService2 = SimpleAnyhooEnhanceUserService(
          enhanceUserCallback: (_) async => enhancedUser2.toJson(),
        );

        enhanceUserService = SimpleAnyhooEnhanceUserService(
          enhanceUserCallback: (_) async => enhancedUser1.toJson(),
        );

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
          enhanceUserServices: [enhanceUserService, enhanceUserService2],
        );

        await cubit.refreshUser(testUser);
        expect(cubit.state.user?.toJson(), equals(enhancedUser2.toJson()));
        expect(cubit.state.isLoading, false);
      });

      test('refreshUser sets user to null initially then updates', () async {
        final testUser = TestUser(id: '123', email: 'test@example.com');
        final enhancedUser = TestUser(id: testUser.id, email: testUser.email, extra: 'refreshed');

        enhanceUserService = SimpleAnyhooEnhanceUserService(
          enhanceUserCallback: (_) async => enhancedUser.toJson(),
        );

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
          enhanceUserServices: [enhanceUserService],
        );

        await Future.delayed(Duration.zero);

        // Capture states during refresh
        final states = <AnyhooAuthState<TestUser>>[];
        final subscription = cubit.stream.listen((state) {
          states.add(state);
        });

        await cubit.refreshUser(testUser);
        await Future.delayed(Duration.zero);

        // Should have initial null user state, then updated user state
        expect(states.any((s) => s.user == null && s.isLoading == true), isTrue);
        expect(cubit.state.user?.toJson(), equals(enhancedUser.toJson()));
        expect(cubit.state.isLoading, false);

        await subscription.cancel();
      });
    });

    group('Subscription Management', () {
      test('cancels subscription on close', () async {
        final controller = StreamController<Map<String, dynamic>?>();
        when(() => mockAuthService.authStateChanges).thenAnswer((_) => controller.stream);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: testConverter,
        );

        await Future.delayed(Duration.zero);

        expect(controller.hasListener, isTrue);

        await cubit.close();

        expect(controller.hasListener, isFalse);
        await controller.close();
      });
    });
  });
}
