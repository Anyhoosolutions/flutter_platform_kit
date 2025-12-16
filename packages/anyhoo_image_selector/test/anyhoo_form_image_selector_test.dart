import 'package:anyhoo_image_selector/layout_type.dart';
import 'package:anyhoo_image_selector/selected_image.dart';
import 'package:anyhoo_image_selector/widgets/anyhoo_form_image_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';

void main() {
  group('AnyhooFormImageSelector', () {
    testWidgets('should display image when created with initialValue', (WidgetTester tester) async {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        // ignore: avoid_print
        print('LOG: ${record.level.name}: ${record.time}: ${record.message}');
      });

      const testImagePath = 'assets/images/test_image.png';
      const initialValue = SelectedImage(path: testImagePath);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: AnyhooFormImageSelector(
                fieldName: 'test_image',
                layoutType: LayoutType.verticalStack,
                initialValue: initialValue,
              ),
            ),
          ),
        ),
      );

      // When initialValue is provided, the FutureBuilder should be present (indicating image preview)
      // We check immediately after pumpWidget, before any pumping that would trigger image loading
      final futureBuilderFinder = find.byType(FutureBuilder<Widget>);
      expect(futureBuilderFinder, findsWidgets,
          reason: 'FutureBuilder should be present when initialValue is provided, indicating image preview is shown');

      // Verify that the placeholder container is NOT shown
      final emptyImageFinder = find.byKey(const Key('empty-image'));
      expect(emptyImageFinder, findsNothing,
          reason: 'Empty placeholder should not be shown when initialValue is provided');

      // Verify that action buttons are NOT shown when image is displayed
      final galleryButtonFinder = find.byIcon(Icons.photo_library);
      final cameraButtonFinder = find.byIcon(Icons.camera_alt);
      expect(galleryButtonFinder, findsNothing, reason: 'Gallery button should not be shown when image is displayed');
      expect(cameraButtonFinder, findsNothing, reason: 'Camera button should not be shown when image is displayed');
    });
  });
}
