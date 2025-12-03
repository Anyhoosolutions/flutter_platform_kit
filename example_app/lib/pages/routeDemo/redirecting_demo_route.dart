import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/routeDemo/route_nested_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteRedirectingDemoRoute extends AnyhooRoute<AnyhooRouteName> {
  RouteRedirectingDemoRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder =>
      (context, state) => RouteNestedDemoPage();

  @override
  String get path => '/route-demo/redirecting';

  @override
  String? get redirect => 'route-demo/nested';

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.routeRedirectingDemo;

  @override
  String get title => 'Route Nested Demo';
}
