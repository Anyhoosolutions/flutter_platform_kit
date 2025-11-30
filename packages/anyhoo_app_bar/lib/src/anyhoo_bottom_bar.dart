import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

enum BottomBarNavItems { recipes, favorites, profile, mealPlan, settings, explore, debug, logging }

class AnyhooBottomBar extends StatefulWidget {
  const AnyhooBottomBar({super.key, this.backgroundColor, required this.items, required this.selected});

  final Color? backgroundColor;
  final List<BottomBarNavItems> items;
  final BottomBarNavItems selected;

  @override
  State<AnyhooBottomBar> createState() => _AnyhooBottomBarState();
}

class _AnyhooBottomBarState extends State<AnyhooBottomBar> {
  // ignore: unused_field
  final _log = Logger('CustomBottomBar');

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? Theme.of(context).colorScheme.primary;
    final selectedColor = Theme.of(context).colorScheme.primary;
    final iconColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: backgroundColor.withValues(alpha: 0.4), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items
            .map(
              (item) => switch (item) {
                BottomBarNavItems.recipes => _buildBottomNavItem(
                  context,
                  Icons.book_outlined,
                  'Recipes',
                  item == widget.selected,
                  '/recipes',
                  iconColor,
                  selectedColor,
                ),
                BottomBarNavItems.favorites => _buildBottomNavItem(
                  context,
                  Icons.favorite_border_outlined,
                  'Favorites',
                  item == widget.selected,
                  '/favorites',
                  iconColor,
                  selectedColor,
                ),
                BottomBarNavItems.profile => _buildBottomNavItem(
                  context,
                  Icons.person_outlined,
                  'Profile',
                  item == widget.selected,
                  '/profile',
                  iconColor,
                  selectedColor,
                ),
                BottomBarNavItems.settings => _buildBottomNavItem(
                  context,
                  Icons.settings_outlined,
                  'Settings',
                  item == widget.selected,
                  '/settings',
                  iconColor,
                  selectedColor,
                ),
                BottomBarNavItems.mealPlan => _buildBottomNavItem(
                  context,
                  Icons.receipt_long_outlined,
                  'Meal plan',
                  item == widget.selected,
                  '/mealPlans',
                  iconColor,
                  selectedColor,
                ),
                BottomBarNavItems.explore => _buildBottomNavItem(
                  context,
                  Icons.explore_outlined,
                  'Explore',
                  item == widget.selected,
                  '/explore',
                  iconColor,
                  selectedColor,
                ),
                BottomBarNavItems.debug => _buildBottomNavItem(
                  context,
                  Icons.bug_report_outlined,
                  'Debug',
                  item == widget.selected,
                  '/debug',
                  iconColor,
                  selectedColor,
                ),
                BottomBarNavItems.logging => _buildBottomNavItem(
                  context,
                  Icons.document_scanner,
                  'Logging',
                  item == widget.selected,
                  '/logging',
                  iconColor,
                  selectedColor,
                ),
              },
            )
            .toList(),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
    String url,
    Color color,
    Color selectedColor,
  ) {
    return GestureDetector(
      onTap: () {
        // goRouterWrapper.push(context, url);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? selectedColor : color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? selectedColor : color, fontSize: 12)),
        ],
      ),
    );
  }
}
