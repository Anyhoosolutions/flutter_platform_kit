import 'package:app_image_selector/widgets/image_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/wrap_in_mocks_helper.dart';

@widgetbook.UseCase(name: 'Default', type: ImageSelectorWidget, path: 'app_image_selector')
Widget build(BuildContext context) {
  final widget = Center(
    child: ImageSelectorWidget(
      preselectedImage: 'assets/images/baking.png',
      onImageSelected: (state) {},
      stockAssetPaths: [
        'assets/images/baking.png',
        'assets/images/casserole.png',
        'assets/images/cocktail.png',
        'assets/images/desssert.png',
        'assets/images/drink.png',
        'assets/images/pot.png',
        'assets/images/stew.png',
      ],
    ),
  );

  return WrapInMocksHelper().wrapInMocks(context, widget);
}
