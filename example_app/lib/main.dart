import 'package:anyhoo_core/arguments_parser.dart';
import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_firebase/anyhoo_firebase.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/firebase_options.dart';
import 'package:example_app/models/example_user_converter.dart';
import 'package:example_app/routes/analytics_demo_route.dart';
import 'package:example_app/routes/auth_page_route.dart';
import 'package:example_app/routes/home_page_route.dart';
import 'package:example_app/routes/redirecting_demo_route.dart';
import 'package:example_app/routes/remote_config_demo_route.dart';
import 'package:example_app/routes/route_first_demo_route.dart';
import 'package:example_app/routes/route_nested_demo_route.dart';
import 'package:example_app/services/firebase_auth_service.dart' hide ExampleUserConverter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:logging/logging.dart';

import 'models/example_user.dart';
// import 'services/mock_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final str = '${record.loggerName}: ${record.level.name}: ${record.time}: ${record.message}';
    // ignore: avoid_print
    print('LOG: $str');
  });

  final arguments = await ArgumentsParser.getArguments();

  // final authService = createMockAuthService();
  final authService = await createFirebaseAuthService();
  final converter = ExampleUserConverter();
  final firebaseInitializer = FirebaseInitializer(arguments: arguments, hostIp: '192.168.86.27');
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
  final AnyhooAuthService authService;
  final AnyhooUserConverter<ExampleUser> converter;
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
    final routes = [
      HomePageRoute(arguments: arguments, firestore: firebaseInitializer.getFirestore()),
      AuthPageRoute(),
      RouteFirstDemoRoute(),
      RouteNestedDemoRoute(),
      RouteRedirectingDemoRoute(),
      AnalyticsDemoRoute(),
      RemoteConfigDemoRoute(),
    ];

    final appRouter = AnyhooRouter(routes: routes).getGoRouter();
    return BlocProvider(
      create: (_) => AnyhooAuthCubit<ExampleUser>(authService: authService, converter: converter),
      child: MaterialApp.router(title: 'Example app', routerConfig: appRouter),
    );
  }
}

enum AnyhooRouteName { home, auth, routeFirstDemo, routeNestedDemo, routeRedirectingDemo, analytics, remoteConfig }
