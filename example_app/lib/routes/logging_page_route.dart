import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/logging_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoggingPageRoute extends AnyhooRoute<AnyhooRouteName> {
  LoggingPageRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder =>
      (context, state) => LoggingPage();

  @override
  String get path => '/logging';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.logging;

  @override
  String get title => 'Logging';
}
