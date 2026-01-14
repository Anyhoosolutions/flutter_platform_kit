// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';
import 'package:anyhoo_shimmer/anyhoo_shimmer.dart';

@widgetbook.UseCase(name: 'Shimmer', type: AnyhooShimmer, path: 'anyhoo_shimmer')
Widget build(BuildContext context) {
  final isLoading = context.knobs.boolean(label: 'Is loading', initialValue: true);

  final widget = Center(
    child: SizedBox(
      width: 300,
      height: 30,
      child: AnyhooShimmer(child: isLoading ? Text('Hello world...') : ShimmerShapes.text()),
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
