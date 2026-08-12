import 'package:flutter/material.dart';

final List<NavigationDestination> appDestinations = [
  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
];

class AnyhooBottomBar extends StatelessWidget {
  const AnyhooBottomBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  factory AnyhooBottomBar.fromPath(String path) {
    return AnyhooBottomBar(
      destinations: appDestinations,
      selectedIndex: path.startsWith('/settings') ? 1 : 0,
      onDestinationSelected: (BuildContext context, int index) {
        switch (index) {
          case 0:
          // context.go('/home');
          case 1:
          // context.go('/settings');
        }
      },
    );
  }

  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final Function(BuildContext context, int index) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        onDestinationSelected(context, index);
      },
      destinations: destinations,
    );
  }
}
