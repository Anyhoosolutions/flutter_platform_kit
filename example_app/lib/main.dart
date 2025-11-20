import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anyhoo_auth/anyhoo_auth.dart';

import 'models/example_user.dart';
import 'services/mock_auth_service.dart';
import 'pages/home_page.dart';

void main() {
  // Set up the auth service with mock implementation
  final authService = createMockAuthService();

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService<ExampleUser> authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit<ExampleUser>(authService: authService),
      child: MaterialApp(
        title: 'Anyhoo Packages Example',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
        home: const HomePage(),
      ),
    );
  }
}
