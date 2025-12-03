import 'package:anyhoo_core/arguments_parser.dart';
import 'package:anyhoo_core/models/anyhoo_user.dart';
import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_firebase/anyhoo_firebase.dart';
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/firebase_options.dart';
import 'package:example_app/models/example_user_converter.dart';
import 'package:example_app/pages/analyticsDemo/analytics_demo_route.dart';
import 'package:example_app/pages/argumentsDemo/arguments_demo_page_route.dart';
import 'package:example_app/pages/authDemo/auth_page_route.dart';
import 'package:example_app/pages/enhanceUserDemo/enhance_user_demo_page_route.dart';
import 'package:example_app/pages/errorPageDemo/error_page_demo_page_route.dart';
import 'package:example_app/pages/firestoreDemo/firestore_demo_page_route.dart';
import 'package:example_app/pages/homePage/home_page_route.dart';
import 'package:example_app/pages/imageSelectorDemo/image_selector_page_route.dart';
import 'package:example_app/pages/loggingPage/logging_page_route.dart';
import 'package:example_app/pages/login/login_route.dart';
import 'package:example_app/pages/routeDemo/redirecting_demo_route.dart';
import 'package:example_app/pages/remoteConfigDemo/remote_config_demo_route.dart';
import 'package:example_app/pages/routeDemo/route_first_demo_route.dart';
import 'package:example_app/pages/routeDemo/route_nested_demo_route.dart';
import 'package:example_app/pages/waitingPageDemo/waiting_page_demo_page_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:logging/logging.dart';

import 'models/example_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final loggingCubit = LoggingCubit(maxLogs: 10);
  final loggingConfiguration = LoggingConfiguration(
    logLevel: kDebugMode ? Level.ALL : Level.WARNING,
    loggersAtInfo: [],
    loggersAtWarning: [],
    loggersAtSevere: [],
    loggingCubit: loggingCubit,
  );

  final arguments = await ArgumentsParser.getArguments();

  final firebaseInitializer = FirebaseInitializer(arguments: arguments, hostIp: '192.168.86.27');
  await firebaseInitializer.initialize(DefaultFirebaseOptions.currentPlatform);

  runApp(
    MyApp(arguments: arguments, firebaseInitializer: firebaseInitializer, loggingConfiguration: loggingConfiguration),
  );
}

class MyApp extends StatelessWidget {
  final Arguments arguments;
  final FirebaseInitializer firebaseInitializer;
  final LoggingConfiguration loggingConfiguration;

  const MyApp({
    super.key,
    required this.arguments,
    required this.firebaseInitializer,
    required this.loggingConfiguration,
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
      LoggingPageRoute(),
      ImageSelectorPageRoute(),
      EnhanceUserDemoPageRoute(),
      ArgumentsDemoPageRoute(),
      FirestoreDemoPageRoute(),
      ErrorPageDemoPageRoute(),
      WaitingPageDemoPageRoute(),
      LoginRoute(),
    ];

    final converter = ExampleUserConverter();
    final AnyhooAuthService authService = AnyhooFirebaseAuthService(
      converter: converter,
      firebaseAuth: firebaseInitializer.getAuth(),
    );

    final appRouter = AnyhooRouter(routes: routes).getGoRouter();

    return RepositoryProvider<LoggingConfiguration>(
      create: (context) => loggingConfiguration,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => loggingConfiguration.loggingCubit!),
          BlocProvider(
            create: (_) => AnyhooAuthCubit<AnyhooUser>(authService: authService, converter: converter),
          ),
        ],
        child: MaterialApp.router(title: 'Example app', routerConfig: appRouter),
      ),
    );
  }
}

enum AnyhooRouteName {
  home,
  auth,
  routeFirstDemo,
  routeNestedDemo,
  routeRedirectingDemo,
  analytics,
  remoteConfig,
  logging,
  imageSelector,
  enhanceUser,
  arguments,
  firestore,
  error,
  waiting,
  login,
}
