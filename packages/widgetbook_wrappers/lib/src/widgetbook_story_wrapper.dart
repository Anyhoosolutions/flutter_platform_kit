import 'package:flutter/material.dart';

/// App-specific wiring (Bloc, repositories, routing) around the shell-built
/// [MaterialApp] / framed subtree.
///
/// Typically returns something like `MultiBlocProvider(..., child: child)` so
/// providers sit **outside** [MaterialApp], matching common app structure.
abstract class WidgetbookStoryWrapper {
  const WidgetbookStoryWrapper();

  Widget wrap(BuildContext context, Widget child);
}

/// Pass-through wrapper (story only).
class IdentityWidgetbookStoryWrapper extends WidgetbookStoryWrapper {
  const IdentityWidgetbookStoryWrapper();

  @override
  Widget wrap(BuildContext context, Widget child) => child;
}
