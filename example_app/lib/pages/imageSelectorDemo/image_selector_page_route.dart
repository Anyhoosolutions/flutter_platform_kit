import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:anyhoo_auth/widgets/login_widget.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/models/example_user.dart';
import 'package:example_app/models/example_user_converter.dart';
import 'package:example_app/services/mock_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ImageSelectorPageRoute extends AnyhooRoute<AnyhooRouteName> {
  ImageSelectorPageRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder => (context, state) {
    // return ImageSelectorDemoPage();

    final authService = createMockAuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Widget Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocProvider<AnyhooAuthCubit<ExampleUser>>(
        create: (_) => AnyhooAuthCubit<ExampleUser>(authService: authService, converter: ExampleUserConverter()),
        child: LoginWidget(title: 'Example app', assetLogoPath: 'assets/images/logo.webp'),
      ),
    );
  };

  @override
  String get path => '/image-selector';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.imageSelector;

  @override
  String get title => 'Image Selector';
}
