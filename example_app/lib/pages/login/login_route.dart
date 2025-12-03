import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_auth/widgets/login_widget.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/models/example_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginRoute extends AnyhooRoute<AnyhooRouteName> {
  LoginRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder => (context, state) {
    // Get the cubit from the provider tree using the concrete type
    final cubit = context.read<AnyhooAuthCubit<ExampleUser>>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: LoginWidget<ExampleUser>(title: 'Example app', assetLogoPath: 'assets/images/logo.webp', cubit: cubit),
    );
  };

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
