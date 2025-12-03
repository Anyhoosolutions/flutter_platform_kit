import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/imageSelectorDemo/image_selector_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageSelectorPageRoute extends AnyhooRoute<AnyhooRouteName> {
  ImageSelectorPageRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder => (context, state) {
    return ImageSelectorDemoPage();
  };

  @override
  String get path => '/image-selector';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.imageSelector;

  @override
  String get title => 'Image Selector';
}
