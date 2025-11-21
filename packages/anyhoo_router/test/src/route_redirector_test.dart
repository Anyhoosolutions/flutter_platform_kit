import 'package:anyhoo_auth/cubit/auth_cubit.dart';
import 'package:anyhoo_auth/cubit/auth_state.dart';
import 'package:anyhoo_core/models/auth_user.dart';
import 'package:anyhoo_router/src/route_redirector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:go_router/src/state.dart';
import 'package:mocktail/mocktail.dart';

enum AnyhooTestRouteName { home, auth, routeFirstDemo, routeNestedDemo }

void main() {
  group('RouteRedirector', () {
    group('getRedirect', () {
      test('can redirect for simple path', () {
        final redirector = RouteRedirector<AnyhooTestRouteName>(routes: []);
        final route = DummyRoute();

        final redirectPath = redirector.getRedirect('/', route, '/next');

        expect(redirectPath, '/next');
      });

      test('can redirect for :groupId in path', () {
        final redirector = RouteRedirector<AnyhooTestRouteName>(routes: []);
        final route = DummyRoute(path: 'groups/:groupId');

        final redirectPath = redirector.getRedirect('/groups/123', route, '/groups/:groupId/details');

        expect(redirectPath, '/groups/123/details');
      });

      test('can redirect for :userId in path', () {
        final redirector = RouteRedirector<AnyhooTestRouteName>(routes: []);
        final route = DummyRoute(path: 'users/:userId');

        final redirectPath = redirector.getRedirect('/users/34', route, '/users/:userId/details');

        expect(redirectPath, '/users/34/details');
      });

      test('can redirect for multiple ids, :userId and :addressId in path', () {
        final redirector = RouteRedirector<AnyhooTestRouteName>(routes: []);
        final route = DummyRoute(path: 'users/:userId/addresses/:addressId');

        final redirectPath = redirector.getRedirect(
          '/users/34/addresses/56',
          route,
          '/users/:userId/addresses/:addressId/details',
        );

        expect(redirectPath, '/users/34/addresses/56/details');
      });
    });
  });

  group('comparePath', () {
    test('can compare path for simple path', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: []);

      final isMatch = redirector.comparePath('/', '/');
      expect(isMatch, true);
    });

    test('can compare path for :groupId in path', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: []);

      final isMatch = redirector.comparePath('/groups/:groupId', '/groups/123');
      expect(isMatch, true);
    });

    test('can compare path for :userId in path', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: []);

      final isMatch = redirector.comparePath('/users/:userId', '/users/34');
      expect(isMatch, true);
    });

    test('can compare path for multiple ids, :userId and :addressId in path', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: []);

      final isMatch = redirector.comparePath('/users/:userId/addresses/:addressId', '/users/34/addresses/56');
      expect(isMatch, true);
    });
  });

  group('getPageByPath', () {
    final routes = [
      DummyRoute(path: '/'),
      DummyRoute(path: '/users/:userId', title: 'Users'),
      DummyRoute(path: '/users/:userId/addresses/:addressId', title: 'Addresses'),
    ];
    test('can get page by path for simple path', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: routes);

      final route = redirector.getPageByPath('/');
      expect(route, routes[0]);
    });

    test('can get page by path for :userId in path', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: routes);

      final route = redirector.getPageByPath('/users/34');
      expect(route, routes[1]);
    });

    test('can get page by path for :userId and :addressId in path', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: routes);

      final route = redirector.getPageByPath('/users/34/addresses/56');
      expect(route, routes[2]);
    });
  });

  group('redirect', () {
    final routes = [
      DummyRoute(path: '/', requireLogin: false),
      DummyRoute(path: '/login', title: 'Login', requireLogin: false),
      DummyRoute(path: '/users/:userId', title: 'Users', requireLogin: true),
      DummyRoute(path: '/users/:userId/addresses/:addressId', title: 'Addresses', requireLogin: true),
      DummyRoute(path: '/profiles', title: 'Redirecting', redirect: '/users'),
    ];
    final context = MockContext();
    final state = MockState();
    final user = TestUser(id: '123', email: 'test@test.com');
    final authCubit = MockAuthCubit();
    final authState = AuthState<TestUser>(user: user);

    test('do not have to redirect, when not logged in but does not require login', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: routes);
      when(() => state.uri).thenReturn(Uri.parse('/'));

      final redirectPath = redirector.redirect(context, state);
      expect(redirectPath, null);
    });

    test('does redirect to login, when not logged in but requires login', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: routes);
      when(() => state.uri).thenReturn(Uri.parse('/users/123'));

      final redirectPath = redirector.redirect(context, state);
      expect(redirectPath, '/login');
    });

    test('does redirect to /, when logged in and on login page', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: routes, authCubit: authCubit);
      when(() => state.uri).thenReturn(Uri.parse('/login'));
      when(() => authCubit.state).thenReturn(authState);

      final redirectPath = redirector.redirect(context, state);
      expect(redirectPath, '/');
    });

    test('does not redirect when logged in and on a page that requires login', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: routes, authCubit: authCubit);
      when(() => state.uri).thenReturn(Uri.parse('/users/123'));
      when(() => authCubit.state).thenReturn(authState);

      final redirectPath = redirector.redirect(context, state);
      expect(redirectPath, null);
    });

    test('does redirect for deep link', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(
        routes: routes,
        authCubit: authCubit,
        deepLinkSchemeName: 'myapp',
      );
      when(() => state.uri).thenReturn(Uri.parse('myapp://users/123'));
      when(() => authCubit.state).thenReturn(authState);

      final redirectPath = redirector.redirect(context, state);
      expect(redirectPath, '/users/123');
    });

    test('does redirect for https deep link', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(
        routes: routes,
        authCubit: authCubit,
        webDeepLinkHost: 'myapp.com',
      );
      when(() => state.uri).thenReturn(Uri.parse('https://myapp.com/users/123'));
      when(() => authCubit.state).thenReturn(authState);

      final redirectPath = redirector.redirect(context, state);
      expect(redirectPath, '/users/123');
    });

    test('does redirect for https deep link', () {
      final redirector = RouteRedirector<AnyhooTestRouteName>(routes: routes, authCubit: authCubit);
      when(() => state.uri).thenReturn(Uri.parse('/profiles'));
      when(() => authCubit.state).thenReturn(authState);

      final redirectPath = redirector.redirect(context, state);
      expect(redirectPath, '/users');
    });
  });
}

class MockContext extends Mock implements BuildContext {}

class MockState extends Mock implements GoRouterState {}

class MockAuthCubit extends Mock implements AuthCubit<TestUser> {}

class DummyRoute extends AnyhooRoute<AnyhooTestRouteName> {
  DummyRoute({
    String path = '/',
    String title = 'Home',
    AnyhooTestRouteName routeName = AnyhooTestRouteName.home,
    bool requireLogin = true,
    String? redirect,
  }) : _path = path,
       _title = title,
       _routeName = routeName,
       _requireLogin = requireLogin,
       _redirect = redirect;

  final String _path;
  final String _title;
  final AnyhooTestRouteName _routeName;
  final bool _requireLogin;
  final String? _redirect;

  @override
  String get path => _path;

  @override
  String get title => _title;

  @override
  AnyhooTestRouteName get routeName => _routeName;

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder =>
      (context, state) => Text(_title);

  @override
  String? get redirect => _redirect;

  @override
  bool get requireLogin => _requireLogin;

  @override
  String toString() => 'DummyRoute(path: $_path, title: $_title, routeName: $_routeName)';
}

class TestUser extends AuthUser {
  @override
  final String id;
  @override
  final String email;

  TestUser({required this.id, required this.email});

  @override
  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}
