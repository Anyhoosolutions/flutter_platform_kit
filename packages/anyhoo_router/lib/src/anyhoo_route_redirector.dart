import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final log = Logger('RouteRedirector');

class AnyhooRouteRedirector {
  final List<RouteBase> routes;
  final AnyhooAuthCubit? authCubit;
  final String? deepLinkSchemeName;
  final String? webDeepLinkHost;
  final String loginPath;
  final String initialPath;
  final List<String> allPaths;

  AnyhooRouteRedirector({
    required this.routes,
    this.authCubit,
    this.deepLinkSchemeName,
    this.webDeepLinkHost,
    this.loginPath = '/login',
    this.initialPath = '/',
  }) : allPaths = getAllPaths(routes);

  String? redirect(BuildContext context, GoRouterState state) {
    final uri = state.uri;
    final originalPath = uri.path;
    log.info('redirect called for originalPath: $originalPath');
    log.info('allPaths: ${allPaths.join(', ')}');

    if (!_pathMatchesAnyRoute(originalPath)) {
      log.info('route not found, redirecting to /');
      return redirecting(originalPath, '/');
    }

    if (deepLinkSchemeName != null) {
      // Handle custom scheme deep links
      if (uri.scheme == deepLinkSchemeName) {
        // TODO: Handle all apps
        // Convert snapandsavor://tasks/simple to /tasks/simple
        String path;

        if (uri.host.isEmpty && uri.path.isEmpty) {
          // snapandsavor:// -> go to initial location
          path = initialPath;
        } else if (uri.host.isNotEmpty && uri.path.isEmpty) {
          // snapandsavor://about -> /about
          path = '/${uri.host}';
        } else {
          // snapandsavor://tasks/simple -> /tasks/simple
          // Handle case where host is empty but path exists (e.g., snapandsavor:///about)
          if (uri.host.isEmpty && uri.path.isNotEmpty) {
            path = uri.path;
          } else {
            path = '/${uri.host}${uri.path}';
          }
        }

        // Remove trailing slash if present (except for root path)
        if (path.endsWith('/') && path != initialPath) {
          path = path.substring(0, path.length - 1);
        }

        log.info('Deep link redirect: ${uri.toString()} -> $path');
        return redirecting(originalPath, path);
      }
    }
    if (webDeepLinkHost != null) {
      // Handle web deep links
      if (uri.scheme == 'https' && uri.host.toLowerCase() == webDeepLinkHost?.toLowerCase()) {
        // Return the path as-is for web links
        return redirecting(originalPath, uri.path);
      }
    }

    // No redirect needed for normal routes
    return redirecting(originalPath, null);
  }

  String? redirecting(String originalPath, String? redirectTo) {
    if (redirectTo == null) {
      log.info('no redirecting needed. Will go to $originalPath');
      return null;
    }

    log.info('...redirecting to $redirectTo instead of $originalPath');
    return redirectTo;
  }

  bool _pathMatchesAnyRoute(String path) {
    final normalizedPath = path.toLowerCase();

    // First check exact match
    if (allPaths.contains(normalizedPath)) {
      return true;
    }

    // Then check if it matches any parameterized route pattern
    final pathSegments = normalizedPath.split('/').where((s) => s.isNotEmpty).toList();

    for (final routePath in allPaths) {
      final routeSegments = routePath.split('/').where((s) => s.isNotEmpty).toList();

      // Must have same number of segments
      if (pathSegments.length != routeSegments.length) {
        continue;
      }

      // Check if all non-parameter segments match
      bool matches = true;
      for (int i = 0; i < pathSegments.length; i++) {
        final routeSegment = routeSegments[i];
        // If it's a parameter (starts with :), it matches any value
        if (routeSegment.startsWith(':')) {
          continue;
        }
        // Otherwise, segments must match exactly
        if (pathSegments[i] != routeSegment) {
          matches = false;
          break;
        }
      }

      if (matches) {
        return true;
      }
    }

    return false;
  }

  static List<String> getAllPaths(List<RouteBase> routes) {
    List<String> paths = [];
    for (var route in routes) {
      final r = route as GoRoute;
      String p = r.path.toLowerCase();
      if (p.endsWith('/')) {
        p = p.substring(0, p.length - 1);
      }
      if (!p.startsWith('/')) {
        p = '/$p';
      }
      paths.add(p);

      paths.addAll(getAllPaths(r.routes));
    }
    return paths;
  }
}
