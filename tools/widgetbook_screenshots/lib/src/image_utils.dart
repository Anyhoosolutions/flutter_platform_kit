import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:logging/logging.dart';

/// Shared utilities for loading and processing images
class ImageUtils {
  final Logger _logger = Logger('ImageUtils');

  /// Load an image from file path
  Future<img.Image?> loadImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        _logger.warning('Image not found: $imagePath');
        return null;
      }

      final imageBytes = await file.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        _logger.warning('Failed to decode image: $imagePath');
        return null;
      }

      return image;
    } catch (e) {
      _logger.warning('Error loading image $imagePath: $e');
      return null;
    }
  }

  /// Resize an image to specified dimensions (preserves aspect ratio)
  /// The image will be scaled to fit within the given width/height while maintaining aspect ratio
  img.Image resizeImage(img.Image image, int width, int height,
      {img.Interpolation interpolation = img.Interpolation.linear}) {
    // Calculate aspect ratios
    final imageAspect = image.width / image.height;
    final targetAspect = width / height;

    int finalWidth = width;
    int finalHeight = height;

    // Preserve aspect ratio - fit within bounds
    if (imageAspect > targetAspect) {
      // Image is wider - fit to width
      finalHeight = (width / imageAspect).round();
    } else {
      // Image is taller - fit to height
      finalWidth = (height * imageAspect).round();
    }

    return img.copyResize(
      image,
      width: finalWidth,
      height: finalHeight,
      interpolation: interpolation,
    );
  }

  /// Resize an image to specified dimensions without preserving aspect ratio (for when distortion is desired)
  img.Image resizeImageExact(img.Image image, int width, int height,
      {img.Interpolation interpolation = img.Interpolation.linear}) {
    return img.copyResize(
      image,
      width: width,
      height: height,
      interpolation: interpolation,
    );
  }

  /// Scale an image by a factor
  img.Image scaleImage(img.Image image, double scale) {
    final newWidth = (image.width * scale).round();
    final newHeight = (image.height * scale).round();
    return resizeImage(image, newWidth, newHeight);
  }

  /// Determines if a pixel at (x, y) should be filled to remove rounded corners
  /// Returns true if the pixel is within the rounded corner area (inside the quarter-circle)
  /// [x], [y] are the pixel coordinates
  /// [width], [height] are the image dimensions
  /// [radius] is the corner radius
  bool shouldFillPixel(int x, int y, int width, int height, int radius) {
    if (radius <= 0) {
      return false;
    }

    var dx = -1;
    var dy = -1;

    // Top-left corner
    if (x <= radius && y <= radius) {
      dx = radius - x;
      dy = radius - y;
    }
    // Top-right corner
    else if (x >= width - radius - 1 && y <= radius) {
      dx = x - (width - radius - 1);
      dy = radius - y;
    }
    // Bottom-left corner
    else if (x <= radius && y >= height - radius - 1) {
      dx = radius - x;
      dy = y - (height - radius - 1);
    }
    // Bottom-right corner
    else if (x >= width - radius - 1 && y >= height - radius - 1) {
      dx = x - (width - radius - 1);
      dy = y - (height - radius - 1);
    }

    if (dx != -1 && dy != -1) {
      final distanceSquared = dx * dx + dy * dy;
      final distance = math.sqrt(distanceSquared);
      return distance >= radius;
    }

    return false;
  }

  /// Remove rounded corners by filling edge pixels with background color
  /// The radius parameter specifies how many pixels from each edge to fill
  /// This makes corners match the collage background color
  img.Image removeRoundedCorners(img.Image image, int radius, int bgR, int bgG, int bgB) {
    if (radius <= 0) {
      return image; // No removal needed
    }

    _logger.info('Removing rounded corners with radius: $radius, bgColor: RGB($bgR, $bgG, $bgB)');

    // Create a copy using copyResize to preserve format and orientation
    final result = img.copyResize(image, width: image.width, height: image.height);

    // Process corner regions and fill pixels with background color
    // Replace pixels in corner region that are OUTSIDE the quarter-circle arc
    // The quarter-circle keeps pixels within 'radius' distance from the corner
    // Pixels outside this arc (but still in the corner square) get replaced
    int pixelsModified = 0;
    final bgColor = img.ColorRgb8(bgR, bgG, bgB);

    for (int y = 0; y < result.height; y++) {
      for (int x = 0; x < result.width; x++) {
        if (shouldFillPixel(x, y, result.width, result.height, radius)) {
          // Replace pixel with background color
          result.setPixel(x, y, bgColor);
          pixelsModified++;
        }
      }
    }

    _logger.info('Modified $pixelsModified corner pixels (out of ${result.width * result.height} total)');
    return result;
  }
}
