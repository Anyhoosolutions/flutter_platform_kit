// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/anyhoo_design_system/showcase_themes.dart';
import 'package:widgetbook_workspace/helpers/device_frame_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Device-frame wrapper for `anyhoo_design_system` showcases.
///
/// Keeps the usual device / orientation / theme-mode knobs and adds a
/// dropdown to switch between default and custom Anyhoo themes.
class DesignSystemDeviceFrameWrapper {
  static Widget wrapInDeviceFrame(BuildContext context, Widget child) {
    final deviceTypeSelection = context.knobs.list(
      label: 'Device type',
      options: Devices.all.map((e) => e.name).toList(),
    );
    final deviceType = Devices.all.firstWhere((e) => e.name == deviceTypeSelection);

    final themeModeSelection = context.knobs.list(
      label: 'Theme mode',
      options: ThemeMode.values.map((e) => e.name).toList(),
      initialOption: ThemeMode.light.name,
    );
    final themeMode = ThemeMode.values.firstWhere((e) => e.name == themeModeSelection);

    final orientationSelection = context.knobs.list(
      label: 'Orientation',
      options: ['portrait', 'landscape'],
      initialOption: 'portrait',
    );
    final orientation = orientationSelection == 'portrait' ? Orientation.portrait : Orientation.landscape;

    final themeSelection = context.knobs.list(
      label: 'Anyhoo theme',
      options: ShowcaseThemeOption.values.map((e) => e.label).toList(),
      initialOption: ShowcaseThemeOption.defaults.label,
    );
    final showcaseTheme = ShowcaseThemeOption.fromLabel(themeSelection);

    return DeviceFrameWidget(
      deviceType: deviceType,
      orientation: orientation,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: showcaseTheme.lightTheme(),
        darkTheme: showcaseTheme.darkTheme(),
        localizationsDelegates: [
          // AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('sv')],
        themeMode: themeMode,
        home: Scaffold(body: child),
      ),
    );
  }
}
