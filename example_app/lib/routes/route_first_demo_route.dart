import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/route_first_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteFirstDemoRoute extends AnyhooRoute<AnyhooRouteName> {
  RouteFirstDemoRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder =>
      (context, state) => RouteFirstDemoPage();

  @override
  String get path => '/route-demo';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.routeFirstDemo;

  @override
  String get title => 'Route First Demo';
}
