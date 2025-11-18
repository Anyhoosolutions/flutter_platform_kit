import 'package:app_image_selector/cubit/image_selector_state.dart';
import 'package:app_image_selector/cubit/show_stock_photos_cubit.dart';
import 'package:app_image_selector/widgets/add_stock_photo_page.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ImageSelectorCubit(
            stockAssetPaths: stockAssetPaths,
            preselectedImage: preselectedImage,
          ),
        ),
        BlocProvider(
          create: (context) => ShowStockPhotosCubit(),
        ),
      ],
      child: _ImageSelectorView(onImageSelected: onImageSelected, stockAssetPaths: stockAssetPaths),
    );
  }
}

class _ImageSelectorView extends StatelessWidget {
  final ValueChanged<ImageSelectorState> onImageSelected;
  final List<String> stockAssetPaths;

  const _ImageSelectorView({required this.onImageSelected, required this.stockAssetPaths});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ImageSelectorCubit>();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final parentWidth = constraints.maxWidth;

        final imageSelectorState = context.watch<ImageSelectorCubit>().state;
        final showStockPhotos = context.watch<ShowStockPhotosCubit>().state;

        if (imageSelectorState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (showStockPhotos) {
          return _showStockPhotos(context, stockAssetPaths);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display the selected image preview
            if (shouldShowImage(imageSelectorState)) _buildImagePreview(context, imageSelectorState, parentWidth),
            if (!shouldShowImage(imageSelectorState))

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
                      onPressed: () {
                        context.read<ShowStockPhotosCubit>().showStockPhotos();
                      },
                    ),
                  if (imageSelectorState.sourceType != ImageSourceType.none)
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
  }

  Widget _showStockPhotos(BuildContext context, List<String> stockAssetPaths) {
    return StockPhotoPage(
        stockAssetPaths: stockAssetPaths,
        onSelected: (String image) {
          context.read<ShowStockPhotosCubit>().hideStockPhotos();
          context.read<ImageSelectorCubit>().selectStockPhoto(image);
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
}
