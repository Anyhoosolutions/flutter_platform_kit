import 'dart:io';
import 'dart:typed_data';

// --- State Class ---

enum ImageSourceType {
  none, // No image selected
  gallery,
  camera,
  stock, // Asset image
}

class ImageSelectorState {
  final File? selectedFile;
  final Uint8List? selectedImage;
  final String? stockAssetPath;
  final ImageSourceType sourceType;
  final bool isLoading;
  final String? errorMessage;

  const ImageSelectorState({
    this.selectedFile,
    this.selectedImage,
    this.stockAssetPath,
    this.sourceType = ImageSourceType.none,
    this.isLoading = false,
    this.errorMessage,
  });

  // Helper method to copy/update state
  ImageSelectorState copyWith({
    File? selectedFile,
    Uint8List? selectedImage,
    String? stockAssetPath,
    ImageSourceType? sourceType,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ImageSelectorState(
      selectedFile: selectedFile,
      selectedImage: selectedImage,
      stockAssetPath: stockAssetPath,
      sourceType: sourceType ?? this.sourceType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // We keep the last error unless cleared
    );
  }
}
