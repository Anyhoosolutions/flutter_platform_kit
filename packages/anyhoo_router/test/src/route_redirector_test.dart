import 'package:anyhoo_router/src/route_redirector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:go_router/src/state.dart';

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
}

class DummyRoute extends AnyhooRoute<AnyhooTestRouteName> {
  DummyRoute({String path = '/', String title = 'Home', AnyhooTestRouteName routeName = AnyhooTestRouteName.home})
    : _path = path,
      _title = title,
      _routeName = routeName;

  final String _path;
  final String _title;
  final AnyhooTestRouteName _routeName;

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
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  String toString() => 'DummyRoute(path: $_path, title: $_title, routeName: $_routeName)';
}
