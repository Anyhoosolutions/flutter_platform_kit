import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/models/example_user.dart';
import 'package:example_app/models/example_user_converter.dart';
import 'package:example_app/pages/enhanceUserDemo/enhance_user_demo_page.dart';
import 'package:example_app/services/mock_auth_service.dart';
import 'package:example_app/services/mock_enhance_user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EnhanceUserDemoPageRoute extends AnyhooRoute<AnyhooRouteName> {
  EnhanceUserDemoPageRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder => (context, state) {
    return BlocProvider(
      create: (_) => AnyhooAuthCubit<ExampleUser>(
        authService: createMockAuthService(),
        converter: ExampleUserConverter(),
        enhanceUserService: createMockEnhanceUserService(),
      ),
      child: EnhanceUserDemoPage(),
    );
  };

  @override
  String get path => '/enhance-user';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.enhanceUser;

  @override
  String get title => 'Enhance User';
}
