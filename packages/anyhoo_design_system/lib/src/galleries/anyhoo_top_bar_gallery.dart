import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_design_system/src/widgets/topBar/button_item.dart';
import 'package:anyhoo_design_system/src/widgets/topBar/menu_item.dart';
import 'package:flutter/material.dart';

/// Showcase of top and bottom bars.
class AnyhooTopBarGallery extends StatelessWidget {
  const AnyhooTopBarGallery({super.key, this.useSubtitle = false});

  final bool useSubtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnyhooTopBar(
            topBarTitle: 'Anyhoo Top Bar',
            topBarSubtitle: useSubtitle ? 'Subtitle' : null,
            showBackButton: true,
            overflowMenuIcon: Icons.add_business_outlined,
            buttonItems: [
              ButtonItem(
                key: const Key('settings'),
                label: 'Settings',
                icon: Icons.car_crash,
                color: Colors.red,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings')));
                },
              ),
            ],
            menuItems: [
              MenuItem(
                key: const Key('settings'),
                label: 'Settings',
                icon: Icons.car_crash,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings')));
                },
              ),
              MenuItem(
                key: const Key('profile'),
                label: 'Profile',
                icon: Icons.celebration,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile')));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
