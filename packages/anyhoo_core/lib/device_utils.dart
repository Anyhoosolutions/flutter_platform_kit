import 'package:flutter/material.dart';

enum DeviceType { phonePortrait, phoneLandscape, tabletPortrait, tabletLandscape }

class DeviceUtils {
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    // You can adjust this threshold based on your application's needs.
    // 600dp is a widely accepted threshold for distinguishing tablets.
    const tabletThreshold = 600;
    return shortestSide >= tabletThreshold;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static DeviceType getDeviceType(BuildContext context) {
    if (isTablet(context)) {
      return isPortrait(context) ? DeviceType.tabletPortrait : DeviceType.tabletLandscape;
    }
    return isPortrait(context) ? DeviceType.phonePortrait : DeviceType.phoneLandscape;
  }
}
