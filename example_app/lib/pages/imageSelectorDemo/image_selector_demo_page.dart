import 'package:anyhoo_image_selector/layout_type.dart';
import 'package:anyhoo_image_selector/widgets/anyhoo_image_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:anyhoo_image_selector/selected_image.dart';

/// Demo page showing image selector functionality.
class ImageSelectorDemoPage extends StatefulWidget {
  const ImageSelectorDemoPage({super.key});

  @override
  State<ImageSelectorDemoPage> createState() => _ImageSelectorDemoPageState();
}

class _ImageSelectorDemoPageState extends State<ImageSelectorDemoPage> {
  SelectedImage? _selectedImage;

  // Example stock photo paths (in a real app, these would be actual asset paths)
  final List<String> _stockPhotos = [
    'assets/images/baking.png',
    'assets/images/casserole.png',
    'assets/images/cocktail.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Selector Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select an image from gallery, camera, or stock photos',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AnyhooImageSelectorWidget(
              stockAssetPaths: _stockPhotos,
              layoutType: LayoutType.verticalStack,
              roundImage: false,
              onImageSelected: (image) {
                setState(() {
                  _selectedImage = image;
                });
                _showImageInfo(context, image);
              },
            ),
            const SizedBox(height: 32),
            if (_selectedImage != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              Text('Selected Image Info:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _buildImageInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageInfo() {
    final image = _selectedImage!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(label: 'Has Selection', value: image.hasSelection.toString()),
            if (image.path != null) _InfoRow(label: 'Type', value: 'Stock Photo'),
            if (image.path != null) _InfoRow(label: 'Path', value: image.path!),
            if (image.selectedFile != null) _InfoRow(label: 'Type', value: 'File'),
            if (image.selectedFile != null) _InfoRow(label: 'File Path', value: image.selectedFile!.path),
            if (image.selectedImage != null) _InfoRow(label: 'Type', value: 'Web Image'),
            if (image.selectedImage != null) _InfoRow(label: 'Bytes', value: '${image.selectedImage!.length} bytes'),
          ],
        ),
      ),
    );
  }

  void _showImageInfo(BuildContext context, SelectedImage image) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image selected: ${image.toString()}'), duration: const Duration(seconds: 2)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
