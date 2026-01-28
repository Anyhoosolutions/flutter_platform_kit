import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_auth/widgets/login_widget.dart';
import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_firebase/anyhoo_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/models/example_user.dart';
import 'package:example_app/pages/argumentsDemo/arguments_demo_page.dart';
import 'package:example_app/pages/authDemo/auth_demo_page.dart';
import 'package:example_app/pages/enhanceUserDemo/enhance_user_demo_page.dart';
import 'package:example_app/pages/errorPageDemo/error_page_demo_page.dart';
import 'package:example_app/pages/firestoreDemo/firestore_demo_page.dart';
import 'package:example_app/pages/homePage/home_page.dart';
import 'package:example_app/pages/imageSelectorDemo/image_selector_demo_page.dart';
import 'package:example_app/pages/loggingPage/logging_page.dart';
import 'package:example_app/pages/mapPage/map_page.dart';
import 'package:example_app/pages/remoteConfigDemo/remote_config_demo_page.dart';
import 'package:example_app/pages/routeDemo/route_first_demo_page.dart';
import 'package:example_app/pages/routeDemo/route_nested_demo_page.dart';
import 'package:example_app/pages/waitingPageDemo/waiting_page_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

part 'routes.g.dart';

// ignore: unused_element
final _log = Logger('Routes');

@TypedGoRoute<HomeScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<AnalyticsRoute>(path: 'analytics'),
    TypedGoRoute<ArgumentsRoute>(path: 'arguments'),
    TypedGoRoute<AuthRoute>(path: 'auth'),
    TypedGoRoute<EnhanceUserRoute>(path: 'enhance-user'),
    TypedGoRoute<FirestoreRoute>(path: 'firestore'),
    TypedGoRoute<ImageSelectorRoute>(path: 'image-selector'),
    TypedGoRoute<RemoteConfigRoute>(path: 'remote-config'),
    TypedGoRoute<MapRoute>(path: 'map'),
    TypedGoRoute<LoggingRoute>(path: 'logging'),
    TypedGoRoute<RouteDemoRoute>(
      path: 'route-demo',
      routes: [
        TypedGoRoute<RouteNestedDemoRoute>(path: 'nested'),
        TypedGoRoute<RouteRedirectingDemoRoute>(path: 'redirecting'),
      ],
    ),
    TypedGoRoute<ErrorPageDemoRoute>(path: 'error-page-demo'),
    TypedGoRoute<WaitingPageDemoRoute>(path: 'waiting-page-demo'),
    TypedGoRoute<LoginRoute>(path: 'login'),
    TypedGoRoute<NotLoggedInRedirectorRoute>(path: 'not-logged-in-redirector'),
  ],
  name: 'home',
)
@immutable
class HomeScreenRoute extends GoRouteData with $HomeScreenRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final arguments = context.read<Arguments>();
    final firestore = context.read<FirebaseFirestore>();
    return HomePage(arguments: arguments, firestore: firestore);
  }
}

@immutable
class AnalyticsRoute extends GoRouteData with $AnalyticsRoute {
  const AnalyticsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Demo')),
      body: FirebaseAnalyticsPage(),
    );
  }
}

@immutable
class ArgumentsRoute extends GoRouteData with $ArgumentsRoute {
  const ArgumentsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ArgumentsDemoPage(arguments: state.extra as Arguments);
  }
}

@immutable
class AuthRoute extends GoRouteData with $AuthRoute {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AuthDemoPage();
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final user = context.read<AnyhooAuthCubit<ExampleUser>>().state.user;
    if (user != null) {
      return '/';
    }
    return null;
  }
}

@immutable
class EnhanceUserRoute extends GoRouteData with $EnhanceUserRoute {
  const EnhanceUserRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EnhanceUserDemoPage();
  }
}

@immutable
class FirestoreRoute extends GoRouteData with $FirestoreRoute {
  const FirestoreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FirestoreDemoPage(firestore: state.extra as FirebaseFirestore);
  }
}

@immutable
class ImageSelectorRoute extends GoRouteData with $ImageSelectorRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ImageSelectorDemoPage();
  }
}

@immutable
class RemoteConfigRoute extends GoRouteData with $RemoteConfigRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RemoteConfigDemoPage();
  }
}

@immutable
class MapRoute extends GoRouteData with $MapRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MapPage();
  }
}

@immutable
class LoggingRoute extends GoRouteData with $LoggingRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoggingPage();
  }
}

@immutable
class ErrorPageDemoRoute extends GoRouteData with $ErrorPageDemoRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ErrorPageDemoPage();
  }
}

@immutable
class WaitingPageDemoRoute extends GoRouteData with $WaitingPageDemoRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WaitingPageDemoPage();
  }
}

@immutable
class LoginRoute extends GoRouteData with $LoginRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final cubit = context.read<AnyhooAuthCubit<ExampleUser>>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: LoginWidget<ExampleUser>(title: 'Example app', assetLogoPath: 'assets/images/logo.webp', cubit: cubit),
    );
  }
}

@immutable
class RouteDemoRoute extends GoRouteData with $RouteDemoRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RouteFirstDemoPage();
  }
}

@immutable
class RouteNestedDemoRoute extends GoRouteData with $RouteNestedDemoRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RouteNestedDemoPage();
  }
}

@immutable
class RouteRedirectingDemoRoute extends GoRouteData with $RouteRedirectingDemoRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Text('Route Redirecting Demo');
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    return '/route-demo/nested';
  }
}

@immutable
class NotLoggedInRedirectorRoute extends GoRouteData with $NotLoggedInRedirectorRoute {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Logged In Redirector')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('User is already logged in'),
            Text('This page is allowed to be accessed by logged in users'),
            IconButton(
              onPressed: () {
                context.read<AnyhooAuthCubit<ExampleUser>>().logout();
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final user = context.read<AnyhooAuthCubit<ExampleUser>>().state.user;
    if (user == null) {
      return '/login';
    }
    return null;
  }
}
