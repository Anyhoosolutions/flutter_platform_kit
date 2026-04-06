import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_wrappers/src/widgetbook_widget_frame_config.dart';
import 'package:widgetbook_wrappers/src/widgetbook_widget_frame_option.dart';

import 'widgetbook_phone_frame_config.dart';
import 'widgetbook_simple_story_config.dart';
import 'widgetbook_story_wrapper.dart';
import 'widgetbook_theme_config.dart';

/// Builds themed [MaterialApp] shells with Widgetbook knobs, optional device
/// frame, and a pluggable [WidgetbookStoryWrapper].
class WidgetbookStoryShell {
  WidgetbookStoryShell({
    required this.theme,
    required this.phone,
    this.simple = const WidgetbookSimpleStoryConfig(),
    this.wrapper = const IdentityWidgetbookStoryWrapper(),
    WidgetbookWidgetFrameConfig? widgetFrameConfig,
  }) : _widgetFrameConfig = widgetFrameConfig ?? WidgetbookWidgetFrameConfig.allFrames();

  final WidgetbookThemeConfig theme;
  final WidgetbookPhoneFrameConfig phone;
  final WidgetbookSimpleStoryConfig simple;
  final WidgetbookStoryWrapper wrapper;
  final WidgetbookWidgetFrameConfig _widgetFrameConfig;

  /// Device frame + theme/orientation knobs; [wrapper] wraps the full
  /// `DeviceFrame` → `MaterialApp` subtree (providers usually go here).
  Widget wrapPhoneStory(BuildContext context, Widget child) {
    final themeMode = _readThemeMode(context);
    final device = _readDevice(context);
    final orientation = _readOrientation(context);

    final materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: themeMode,
      home: child,
    );

    final framed = DeviceFrame(
      device: device,
      orientation: orientation,
      isFrameVisible: phone.showFrame,
      screen: materialApp,
    );

    return wrapper.wrap(context, framed);
  }

  /// Full-screen [MaterialApp] with padded [Scaffold] body; no frame.
  Widget wrapSimpleStory(BuildContext context, Widget child) {
    final themeMode = _readThemeMode(context);
    final widgetFrame = _readWidgetFrame(context);
    final currentTheme = themeMode == ThemeMode.light ? theme.light : theme.dark;

    final Widget framedChild = SizedBox(
      width: widgetFrame.width,
      height: widgetFrame.height,
      child: Material(
        color: currentTheme.scaffoldBackgroundColor,
        child: simple.centerBody ? Center(child: child) : child,
      ),
    );

    final Widget body = ColoredBox(
      color: widgetFrame.backgroundColor,
      child: Center(
        child: Padding(padding: EdgeInsets.all(16), child: framedChild),
      ),
    );

    final materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      darkTheme: theme.dark,
      themeMode: themeMode,
      home: Scaffold(body: body),
    );

    return wrapper.wrap(context, materialApp);
  }

  Widget wrapDesignSystemStory(BuildContext context, Widget child) {
    final themeMode = _readThemeMode(context);

    final materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: themeMode,
      home: child,
    );

    return wrapper.wrap(context, materialApp);
  }

  ThemeMode _readThemeMode(BuildContext context) {
    if (!theme.enableThemeKnob) {
      return theme.initialThemeMode;
    }
    return context.knobs.object.dropdown<ThemeMode>(
      label: theme.themeKnobLabel,
      options: const [ThemeMode.light, ThemeMode.dark, ThemeMode.system],
      initialOption: theme.initialThemeMode,
      labelBuilder: _themeModeLabel,
    );
  }

  static String _themeModeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }

  DeviceInfo _readDevice(BuildContext context) {
    final labels = phone.devices.map((e) => e.label).toList();
    final initial = phone.resolveInitialDeviceLabel();
    final selected = context.knobs.object.dropdown<String>(
      label: phone.deviceKnobLabel,
      options: labels,
      initialOption: initial,
    );
    return phone.devices.firstWhere((e) => e.label == selected).device;
  }

  Orientation _readOrientation(BuildContext context) {
    if (!phone.enableOrientationKnob) {
      return phone.fixedOrientation;
    }
    return context.knobs.object.dropdown<Orientation>(
      label: phone.orientationKnobLabel,
      options: const [Orientation.portrait, Orientation.landscape],
      initialOption: Orientation.portrait,
      labelBuilder: _orientationLabel,
    );
  }

  static String _orientationLabel(Orientation o) {
    return switch (o) {
      Orientation.portrait => 'portrait',
      Orientation.landscape => 'landscape',
    };
  }

  WidgetFrameSize _readWidgetFrame(BuildContext context) {
    final labels = _widgetFrameConfig.widgetFrames.map((e) => e.name).toList();
    final initial = _widgetFrameConfig.resolveInitialDeviceLabel();
    final selected = context.knobs.object.dropdown<String>(
      label: _widgetFrameConfig.widgetFrameKnobLabel,
      options: labels,
      initialOption: initial,
    );
    if (selected == customWidgetFrameLabel) {
      final w = context.knobs.int.slider(label: 'Width', initialValue: 800, min: 100, max: 1000);
      final h = context.knobs.int.slider(label: 'Height', initialValue: 500, min: 100, max: 1000);
      return WidgetFrameSize(name: customWidgetFrameLabel, width: w.toDouble(), height: h.toDouble());
    }
    return _widgetFrameConfig.widgetFrames.firstWhere((e) => e.name == selected);
  }
}
