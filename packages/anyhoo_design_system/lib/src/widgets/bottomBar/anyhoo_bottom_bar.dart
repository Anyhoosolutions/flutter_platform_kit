import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

class AnyhooBottomBar extends StatelessWidget {
  const AnyhooBottomBar({super.key, required this.destinations, required this.selectedIndex});

  final List<AnyhooBottomBarButton> destinations;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final appBar = context.appBar;

    final styledDestinations = destinations
        .map(
          (e) => NavigationDestination(
            icon: Icon(e.icon, color: appBar.bottomBarIconColors),
            label: '',
          ),
        )
        .toList();

    return NavigationBar(
      backgroundColor: appBar.bottomBarBackground,
      selectedIndex: selectedIndex,
      height: 64,
      indicatorColor: appBar.bottomBarIndicatorColor,
      onDestinationSelected: (index) {
        destinations[index].onTap();
      },
      destinations: styledDestinations,
    );
  }
}
