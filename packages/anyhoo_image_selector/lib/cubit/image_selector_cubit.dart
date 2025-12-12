import 'dart:io';
import 'package:anyhoo_image_selector/cubit/image_selector_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

// --- Cubit Class ---
final _log = Logger('ImageSelectorCubit');

class ImageSelectorCubit extends Cubit<ImageSelectorState> {
  final ImagePicker _picker = ImagePicker();

  // List of paths for stock images provided by the consuming app
  final List<String> stockAssetPaths;
  final String? preselectedImage;

  ImageSelectorCubit({required this.stockAssetPaths, this.preselectedImage})
      : super(ImageSelectorState(path: preselectedImage)) {
    _log.info('ImageSelectorCubit initialized with preselectedImage: $preselectedImage');
  }

  // Handles camera and gallery picking
  Future<void> pickImage(ImageSource source) async {
    _log.info('pickImage called for source: $source');
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final XFile? xFile = await _picker.pickImage(source: source);

      if (xFile != null) {
        if (kIsWeb) {
          Uint8List imageDataBytes = await xFile.readAsBytes();
          emit(ImageSelectorState(
            selectedImage: imageDataBytes,
            sourceType: source == ImageSource.camera ? ImageSourceType.camera : ImageSourceType.gallery,
          ));
        } else {
          final File file = File(xFile.path);
          emit(ImageSelectorState(
            selectedFile: file,
            sourceType: source == ImageSource.camera ? ImageSourceType.camera : ImageSourceType.gallery,
          ));
        }
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
    _log.info('selectStockPhoto called for assetPath: $assetPath');
    emit(ImageSelectorState(
      path: assetPath,
      sourceType: ImageSourceType.stock,
    ));
  }

  void clearSelection() {
    _log.info('clearSelection called');
    emit(const ImageSelectorState());
  }
}
