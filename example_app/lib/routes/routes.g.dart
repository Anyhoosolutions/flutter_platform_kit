// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeScreenRoute];

RouteBase get $homeScreenRoute => GoRouteData.$route(
  path: '/',
  name: 'home',
  factory: $HomeScreenRoute._fromState,
  routes: [
    GoRouteData.$route(path: 'analytics', factory: $AnalyticsRoute._fromState),
    GoRouteData.$route(path: 'arguments', factory: $ArgumentsRoute._fromState),
    GoRouteData.$route(path: 'auth', factory: $AuthRoute._fromState),
    GoRouteData.$route(
      path: 'enhance-user',
      factory: $EnhanceUserRoute._fromState,
    ),
    GoRouteData.$route(path: 'firestore', factory: $FirestoreRoute._fromState),
    GoRouteData.$route(
      path: 'image-selector',
      factory: $ImageSelectorRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'remote-config',
      factory: $RemoteConfigRoute._fromState,
    ),
    GoRouteData.$route(path: 'map', factory: $MapRoute._fromState),
    GoRouteData.$route(path: 'logging', factory: $LoggingRoute._fromState),
    GoRouteData.$route(
      path: 'route-demo',
      factory: $RouteDemoRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'nested',
          factory: $RouteNestedDemoRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'redirecting',
          factory: $RouteRedirectingDemoRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: 'error-page-demo',
      factory: $ErrorPageDemoRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'waiting-page-demo',
      factory: $WaitingPageDemoRoute._fromState,
    ),
    GoRouteData.$route(path: 'login', factory: $LoginRoute._fromState),
    GoRouteData.$route(
      path: 'not-logged-in-redirector',
      factory: $NotLoggedInRedirectorRoute._fromState,
    ),
  ],
);

mixin $HomeScreenRoute on GoRouteData {
  static HomeScreenRoute _fromState(GoRouterState state) => HomeScreenRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AnalyticsRoute on GoRouteData {
  static AnalyticsRoute _fromState(GoRouterState state) =>
      const AnalyticsRoute();

  @override
  String get location => GoRouteData.$location('/analytics');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ArgumentsRoute on GoRouteData {
  static ArgumentsRoute _fromState(GoRouterState state) =>
      const ArgumentsRoute();

  @override
  String get location => GoRouteData.$location('/arguments');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AuthRoute on GoRouteData {
  static AuthRoute _fromState(GoRouterState state) => const AuthRoute();

  @override
  String get location => GoRouteData.$location('/auth');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EnhanceUserRoute on GoRouteData {
  static EnhanceUserRoute _fromState(GoRouterState state) =>
      const EnhanceUserRoute();

  @override
  String get location => GoRouteData.$location('/enhance-user');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FirestoreRoute on GoRouteData {
  static FirestoreRoute _fromState(GoRouterState state) =>
      const FirestoreRoute();

  @override
  String get location => GoRouteData.$location('/firestore');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ImageSelectorRoute on GoRouteData {
  static ImageSelectorRoute _fromState(GoRouterState state) =>
      ImageSelectorRoute();

  @override
  String get location => GoRouteData.$location('/image-selector');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RemoteConfigRoute on GoRouteData {
  static RemoteConfigRoute _fromState(GoRouterState state) =>
      RemoteConfigRoute();

  @override
  String get location => GoRouteData.$location('/remote-config');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MapRoute on GoRouteData {
  static MapRoute _fromState(GoRouterState state) => MapRoute();

  @override
  String get location => GoRouteData.$location('/map');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LoggingRoute on GoRouteData {
  static LoggingRoute _fromState(GoRouterState state) => LoggingRoute();

  @override
  String get location => GoRouteData.$location('/logging');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RouteDemoRoute on GoRouteData {
  static RouteDemoRoute _fromState(GoRouterState state) => RouteDemoRoute();

  @override
  String get location => GoRouteData.$location('/route-demo');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RouteNestedDemoRoute on GoRouteData {
  static RouteNestedDemoRoute _fromState(GoRouterState state) =>
      RouteNestedDemoRoute();

  @override
  String get location => GoRouteData.$location('/route-demo/nested');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RouteRedirectingDemoRoute on GoRouteData {
  static RouteRedirectingDemoRoute _fromState(GoRouterState state) =>
      RouteRedirectingDemoRoute();

  @override
  String get location => GoRouteData.$location('/route-demo/redirecting');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ErrorPageDemoRoute on GoRouteData {
  static ErrorPageDemoRoute _fromState(GoRouterState state) =>
      ErrorPageDemoRoute();

  @override
  String get location => GoRouteData.$location('/error-page-demo');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $WaitingPageDemoRoute on GoRouteData {
  static WaitingPageDemoRoute _fromState(GoRouterState state) =>
      WaitingPageDemoRoute();

  @override
  String get location => GoRouteData.$location('/waiting-page-demo');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $NotLoggedInRedirectorRoute on GoRouteData {
  static NotLoggedInRedirectorRoute _fromState(GoRouterState state) =>
      NotLoggedInRedirectorRoute();

  @override
  String get location => GoRouteData.$location('/not-logged-in-redirector');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
