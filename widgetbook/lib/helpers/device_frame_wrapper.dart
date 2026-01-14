// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'device_frame_widget.dart';

class DeviceFrameWrapper {
  static Widget wrapInDeviceFrame(BuildContext context, Widget child) {
    final deviceTypeSelection = context.knobs.list(
      label: 'Device type',
      options: Devices.all.map((e) => e.name).toList(),
      // initialOption: Devices.ios.iPadAir4.name,
    );
    final deviceType = Devices.all.firstWhere((e) => e.name == deviceTypeSelection);

    // Add language selection knob
    // final languageSelection = context.knobs.list(
    //   label: 'Language',
    //   options: AppLocalizations.supportedLocales.map((locale) => locale.languageCode).toList(),
    // );
    // final selectedLocale = AppLocalizations.supportedLocales.firstWhere(
    //   (locale) => locale.languageCode == languageSelection,
    // );

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

    final colorSchemeOptions = {
      'red': ColorScheme.fromSeed(seedColor: Colors.red),
      'green': ColorScheme.fromSeed(seedColor: Colors.green),
      'purple': ColorScheme.fromSeed(seedColor: Colors.purple),
      'lightblue': ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      'brown': ColorScheme.fromSeed(
        seedColor: Colors.brown,
        onPrimaryContainer: Colors.blue,
        surface: Colors.brown[100],
        onSurface: Colors.green,
      ),
    };
    final colorSchemeSelection = context.knobs.list(
      label: 'Color scheme',
      options: colorSchemeOptions.keys.toList(),
      initialOption: 'brown',
    );
    final colorScheme = colorSchemeOptions[colorSchemeSelection];

    final themeData = ThemeData.from(colorScheme: colorScheme ?? ColorScheme.fromSeed(seedColor: Colors.blue));

    return DeviceFrameWidget(
      deviceType: deviceType,
      orientation: orientation,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData,
        // darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
        // locale: selectedLocale,
        home: Scaffold(body: child),
      ),
    );
  }
}
