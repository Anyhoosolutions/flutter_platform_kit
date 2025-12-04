import 'package:anyhoo_router/src/anyhoo_route_redirector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('AnyhooRouteRedirector.getAllPaths', () {
    test('should return root path for single root route', () {
      final routes = [GoRoute(path: '/', builder: (context, state) => const Text('Home'))];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, contains('/'));
      expect(paths.length, 1);
    });

    test('should return paths for flat routes', () {
      final routes = [
        GoRoute(path: '/', builder: (context, state) => const Text('Home')),
        GoRoute(path: '/about', builder: (context, state) => const Text('About')),
        GoRoute(path: '/contact', builder: (context, state) => const Text('Contact')),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, containsAll(['/', '/about', '/contact']));
      expect(paths.length, 3);
    });

    test('should handle routes without leading slash', () {
      final routes = [
        GoRoute(path: 'home', builder: (context, state) => const Text('Home')),
        GoRoute(path: 'about', builder: (context, state) => const Text('About')),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, containsAll(['/home', '/about']));
      expect(paths.length, 2);
    });

    test('should handle routes with trailing slash', () {
      final routes = [
        GoRoute(path: '/home/', builder: (context, state) => const Text('Home')),
        GoRoute(path: '/about/', builder: (context, state) => const Text('About')),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, containsAll(['/home', '/about']));
      expect(paths.length, 2);
    });

    test('should handle nested routes with root parent', () {
      final routes = [
        GoRoute(
          path: '/',
          builder: (context, state) => const Text('Home'),
          routes: [
            GoRoute(path: 'users', builder: (context, state) => const Text('Users')),
            GoRoute(path: 'login', builder: (context, state) => const Text('Login')),
          ],
        ),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, containsAll(['/', '/users', '/login']));
      expect(paths.length, 3);
    });

    test('should handle nested routes with non-root parent', () {
      final routes = [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const Text('Admin'),
          routes: [
            GoRoute(path: 'users', builder: (context, state) => const Text('Admin Users')),
            GoRoute(path: 'settings', builder: (context, state) => const Text('Admin Settings')),
          ],
        ),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      // This test will likely fail, exposing the bug
      // Expected: ['/admin', '/admin/users', '/admin/settings']
      // Actual: ['/admin', '/users', '/settings'] (if bug exists)
      expect(paths, containsAll(['/admin', '/admin/users', '/admin/settings']));
      expect(paths.length, 3);
    });

    test('should handle deeply nested routes', () {
      final routes = [
        GoRoute(
          path: '/',
          builder: (context, state) => const Text('Home'),
          routes: [
            GoRoute(
              path: 'admin',
              builder: (context, state) => const Text('Admin'),
              routes: [
                GoRoute(
                  path: 'users',
                  builder: (context, state) => const Text('Admin Users'),
                  routes: [GoRoute(path: ':id', builder: (context, state) => const Text('User Detail'))],
                ),
              ],
            ),
          ],
        ),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      // Expected: ['/', '/admin', '/admin/users', '/admin/users/:id']
      expect(paths, containsAll(['/', '/admin', '/admin/users', '/admin/users/:id']));
      expect(paths.length, 4);
    });

    test('should handle parameterized routes', () {
      final routes = [
        GoRoute(
          path: '/',
          builder: (context, state) => const Text('Home'),
          routes: [
            GoRoute(path: 'users/:id', builder: (context, state) => const Text('User')),
            GoRoute(path: 'posts/:postId/comments/:commentId', builder: (context, state) => const Text('Comment')),
          ],
        ),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      // Parameter names are preserved (not lowercased)
      expect(paths, containsAll(['/', '/users/:id', '/posts/:postId/comments/:commentId']));
      expect(paths.length, 3);
    });

    test('should handle mixed nested and flat routes', () {
      final routes = [
        GoRoute(
          path: '/',
          builder: (context, state) => const Text('Home'),
          routes: [GoRoute(path: 'users', builder: (context, state) => const Text('Users'))],
        ),
        GoRoute(path: '/about', builder: (context, state) => const Text('About')),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, containsAll(['/', '/users', '/about']));
      expect(paths.length, 3);
    });

    test('should handle multiple nested routes at same level', () {
      final routes = [
        GoRoute(
          path: '/',
          builder: (context, state) => const Text('Home'),
          routes: [
            GoRoute(
              path: 'users',
              builder: (context, state) => const Text('Users'),
              routes: [GoRoute(path: ':id', builder: (context, state) => const Text('User Detail'))],
            ),
            GoRoute(
              path: 'posts',
              builder: (context, state) => const Text('Posts'),
              routes: [GoRoute(path: ':id', builder: (context, state) => const Text('Post Detail'))],
            ),
          ],
        ),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, containsAll(['/', '/users', '/users/:id', '/posts', '/posts/:id']));
      expect(paths.length, 5);
    });

    test('should normalize paths to lowercase', () {
      final routes = [
        GoRoute(path: '/HOME', builder: (context, state) => const Text('Home')),
        GoRoute(path: '/About', builder: (context, state) => const Text('About')),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, containsAll(['/home', '/about']));
      expect(paths.length, 2);
    });

    test('should handle empty routes list', () {
      final routes = <RouteBase>[];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, isEmpty);
    });

    test('should handle routes with complex nested structure', () {
      final routes = [
        GoRoute(
          path: '/',
          builder: (context, state) => const Text('Home'),
          routes: [
            GoRoute(
              path: 'shop',
              builder: (context, state) => const Text('Shop'),
              routes: [
                GoRoute(
                  path: 'products',
                  builder: (context, state) => const Text('Products'),
                  routes: [
                    GoRoute(
                      path: ':productId',
                      builder: (context, state) => const Text('Product Detail'),
                      routes: [GoRoute(path: 'reviews', builder: (context, state) => const Text('Reviews'))],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(
        paths,
        containsAll(['/', '/shop', '/shop/products', '/shop/products/:productId', '/shop/products/:productId/reviews']),
      );
      expect(paths.length, 5);
    });

    test('should handle routes with parent path ending in slash', () {
      final routes = [
        GoRoute(
          path: '/admin/',
          builder: (context, state) => const Text('Admin'),
          routes: [GoRoute(path: 'users', builder: (context, state) => const Text('Users'))],
        ),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      expect(paths, containsAll(['/admin', '/admin/users']));
      expect(paths.length, 2);
    });

    test('should handle child routes without leading slash', () {
      final routes = [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const Text('Admin'),
          routes: [
            GoRoute(path: 'users', builder: (context, state) => const Text('Users')),
            GoRoute(
              path: '/settings', // This would be unusual but test it
              builder: (context, state) => const Text('Settings'),
            ),
          ],
        ),
      ];

      final paths = AnyhooRouteRedirector.getAllPaths(routes);

      // Child routes should be relative to parent
      // '/settings' as a child of '/admin' would be '/admin/settings' in GoRouter
      expect(paths, containsAll(['/admin', '/admin/users', '/admin/settings']));
      expect(paths.length, 3);
    });
  });
}
