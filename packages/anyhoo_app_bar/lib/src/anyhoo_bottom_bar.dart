import 'package:anyhoo_app_bar/src/anyhoo_bottom_bar_item.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class AnyhooBottomBar extends StatefulWidget {
  const AnyhooBottomBar({super.key, this.backgroundColor, required this.items, required this.selectedItemKey});

  final Color? backgroundColor;
  final List<AnyhooBottomBarItem> items;
  final String selectedItemKey;

  @override
  State<AnyhooBottomBar> createState() => _AnyhooBottomBarState();
}

class _AnyhooBottomBarState extends State<AnyhooBottomBar> {
  final _log = Logger('AnyhooBottomBar');

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
              (item) => _buildBottomNavItem(
                context,
                item.icon,
                item.label,
                item.key == widget.selectedItemKey,
                item.route,
                iconColor,
                selectedColor,
              ),
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
        _log.info('Tapping on $label to go to $url');
        GoRouterWrapper.push(context, url);
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
