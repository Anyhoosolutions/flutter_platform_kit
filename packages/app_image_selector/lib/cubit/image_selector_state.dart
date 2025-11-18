import 'dart:io';

// --- State Class ---

enum ImageSourceType {
  none, // No image selected
  gallery,
  camera,
  stock, // Asset image
}

class ImageSelectorState {
  final File? selectedFile;
  final String? stockAssetPath;
  final ImageSourceType sourceType;
  final bool isLoading;
  final String? errorMessage;

  const ImageSelectorState({
    this.selectedFile,
    this.stockAssetPath,
    this.sourceType = ImageSourceType.none,
    this.isLoading = false,
    this.errorMessage,
  });

  // Helper method to copy/update state
  ImageSelectorState copyWith({
    File? selectedFile,
    String? stockAssetPath,
    ImageSourceType? sourceType,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ImageSelectorState(
      selectedFile: selectedFile,
      stockAssetPath: stockAssetPath,
      sourceType: sourceType ?? this.sourceType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // We keep the last error unless cleared
    );
  }
}
