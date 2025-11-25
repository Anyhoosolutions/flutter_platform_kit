// ignore_for_file: deprecated_member_use

import 'package:anyhoo_image_selector/layout_type.dart';
import 'package:anyhoo_image_selector/widgets/anyhoo_image_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooImageSelectorWidget, path: 'anyhoo_image_selector')
Widget build(BuildContext context) {
  final colorSchemeOptions = ['red', 'green', 'purple'];
  final colorScheme = context.knobs.list(label: 'Color scheme', options: colorSchemeOptions, initialOption: 'red');

  final imageOptions = {'Asset': 'assets/images/baking.png', 'Web': 'https://picsum.photos/200/200', 'none': null};
  final imageSelection = context.knobs.list(
    label: 'Show image',
    options: imageOptions.keys.toList(),
    initialOption: imageOptions.keys.first,
  );
  final image = imageOptions[imageSelection];
  final roundImage = context.knobs.boolean(label: 'Round image', initialValue: false);

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
        height: 400,
        child: Stack(
          children: [
            // Simulating how it might be used in a real app - inside a Stack
            // This could be a form page with other widgets stacked on top
            AnyhooImageSelectorWidget(
              layoutType: LayoutType.values.firstWhere((e) => e.name == layoutType),
              preselectedImage: image,
              onImageSelected: (selectedImage) {
                // ignore: avoid_print
                print('selectedImage: $selectedImage');
              },
              roundImage: roundImage,
              stockAssetPaths: [
                'assets/images/baking.png',
                'assets/images/casserole.png',
                'assets/images/cocktail.png',
                'assets/images/dessert.png',
                'assets/images/drink.png',
                'assets/images/pot.png',
                'assets/images/stew.png',
                'assets/images/baking.png',
                'assets/images/casserole.png',
                'assets/images/cocktail.png',
                'assets/images/dessert.png',
                'assets/images/drink.png',
                'assets/images/pot.png',
                'assets/images/stew.png',
              ],
            ),
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
