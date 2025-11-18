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
  int _currentPage = 0;

  static const int _itemsPerPage = 6; // 3 columns × 2 rows

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _totalPages => (widget.stockAssetPaths.length / _itemsPerPage).ceil();
  bool get _hasPreviousPage => _currentPage > 0;
  bool get _hasNextPage => _currentPage < _totalPages - 1;

  List<String> get _currentPageItems {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, widget.stockAssetPaths.length);
    return widget.stockAssetPaths.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.brown, // Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          _buildTitle(context, theme),
          Expanded(
            child: Row(
              children: [
                _buildArrowButton(context, theme, isLeft: true),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      _buildImageGrid(context, theme),
                    ],
                  ),
                ),
                if (_hasNextPage) _buildArrowButton(context, theme, isLeft: false),
              ],
            ),
          ),
          _buildDoneButton(context, theme),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text('Select a stock photo', style: theme.textTheme.titleLarge)),
    );
  }

  Widget _buildImageGrid(BuildContext context, ThemeData theme) {
    final currentItems = _currentPageItems;

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final assetPath = currentItems[index];
            final isSelected = _selectedStockPhotoId == assetPath;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStockPhotoId = isSelected ? null : assetPath;
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
                        assetPath,
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
                        width: 24,
                        height: 24,
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
          },
          childCount: currentItems.length,
        ),
      ),
    );
  }

  Widget _buildArrowButton(BuildContext context, ThemeData theme, {required bool isLeft}) {
    var showArrow = true;
    if (isLeft && !_hasPreviousPage) {
      showArrow = false;
    }
    if (!isLeft && !_hasNextPage) {
      showArrow = false;
    }

    return IconButton(
      onPressed: () {
        if (!showArrow) return;
        setState(() {
          if (isLeft) {
            _currentPage--;
          } else {
            _currentPage++;
          }
        });
      },
      padding: EdgeInsets.zero,
      icon: Icon(isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios),
      iconSize: 24,
      color: showArrow ? theme.colorScheme.onSurface : Colors.transparent,
    );
  }

  Widget _buildDoneButton(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
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
    );
  }
}
