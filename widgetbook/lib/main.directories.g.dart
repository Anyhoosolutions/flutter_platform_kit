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
import 'package:widgetbook_workspace/anyhoo_auth/login_widget.dart'
    as _widgetbook_workspace_anyhoo_auth_login_widget;
import 'package:widgetbook_workspace/anyhoo_core/error_display_widget.dart'
    as _widgetbook_workspace_anyhoo_core_error_display_widget;
import 'package:widgetbook_workspace/anyhoo_core/error_page.dart'
    as _widgetbook_workspace_anyhoo_core_error_page;
import 'package:widgetbook_workspace/anyhoo_core/waiting_page.dart'
    as _widgetbook_workspace_anyhoo_core_waiting_page;
import 'package:widgetbook_workspace/anyhoo_design_system/appBar/anyhoo_top_bar.dart'
    as _widgetbook_workspace_anyhoo_design_system_appBar_anyhoo_top_bar;
import 'package:widgetbook_workspace/anyhoo_design_system/buttons/anyhoo_round_button.dart'
    as _widgetbook_workspace_anyhoo_design_system_buttons_anyhoo_round_button;
import 'package:widgetbook_workspace/anyhoo_design_system/cards/anyhoo_cards_gallery.dart'
    as _widgetbook_workspace_anyhoo_design_system_cards_anyhoo_cards_gallery;
import 'package:widgetbook_workspace/anyhoo_design_system/typography/anyhoo_typography_gallery.dart'
    as _widgetbook_workspace_anyhoo_design_system_typography_anyhoo_typography_gallery;
import 'package:widgetbook_workspace/anyhoo_firebase/firebase_analytics_page.dart'
    as _widgetbook_workspace_anyhoo_firebase_firebase_analytics_page;
import 'package:widgetbook_workspace/anyhoo_form_builder_widgets/anyhoo_form_builder_multi_select.dart'
    as _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_form_builder_multi_select;
import 'package:widgetbook_workspace/anyhoo_form_builder_widgets/anyhoo_multi_select.dart'
    as _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_multi_select;
import 'package:widgetbook_workspace/anyhoo_image_selector/image_selector_widget.dart'
    as _widgetbook_workspace_anyhoo_image_selector_image_selector_widget;
import 'package:widgetbook_workspace/anyhoo_search_bar/anyhoo_search_bar.dart'
    as _widgetbook_workspace_anyhoo_search_bar_anyhoo_search_bar;
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
    name: 'anyhoo_auth',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'LoginWidget<AnyhooUser>',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'LoginWidget',
            builder: _widgetbook_workspace_anyhoo_auth_login_widget.build,
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
    name: 'anyhoo_design_system',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'appBar',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AnyhooTopBar',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _widgetbook_workspace_anyhoo_design_system_appBar_anyhoo_top_bar
                        .buildAnyhooTopBar,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'buttons',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AnyhooRoundButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder:
                    _widgetbook_workspace_anyhoo_design_system_buttons_anyhoo_round_button
                        .buildAnyhooRoundButton,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'cards',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AnyhooStandardCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Gallery',
                builder:
                    _widgetbook_workspace_anyhoo_design_system_cards_anyhoo_cards_gallery
                        .buildAnyhooCardsGallery,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'typography',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AnyhooHeadline',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Gallery',
                builder:
                    _widgetbook_workspace_anyhoo_design_system_typography_anyhoo_typography_gallery
                        .buildAnyhooTypographyGallery,
              ),
            ],
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
        name: 'AnyhooFormBuilderMultiSelect<Object>',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Flat',
            builder:
                _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_form_builder_multi_select
                    .build,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'AnyhooMultiSelect',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Flat with add new',
            builder:
                _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_multi_select
                    .buildFlatAddNew,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Sectioned',
            builder:
                _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_multi_select
                    .buildSectioned,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'Single selection',
            builder:
                _widgetbook_workspace_anyhoo_form_builder_widgets_anyhoo_multi_select
                    .buildSingleSelection,
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
    name: 'anyhoo_search_bar',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'AnyhooSearchBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'Default',
            builder:
                _widgetbook_workspace_anyhoo_search_bar_anyhoo_search_bar.build,
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
