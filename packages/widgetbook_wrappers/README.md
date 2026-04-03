# widgetbook_wrappers

Helpers for [Widgetbook](https://www.widgetbook.io/) use cases: phone [DeviceFrame](https://pub.dev/packages/device_frame_plus), theme/orientation knobs, and a pluggable wrapper so apps can inject Bloc/repository/routing **outside** `MaterialApp`.

## Setup

Add the package (path, git, or published):

```yaml
dependencies:
  widgetbook_wrappers:
    path: ../flutter_platform_kit/packages/widgetbook_wrappers
```

Use a supported `widgetbook` range (see this package's `pubspec.yaml`).

## Usage

1. Create a [`WidgetbookThemeConfig`](lib/src/widgetbook_theme_config.dart) with your app themes.
2. Create a [`WidgetbookPhoneFrameConfig`](lib/src/widgetbook_phone_frame_config.dart) with the devices you want in the dropdown, or use [`WidgetbookPhoneFrameConfig.commonPhones()`](lib/src/widgetbook_phone_frame_config.dart).
3. Implement [`WidgetbookStoryWrapper`](lib/src/widgetbook_story_wrapper.dart) once per app (e.g. `MultiBlocProvider` / `MultiRepositoryProvider` around the shell output).
4. Build a [`WidgetbookStoryShell`](lib/src/widgetbook_story_shell.dart) and call `wrapPhoneStory` or `wrapSimpleStory` from your use-case builder.

Example:

```dart
final shell = WidgetbookStoryShell(
  theme: WidgetbookThemeConfig(
    light: ThemeData.light(),
    dark: ThemeData.dark(),
  ),
  phone: WidgetbookPhoneFrameConfig.commonPhones(),
  wrapper: MyAppWidgetbookWrapper(),
);

@widgetbook.UseCase(...)
Widget buildMyScreen(BuildContext context) {
  return shell.wrapPhoneStory(context, const MyScreen());
}
```

`wrapSimpleStory` uses a padded `Scaffold` body without a device frame (good for small components).

### Wrapper placement and GoRouter

[`WidgetbookStoryShell.wrapPhoneStory`](lib/src/widgetbook_story_shell.dart) builds `DeviceFrame` → `MaterialApp` → `home: your story`. The wrapper receives that **whole** subtree so you can place providers **outside** `MaterialApp`, consistent with many Flutter apps.

If you need `MaterialApp.router` and GoRouter, implement the wrapper so it returns your router shell **instead** of only wrapping with providers: for example, your wrapper can replace the inner `MaterialApp` by building `MaterialApp.router` yourself and passing the story as the initial route child—but that duplicates shell logic. A practical approach is to keep the story as a normal widget under `MaterialApp(home: …)` and only add GoRouter when the widget under test requires it (e.g. a small `MaterialApp.router` **inside** the story). Prefer the smallest router scope that satisfies the widget.

## Exports

The library also exports `DeviceInfo`, `Devices`, and `DeviceFrame` from `device_frame_plus` for configuring [`WidgetbookDeviceOption`](lib/src/widgetbook_device_option.dart).

## Additional information

Part of [flutter_platform_kit](https://anyhoosolutions.web.app/documentation/flutter_platform_kit).
