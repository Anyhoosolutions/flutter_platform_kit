// ignore_for_file: deprecated_member_use

import 'package:anyhoo_app_bar/anyhoo_app_bar.dart';
import 'package:anyhoo_search_bar/anyhoo_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooSearchBar, path: 'anyhoo_search_bar')
Widget build(BuildContext context) {
  final showIncludeEverythingCheckbox = context.knobs.boolean(
    label: 'Show include everything checkbox',
    initialValue: false,
  );
  final searchText = context.knobs.string(label: 'Search text', initialValue: 'Search...');

  final iconOptions = ['search', 'filter_list', 'filter_list_off'];
  final icon = context.knobs.list(label: 'Icon', options: iconOptions, initialOption: 'search');

  final widget = Center(
    child: CustomScrollView(
      slivers: [
        AnyhooAppBar(hasBackButton: false, title: 'Example app', imageUrl: null, actionButtons: []),
        AnyhooSearchBar(
          icon: icon == 'search'
              ? Icons.search
              : icon == 'filter_list'
              ? Icons.filter_list
              : Icons.filter_list_off,
          labelText: searchText,
          showIncludeEverythingCheckbox: showIncludeEverythingCheckbox,
          onChanged: (value) {
            // ignore: avoid_print
            print('value: $value');
          },
          onIncludeEverythingChanged: (value) {
            // ignore: avoid_print
            print('value: $value');
          },
        ),
      ],
    ),
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
