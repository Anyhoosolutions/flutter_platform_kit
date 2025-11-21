// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _widgetbook;
import 'package:widgetbook_workspace/anyhoo_core/error_page.dart'
    as _widgetbook_workspace_anyhoo_core_error_page;
import 'package:widgetbook_workspace/anyhoo_core/waiting_page.dart'
    as _widgetbook_workspace_anyhoo_core_waiting_page;
import 'package:widgetbook_workspace/anyhoo_image_selector%20copy/image_selector_widget.dart'
    as _widgetbook_workspace_anyhoo_image_selector_20copy_image_selector_widget;
import 'package:widgetbook_workspace/anyhoo_core/error_display_widget.dart'
    as _widgetbook_workspace_error_page;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookComponent(
    name: 'ErrorDisplayWidget',
    useCases: [
      _widgetbook.WidgetbookUseCase(
        name: 'ErrorDisplayWidget',
        builder: _widgetbook_workspace_error_page.build,
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'image_selector',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'ImageSelectorWidget',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _widgetbook_workspace_anyhoo_image_selector_20copy_image_selector_widget
                    .build,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'widgets',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'ErrorPage',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'ErrorPage',
            builder: _widgetbook_workspace_anyhoo_core_error_page.build,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'WaitingPage',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'WaitingPage',
            builder: _widgetbook_workspace_anyhoo_core_waiting_page.build,
          ),
        ],
      ),
    ],
  ),
];
