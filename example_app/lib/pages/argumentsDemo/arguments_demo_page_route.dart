import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/argumentsDemo/arguments_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ArgumentsDemoPageRoute extends AnyhooRoute<AnyhooRouteName> {
  ArgumentsDemoPageRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder => (context, state) {
    return ArgumentsDemoPage(arguments: state.extra as Arguments);
  };

  @override
  String get path => '/arguments';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.arguments;

  @override
  String get title => 'Arguments';
}
