import 'package:anyhoo_auth/anyhoo_auth.dart';
import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_firebase/anyhoo_firebase.dart';
import 'package:example_app/firebase_options.dart';
import 'package:example_app/models/example_user.dart';

/// Creates a mock AuthService for demonstration purposes.
///
/// In a real app, this would make actual API calls.
Future<AuthService> createFirebaseAuthService() async {
  FirebaseInitializer firebaseInitializer = FirebaseInitializer(arguments: Arguments(), hostIp: '192.168.87.21');
  await firebaseInitializer.initialize(DefaultFirebaseOptions.currentPlatform);
  return FirebaseAuthService(converter: ExampleUserConverter(), firebaseAuth: firebaseInitializer.getAuth());
}

class ExampleUserConverter implements UserConverter<ExampleUser> {
  @override
  ExampleUser fromJson(Map<String, dynamic> json) {
    return ExampleUser.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ExampleUser user) {
    return user.toJson();
  }
}
