// ignore_for_file: deprecated_member_use

import 'package:app_image_selector/widgets/image_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: ImageSelectorWidget, path: 'app_image_selector')
Widget build(BuildContext context) {
  final colorSchemeOptions = ['red', 'green', 'purple'];
  final colorScheme = context.knobs.list(label: 'Color scheme', options: colorSchemeOptions, initialOption: 'red');
  final showImage = context.knobs.boolean(label: 'Show image', initialValue: true);

  final layoutType = context.knobs.list(
    label: 'Layout type',
    options: LayoutType.values.map((e) => e.name).toList(),
    initialOption: LayoutType.verticalStack.name,
  );

  final widget = Theme(
    data: ThemeData(colorScheme: getColorScheme(colorScheme)),
    child: Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: ImageSelectorWidget(
          layoutType: LayoutType.values.firstWhere((e) => e.name == layoutType),
          preselectedImage: showImage ? 'assets/images/baking.png' : null,
          onImageSelected: (state) {},
          stockAssetPaths: [
            'assets/images/baking.png',
            'assets/images/casserole.png',
            'assets/images/cocktail.png',
            'assets/images/dessert.png',
            'assets/images/drink.png',
            'assets/images/pot.png',
            'assets/images/stew.png',
          ],
        ),
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
