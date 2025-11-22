import 'package:anyhoo_core/models/arguments.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_launch_arguments/flutter_launch_arguments.dart';
import 'package:logging/logging.dart';

class ArgumentsParser {
  static final _log = Logger('ArgumentsParser');

  static Future<Arguments> getArguments() async {
    final fla = kIsWeb ? null : FlutterLaunchArguments();

    final arguments = Arguments(
      currentTime: await getCurrentTime(fla),
      location: await getLocation(fla),
      logoutAtStartup: await getLogoutAtStartup(fla),
      loginAtStartup: await getLoginAtStartup(fla),
      userEmail: await getUserEmail(fla),
      userPassword: await getUserPassword(fla),
      useFakeData: await getUseFakeData(fla),
      useFirebaseEmulator: await getUseFirebaseEmulator(fla),
      useFirebaseAnalytics: await getUseFirebaseAnalytics(fla),
    );
    _log.info('!! Arguments: $arguments');
    _log.info('!! shouldUseFirebaseEmulator(): ${arguments.shouldUseFirebaseEmulator()}');
    return arguments;
  }

  static Future<DateTime?> getCurrentTime(FlutterLaunchArguments? fla) async {
    final currentTimeString = await fla?.getString('currentTime');
    DateTime? currentTime = currentTimeString != null ? DateTime.tryParse(currentTimeString) : null;
    if (currentTime == null) {
      const tmp = String.fromEnvironment('CURRENT_TIME');
      if (tmp.isNotEmpty) {
        currentTime = DateTime.tryParse(tmp);
      }
    }
    return currentTime;
  }

  static Future<String?> getLocation(FlutterLaunchArguments? fla) async {
    var location = await fla?.getString('location');
    if (location == null) {
      const tmp = String.fromEnvironment('LOCATION');
      if (tmp.isNotEmpty) {
        location = tmp;
      }
    }
    return location;
  }

  static Future<bool> getLogoutAtStartup(FlutterLaunchArguments? fla) async {
    var logout = await fla?.getBool('logout') ?? false;
    if (logout == false) {
      const tmp = String.fromEnvironment('LOGOUT');
      if (tmp == 'true') {
        logout = true;
      }
    }
    return logout;
  }

  static Future<bool> getLoginAtStartup(FlutterLaunchArguments? fla) async {
    var login = await fla?.getBool('login') ?? false;
    if (login == false) {
      const tmp = String.fromEnvironment('LOGIN');
      if (tmp == 'true') {
        login = true;
      }
    }
    return login;
  }

  static Future<String?> getUserEmail(FlutterLaunchArguments? fla) async {
    var userEmail = await fla?.getString('userEmail');
    if (userEmail == null) {
      const tmp = String.fromEnvironment('USER_EMAIL');
      if (tmp.isNotEmpty) {
        userEmail = tmp;
      }
    }
    return userEmail;
  }

  static Future<String?> getUserPassword(FlutterLaunchArguments? fla) async {
    var userPassword = await fla?.getString('userPassword');
    if (userPassword == null) {
      const tmp = String.fromEnvironment('USER_PASSWORD');
      if (tmp.isNotEmpty) {
        userPassword = tmp;
      }
    }
    return userPassword;
  }

  static Future<bool> getUseFakeData(FlutterLaunchArguments? fla) async {
    var useFakeData = await fla?.getBool('useFakeData') ?? false;
    if (useFakeData == false) {
      const tmp = String.fromEnvironment('USE_FAKE_DATA');
      if (tmp.isNotEmpty) {
        useFakeData = tmp == 'true';
      }
    }
    return useFakeData;
  }

  static Future<bool?> getUseFirebaseEmulator(FlutterLaunchArguments? fla) async {
    var useFirebaseEmulator = await fla?.getBool('useFirebaseEmulator');
    if (useFirebaseEmulator == null) {
      const tmp = String.fromEnvironment('USE_FIREBASE_EMULATOR');
      if (tmp.isNotEmpty) {
        useFirebaseEmulator = tmp == 'true';
      }
    }
    return useFirebaseEmulator;
  }

  static Future<bool?> getUseFirebaseAnalytics(FlutterLaunchArguments? fla) async {
    var useFirebaseAnalytics = await fla?.getBool('useFirebaseAnalytics');
    if (useFirebaseAnalytics == null) {
      const tmp = String.fromEnvironment('USE_FIREBASE_ANALYTICS');
      if (tmp.isNotEmpty) {
        useFirebaseAnalytics = tmp == 'true';
      }
    }
    return useFirebaseAnalytics;
  }
}
