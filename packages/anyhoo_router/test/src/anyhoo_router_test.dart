import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_auth/cubit/anyhoo_auth_state.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

enum AnyhooTestRouteName { home, login, users, profiles, accounts, usersDetails, accountsDetails, profilesDetails }

void main() {
  group('AnyhooRouter', () {
    late AnyhooRouter<AnyhooTestRouteName> router;
    late GoRouter goRouter;

    setUp(() {
      final routes = [
        GoRoute(
          path: '/',
          builder: (context, state) => Text('Home'),
          routes: [
            GoRoute(path: 'users', builder: (context, state) => Text('Users')),
            GoRoute(
              path: 'login',
              builder: (context, state) => Text('Login'),
              redirect: (context, state) {
                final user = context.read<AnyhooAuthCubit<TestUser>>().state.user;
                if (user != null) {
                  return '/';
                }
                return null;
              },
            ),
            GoRoute(
              path: 'profiles',
              builder: (context, state) => Text('Profiles'),
              redirect: (context, state) => '/users',
            ),
            GoRoute(
              path: 'accounts',
              builder: (context, state) => Text('Accounts'),
              redirect: (context, state) => '/profiles',
            ),
            GoRoute(path: 'people/:id', builder: (context, state) => Text('People')),
            GoRoute(
              path: 'persons/:id',
              builder: (context, state) => Text('Persons'),
              redirect: (context, state) => '/people/${state.pathParameters['id']}',
            ),
            GoRoute(
              path: 'protected',
              builder: (context, state) => Text('Protected'),
              redirect: (context, state) {
                final user = context.read<AnyhooAuthCubit<TestUser>>().state.user;
                if (user == null) {
                  return '/login';
                }
                return null;
              },
            ),
          ],
        ),
      ];
      router = AnyhooRouter<AnyhooTestRouteName>(routes: routes);
      goRouter = router.getGoRouter();
    });

    testWidgets('should go to route if no redirect is needed', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

      // Navigate to /accounts which should redirect to /profiles, then to /users
      goRouter.go('/users');
      await tester.pumpAndSettle();

      // Verify we ended up at /users (the final destination after recursive redirects)
      expect(goRouter.routeInformationProvider.value.uri.path, '/users');

      expect(find.text('Users'), findsOneWidget);
    });

    testWidgets('should redirect: /profiles -> /users', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

      // Navigate to /accounts which should redirect to /profiles, then to /users
      goRouter.go('/profiles');
      await tester.pumpAndSettle();

      // Verify we ended up at /users (the final destination after recursive redirects)
      expect(goRouter.routeInformationProvider.value.uri.path, '/users');
      expect(find.text('Users'), findsOneWidget);
    });

    testWidgets('should redirect recursively: /accounts -> /profiles -> /users', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

      // Navigate to /accounts which should redirect to /profiles, then to /users
      goRouter.go('/accounts');
      await tester.pumpAndSettle();

      // Verify we ended up at /users (the final destination after recursive redirects)
      expect(goRouter.routeInformationProvider.value.uri.path, '/users');
      expect(find.text('Users'), findsOneWidget);
    });

    testWidgets('should redirect recursively with path parameters', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

      goRouter.go('/persons/123');
      await tester.pumpAndSettle();

      expect(goRouter.routeInformationProvider.value.uri.path, '/people/123');
    });

    testWidgets('should redirect to login when not authenticated and route requires login', (
      WidgetTester tester,
    ) async {
      final authCubit = MockAuthCubit();
      final authState = AnyhooAuthState<TestUser>(user: null);

      when(() => authCubit.state).thenReturn(authState);
      when(() => authCubit.stream).thenAnswer((_) => Stream.value(authState));

      await tester.pumpWidget(
        BlocProvider<AnyhooAuthCubit<TestUser>>.value(
          value: authCubit,
          child: MaterialApp.router(routerConfig: goRouter),
        ),
      );

      goRouter.go('/protected');
      await tester.pumpAndSettle();

      // Verify we ended up at /users (the final destination after recursive redirects)
      expect(goRouter.routeInformationProvider.value.uri.path, '/login');
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should NOT redirect to login when authenticated and route requires login', (
      WidgetTester tester,
    ) async {
      final authCubit = MockAuthCubit();
      final authState = AnyhooAuthState<TestUser>(
        user: TestUser(id: '123', email: 'test@test.com'),
      );

      when(() => authCubit.state).thenReturn(authState);
      when(() => authCubit.stream).thenAnswer((_) => Stream.value(authState));

      await tester.pumpWidget(
        BlocProvider<AnyhooAuthCubit<TestUser>>.value(
          value: authCubit,
          child: MaterialApp.router(routerConfig: goRouter),
        ),
      );

      // Navigate to /users/123 which requires login
      goRouter.go('/protected');
      await tester.pumpAndSettle();

      // Verify we were redirected to /login
      expect(goRouter.routeInformationProvider.value.uri.path, '/protected');
      expect(find.text('Protected'), findsOneWidget);
    });

    testWidgets('should redirect to home when authenticated and on login page', (WidgetTester tester) async {
      final user = TestUser(id: '123', email: 'test@test.com');
      final authCubit = MockAuthCubit();
      final authState = AnyhooAuthState<TestUser>(user: user);

      when(() => authCubit.state).thenReturn(authState);
      when(() => authCubit.stream).thenAnswer((_) => Stream.value(authState));

      await tester.pumpWidget(
        BlocProvider<AnyhooAuthCubit<TestUser>>.value(
          value: authCubit,
          child: MaterialApp.router(routerConfig: goRouter),
        ),
      );

      // Navigate to /login while authenticated
      goRouter.go('/login');
      await tester.pumpAndSettle();

      // Verify we were redirected to / (home)
      expect(goRouter.routeInformationProvider.value.uri.path, '/');
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should NOT redirect to home when NOT authenticated and on login page', (WidgetTester tester) async {
      final authCubit = MockAuthCubit();
      final authState = AnyhooAuthState<TestUser>(user: null);

      when(() => authCubit.state).thenReturn(authState);
      when(() => authCubit.stream).thenAnswer((_) => Stream.value(authState));

      await tester.pumpWidget(
        BlocProvider<AnyhooAuthCubit<TestUser>>.value(
          value: authCubit,
          child: MaterialApp.router(routerConfig: goRouter),
        ),
      );

      // Navigate to /login while authenticated
      goRouter.go('/login');
      await tester.pumpAndSettle();

      // Verify we were redirected to / (home)
      expect(goRouter.routeInformationProvider.value.uri.path, '/login');
      expect(find.text('Login'), findsOneWidget);
    });
  });
}

class MockAuthCubit extends Mock implements AnyhooAuthCubit<TestUser> {}

class TestUser extends AnyhooUser {
  @override
  final String id;
  @override
  final String email;

  TestUser({required this.id, required this.email});

  @override
  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}
