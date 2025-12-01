import 'package:flutter/material.dart';

class AnyhooMultiSelectSearchable extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;
  final String? hintText;
  final String? semanticLabel;

  const AnyhooMultiSelectSearchable({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.hintText,
    this.semanticLabel,
  });

  @override
  State<AnyhooMultiSelectSearchable> createState() => _AnyhooMultiSelectSearchableState();
}

class _AnyhooMultiSelectSearchableState extends State<AnyhooMultiSelectSearchable> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];
  final List<String> _customItems = [];
  late List<String> _selectedItems;
  bool _isOverlayVisible = false;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _inputDecoratorKey = GlobalKey();
  double _inputDecoratorHeight = 0;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = [...widget.items, ..._customItems].where((item) => item.toLowerCase().contains(query)).toList();
    });
  }

  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });
  }

  List<Widget> _buildSelectedItemsChips(ThemeData theme) {
    if (_selectedItems.isEmpty) {
      return [Text('Select items...', style: TextStyle(color: theme.colorScheme.primary.withValues(alpha: 0.8)))];
    }
    const maxChips = 3;

    final itemsToShow = _selectedItems.length > maxChips ? _selectedItems.sublist(0, maxChips) : _selectedItems;

    final chips = itemsToShow.map((item) {
      return Chip(
        label: Text(item),
        onDeleted: () {
          setState(() {
            _selectedItems.remove(item);
            widget.onChanged(_selectedItems);
          });
        },
      );
    }).toList();

    if (_selectedItems.length > maxChips) {
      chips.add(Chip(label: Text('+${_selectedItems.length - maxChips} more')));
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _inputDecoratorKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final newHeight = renderBox.size.height;
        if (newHeight != _inputDecoratorHeight) {
          setState(() {
            _inputDecoratorHeight = newHeight;
          });
        }
      }
    });

    final theme = Theme.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _toggleOverlay,
            child: Semantics(
              label: widget.semanticLabel,
              child: InputDecorator(
                key: _inputDecoratorKey,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  helperMaxLines: 2,
                  labelText: widget.hintText,
                ),
                child: Wrap(spacing: 8, children: _buildSelectedItemsChips(theme)),
              ),
            ),
          ),
          if (_isOverlayVisible)
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, _inputDecoratorHeight + 5),
              child: Material(
                elevation: 4,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 32, // Adjust as needed
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search or add new...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          itemCount:
                              _filteredItems.length +
                              (_searchController.text.isNotEmpty && !_filteredItems.contains(_searchController.text)
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index == _filteredItems.length) {
                              return ListTile(
                                title: Text('Add "${_searchController.text}"'),
                                onTap: () {
                                  setState(() {
                                    final newItem = _searchController.text;
                                    if (!widget.items.contains(newItem) && !_customItems.contains(newItem)) {
                                      _customItems.add(newItem);
                                    }
                                    if (!_selectedItems.contains(newItem)) {
                                      _selectedItems.add(newItem);
                                      widget.onChanged(_selectedItems);
                                    }
                                    _searchController.clear();
                                  });
                                },
                              );
                            }

                            final item = _filteredItems[index];

                            return CheckboxListTile(
                              title: Text(item),
                              value: _selectedItems.contains(item),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    if (!_selectedItems.contains(item)) {
                                      _selectedItems.add(item);
                                    }
                                  } else {
                                    _selectedItems.remove(item);
                                  }

                                  widget.onChanged(_selectedItems);
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
