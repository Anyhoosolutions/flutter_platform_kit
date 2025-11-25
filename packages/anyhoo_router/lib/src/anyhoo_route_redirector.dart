import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_core/extensions/anyhoo_string_extensions.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:anyhoo_router/src/anyhoo_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final log = Logger('RouteRedirector');

class AnyhooRouteRedirector<T extends Enum> {
  final List<AnyhooRoute<T>> routes;
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
    log.info('originalPath: $originalPath');

    // Debug logging
    // log.fine('AuthBloc state: ${authBloc.state.runtimeType}');

    final appRouterPage = getPageByPath(originalPath);
    // log.info('appRouterPage: ${appRouterPage?.routeName}');

    final user = getUser();
    // Only check authentication if AuthBloc is available
    if (user == null) {
      if (appRouterPage != null && appRouterPage.requireLogin) {
        // log.info('requireLogin is true for ${appRouterPage.routeName}');

        return redirecting(originalPath, loginPath);
      }
    } else {
      if (uri.path == loginPath) {
        return redirecting(originalPath, initialPath);
      }
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

    if (appRouterPage != null && appRouterPage.redirect != null) {
      log.info('Should redirect ${appRouterPage.routeName} to ${appRouterPage.redirect}');
      final redirectUri = getRedirect(originalPath, appRouterPage, appRouterPage.redirect!);
      // log.info('redirectUri: $redirectUri');
      return redirecting(originalPath, redirectUri);
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

  AnyhooUser? getUser() {
    final user = authCubit?.state.user;
    if (user is! AnyhooUser) {
      return null;
    }

    return user;
  }

  AnyhooRoute<T>? getPageByPath(String originalPath) {
    final route = routes.where((r) => comparePath(r.path, originalPath)).firstOrNull;
    return route;
  }

  bool comparePath(String pagePath, String? uriPath) {
    if (uriPath == null) {
      return false;
    }
    uriPath = uriPath != '/' ? uriPath.stripRight('/') : uriPath;
    String normalizedPagePath = pagePath != '/' ? pagePath.stripRight('/') : pagePath;

    // Extract path parameters (wildcards) from the page path
    final pathParameters = normalizedPagePath.split('/').where((s) => s.startsWith(':')).toList();

    // If there are no parameters, do a simple string comparison
    if (pathParameters.isEmpty) {
      return normalizedPagePath == uriPath;
    }

    // Build a regex pattern by replacing each parameter with a regex pattern
    String pagePathRegex = normalizedPagePath;
    for (final pathParameter in pathParameters) {
      pagePathRegex = pagePathRegex.replaceAll(pathParameter, '[^/]+');
    }

    // Escape forward slashes in the pattern
    pagePathRegex = pagePathRegex.replaceAll('/', r'\/');
    pagePathRegex = '^$pagePathRegex\$';

    // Match the uri path against the pattern
    // ignore: deprecated_member_use
    final regex = RegExp(pagePathRegex);
    return regex.hasMatch(uriPath);
  }

  String? getRedirect(String originalPath, AnyhooRoute<T> route, String redirect) {
    // Normalize paths - ensure both have leading slashes for consistent matching
    String normalizedRoutePath = route.path.startsWith('/') ? route.path : '/${route.path}';
    String normalizedOriginalPath = originalPath;

    // Extract path parameters (wildcards) from the route path
    final pathParameters = normalizedRoutePath.split('/').where((s) => s.startsWith(':')).toList();

    // If there are no parameters, normalize and return the redirect path
    if (pathParameters.isEmpty) {
      return redirect.startsWith('/') ? redirect : '/$redirect';
    }

    // Build a regex pattern by replacing each parameter with a capture group
    String pattern = normalizedRoutePath;
    for (final pathParameter in pathParameters) {
      pattern = pattern.replaceAll(pathParameter, '([^/]+)');
    }

    // Escape forward slashes in the pattern
    pattern = pattern.replaceAll('/', r'\/');
    pattern = '^$pattern\$';

    // Match the original path against the pattern
    // ignore: deprecated_member_use
    final regex = RegExp(pattern);
    final match = regex.firstMatch(normalizedOriginalPath);

    if (match == null) {
      // If no match, normalize and return redirect as-is (shouldn't happen in normal flow)
      return redirect.startsWith('/') ? redirect : '/$redirect';
    }

    // Extract captured values and map them to parameter names
    final replacements = <String, String>{};
    for (int i = 0; i < pathParameters.length; i++) {
      final parameterName = pathParameters[i];
      final capturedValue = match.group(i + 1); // group(0) is the full match
      if (capturedValue != null) {
        replacements[parameterName] = capturedValue;
      }
    }

    // Replace all occurrences of each parameter in the redirect path
    String result = redirect;
    for (final replacement in replacements.entries) {
      result = result.replaceAll(replacement.key, replacement.value);
    }

    // Ensure the result has a leading slash
    return result.startsWith('/') ? result : '/$result';
  }
}
