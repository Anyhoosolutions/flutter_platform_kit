import 'package:flutter/material.dart';

class AnyhooSearchBar extends StatefulWidget {
  final bool showIncludeEverythingCheckbox;
  final void Function(String) onChanged;
  final void Function(bool)? onIncludeEverythingChanged;
  final IconData icon;
  final String labelText;
  final bool wrapInSliver;

  const AnyhooSearchBar({
    super.key,
    this.labelText = 'Search...',
    this.showIncludeEverythingCheckbox = false,
    required this.onChanged,
    this.onIncludeEverythingChanged,
    this.icon = Icons.search,
    this.wrapInSliver = true,
  });

  @override
  State<AnyhooSearchBar> createState() => _AnyhooSearchBarState();
}

class _AnyhooSearchBarState extends State<AnyhooSearchBar> {
  bool includeEverything = false;
  late final SearchController searchController;

  @override
  void initState() {
    super.initState();
    searchController = SearchController();
    searchController.addListener(() {
      widget.onChanged(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: SearchBar(
              controller: searchController,
              hintText: widget.labelText,
              leading: Icon(widget.icon, color: theme.colorScheme.primary),
            ),
          ),
          if (widget.showIncludeEverythingCheckbox)
            Checkbox(
              value: includeEverything,
              onChanged: (value) {
                widget.onIncludeEverythingChanged?.call(value ?? false);
                setState(() {
                  includeEverything = value ?? false;
                });
              },
            ),
          if (widget.showIncludeEverythingCheckbox) Text('Full'),
        ],
      ),
    );
    if (widget.wrapInSliver) {
      return SliverToBoxAdapter(child: child);
    }
    return child;
  }
}
