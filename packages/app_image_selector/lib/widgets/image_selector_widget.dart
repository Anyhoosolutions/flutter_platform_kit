import 'package:app_image_selector/cubit/image_selector_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

import '../cubit/image_selector_cubit.dart';

class ImageSelectorWidget extends StatelessWidget {
  // Callback when a file is selected (null if cleared)
  final ValueChanged<ImageSelectorState> onImageSelected;
  final List<String> stockAssetPaths;
  final String? preselectedImage;
  final bool roundImage;

  const ImageSelectorWidget({
    super.key,
    required this.onImageSelected,
    this.stockAssetPaths = const [],
    this.preselectedImage,
    this.roundImage = false,
  });

  @override
  Widget build(BuildContext context) {
    // Provide the cubit locally to the widget subtree
    return BlocProvider(
      create: (context) => ImageSelectorCubit(
        stockAssetPaths: stockAssetPaths,
        preselectedImage: preselectedImage,
      ),
      child: _ImageSelectorView(onImageSelected: onImageSelected),
    );
  }
}

class _ImageSelectorView extends StatelessWidget {
  final ValueChanged<ImageSelectorState> onImageSelected;

  const _ImageSelectorView({required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ImageSelectorCubit>();

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final parentWidth = constraints.maxWidth;

      return BlocBuilder<ImageSelectorCubit, ImageSelectorState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display the selected image preview
              if (shouldShowImage(state)) _buildImagePreview(context, state, parentWidth),
              if (!shouldShowImage(state))

                // Action buttons
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildEmptyImageIcon(context, parentWidth),
                    const SizedBox(height: 16),
                    _buildActionButton(
                      context,
                      parentWidth,
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onPressed: () => cubit.pickImage(ImageSource.gallery),
                    ),
                    _buildActionButton(
                      context,
                      parentWidth,
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onPressed: () => cubit.pickImage(ImageSource.camera),
                    ),
                    if (cubit.stockAssetPaths.isNotEmpty)
                      _buildActionButton(
                        context,
                        parentWidth,
                        icon: Icons.image,
                        label: 'Stock',
                        onPressed: () => _showStockPhotoDialog(context, cubit),
                      ),
                    if (state.sourceType != ImageSourceType.none)
                      _buildActionButton(
                        context,
                        parentWidth,
                        icon: Icons.clear,
                        label: 'Clear',
                        onPressed: cubit.clearSelection,
                      ),
                  ],
                ),
            ],
          );
        },
      );
    });
  }

  bool shouldShowImage(ImageSelectorState state) {
    return state.selectedFile != null || state.stockAssetPath != null;
  }

  Widget _buildImagePreview(BuildContext context, ImageSelectorState state, double parentWidth) {
    Widget image;

    if (state.selectedFile != null) {
      image = Image.file(state.selectedFile!, width: parentWidth * 0.9, fit: BoxFit.cover);
    } else if (state.stockAssetPath != null) {
      image = Image.asset(state.stockAssetPath!, width: parentWidth * 0.9, fit: BoxFit.cover);
    } else {
      image = Container(
        height: 100,
        width: 100,
        color: Colors.grey.shade200,
        child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
      );
    }
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: image,
          )),
      Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
              onTap: () {
                context.read<ImageSelectorCubit>().clearSelection();
              },
              child: Container(
                  padding: const EdgeInsets.all(0.1),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cancel, size: 48)))),
    ]);
  }

  Widget _buildEmptyImageIcon(BuildContext context, double parentWidth) {
    final image = Container(
      height: 100,
      width: 100,
      color: Colors.grey.shade200,
      child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
    );
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: image,
        ));
  }

  Widget _buildActionButton(BuildContext context, double parentWidth,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.only(
            left: parentWidth * 0.05 + 8.0,
            right: parentWidth * 0.05 + 8.0,
            bottom: 16,
          ),
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 2,
              dashPattern: [10, 6],
              radius: const Radius.circular(20),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
                ),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ));
  }

  void _showStockPhotoDialog(BuildContext context, ImageSelectorCubit cubit) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Stock Photo'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: cubit.stockAssetPaths.map((path) {
                return InkWell(
                  onTap: () {
                    cubit.selectStockPhoto(path);
                    Navigator.of(dialogContext).pop();
                  },
                  child: Image.asset(
                    path,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
