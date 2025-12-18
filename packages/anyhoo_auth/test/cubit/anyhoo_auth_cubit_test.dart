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

class MockAnyhooUserConverter extends Mock implements AnyhooUserConverter<AnyhooUser> {}

class MockAnyhooEnhanceUserService extends Mock implements AnyhooEnhanceUserService {}

class MockAnyhooUser extends Mock implements AnyhooUser {}

void main() {
  group('AnyhooAuthCubit', () {
    late MockAnyhooAuthService mockAuthService;
    late MockAnyhooUserConverter mockConverter;
    late MockAnyhooEnhanceUserService mockEnhanceUserService;
    late AnyhooAuthCubit<AnyhooUser> cubit;

    setUp(() {
      mockAuthService = MockAnyhooAuthService();
      mockConverter = MockAnyhooUserConverter();
      mockEnhanceUserService = MockAnyhooEnhanceUserService();

      when(() => mockAuthService.authStateChanges).thenAnswer((_) => const Stream.empty());
      when(() => mockAuthService.currentUser).thenReturn(null);

      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        // ignore: avoid_print
        print('${record.level.name}: ${record.time}: ${record.message}');
      });
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct when no user is logged in', () {
      cubit = AnyhooAuthCubit(
        authService: mockAuthService,
        converter: mockConverter,
      );
      expect(cubit.state.user, isNull);
      expect(cubit.state.isLoading, false);
      expect(cubit.state.errorMessage, isNull);
    });

    test('initial state is correct when user is logged in', () {
      final mockUserMap = {'uid': '123', 'email': 'test@example.com'};
      final mockUser = MockAnyhooUser();
      when(() => mockAuthService.currentUser).thenReturn(mockUserMap);
      when(() => mockConverter.fromJson(mockUserMap)).thenReturn(mockUser);

      cubit = AnyhooAuthCubit(
        authService: mockAuthService,
        converter: mockConverter,
      );
      expect(cubit.state.user, equals(mockUser));
    });

    group('Auth State Changes', () {
      test('emits state with new user when auth state changes to signed in', () async {
        final mockUserMap = {'uid': '123'};
        final mockEnhancedMap = {'uid': '123', 'enhanced': true};
        final mockUser = MockAnyhooUser();
        when(() => mockUser.getId()).thenReturn('123');

        // Mock stream controller to emit events
        final controller = StreamController<Map<String, dynamic>?>();
        when(() => mockAuthService.authStateChanges).thenAnswer((_) => controller.stream);

        // Mock enhancements
        when(() => mockEnhanceUserService.enhanceUser(mockUserMap)).thenAnswer((_) async => mockEnhancedMap);
        when(() => mockConverter.fromJson(mockEnhancedMap)).thenReturn(mockUser);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: mockConverter,
          enhanceUserServices: [mockEnhanceUserService],
        );

        // Wait for init to listen
        await Future.delayed(Duration.zero);

        controller.add(mockUserMap);

        await expectLater(
          cubit.stream,
          emits(isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.user, 'user', mockUser)
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
          converter: mockConverter,
        );

        // Wait for init
        await Future.delayed(Duration.zero);

        controller.add(null);

        await expectLater(
          cubit.stream,
          emits(isA<AnyhooAuthState<AnyhooUser>>()
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
          converter: mockConverter,
        );

        await Future.delayed(Duration.zero);

        controller.addError(Exception('Stream error'));

        await expectLater(
          cubit.stream,
          emits(isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Stream error'))),
        );

        await controller.close();
      });

      test('calls multiple enhance user services in sequence', () async {
        final mockUserMap = {'uid': '123'};
        // Note: Each enhance service receives the original user map, not chained
        final mockEnhancedMap1 = {'uid': '123', 'enhanced1': true};
        final mockEnhancedMap2 = {'uid': '123', 'enhanced1': true, 'enhanced2': true};
        final mockUser = MockAnyhooUser();
        when(() => mockUser.getId()).thenReturn('123');

        final mockEnhanceUserService2 = MockAnyhooEnhanceUserService();

        final controller = StreamController<Map<String, dynamic>?>();
        when(() => mockAuthService.authStateChanges).thenAnswer((_) => controller.stream);

        when(() => mockEnhanceUserService.enhanceUser(mockUserMap)).thenAnswer((_) async => mockEnhancedMap1);
        when(() => mockEnhanceUserService2.enhanceUser(mockEnhancedMap1)).thenAnswer((_) async => mockEnhancedMap2);
        // The last enhanced map is used for conversion
        when(() => mockConverter.fromJson(mockEnhancedMap2)).thenReturn(mockUser);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: mockConverter,
          enhanceUserServices: [mockEnhanceUserService, mockEnhanceUserService2],
        );

        await Future.delayed(Duration.zero);

        controller.add(mockUserMap);

        await expectLater(
          cubit.stream,
          emits(isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.user, 'user', mockUser)
              .having((s) => s.isLoading, 'isLoading', false)),
        );

        verify(() => mockEnhanceUserService.enhanceUser(mockUserMap)).called(1);
        verify(() => mockEnhanceUserService2.enhanceUser(mockEnhancedMap1)).called(1);

        await controller.close();
      });
    });

    group('Login Methods', () {
      setUp(() {
        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: mockConverter,
        );
      });

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'login emits loading then completes on success',
        build: () {
          when(() => mockAuthService.loginWithEmailAndPassword(any(), any())).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.login('test@email.com', 'password'),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'login emits loading then error on failure',
        build: () {
          when(() => mockAuthService.loginWithEmailAndPassword(any(), any())).thenThrow(Exception('Login failed'));
          return cubit;
        },
        act: (cubit) => cubit.login('test@email.com', 'password'),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Login failed')),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'loginWithGoogle emits loading then completes on success',
        build: () {
          when(() => mockAuthService.loginWithGoogle()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.loginWithGoogle(),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'loginWithGoogle emits error on failure',
        build: () {
          when(() => mockAuthService.loginWithGoogle()).thenThrow(Exception('Google login failed'));
          return cubit;
        },
        act: (cubit) => cubit.loginWithGoogle(),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Google login failed')),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'loginWithApple emits loading then completes on success',
        build: () {
          when(() => mockAuthService.loginWithApple()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.loginWithApple(),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'loginWithApple emits error on failure',
        build: () {
          when(() => mockAuthService.loginWithApple()).thenThrow(Exception('Apple login failed'));
          return cubit;
        },
        act: (cubit) => cubit.loginWithApple(),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Apple login failed')),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'loginWithAnonymous emits loading then completes on success',
        build: () {
          when(() => mockAuthService.loginWithAnonymous()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.loginWithAnonymous(),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'loginWithAnonymous emits error on failure',
        build: () {
          when(() => mockAuthService.loginWithAnonymous()).thenThrow(Exception('Anonymous login failed'));
          return cubit;
        },
        act: (cubit) => cubit.loginWithAnonymous(),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<AnyhooAuthState<AnyhooUser>>()
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
          converter: mockConverter,
        );
      });

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'logout emits loading then completes',
        build: () {
          when(() => mockAuthService.logout()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>().having((s) => s.isLoading, 'isLoading', true),
        ],
      );

      blocTest<AnyhooAuthCubit<AnyhooUser>, AnyhooAuthState<AnyhooUser>>(
        'logout emits error on failure',
        build: () {
          when(() => mockAuthService.logout()).thenThrow(Exception('Logout failed'));
          return cubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [
          isA<AnyhooAuthState<AnyhooUser>>().having((s) => s.isLoading, 'isLoading', true),
          isA<AnyhooAuthState<AnyhooUser>>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', contains('Logout failed')),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('User Management', () {
      test('saveUser calls enhance services and updates state', () async {
        final mockUserMap = {'uid': '123', 'name': 'Test'};
        final mockSavedMap = {'uid': '123', 'name': 'Test', 'saved': true};
        final mockUser = MockAnyhooUser();

        when(() => mockEnhanceUserService.saveUser(mockUserMap)).thenAnswer((_) async => mockSavedMap);
        when(() => mockConverter.fromJson(mockSavedMap)).thenReturn(mockUser);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: mockConverter,
          enhanceUserServices: [mockEnhanceUserService],
        );

        // Clear initial state emission
        await Future.delayed(Duration.zero);

        await cubit.saveUser(mockUserMap);

        verify(() => mockEnhanceUserService.saveUser(mockUserMap)).called(1);
        expect(cubit.state.user, equals(mockUser));
        expect(cubit.state.isLoading, false);
        expect(cubit.state.errorMessage, isNull);
      });

      test('saveUser calls multiple enhance services in sequence', () async {
        final mockUserMap = {'uid': '123', 'name': 'Test'};
        final mockSavedMap1 = {'uid': '123', 'name': 'Test', 'saved1': true};
        final mockSavedMap2 = {'uid': '123', 'name': 'Test', 'saved1': true, 'saved2': true};
        final mockUser = MockAnyhooUser();
        final mockEnhanceUserService2 = MockAnyhooEnhanceUserService();

        when(() => mockEnhanceUserService.saveUser(mockUserMap)).thenAnswer((_) async => mockSavedMap1);
        when(() => mockEnhanceUserService2.saveUser(mockSavedMap1)).thenAnswer((_) async => mockSavedMap2);
        when(() => mockConverter.fromJson(mockSavedMap2)).thenReturn(mockUser);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: mockConverter,
          enhanceUserServices: [mockEnhanceUserService, mockEnhanceUserService2],
        );

        await Future.delayed(Duration.zero);

        await cubit.saveUser(mockUserMap);

        verify(() => mockEnhanceUserService.saveUser(mockUserMap)).called(1);
        verify(() => mockEnhanceUserService2.saveUser(mockSavedMap1)).called(1);
        expect(cubit.state.user, equals(mockUser));
        expect(cubit.state.isLoading, false);
      });

      test('saveUser emits error on failure', () async {
        final mockUserMap = {'uid': '123', 'name': 'Test'};

        when(() => mockEnhanceUserService.saveUser(mockUserMap)).thenThrow(Exception('Save failed'));

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: mockConverter,
          enhanceUserServices: [mockEnhanceUserService],
        );

        await Future.delayed(Duration.zero);

        expect(
          () => cubit.saveUser(mockUserMap),
          throwsA(isA<Exception>()),
        );

        expect(cubit.state.isLoading, false);
        expect(cubit.state.errorMessage, contains('Save failed'));
      });

      test('refreshUser calls enhance services and updates state', () async {
        final mockUserMap = {'uid': '123'};
        final mockEnhancedMap = {'uid': '123', 'refreshed': true};
        final mockUser = MockAnyhooUser();
        when(() => mockUser.getId()).thenReturn('123');

        when(() => mockEnhanceUserService.enhanceUser(mockUserMap)).thenAnswer((_) async => mockEnhancedMap);
        when(() => mockConverter.fromJson(mockEnhancedMap)).thenReturn(mockUser);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: mockConverter,
          enhanceUserServices: [mockEnhanceUserService],
        );

        await cubit.refreshUser(mockUserMap);

        verify(() => mockEnhanceUserService.enhanceUser(mockUserMap)).called(1);
        expect(cubit.state.user, equals(mockUser));
        expect(cubit.state.isLoading, false);
      });

      test('refreshUser calls multiple enhance services in sequence', () async {
        final mockUserMap = {'uid': '123'};
        final mockEnhancedMap1 = {'uid': '123', 'refreshed1': true};
        final mockEnhancedMap2 = {'uid': '123', 'refreshed1': true, 'refreshed2': true};
        final mockUser = MockAnyhooUser();
        when(() => mockUser.getId()).thenReturn('123');
        final mockEnhanceUserService2 = MockAnyhooEnhanceUserService();

        when(() => mockEnhanceUserService.enhanceUser(mockUserMap)).thenAnswer((_) async => mockEnhancedMap1);
        when(() => mockEnhanceUserService2.enhanceUser(mockEnhancedMap1)).thenAnswer((_) async => mockEnhancedMap2);
        when(() => mockConverter.fromJson(mockEnhancedMap2)).thenReturn(mockUser);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: mockConverter,
          enhanceUserServices: [mockEnhanceUserService, mockEnhanceUserService2],
        );

        await cubit.refreshUser(mockUserMap);

        verify(() => mockEnhanceUserService.enhanceUser(mockUserMap)).called(1);
        verify(() => mockEnhanceUserService2.enhanceUser(mockEnhancedMap1)).called(1);
        expect(cubit.state.user, equals(mockUser));
        expect(cubit.state.isLoading, false);
      });

      test('refreshUser sets user to null initially then updates', () async {
        final mockUserMap = {'uid': '123'};
        final mockEnhancedMap = {'uid': '123', 'refreshed': true};
        final mockUser = MockAnyhooUser();
        when(() => mockUser.getId()).thenReturn('123');

        when(() => mockEnhanceUserService.enhanceUser(mockUserMap)).thenAnswer((_) async => mockEnhancedMap);
        when(() => mockConverter.fromJson(mockEnhancedMap)).thenReturn(mockUser);

        cubit = AnyhooAuthCubit(
          authService: mockAuthService,
          converter: mockConverter,
          enhanceUserServices: [mockEnhanceUserService],
        );

        await Future.delayed(Duration.zero);

        // Capture states during refresh
        final states = <AnyhooAuthState<AnyhooUser>>[];
        final subscription = cubit.stream.listen((state) {
          states.add(state);
        });

        await cubit.refreshUser(mockUserMap);
        await Future.delayed(Duration.zero);

        // Should have initial null user state, then updated user state
        expect(states.any((s) => s.user == null && s.isLoading == true), isTrue);
        expect(cubit.state.user, equals(mockUser));
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
          converter: mockConverter,
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
