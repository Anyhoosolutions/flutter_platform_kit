import 'package:test/test.dart';
import 'package:widgetbook_screenshots/src/image_utils.dart';

void main() {
  group('shouldFillPixel', () {
    final imageUtils = ImageUtils();

    test('should return false for radius 0', () {
      expect(imageUtils.shouldFillPixel(0, 0, 10, 10, 0), isFalse);
      expect(imageUtils.shouldFillPixel(5, 5, 10, 10, 0), isFalse);
    });

    test('should return false for negative radius', () {
      expect(imageUtils.shouldFillPixel(0, 0, 10, 10, -1), isFalse);
    });

    test('should return false for pixels outside corner regions', () {
      // Center pixel
      expect(imageUtils.shouldFillPixel(5, 5, 10, 10, 2), isFalse);
      // Edge pixels not in corners
      expect(imageUtils.shouldFillPixel(5, 0, 10, 10, 2), isFalse);
      expect(imageUtils.shouldFillPixel(0, 5, 10, 10, 2), isFalse);
      expect(imageUtils.shouldFillPixel(9, 5, 10, 10, 2), isFalse);
      expect(imageUtils.shouldFillPixel(5, 9, 10, 10, 2), isFalse);
    });

    test('should handle single pixel radius', () {
      // For radius=1, pixels at distance <= 1 should be filled
      expect(imageUtils.shouldFillPixel(0, 0, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(0, 1, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(1, 0, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(1, 1, 10, 10, 1), isFalse);

      expect(imageUtils.shouldFillPixel(9, 0, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(9, 1, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(8, 0, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(8, 1, 10, 10, 1), isFalse);

      expect(imageUtils.shouldFillPixel(0, 9, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(1, 9, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(0, 8, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(1, 8, 10, 10, 1), isFalse);

      expect(imageUtils.shouldFillPixel(9, 9, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(8, 9, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(9, 8, 10, 10, 1), isTrue);
      expect(imageUtils.shouldFillPixel(8, 8, 10, 10, 1), isFalse);
    });
  });
}
