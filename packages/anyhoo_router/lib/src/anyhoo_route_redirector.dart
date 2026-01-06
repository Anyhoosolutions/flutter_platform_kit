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
  final String redirectNotFound;

  AnyhooRouteRedirector({
    required this.routes,
    this.authCubit,
    this.deepLinkSchemeName,
    this.webDeepLinkHost,
    required this.loginPath,
    required this.initialPath,
    required this.redirectNotFound,
  }) : allPaths = getAllPaths(routes);

  String? redirect(BuildContext context, GoRouterState state) {
    final uri = state.uri;
    final originalPath = uri.path;
    log.info('redirect called for originalPath: $originalPath');
    log.info('allPaths: ${allPaths.join(', ')}');

    // Check if user is on login path but already logged in - redirect to initial path
    log.info('authCubit: $authCubit');
    log.info('authCubit state: ${authCubit?.state}');
    log.info('loginPath: $loginPath');
    log.info('originalPath: $originalPath');

    if (authCubit != null && _normalizePath(originalPath) == _normalizePath(loginPath)) {
      final user = authCubit!.state.user;
      log.info('user: $user');
      if (user != null) {
        log.info('User is logged in but on login path, redirecting to initial path');
        return redirecting(originalPath, initialPath);
      }
    }

    if (!_pathMatchesAnyRoute(originalPath)) {
      log.info('route not found, redirecting to /');
      return redirecting(originalPath, '$redirectNotFound?originalPath=$originalPath');
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

  static List<String> getAllPaths(List<RouteBase> routes, [String parentPath = '']) {
    List<String> paths = [];
    for (var route in routes) {
      final r = route as GoRoute;
      String p = r.path;

      // Normalize the path
      if (p.endsWith('/')) {
        p = p.substring(0, p.length - 1);
      }

      // Build full path by combining parent and current path
      String fullPath;
      if (parentPath.isEmpty) {
        // Root level route
        if (!p.startsWith('/')) {
          fullPath = '/$p';
        } else {
          fullPath = p;
        }
      } else {
        // Nested route - combine with parent
        // In GoRouter, child routes are always relative to parent, even if they start with /
        // So we remove leading slash if present and combine with parent
        String relativePath = p.startsWith('/') ? p.substring(1) : p;

        // Special case: if parent is '/', don't add extra slash
        if (parentPath == '/') {
          fullPath = '/$relativePath';
        } else {
          fullPath = '$parentPath/$relativePath';
        }
      }

      // Normalize to lowercase for matching (but preserve parameter names)
      // Parameters like :id, :postId should remain as-is for matching
      String normalizedPath = _normalizePathForMatching(fullPath);
      paths.add(normalizedPath);

      // Recursively process child routes with the full path as parent
      paths.addAll(getAllPaths(r.routes, fullPath));
    }
    return paths;
  }

  /// Normalizes a path for matching by lowercasing non-parameter segments
  /// Parameter names (starting with :) are preserved as-is
  static String _normalizePathForMatching(String path) {
    // Split path into segments
    final segments = path.split('/');
    final normalizedSegments = segments.map((segment) {
      // If it's a parameter (starts with :), keep it as-is (preserve case)
      if (segment.startsWith(':')) {
        return segment;
      }
      // Otherwise, lowercase it
      return segment.toLowerCase();
    }).toList();
    return normalizedSegments.join('/');
  }

  /// Normalizes a path for comparison (removes trailing slashes, lowercases)
  String _normalizePath(String path) {
    String normalized = path.toLowerCase();
    // Remove trailing slash except for root path
    if (normalized.endsWith('/') && normalized != '/') {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }
}
