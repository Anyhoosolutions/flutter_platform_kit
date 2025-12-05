import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_core/widgets/error_page.dart';
import 'package:anyhoo_router/src/go_router_refresh_stream.dart';
import 'package:anyhoo_router/src/anyhoo_route_redirector.dart';
import 'package:anyhoo_router/src/anyhoo_route_stack_observer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final _log = Logger('AnyhooRouter');

class AnyhooRouter {
  final List<RouteBase> routes;
  final AnyhooAuthCubit? authCubit;
  final bool debugLogDiagnostics;
  final String redirectNotFound;
  final String loginPath;
  final String initialPath;

  AnyhooRouter({
    required this.routes,
    this.authCubit,
    this.debugLogDiagnostics = false,
    this.redirectNotFound = '/not-found',
    this.loginPath = '/login',
    this.initialPath = '/',
  });

  GoRouter getGoRouter() {
    final routeStackObserver = AnyhooRouteStackObserver();

    final redirectHelper = AnyhooRouteRedirector(
      routes: routes,
      authCubit: authCubit,
      redirectNotFound: redirectNotFound,
      loginPath: loginPath,
      initialPath: initialPath,
    );

    // Create unique GlobalKeys for each router instance
    final rootNavigatorKey = GlobalKey<NavigatorState>();
    final navDrawerShellNavigatorKey = GlobalKey<NavigatorState>();
    final router = GoRouter(
      initialLocation: '/',
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: debugLogDiagnostics,
      observers: [routeStackObserver],
      redirect: (context, state) => redirectHelper.redirect(context, state),
      refreshListenable: authCubit != null ? GoRouterRefreshStream([authCubit!.stream]) : null,
      routes: [
        ShellRoute(
          navigatorKey: navDrawerShellNavigatorKey,
          builder: (context, state, child) {
            return child;
          },
          routes: routes,
        ),
      ],
      errorBuilder: (context, state) => Scaffold(body: ErrorPage(errorMessage: 'Error: ${state.error}')),
    );
    GoRouter.optionURLReflectsImperativeAPIs = true;

    addLoggingListener(router);
    return router;
  }

  void addLoggingListener(GoRouter router) {
    router.routerDelegate.addListener(() {
      _log.info('Route changed: ${router.routeInformationProvider.value.uri}');
    });
  }
}
