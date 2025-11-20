import 'dart:io';

import 'package:flutter/foundation.dart';

enum PlatformType { web, android, ios, linux, windows, macos, fuchsia }

class OSTool {
  OSTool._();

  static const bool isWeb = kIsWeb;

  static final bool isAndroid = !isWeb && Platform.isAndroid;
  static final bool isIOS = !isWeb && Platform.isIOS;
  static final bool isLinux = !isWeb && Platform.isLinux;
  static final bool isWindows = !isWeb && Platform.isWindows;
  static final bool isMacOS = !isWeb && Platform.isMacOS;
  static final bool isFuchsia = !isWeb && Platform.isFuchsia;

  static PlatformType getPlatformType() {
    if (isWeb) {
      return PlatformType.web;
    }
    if (Platform.isAndroid) {
      return PlatformType.android;
    }
    if (Platform.isIOS) {
      return PlatformType.ios;
    }
    if (Platform.isLinux) {
      return PlatformType.linux;
    }
    if (Platform.isWindows) {
      return PlatformType.windows;
    }
    if (Platform.isMacOS) {
      return PlatformType.macos;
    }
    if (Platform.isFuchsia) {
      return PlatformType.fuchsia;
    }
    throw UnimplementedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  static String? getEnvironmentVariable(String key) {
    if (isWeb) {
      return null;
    }
    return Platform.environment[key];
  }

  static bool hasEnvironmentVariable(String key) {
    return getEnvironmentVariable(key) != null;
  }
}
