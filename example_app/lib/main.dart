import 'package:anyhoo_core/arguments_parser.dart';
import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_firebase/anyhoo_firebase.dart';
import 'package:example_app/firebase_options.dart';
import 'package:example_app/models/example_user_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:logging/logging.dart';

import 'models/example_user.dart';
import 'services/mock_auth_service.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final str = '${record.loggerName}: ${record.level.name}: ${record.time}: ${record.message}';
    // ignore: avoid_print
    print('LOG: $str');
  });

  final arguments = await ArgumentsParser.getArguments();

  final authService = createMockAuthService();
  final converter = ExampleUserConverter();
  print('!! arguments: $arguments');
  final firebaseInitializer = FirebaseInitializer(arguments: arguments, hostIp: '192.168.87.21');
  print('!! firebaseInitializer: $firebaseInitializer');
  await firebaseInitializer.initialize(DefaultFirebaseOptions.currentPlatform);

  runApp(
    MyApp(
      authService: authService,
      converter: converter,
      arguments: arguments,
      firebaseInitializer: firebaseInitializer,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final UserConverter<ExampleUser> converter;
  final Arguments arguments;
  final FirebaseInitializer firebaseInitializer;

  const MyApp({
    super.key,
    required this.authService,
    required this.converter,
    required this.arguments,
    required this.firebaseInitializer,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit<ExampleUser>(authService: authService, converter: converter),
      child: MaterialApp(
        title: 'Anyhoo Packages Example',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
        home: HomePage(arguments: arguments, firestore: firebaseInitializer.getFirestore()),
      ),
    );
  }
}
