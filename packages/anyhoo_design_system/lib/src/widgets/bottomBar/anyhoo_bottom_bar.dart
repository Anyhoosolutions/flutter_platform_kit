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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 1, thickness: 1, color: appBar.bottomBarBorderColor),
        NavigationBar(
          backgroundColor: appBar.bottomBarBackground,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          selectedIndex: selectedIndex,
          height: 64,
          indicatorColor: appBar.bottomBarIndicatorColor,
          onDestinationSelected: (index) {
            destinations[index].onTap();
          },
          destinations: styledDestinations,
        ),
      ],
    );
  }
}
