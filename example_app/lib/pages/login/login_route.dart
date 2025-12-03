import 'package:anyhoo_auth/widgets/login_widget.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/models/example_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginRoute extends AnyhooRoute<AnyhooRouteName> {
  LoginRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder =>
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: LoginWidget<ExampleUser>(title: 'Example app', assetLogoPath: 'assets/images/logo.webp'),
      );

  @override
  String get path => '/login';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.login;

  @override
  String get title => 'Login';
}
