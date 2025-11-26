// ignore_for_file: deprecated_member_use

import 'package:anyhoo_app_bar/anyhoo_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'AnyhooAppBar', type: AnyhooAppBar, path: 'anyhoo_app_bar')
Widget build(BuildContext context) {
  final colorSchemeOptions = ['green', 'purple', 'red'];
  final colorScheme = context.knobs.list(label: 'Color scheme', options: colorSchemeOptions, initialOption: 'purple');

  final isLoading = context.knobs.boolean(label: 'Is loading', initialValue: false);
  final alwaysCollapsed = context.knobs.boolean(label: 'Always collapsed', initialValue: false);
  final imgUrl = 'https://picsum.photos/600/800';

  final scrollController = ScrollController();

  final widget = Theme(
    data: ThemeData(colorScheme: getColorScheme(colorScheme)),
    child: Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          AnyhooAppBar(
            scrollController: scrollController,
            hasBackButton: true,
            title: 'Example App Bar',
            imageUrl: imgUrl,
            actionButtons: [],
            isLoading: isLoading,
            alwaysCollapsed: alwaysCollapsed,
          ),
          SliverList.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return Text('Item $index');
            },
          ),
        ],
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
