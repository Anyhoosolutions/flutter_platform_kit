import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'widgetbook_phone_frame_config.dart';
import 'widgetbook_runtime.dart';
import 'widgetbook_story_definition.dart';
import 'widgetbook_theme_config.dart';
import 'widgetbook_widget_frame_config.dart';
import 'widgetbook_widget_frame_option.dart';

typedef WidgetbookAppHostBuilder = Widget Function(
  BuildContext context,
  Widget child,
  WidgetbookStoryRuntime runtime,
);
typedef WidgetbookDependencyWrapper = Widget Function(
  BuildContext context,
  Widget child,
  WidgetbookStoryRuntime runtime,
);

class WidgetbookStoryRenderer {
  WidgetbookStoryRenderer({
    required this.theme,
    required this.phone,
    WidgetbookWidgetFrameConfig? widgetFrame,
    this.appHostBuilder,
    this.dependencyWrapper,
    this.dependencies = const WidgetbookDependencyRegistry(),
    this.isWebKnobLabel = 'Is web',
    this.isWebInitialValue = false,
    this.widgetPadding = const EdgeInsets.all(16),
    this.widgetCenterChild = true,
  }) : widgetFrame = widgetFrame ?? WidgetbookWidgetFrameConfig.allFrames();

  final WidgetbookThemeConfig theme;
  final WidgetbookPhoneFrameConfig phone;
  final WidgetbookWidgetFrameConfig widgetFrame;
  final WidgetbookAppHostBuilder? appHostBuilder;
  final WidgetbookDependencyWrapper? dependencyWrapper;
  final WidgetbookDependencyRegistry dependencies;
  final String isWebKnobLabel;
  final bool isWebInitialValue;
  final EdgeInsets widgetPadding;
  final bool widgetCenterChild;

  Widget build(BuildContext context, WidgetbookStoryDefinition story) {
    final themeMode = _readThemeMode(context);
    final isWeb = readWidgetbookIsWebKnob(
      context,
      knobLabel: isWebKnobLabel,
      initialValue: isWebInitialValue,
    );
    final dependencyMap = dependencies.create(context, story);
    final device =
        story.type == WidgetbookStoryType.phone ? _readDevice(context) : null;
    final orientation = story.type == WidgetbookStoryType.phone
        ? _readOrientation(context)
        : null;
    final widgetFrameOption = story.type == WidgetbookStoryType.widget
        ? _readWidgetFrame(context)
        : null;

    final child = story.builder(
      context,
      WidgetbookStoryRuntime(
        context: context,
        story: story,
        themeMode: themeMode,
        isWeb: isWeb,
        content: const SizedBox.shrink(),
        device: device,
        orientation: orientation,
        widgetFrame: widgetFrameOption,
        dependencies: dependencyMap,
      ),
    );

    final content = switch (story.type) {
      WidgetbookStoryType.phone => _buildPhoneContent(
        child: child,
        themeMode: themeMode,
        device: device!,
        orientation: orientation!,
      ),
      WidgetbookStoryType.widget => _buildWidgetContent(
        child: child,
        themeMode: themeMode,
        frameOption: widgetFrameOption!,
      ),
      WidgetbookStoryType.designSystem => _buildDesignSystemContent(
        child: child,
        themeMode: themeMode,
      ),
      WidgetbookStoryType.custom => child,
    };

    final runtime = WidgetbookStoryRuntime(
      context: context,
      story: story,
      themeMode: themeMode,
      isWeb: isWeb,
      content: content,
      device: device,
      orientation: orientation,
      widgetFrame: widgetFrameOption,
      dependencies: dependencyMap,
    );

    var result = appHostBuilder?.call(context, content, runtime) ?? content;
    for (final providerSpec in dependencies.providers.reversed) {
      final value = dependencyMap[providerSpec.type];
      if (value != null) {
        result = providerSpec.wrap(result, value);
      }
    }
    result = dependencyWrapper?.call(context, result, runtime) ?? result;
    return result;
  }

  ThemeMode _readThemeMode(BuildContext context) {
    if (!theme.enableThemeKnob) {
      return theme.initialThemeMode;
    }
    return context.knobs.object.dropdown<ThemeMode>(
      label: theme.themeKnobLabel,
      options: const [ThemeMode.light, ThemeMode.dark, ThemeMode.system],
      initialOption: theme.initialThemeMode,
      labelBuilder: (mode) => mode.name,
    );
  }

  Widget _buildPhoneContent({
    required Widget child,
    required ThemeMode themeMode,
    required DeviceInfo device,
    required Orientation orientation,
  }) {
    return DeviceFrame(
      device: device,
      orientation: orientation,
      isFrameVisible: phone.showFrame,
      screen: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.light,
        darkTheme: theme.dark,
        themeMode: themeMode,
        home: child,
      ),
    );
  }

  Widget _buildWidgetContent({
    required Widget child,
    required ThemeMode themeMode,
    required WidgetFrameSizeOption frameOption,
  }) {
    final currentTheme = themeMode == ThemeMode.light ? theme.light : theme.dark;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: themeMode,
      home: Scaffold(
        body: ColoredBox(
          color: frameOption.backgroundColor,
          child: Center(
            child: Padding(
              padding: widgetPadding,
              child: SizedBox(
                width: frameOption.width,
                height: frameOption.height,
                child: Material(
                  color: currentTheme.scaffoldBackgroundColor,
                  child: widgetCenterChild ? Center(child: child) : child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesignSystemContent({
    required Widget child,
    required ThemeMode themeMode,
  }) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: themeMode,
      home: child,
    );
  }

  DeviceInfo _readDevice(BuildContext context) {
    final labels = phone.devices.map((e) => e.label).toList(growable: false);
    final selected = context.knobs.object.dropdown<String>(
      label: phone.deviceKnobLabel,
      options: labels,
      initialOption: phone.resolveInitialDeviceLabel(),
    );
    return phone.devices.firstWhere((device) => device.label == selected).device;
  }

  Orientation _readOrientation(BuildContext context) {
    if (!phone.enableOrientationKnob) {
      return phone.fixedOrientation;
    }
    return context.knobs.object.dropdown<Orientation>(
      label: phone.orientationKnobLabel,
      options: const [Orientation.portrait, Orientation.landscape],
      initialOption: Orientation.portrait,
      labelBuilder: (o) => o.name,
    );
  }

  WidgetFrameSizeOption _readWidgetFrame(BuildContext context) {
    final availableSizes = widgetFrame.widgetFrames;
    final selected = context.knobs.object.dropdown<WidgetFrameSize>(
      label: widgetFrame.widgetFrameKnobLabel,
      options: availableSizes,
      initialOption: widgetFrame.resolveInitialWidgetFrame(),
      labelBuilder: (size) => fromWidgetFrameSize(size).name,
    );
    if (selected == WidgetFrameSize.custom) {
      final width = context.knobs.int.slider(
        label: 'Width',
        initialValue: 800,
        min: 100,
        max: 2000,
      );
      final height = context.knobs.int.slider(
        label: 'Height',
        initialValue: 500,
        min: 100,
        max: 2000,
      );
      return WidgetFrameSizeOption(
        name: fromWidgetFrameSize(WidgetFrameSize.custom).name,
        width: width.toDouble(),
        height: height.toDouble(),
      );
    }
    return fromWidgetFrameSize(selected);
  }
}
