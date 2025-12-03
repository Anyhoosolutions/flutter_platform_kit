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

  AnyhooRouteRedirector({
    required this.routes,
    this.authCubit,
    this.deepLinkSchemeName,
    this.webDeepLinkHost,
    this.loginPath = '/login',
    this.initialPath = '/',
  });

  String? redirect(BuildContext context, GoRouterState state) {
    final uri = state.uri;
    final originalPath = uri.path;
    log.info('redirect called for originalPath: $originalPath');

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
}
