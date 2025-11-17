import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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

// --- Cubit Class ---

class ImageSelectorCubit extends Cubit<ImageSelectorState> {
  final ImagePicker _picker = ImagePicker();

  // List of paths for stock images provided by the consuming app
  final List<String> stockAssetPaths;

  ImageSelectorCubit({required this.stockAssetPaths}) : super(const ImageSelectorState());

  // Handles camera and gallery picking
  Future<void> pickImage(ImageSource source) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final XFile? xFile = await _picker.pickImage(source: source);

      if (xFile != null) {
        final File file = File(xFile.path);
        emit(ImageSelectorState(
          selectedFile: file,
          sourceType: source == ImageSource.camera ? ImageSourceType.camera : ImageSourceType.gallery,
        ));
      } else {
        // User cancelled the picker
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to pick image: $e',
      ));
    }
  }

  // Handles stock photo selection
  void selectStockPhoto(String assetPath) {
    emit(ImageSelectorState(
      stockAssetPath: assetPath,
      sourceType: ImageSourceType.stock,
    ));
  }

  void clearSelection() {
    emit(const ImageSelectorState());
  }
}
