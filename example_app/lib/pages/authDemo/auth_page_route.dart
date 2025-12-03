import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/authDemo/auth_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthPageRoute extends AnyhooRoute<AnyhooRouteName> {
  AuthPageRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder =>
      (context, state) => AuthDemoPage();

  @override
  String get path => '/auth';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.auth;

  @override
  String get title => 'Auth';
}
