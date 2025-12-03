import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/errorPageDemo/error_page_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPageDemoPageRoute extends AnyhooRoute<AnyhooRouteName> {
  ErrorPageDemoPageRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder => (context, state) {
    return ErrorPageDemoPage();
  };

  @override
  String get path => '/error';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.error;

  @override
  String get title => 'Error';
}
