import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:flutter/material.dart';
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
            GoRoute(path: 'profiles', builder: (context, state) => Text('Profiles')),
            GoRoute(
              path: 'accounts',
              builder: (context, state) => Text('Accounts'),
              redirect: (context, state) => '/profiles',
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

    // testWidgets('should redirect recursively: /accounts -> /profiles -> /users', (WidgetTester tester) async {
    //   final routes = [
    //     GoRoute(
    //       path: '/',
    //       builder: (context, state) => Text('Home'),
    //       routes: [
    //         GoRoute(path: 'users', builder: (context, state) => Text('Users')),
    //         GoRoute(path: 'profiles', builder: (context, state) => Text('Profiles')),
    //         GoRoute(path: 'accounts', builder: (context, state) => Text('Accounts')),
    //       ],
    //     ),
    //   ];

    //   final router = AnyhooRouter<AnyhooTestRouteName>(routes: routes);
    //   final goRouter = router.getGoRouter();

    //   await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

    //   // Navigate to /accounts which should redirect to /profiles, then to /users
    //   goRouter.go('/accounts');
    //   await tester.pumpAndSettle();

    //   // Verify we ended up at /users (the final destination after recursive redirects)
    //   expect(goRouter.routeInformationProvider.value.uri.path, '/users');
    // });

    // testWidgets('should redirect recursively with path parameters', (WidgetTester tester) async {
    //   final routes = [
    //     DummyRoute(path: '/', title: 'Home', routeName: AnyhooTestRouteName.home, requireLogin: false, redirect: null),
    //     DummyRoute(
    //       path: '/users',
    //       title: 'Users',
    //       routeName: AnyhooTestRouteName.users,
    //       requireLogin: false,
    //       redirect: null,
    //     ),
    //     DummyRoute(
    //       path: '/users/:userId',
    //       title: 'User Details',
    //       routeName: AnyhooTestRouteName.usersDetails,
    //       requireLogin: false,
    //       redirect: null,
    //     ),
    //     DummyRoute(
    //       path: '/profiles',
    //       title: 'Profiles',
    //       routeName: AnyhooTestRouteName.profiles,
    //       requireLogin: false,
    //       redirect: null,
    //     ),
    //     DummyRoute(
    //       path: '/profiles/:userId',
    //       title: 'Profile',
    //       routeName: AnyhooTestRouteName.profilesDetails,
    //       redirect: '/users/:userId',
    //       requireLogin: false,
    //     ),
    //     DummyRoute(
    //       path: '/accounts',
    //       title: 'Accounts',
    //       routeName: AnyhooTestRouteName.accounts,
    //       requireLogin: false,
    //       redirect: null,
    //     ),
    //     DummyRoute(
    //       path: '/accounts/:userId',
    //       title: 'Account',
    //       routeName: AnyhooTestRouteName.accountsDetails,
    //       redirect: '/profiles/:userId',
    //       requireLogin: false,
    //     ),
    //   ];

    //   final router = AnyhooRouter<AnyhooTestRouteName>(routes: routes);
    //   final goRouter = router.getGoRouter();

    //   await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

    //   // Navigate to /accounts/123 which should redirect to /profiles/123, then to /users/123
    //   goRouter.go('/accounts/123');
    //   await tester.pumpAndSettle();

    //   // Verify we ended up at /users/123 (the final destination after recursive redirects)
    //   expect(goRouter.routeInformationProvider.value.uri.path, '/users/123');
    // });

    // testWidgets('should redirect to login when not authenticated and route requires login', (
    //   WidgetTester tester,
    // ) async {
    //   final routes = [
    //     DummyRoute(path: '/', title: 'Home', routeName: AnyhooTestRouteName.home, requireLogin: false, redirect: null),
    //     DummyRoute(
    //       path: '/login',
    //       title: 'Login',
    //       routeName: AnyhooTestRouteName.login,
    //       requireLogin: false,
    //       redirect: null,
    //     ),
    //     DummyRoute(
    //       path: '/users/:userId',
    //       title: 'Users',
    //       routeName: AnyhooTestRouteName.users,
    //       requireLogin: true,
    //       redirect: null,
    //     ),
    //   ];

    //   final router = AnyhooRouter<AnyhooTestRouteName>(routes: routes);
    //   final goRouter = router.getGoRouter();

    //   await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

    //   // Navigate to /users/123 which requires login
    //   goRouter.go('/users/123');
    //   await tester.pumpAndSettle();

    //   // Verify we were redirected to /login
    //   expect(goRouter.routeInformationProvider.value.uri.path, '/login');
    // });

    // testWidgets('should redirect to home when authenticated and on login page', (WidgetTester tester) async {
    //   final user = TestUser(id: '123', email: 'test@test.com');
    //   final authCubit = MockAuthCubit();
    //   final authState = AnyhooAuthState<TestUser>(user: user);

    //   when(() => authCubit.state).thenReturn(authState);
    //   when(() => authCubit.stream).thenAnswer((_) => Stream.value(authState));

    //   final routes = [
    //     DummyRoute(path: '/', title: 'Home', routeName: AnyhooTestRouteName.home, requireLogin: false, redirect: null),
    //     DummyRoute(
    //       path: '/login',
    //       title: 'Login',
    //       routeName: AnyhooTestRouteName.login,
    //       requireLogin: false,
    //       redirect: null,
    //     ),
    //     DummyRoute(
    //       path: '/users/:userId',
    //       title: 'Users',
    //       routeName: AnyhooTestRouteName.users,
    //       requireLogin: true,
    //       redirect: null,
    //     ),
    //   ];

    //   final router = AnyhooRouter<AnyhooTestRouteName>(routes: routes, authCubit: authCubit);
    //   final goRouter = router.getGoRouter();

    //   await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

    //   // Navigate to /login while authenticated
    //   goRouter.go('/login');
    //   await tester.pumpAndSettle();

    //   // Verify we were redirected to / (home)
    //   expect(goRouter.routeInformationProvider.value.uri.path, '/');
    // });
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
