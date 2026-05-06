# widgetbook_wrappers

Simple, script-friendly wrappers for Widgetbook stories.

The API is centered around a single list of `WidgetbookStoryDefinition` values.
Each story includes machine-readable metadata (`id`, `type`, `tags`, `group`) so a
third-party repo can discover what to screenshot by reading source code.

## Setup

```yaml
dependencies:
  widgetbook_wrappers:
    path: ../flutter_platform_kit/packages/widgetbook_wrappers
```

## Consumer API (repo using this package)

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_wrappers/widgetbook_wrappers.dart';

final stories = <WidgetbookStoryDefinition>[
  WidgetbookStoryDefinition.phone(
    id: 'home.page',
    name: 'HomePage',
    tags: ['page', 'smoke'],
    group: 'home',
    builder: (context, runtime) => const HomePage(),
  ),
  WidgetbookStoryDefinition.widget(
    id: 'buttons.primary',
    name: 'PrimaryButton',
    tags: ['widget', 'ui'],
    group: 'design_system',
    builder: (context, runtime) => const PrimaryButton(),
  ),
  WidgetbookStoryDefinition.designSystem(
    id: 'design-system.colors',
    name: 'DesignSystemColorsPage',
    tags: ['design-system'],
    group: 'design_system',
    builder: (context, runtime) => const DesignSystemColorsPage(),
  ),
  WidgetbookStoryDefinition.custom(
    id: 'checkout.flow',
    name: 'CheckoutFlow',
    customTypeLabel: 'app-flow',
    tags: ['custom', 'checkout'],
    builder: (context, runtime) => const CheckoutFlowPreview(),
  ),
];

final renderer = WidgetbookStoryRenderer(
  theme: WidgetbookThemeConfig(
    light: ThemeData.light(),
    dark: ThemeData.dark(),
  ),
  phone: WidgetbookPhoneFrameConfig.commonDevices(),
  appHostBuilder: (context, child, runtime) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: buildWidgetbookRouter(child),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: runtime.themeMode,
    );
  },
  dependencyWrapper: (context, child, runtime) {
    return AppDependenciesWidget(child: child);
  },
  dependencies: WidgetbookDependencyRegistry(
    repositories: [
      WidgetbookRepositorySpec<MyRepo>(
        createValue: (context, story, dependencies) => FakeMyRepo(),
      ),
    ],
    providers: [
      WidgetbookProviderSpec<MyBloc>(
        createValue: (context, story, dependencies) {
          final repo = dependencies[MyRepo] as MyRepo;
          return MyBloc(repo);
        },
        wrapValue: (child, bloc) => MyBlocProvider(bloc: bloc, child: child),
      ),
    ],
  ),
);

@UseCase(name: 'HomePage', type: HomePage)
Widget homePageUseCase(BuildContext context) {
  final story = stories.firstWhere((s) => s.id == 'home.page');
  return renderer.build(context, story);
}
```

## Discovery for screenshot tooling

Metadata is available from source and at runtime:

```dart
final catalog = stories.toCatalogJson();
```

This is intended for external screenshot runners to determine:
- which stories exist
- which type they are (`phone`, `widget`, `designSystem`, `custom`)
- tags/group filters for batch screenshot runs
