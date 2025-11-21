import 'package:anyhoo_auth/cubit/auth_cubit.dart';
import 'package:anyhoo_core/extensions/string_extensions.dart';
import 'package:anyhoo_core/models/auth_user.dart';
import 'package:anyhoo_router/src/anyhoo_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final log = Logger('RouteRedirector');

class RouteRedirector<T extends Enum> {
  final List<AnyhooRoute<T>> routes;
  final AuthCubit? authCubit;
  final String? deepLinkSchemeName;
  final String? webDeepLinkHost;
  final String loginPath;
  final String initialPath;

  RouteRedirector({
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

    final user = getUser(context);
    // Only check authentication if AuthBloc is available
    if (user == null) {
      if (appRouterPage != null && appRouterPage.requireLogin) {
        // log.info('requireLogin is true for ${appRouterPage.routeName}');

        return redirecting(originalPath, loginPath);
      }
    } else {
      if (uri.path == loginPath) {
        return redirecting(originalPath, '/');
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
      if (uri.scheme == 'https' && uri.host == webDeepLinkHost) {
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

  AuthUser? getUser(BuildContext context) {
    if (authCubit?.state.user is! AuthUser) {
      return null;
    }

    return authCubit?.state.user;
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

    // Create regex pattern by replacing path parameters with regex patterns
    String pagePathRegex = normalizedPagePath.replaceAll(':groupId', '[^\\/]+');
    pagePathRegex = pagePathRegex.replaceAll('/', '\\/');
    pagePathRegex = "^$pagePathRegex\$";

    // with regex see if it matches when :groupId can be any string
    // ignore: deprecated_member_use
    final regex = RegExp(pagePathRegex);
    if (regex.hasMatch(uriPath)) {
      return true;
    }
    return normalizedPagePath == uriPath;
  }

  String? getRedirect(String originalPath, AnyhooRoute<T> route, String redirect) {
    String? groupId; // TODO: Handle other path parameters
    if (route.path.contains(':groupId')) {
      final pattern = route.path.replaceAll(':groupId', '([^/]+)');
      // ignore: deprecated_member_use
      final match = RegExp(pattern).firstMatch(originalPath);
      if (match != null) {
        groupId = match.group(1);
      }
    }
    if (groupId != null) {
      redirect = redirect.replaceAll(':groupId', groupId);
    }
    return redirect;
  }
}
