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
      _log.info('Mime type: ${xFile?.mimeType}');
      final sourceType = source == ImageSource.camera ? ImageSourceType.camera : ImageSourceType.gallery;
      _log.info('Source type: $sourceType');
      _log.info('kIsWeb: $kIsWeb');

      if (xFile != null) {
        if (kIsWeb) {
          // On web, read bytes from XFile
          final Uint8List imageBytes = await xFile.readAsBytes();
          emit(ImageSelectorState(
            selectedImage: imageBytes,
            sourceType: sourceType,
            isLoading: false,
            mimeType: xFile.mimeType,
          ));
        } else {
          // On mobile, store the File object
          final File file = File(xFile.path);
          _log.info('Mobile mime type from picker: ${xFile.mimeType}');

          emit(ImageSelectorState(
            selectedFile: file,
            sourceType: sourceType,
            isLoading: false,
            mimeType: xFile.mimeType,
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

  // Update the preselected image (useful when data loads asynchronously)
  void updatePreselectedImage(String? newPreselectedImage) {
    _log.info('updatePreselectedImage called with: $newPreselectedImage');
    if (newPreselectedImage != preselectedImage) {
      // Only update if no user selection has been made (state still matches initial state)
      final isInitialState = state.path == preselectedImage &&
          state.selectedFile == null &&
          state.selectedImage == null &&
          state.sourceType == ImageSourceType.none;
      if (isInitialState) {
        _log.info('Updating preselected image from $preselectedImage to $newPreselectedImage');
        emit(ImageSelectorState(path: newPreselectedImage));
      } else {
        _log.info('Not updating preselected image - user has already made a selection');
      }
    }
  }
}
