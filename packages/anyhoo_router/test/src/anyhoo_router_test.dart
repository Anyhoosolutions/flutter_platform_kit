import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_auth/cubit/anyhoo_auth_state.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';

enum AnyhooTestRouteName { home, login, users, profiles, accounts, usersDetails, accountsDetails, profilesDetails }

void main() {
  group('AnyhooRouter', () {
    late AnyhooRouter<AnyhooTestRouteName> router;
    late GoRouter goRouter;

    setUp(() {
      Logger.root.onRecord.listen((record) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      });

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
            GoRoute(path: 'posts/:postId/comments/:commentId', builder: (context, state) => Text('PostComment')),
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

    group('Redirect if route doesn\'t exist', () {
      testWidgets('should redirect if route doesn\'t exist', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        // Navigate to /accounts which should redirect to /profiles, then to /users
        goRouter.go('/nonexistent');
        await tester.pumpAndSettle();

        // Verify we ended up at /users (the final destination after recursive redirects)
        expect(goRouter.routeInformationProvider.value.uri.path, '/');

        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should NOT redirect for valid parameterized route with single param', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/people/123');
        await tester.pumpAndSettle();

        // Should not redirect, route exists
        expect(goRouter.routeInformationProvider.value.uri.path, '/people/123');
        expect(find.text('People'), findsOneWidget);
      });

      testWidgets('should NOT redirect for valid parameterized route with alphanumeric param', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/people/abc123');
        await tester.pumpAndSettle();

        // Should not redirect, route exists
        expect(goRouter.routeInformationProvider.value.uri.path, '/people/abc123');
        expect(find.text('People'), findsOneWidget);
      });

      testWidgets('should NOT redirect for valid parameterized route with UUID param', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/people/550e8400-e29b-41d4-a716-446655440000');
        await tester.pumpAndSettle();

        // Should not redirect, route exists
        expect(goRouter.routeInformationProvider.value.uri.path, '/people/550e8400-e29b-41d4-a716-446655440000');
        expect(find.text('People'), findsOneWidget);
      });

      testWidgets('should NOT redirect for valid parameterized route with multiple params', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/posts/123/comments/456');
        await tester.pumpAndSettle();

        // Should not redirect, route exists
        expect(goRouter.routeInformationProvider.value.uri.path, '/posts/123/comments/456');
        expect(find.text('PostComment'), findsOneWidget);
      });

      testWidgets('should redirect if parameterized route has wrong number of segments', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/people/123/extra');
        await tester.pumpAndSettle();

        // Should redirect to / because route doesn't exist
        expect(goRouter.routeInformationProvider.value.uri.path, '/');
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should redirect if parameterized route has too few segments', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/people');
        await tester.pumpAndSettle();

        // Should redirect to / because route doesn't exist (people requires :id)
        expect(goRouter.routeInformationProvider.value.uri.path, '/');
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should redirect if multi-param route has wrong number of segments', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/posts/123');
        await tester.pumpAndSettle();

        // Should redirect to / because route doesn't exist (posts requires postId and commentId)
        expect(goRouter.routeInformationProvider.value.uri.path, '/');
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should redirect if multi-param route has too many segments', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/posts/123/comments/456/extra');
        await tester.pumpAndSettle();

        // Should redirect to / because route doesn't exist
        expect(goRouter.routeInformationProvider.value.uri.path, '/');
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should redirect if path has wrong segment name before param', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/wrong/123');
        await tester.pumpAndSettle();

        // Should redirect to / because route doesn't exist
        expect(goRouter.routeInformationProvider.value.uri.path, '/');
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should redirect if path has wrong segment name in middle of multi-param route', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/posts/123/wrong/456');
        await tester.pumpAndSettle();

        // Should redirect to / because route doesn't exist
        expect(goRouter.routeInformationProvider.value.uri.path, '/');
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should NOT redirect for root path', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/');
        await tester.pumpAndSettle();

        // Should not redirect, root path exists
        expect(goRouter.routeInformationProvider.value.uri.path, '/');
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should NOT redirect for exact match routes', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/users');
        await tester.pumpAndSettle();

        // Should not redirect, exact match exists
        expect(goRouter.routeInformationProvider.value.uri.path, '/users');
        expect(find.text('Users'), findsOneWidget);
      });

      testWidgets('should redirect for completely non-existent path', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        goRouter.go('/completely/nonexistent/path');
        await tester.pumpAndSettle();

        // Should redirect to / because route doesn't exist
        expect(goRouter.routeInformationProvider.value.uri.path, '/');
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should handle case-insensitive matching', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        // Note: GoRouter route matching is case-sensitive, but our redirector checks are case-insensitive
        // So /USERS should not redirect (route exists), but GoRouter won't match it
        // This test verifies that our redirector doesn't redirect for case variations
        goRouter.go('/USERS');
        await tester.pumpAndSettle();

        // The redirector should not redirect (route exists case-insensitively)
        // But GoRouter itself is case-sensitive, so it won't render the widget
        // We verify the redirector didn't redirect by checking we're not at /
        final path = goRouter.routeInformationProvider.value.uri.path.toLowerCase();
        // The path should be preserved (not redirected to /)
        expect(path, isNot('/'));
      });

      testWidgets('should handle case-insensitive matching for parameterized routes', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

        // Note: GoRouter route matching is case-sensitive, but our redirector checks are case-insensitive
        // So /PEOPLE/123 should not redirect (route exists), but GoRouter won't match it
        // This test verifies that our redirector doesn't redirect for case variations
        goRouter.go('/PEOPLE/123');
        await tester.pumpAndSettle();

        // The redirector should not redirect (route exists case-insensitively)
        // But GoRouter itself is case-sensitive, so it won't render the widget
        // We verify the redirector didn't redirect by checking we're not at /
        final path = goRouter.routeInformationProvider.value.uri.path.toLowerCase();
        // The path should be preserved (not redirected to /)
        expect(path, isNot('/'));
      });
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
