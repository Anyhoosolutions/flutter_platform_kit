import 'dart:math';
import 'dart:typed_data';

import 'package:anyhoo_image_selector/cubit/image_selector_state.dart';
import 'package:anyhoo_image_selector/cubit/show_stock_photos_cubit.dart';
import 'package:anyhoo_image_selector/layout_type.dart';
import 'package:anyhoo_image_selector/widgets/add_stock_photo_page.dart';
import 'package:anyhoo_image_selector/selected_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:logging/logging.dart';

import '../cubit/image_selector_cubit.dart';

const emptyIconSize = 40.0;
const emptyIconTotalSize = 100.0;
const horizontalSplitSpacing = 16.0;
const horizontalSplitPadding = 16.0;

final _log = Logger('AnyhooImageSelectorWidget');

class AnyhooImageSelectorWidget extends StatefulWidget {
  // Callback when a file is selected
  final ValueChanged<SelectedImage>? onImageSelected;
  final List<String> stockAssetPaths;
  final String? preselectedImage;
  final bool roundImage;
  final LayoutType layoutType;

  const AnyhooImageSelectorWidget({
    super.key,
    this.onImageSelected,
    this.stockAssetPaths = const [],
    this.preselectedImage,
    this.roundImage = false,
    required this.layoutType,
  });

  @override
  State<AnyhooImageSelectorWidget> createState() => _AnyhooImageSelectorWidgetState();
}

class _AnyhooImageSelectorWidgetState extends State<AnyhooImageSelectorWidget> {
  late final ImageSelectorCubit _imageSelectorCubit;
  late final ShowStockPhotosCubit _showStockPhotosCubit;

  @override
  void initState() {
    super.initState();
    _imageSelectorCubit = ImageSelectorCubit(
      stockAssetPaths: widget.stockAssetPaths,
      preselectedImage: widget.preselectedImage,
    );
    _showStockPhotosCubit = ShowStockPhotosCubit();
  }

  @override
  void didUpdateWidget(AnyhooImageSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the cubit when preselectedImage changes
    if (oldWidget.preselectedImage != widget.preselectedImage) {
      _imageSelectorCubit.updatePreselectedImage(widget.preselectedImage);
    }
  }

  @override
  void dispose() {
    _imageSelectorCubit.close();
    _showStockPhotosCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide the cubit locally to the widget subtree
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _imageSelectorCubit),
        BlocProvider.value(value: _showStockPhotosCubit),
      ],
      child: _ImageSelectorView(
          onImageSelected: widget.onImageSelected,
          stockAssetPaths: widget.stockAssetPaths,
          layoutType: widget.layoutType,
          roundImage: widget.roundImage),
    );
  }
}

class _ImageSelectorView extends StatelessWidget {
  final ValueChanged<SelectedImage>? onImageSelected;
  final List<String> stockAssetPaths;
  final LayoutType layoutType;
  final bool roundImage;

  const _ImageSelectorView({
    required this.onImageSelected,
    required this.stockAssetPaths,
    required this.layoutType,
    required this.roundImage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageSelectorCubit, ImageSelectorState>(
      listener: (context, state) {
        // Convert internal state to public API and call the callback
        final selectedImage = SelectedImage(
          path: state.path,
          selectedFile: state.selectedFile,
          selectedImage: state.selectedImage,
          mimeType: state.mimeType,
        );
        _log.info('SelectedImage created: $selectedImage');
        if (onImageSelected != null) {
          onImageSelected!(selectedImage);
        }
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          try {
            final parentWidth = constraints.maxWidth;

            final imageSelectorState = context.watch<ImageSelectorCubit>().state;
            final showStockPhotos = context.watch<ShowStockPhotosCubit>().state;

            if (imageSelectorState.isLoading) {
              return const Center(child: CircularProgressIndicator()); // TODO: Shimmer
            }

            if (showStockPhotos) {
              return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: min(parentWidth, 600)),
                  child: _showStockPhotos(context, stockAssetPaths));
            }

            final showImage = shouldShowImage(imageSelectorState);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display the selected image preview
                if (showImage)
                  FutureBuilder<Widget>(
                      future: _buildImagePreview(context, imageSelectorState, parentWidth),
                      builder: (context, snapshot) {
                        return snapshot.data ?? const SizedBox.shrink();
                      }),
                if (!showImage) getEmptyIconAndButtonsLayout(context, parentWidth),
              ],
            );
          } catch (e) {
            _log.severe('Error building image selector', e);
            return Center(child: Text('Error: ${e.toString()}'));
          }
        },
      ),
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
    final shouldShow = state.selectedFile != null || state.path != null || state.selectedImage != null;
    return shouldShow;
  }

  double getImageWidth(double parentWidth) {
    return min(parentWidth * 0.9, 300);
  }

  Future<Widget> _buildImagePreview(BuildContext context, ImageSelectorState state, double parentWidth) async {
    Widget image;
    Uint8List? imageBytes;

    if (state.selectedImage != null) {
      imageBytes = state.selectedImage;
    } else if (state.selectedFile != null) {
      imageBytes = await state.selectedFile!.readAsBytes();
    }

    if (imageBytes != null) {
      _log.info('Showing memory image');
      image = Image.memory(
          key: const Key('memory-image'), imageBytes, width: getImageWidth(parentWidth), fit: BoxFit.cover);
    } else if (state.selectedFile != null) {
      _log.info('Showing file image');
      image = Image.file(
          key: const Key('file-image'), state.selectedFile!, width: getImageWidth(parentWidth), fit: BoxFit.cover);
    } else if (state.path != null && state.path!.startsWith('http')) {
      _log.info('Showing network image');
      image = Image.network(
          key: const Key('network-image'), state.path!, width: getImageWidth(parentWidth), fit: BoxFit.cover);
    } else if (state.path != null) {
      _log.info('Showing asset image');
      image =
          Image.asset(key: const Key('asset-image'), state.path!, width: getImageWidth(parentWidth), fit: BoxFit.cover);
    } else {
      _log.info('Showing empty image');
      image = Container(
        key: const Key('empty-image'),
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
          child: roundImage
              ? ClipOval(child: image)
              : ClipRRect(
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
                  child: const Icon(Icons.cancel, size: 48, color: Colors.black)))),
      // TODO: Colors should either be from theme or settable
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
      {required IconData icon,
      required String label,
      required VoidCallback onPressed,
      required LayoutType layoutType}) {
    final showLabel = layoutType != LayoutType.imageTopRowBottom;

    final labelWidth = getLabelWidth(parentWidth, layoutType);

    return SizedBox(
        width: labelWidth,
        child: InkWell(
            onTap: onPressed,
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 2,
                dashPattern: [10, 6],
                radius: const Radius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(icon, size: emptyIconSize, color: Theme.of(context).colorScheme.primary),
                    if (showLabel) const SizedBox(width: horizontalSplitSpacing),
                    if (showLabel) Text(label, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            )));
  }

  Widget getEmptyIconAndButtonsLayout(BuildContext context, double parentWidth) {
    final cubit = context.read<ImageSelectorCubit>();

    final emptyIcon = _buildEmptyImageIcon(context, parentWidth);
    final buttons = [
      _buildActionButton(
        context,
        parentWidth,
        icon: Icons.photo_library,
        label: 'Gallery',
        onPressed: () => cubit.pickImage(ImageSource.gallery),
        layoutType: layoutType,
      ),
      _buildActionButton(
        context,
        parentWidth,
        icon: Icons.camera_alt,
        label: 'Camera',
        onPressed: () => cubit.pickImage(ImageSource.camera),
        layoutType: layoutType,
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
          layoutType: layoutType,
        ),
    ];

    if (layoutType == LayoutType.verticalStack) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmptyImageIcon(context, parentWidth),
          const SizedBox(height: 16),
          ...buttons.expand((button) => [button, const SizedBox(height: 16)]),
        ],
      );
    }
    if (layoutType == LayoutType.horizontalSplit) {
      return Padding(
        padding: const EdgeInsets.all(horizontalSplitPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            emptyIcon,
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                ...buttons,
              ],
            ),
          ],
        ),
      );
    }
    if (layoutType == LayoutType.imageTopRowBottom) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          emptyIcon,
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, spacing: 16, children: buttons),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  double getLabelWidth(double parentWidth, LayoutType layoutType) {
    if (layoutType == LayoutType.verticalStack) {
      final labelWidth = parentWidth * 0.9;
      return labelWidth;
    }
    if (layoutType == LayoutType.horizontalSplit) {
      final labelWidth = parentWidth - emptyIconTotalSize - 2 * horizontalSplitPadding - horizontalSplitSpacing - 40;
      return labelWidth;
    }
    if (layoutType == LayoutType.imageTopRowBottom) {
      const labelWidth = 60.0;
      return labelWidth;
    }
    throw Exception('Invalid layout type: $layoutType');
  }
}
