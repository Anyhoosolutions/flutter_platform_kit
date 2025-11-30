// ignore_for_file: deprecated_member_use

import 'package:anyhoo_app_bar/anyhoo_app_bar.dart' show AnyhooBottomBar, BottomBarNavItems;
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'AnyhooBottomBar', type: AnyhooBottomBar, path: 'anyhoo_app_bar')
Widget build(BuildContext context) {
  final colorSchemeOptions = ['green', 'purple', 'red'];
  final colorScheme = context.knobs.list(label: 'Color scheme', options: colorSchemeOptions, initialOption: 'purple');

  final isLoading = context.knobs.boolean(label: 'Is loading', initialValue: false);
  final useImage = context.knobs.boolean(label: 'Use image', initialValue: false);

  final backgroundColorOptions = {'none': null, 'brown': Colors.brown, 'orange': Colors.orange};
  final backgroundColor = context.knobs.list(
    label: 'Background color',
    options: backgroundColorOptions.keys.toList(),
    initialOption: 'none',
  );
  final backgroundColorValue = backgroundColor == 'none' ? null : backgroundColorOptions[backgroundColor];
  final scrollController = ScrollController();

  final widget = Theme(
    data: ThemeData(colorScheme: getColorScheme(colorScheme)),
    child: Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverList.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return Text('Item $index');
            },
          ),
        ],
      ),
      bottomNavigationBar: AnyhooBottomBar(
        backgroundColor: backgroundColorValue,
        items: [BottomBarNavItems.recipes, BottomBarNavItems.favorites, BottomBarNavItems.profile],
        selected: BottomBarNavItems.recipes,
      ),
    ),
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}

ColorScheme getColorScheme(String colorScheme) {
  final cs = ColorScheme.fromSeed(seedColor: Colors.white);
  return switch (colorScheme) {
    'red' => cs.copyWith(primary: Colors.red),
    'green' => cs.copyWith(primary: Colors.green),
    'purple' => cs.copyWith(primary: Colors.purple),
    _ => cs,
  };
}
