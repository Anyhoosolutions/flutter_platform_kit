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
import 'package:widgetbook_workspace/anyhoo_app_bar/anyhoo_app_bar.dart'
    as _widgetbook_workspace_anyhoo_app_bar_anyhoo_app_bar;
import 'package:widgetbook_workspace/anyhoo_app_bar/anyhoo_bottom_bar.dart'
    as _widgetbook_workspace_anyhoo_app_bar_anyhoo_bottom_bar;
import 'package:widgetbook_workspace/anyhoo_core/error_display_widget.dart'
    as _widgetbook_workspace_anyhoo_core_error_display_widget;
import 'package:widgetbook_workspace/anyhoo_core/error_page.dart'
    as _widgetbook_workspace_anyhoo_core_error_page;
import 'package:widgetbook_workspace/anyhoo_core/waiting_page.dart'
    as _widgetbook_workspace_anyhoo_core_waiting_page;
import 'package:widgetbook_workspace/anyhoo_firebase/firebase_analytics_page.dart'
    as _widgetbook_workspace_anyhoo_firebase_firebase_analytics_page;
import 'package:widgetbook_workspace/anyhoo_form_builder_widgets/anyhoo_form_builder_multi_select.dart'
    as _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_form_builder_multi_select;
import 'package:widgetbook_workspace/anyhoo_form_builder_widgets/anyhoo_form_builder_multi_select_searchable.dart'
    as _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_form_builder_multi_select_searchable;
import 'package:widgetbook_workspace/anyhoo_form_builder_widgets/anyhoo_multi_select_searchable.dart'
    as _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_multi_select_searchable;
import 'package:widgetbook_workspace/anyhoo_image_selector/image_selector_widget.dart'
    as _widgetbook_workspace_anyhoo_image_selector_image_selector_widget;
import 'package:widgetbook_workspace/anyhoo_shimmer/shimmer.dart'
    as _widgetbook_workspace_anyhoo_shimmer_shimmer;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'anyhoo_app_bar',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'AnyhooAppBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'AnyhooAppBar',
            builder: _widgetbook_workspace_anyhoo_app_bar_anyhoo_app_bar.build,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'AnyhooBottomBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'AnyhooBottomBar',
            builder:
                _widgetbook_workspace_anyhoo_app_bar_anyhoo_bottom_bar.build,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'anyhoo_core',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'ErrorDisplayWidget',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'ErrorDisplayWidget',
            builder:
                _widgetbook_workspace_anyhoo_core_error_display_widget.build,
          ),
        ],
      ),
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
  _widgetbook.WidgetbookFolder(
    name: 'anyhoo_firebase',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'FirebaseAnalyticsPage',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'FirebaseAnalyticsPage',
            builder:
                _widgetbook_workspace_anyhoo_firebase_firebase_analytics_page
                    .build,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'anyhoo_form_builder_widgets',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'AnyhooFormBuilderMultiSelect',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_form_builder_multi_select
                    .build,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'AnyhooFormBuilderMultiSelectSearchable',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_form_builder_multi_select_searchable
                    .build,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'AnyhooMultiSelectSearchable',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_multi_select_searchable
                    .build,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'anyhoo_image_selector',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'AnyhooImageSelectorWidget',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _widgetbook_workspace_anyhoo_image_selector_image_selector_widget
                    .build,
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'anyhoo_shimmer',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'AnyhooShimmer',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Shimmer',
            builder: _widgetbook_workspace_anyhoo_shimmer_shimmer.build,
          ),
        ],
      ),
    ],
  ),
];
