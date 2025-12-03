import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/routeDemo/route_nested_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNestedDemoRoute extends AnyhooRoute<AnyhooRouteName> {
  RouteNestedDemoRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder =>
      (context, state) => RouteNestedDemoPage();

  @override
  String get path => '/route-demo/nested';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.routeNestedDemo;

  @override
  String get title => 'Route Nested Demo';
}
