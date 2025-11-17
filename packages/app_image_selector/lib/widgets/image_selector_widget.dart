import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/image_selector_cubit.dart';

class ImageSelectorWidget extends StatelessWidget {
  // Callback when a file is selected (null if cleared)
  final ValueChanged<ImageSelectorState> onImageSelected;
  final List<String> stockAssetPaths;

  const ImageSelectorWidget({
    super.key,
    required this.onImageSelected,
    this.stockAssetPaths = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Provide the cubit locally to the widget subtree
    return BlocProvider(
      create: (context) => ImageSelectorCubit(
        stockAssetPaths: stockAssetPaths,
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

    // Listen for state changes and call the external callback
    return BlocListener<ImageSelectorCubit, ImageSelectorState>(
      listener: (context, state) {
        onImageSelected(state);
        if (state.errorMessage != null) {
          // You might show a toast or SnackBar here
          print('Error: ${state.errorMessage}');
        }
      },
      child: BlocBuilder<ImageSelectorCubit, ImageSelectorState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display the selected image preview
              _buildImagePreview(state),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onPressed: () => cubit.pickImage(ImageSource.gallery),
                  ),
                  _buildActionButton(
                    context,
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onPressed: () => cubit.pickImage(ImageSource.camera),
                  ),
                  if (cubit.stockAssetPaths.isNotEmpty)
                    _buildActionButton(
                      context,
                      icon: Icons.image,
                      label: 'Stock',
                      onPressed: () => _showStockPhotoDialog(context, cubit),
                    ),
                  if (state.sourceType != ImageSourceType.none)
                    _buildActionButton(
                      context,
                      icon: Icons.clear,
                      label: 'Clear',
                      onPressed: cubit.clearSelection,
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImagePreview(ImageSelectorState state) {
    Widget image;

    if (state.selectedFile != null) {
      image = Image.file(state.selectedFile!, height: 100, fit: BoxFit.cover);
    } else if (state.stockAssetPath != null) {
      image = Image.asset(state.stockAssetPath!, height: 100, fit: BoxFit.cover);
    } else {
      image = Container(
        height: 100,
        width: 100,
        color: Colors.grey.shade200,
        child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
      );
    }
    return image;
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
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
