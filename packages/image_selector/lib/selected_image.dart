import 'dart:io';
import 'dart:typed_data';

/// Represents a selected image from the ImageSelectorWidget.
///
/// This class provides access to the selected image data without exposing
/// internal state management details.
class SelectedImage {
  /// The stock asset path if a stock image was selected, null otherwise.
  final String? path;

  /// The selected file if an image was picked from gallery/camera (non-web), null otherwise.
  final File? selectedFile;

  /// The selected image bytes if an image was picked from gallery/camera (web), null otherwise.
  final Uint8List? selectedImage;

  final String? url;

  const SelectedImage({
    this.path,
    this.selectedFile,
    this.selectedImage,
    this.url,
  });

  /// Returns true if an image is selected (any of the three types).
  bool get hasSelection => path != null || selectedFile != null || selectedImage != null;

  /// Returns true if no image is selected.
  bool get isEmpty => !hasSelection;

  @override
  String toString() {
    return 'SelectedImage(path: $path, selectedFile: ${selectedFile?.lengthSync()}, selectedImage: ${selectedImage?.length})';
  }
}
