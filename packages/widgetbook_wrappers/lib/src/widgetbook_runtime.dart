import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'widgetbook_story_definition.dart';
import 'widgetbook_widget_frame_option.dart';

class WidgetbookStoryRuntime {
  const WidgetbookStoryRuntime({
    required this.context,
    required this.story,
    required this.themeMode,
    required this.isWeb,
    required this.content,
    this.device,
    this.orientation,
    this.widgetFrame,
    this.dependencies = const <Type, Object>{},
  });

  final BuildContext context;
  final WidgetbookStoryDefinition story;
  final ThemeMode themeMode;
  final bool isWeb;
  final Widget content;
  final DeviceInfo? device;
  final Orientation? orientation;
  final WidgetFrameSizeOption? widgetFrame;
  final Map<Type, Object> dependencies;

  T dependency<T extends Object>() {
    final value = dependencies[T];
    if (value == null) {
      throw StateError('No dependency found for type $T');
    }
    return value as T;
  }
}

class WidgetbookDependencyRegistry {
  const WidgetbookDependencyRegistry({
    this.repositories = const <WidgetbookRepositorySpecBase>[],
    this.providers = const <WidgetbookProviderSpecBase>[],
  });

  final List<WidgetbookRepositorySpecBase> repositories;
  final List<WidgetbookProviderSpecBase> providers;

  Map<Type, Object> create(
    BuildContext context,
    WidgetbookStoryDefinition story,
  ) {
    final map = <Type, Object>{};
    for (final spec in repositories) {
      map[spec.type] = spec.create(context, story, map);
    }
    for (final spec in providers) {
      map[spec.type] = spec.create(context, story, map);
    }
    return map;
  }
}

abstract class WidgetbookRepositorySpecBase {
  const WidgetbookRepositorySpecBase();

  Type get type;

  Object create(
    BuildContext context,
    WidgetbookStoryDefinition story,
    Map<Type, Object> dependencies,
  );
}

class WidgetbookRepositorySpec<T extends Object>
    extends WidgetbookRepositorySpecBase {
  const WidgetbookRepositorySpec({
    required this.createValue,
  });

  final T Function(
    BuildContext context,
    WidgetbookStoryDefinition story,
    Map<Type, Object> dependencies,
  ) createValue;

  @override
  Type get type => T;

  @override
  Object create(
    BuildContext context,
    WidgetbookStoryDefinition story,
    Map<Type, Object> dependencies,
  ) {
    return createValue(context, story, dependencies);
  }
}

abstract class WidgetbookProviderSpecBase {
  const WidgetbookProviderSpecBase();

  Type get type;

  Object create(
    BuildContext context,
    WidgetbookStoryDefinition story,
    Map<Type, Object> dependencies,
  );

  Widget wrap(Widget child, Object value);
}

class WidgetbookProviderSpec<T extends Object>
    extends WidgetbookProviderSpecBase {
  const WidgetbookProviderSpec({
    required this.createValue,
    required this.wrapValue,
  });

  final T Function(
    BuildContext context,
    WidgetbookStoryDefinition story,
    Map<Type, Object> dependencies,
  ) createValue;
  final Widget Function(Widget child, T value) wrapValue;

  @override
  Type get type => T;

  @override
  Object create(
    BuildContext context,
    WidgetbookStoryDefinition story,
    Map<Type, Object> dependencies,
  ) {
    return createValue(context, story, dependencies);
  }

  @override
  Widget wrap(Widget child, Object value) {
    return wrapValue(child, value as T);
  }
}

extension WidgetbookStoryCatalogExtension on List<WidgetbookStoryDefinition> {
  List<Map<String, Object?>> toCatalogJson() {
    return map((story) {
      return <String, Object?>{
        'id': story.id,
        'name': story.name,
        'type': story.type.name,
        'group': story.group,
        'tags': story.tags,
        'customTypeLabel': story.customTypeLabel,
      };
    }).toList(growable: false);
  }

  List<WidgetbookStoryDefinition> withTag(String tag) {
    return where((story) => story.tags.contains(tag)).toList(growable: false);
  }

  List<WidgetbookStoryDefinition> withType(WidgetbookStoryType type) {
    return where((story) => story.type == type).toList(growable: false);
  }
}

bool readWidgetbookIsWebKnob(
  BuildContext context, {
  String knobLabel = 'Is web',
  bool initialValue = false,
}) {
  return context.knobs.boolean(
    label: knobLabel,
    initialValue: initialValue,
  );
}
