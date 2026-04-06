import 'package:flutter/material.dart';

/// Layout for [WidgetbookStoryShell.wrapSimpleStory] (no device frame).
class WidgetbookSimpleStoryConfig {
  const WidgetbookSimpleStoryConfig({
    this.bodyPadding = const EdgeInsets.all(24),
    this.centerBody = true,
  });

  final EdgeInsets bodyPadding;

  /// When true, the padded child is wrapped in [Center].
  final bool centerBody;
}
