import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:anyhoo_image_selector/layout_type.dart';
import 'package:anyhoo_image_selector/selected_image.dart';
import 'package:flutter/material.dart';
import 'package:anyhoo_image_selector/widgets/anyhoo_image_selector_widget.dart';

class AnyhooFormImageSelector extends StatelessWidget {
  final List<String> stockAssetPaths;
  final bool roundImage;
  final LayoutType layoutType;
  final String? formFieldKey;
  final String fieldName;
  final SelectedImage? initialValue;

  const AnyhooFormImageSelector({
    super.key,
    this.stockAssetPaths = const [],
    this.roundImage = false,
    required this.layoutType,
    required this.fieldName,
    this.formFieldKey,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
        key: formFieldKey != null ? Key(formFieldKey!) : null,
        name: fieldName,
        initialValue: initialValue,
        builder: (field) {
          return AnyhooImageSelectorWidget(
            onImageSelected: (image) {
              field.didChange(image);
            },
            stockAssetPaths: stockAssetPaths,
            layoutType: layoutType,
            roundImage: roundImage,
            preselectedImage: initialValue?.path ?? initialValue?.url,
          );
        });
  }
}
