import 'package:flutter/widgets.dart';

import 'widgetbook_runtime.dart';

enum WidgetbookStoryType { phone, widget, designSystem, custom }

typedef WidgetbookStoryBuilder =
    Widget Function(BuildContext context, WidgetbookStoryRuntime runtime);

class WidgetbookStoryDefinition {
  const WidgetbookStoryDefinition._({
    required this.id,
    required this.name,
    required this.type,
    required this.builder,
    this.tags = const <String>[],
    this.group,
    this.customTypeLabel,
  });

  factory WidgetbookStoryDefinition.phone({
    required String id,
    required String name,
    required WidgetbookStoryBuilder builder,
    List<String> tags = const <String>[],
    String? group,
  }) {
    return WidgetbookStoryDefinition._(
      id: id,
      name: name,
      type: WidgetbookStoryType.phone,
      builder: builder,
      tags: tags,
      group: group,
    );
  }

  factory WidgetbookStoryDefinition.widget({
    required String id,
    required String name,
    required WidgetbookStoryBuilder builder,
    List<String> tags = const <String>[],
    String? group,
  }) {
    return WidgetbookStoryDefinition._(
      id: id,
      name: name,
      type: WidgetbookStoryType.widget,
      builder: builder,
      tags: tags,
      group: group,
    );
  }

  factory WidgetbookStoryDefinition.designSystem({
    required String id,
    required String name,
    required WidgetbookStoryBuilder builder,
    List<String> tags = const <String>[],
    String? group,
  }) {
    return WidgetbookStoryDefinition._(
      id: id,
      name: name,
      type: WidgetbookStoryType.designSystem,
      builder: builder,
      tags: tags,
      group: group,
    );
  }

  factory WidgetbookStoryDefinition.custom({
    required String id,
    required String name,
    required WidgetbookStoryBuilder builder,
    List<String> tags = const <String>[],
    String? group,
    String? customTypeLabel,
  }) {
    return WidgetbookStoryDefinition._(
      id: id,
      name: name,
      type: WidgetbookStoryType.custom,
      builder: builder,
      tags: tags,
      group: group,
      customTypeLabel: customTypeLabel,
    );
  }

  final String id;
  final String name;
  final WidgetbookStoryType type;
  final List<String> tags;
  final String? group;
  final String? customTypeLabel;
  final WidgetbookStoryBuilder builder;
}
