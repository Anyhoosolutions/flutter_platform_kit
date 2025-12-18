import 'package:anyhoo_core/arguments_parser.dart';
import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_firebase/anyhoo_firebase.dart';
import 'package:anyhoo_logging/anyhoo_logging.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/firebase_options.dart';
import 'package:example_app/models/example_user_converter.dart';
import 'package:example_app/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:logging/logging.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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

  final emulatorConfig = EmulatorConfig(hostIp: 'localhost', authPort: 21201, firestorePort: 21203, storagePort: 21204);
  final firebaseInitializer = FirebaseInitializer(arguments: arguments, emulatorConfig: emulatorConfig);
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
    final converter = ExampleUserConverter();
    final AnyhooAuthService authService = AnyhooFirebaseAuthService(firebaseAuth: firebaseInitializer.getAuth());

    final appRouter = AnyhooRouter(routes: $appRoutes).getGoRouter();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LoggingConfiguration>(create: (context) => loggingConfiguration),
        RepositoryProvider<Arguments>(create: (context) => arguments),
        RepositoryProvider<FirebaseFirestore>(create: (context) => firebaseInitializer.getFirestore()),
        RepositoryProvider<firebase_auth.FirebaseAuth>(create: (context) => firebaseInitializer.getAuth()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => loggingConfiguration.loggingCubit!),
          BlocProvider<AnyhooAuthCubit<ExampleUser>>(
            create: (_) => AnyhooAuthCubit<ExampleUser>(
              authService: authService,
              converter: converter,
              enhanceUserServices: [
                AnyhooFirebaseEnhanceUserService(path: 'users', firestore: firebaseInitializer.getFirestore()),
                PhoneNumberEnhanceUserService(),
              ],
            ),
          ),
        ],
        child: MaterialApp.router(title: 'Example app', routerConfig: appRouter),
      ),
    );
  }
}

class PhoneNumberEnhanceUserService extends AnyhooEnhanceUserService<ExampleUser> {
  @override
  Future<Map<String, dynamic>> enhanceUser(Map<String, dynamic> user) async {
    return {...user, 'phoneNumber': 2125551234};
  }

  @override
  Future<ExampleUser> saveUser(ExampleUser user) {
    throw UnimplementedError();
  }
}
