import 'package:flutter/material.dart';

class AnyhooSearchBar extends StatefulWidget {
  final String searchText;
  final bool showIncludeEverythingCheckbox;
  final void Function(String) onChanged;
  final void Function(bool)? onIncludeEverythingChanged;
  final IconData icon;

  const AnyhooSearchBar({
    super.key,
    this.searchText = 'Search...',
    this.showIncludeEverythingCheckbox = false,
    required this.onChanged,
    this.onIncludeEverythingChanged,
    this.icon = Icons.search,
  });

  @override
  State<AnyhooSearchBar> createState() => _AnyhooSearchBarState();
}

class _AnyhooSearchBarState extends State<AnyhooSearchBar> {
  bool includeEverything = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: const Color(0xFFFFF0E6), borderRadius: BorderRadius.circular(80)),
                child: TextField(
                  controller: searchController,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    hintText: widget.searchText,
                    hintStyle: TextStyle(color: theme.colorScheme.primary, fontSize: 16),
                    prefixIcon: Icon(widget.icon, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
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
            if (widget.showIncludeEverythingCheckbox)
              Text(
                'Full',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.colorScheme.primary),
              ),
          ],
        ),
      ),
    );
  }
}
