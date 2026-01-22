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
  final String? path;
  final ImageSourceType sourceType;
  final bool isLoading;
  final String? errorMessage;
  final String? mimeType;

  const ImageSelectorState({
    this.selectedFile,
    this.selectedImage,
    this.path,
    this.sourceType = ImageSourceType.none,
    this.isLoading = false,
    this.errorMessage,
    this.mimeType,
  });

  // Helper method to copy/update state
  ImageSelectorState copyWith({
    File? selectedFile,
    Uint8List? selectedImage,
    String? path,
    ImageSourceType? sourceType,
    bool? isLoading,
    String? errorMessage,
    String? mimeType,
  }) {
    return ImageSelectorState(
      selectedFile: selectedFile,
      selectedImage: selectedImage,
      path: path,
      sourceType: sourceType ?? this.sourceType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // We keep the last error unless cleared
      mimeType: mimeType ?? this.mimeType,
    );
  }
}
