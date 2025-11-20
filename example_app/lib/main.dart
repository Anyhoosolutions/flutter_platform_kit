import 'package:anyhoo_core/arguments_parser.dart';
import 'package:example_app/models/example_user_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anyhoo_auth/anyhoo_auth.dart';

import 'models/example_user.dart';
import 'services/mock_auth_service.dart';
import 'pages/home_page.dart';

void main() {
  // Set up the auth service with mock implementation
  final authService = createMockAuthService();
  final converter = ExampleUserConverter();

  runApp(MyApp(authService: authService, converter: converter));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final UserConverter<ExampleUser> converter;

  const MyApp({super.key, required this.authService, required this.converter});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ArgumentsParser.getArguments(),
      builder: (context, snapshot) {
        final arguments = snapshot.data;
        if (arguments == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return BlocProvider(
          create: (_) => AuthCubit<ExampleUser>(authService: authService, converter: converter),
          child: MaterialApp(
            title: 'Anyhoo Packages Example',
            theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
            home: HomePage(arguments: arguments),
          ),
        );
      },
    );
  }
}
