import 'package:flutter/material.dart';

class StockPhotoPage extends StatefulWidget {
  const StockPhotoPage({super.key, required this.stockAssetPaths, required this.onSelected});

  final List<String> stockAssetPaths;
  final void Function(String image) onSelected;

  @override
  State<StockPhotoPage> createState() => _StockPhotoPageState();
}

class _StockPhotoPageState extends State<StockPhotoPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedStockPhotoId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Scaffold(
        backgroundColor: Colors.brown, // Theme.of(context).colorScheme.surface,
        body: CustomScrollView(
          slivers: [
            _buildTitle(context, theme),
            _buildImageGrid(context, theme),
            _buildDoneButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text('Select a stock photo', style: theme.textTheme.titleLarge)),
      ),
    );
  }

  Widget _buildImageGrid(
    BuildContext context,
    ThemeData theme,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.all(18.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final isSelected = _selectedStockPhotoId == widget.stockAssetPaths[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedStockPhotoId = isSelected ? null : widget.stockAssetPaths[index];
              });
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.primary : Colors.black,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      widget.stockAssetPaths[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }, childCount: widget.stockAssetPaths.length),
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _selectedStockPhotoId != null
                ? () {
                    widget.onSelected(_selectedStockPhotoId!);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
