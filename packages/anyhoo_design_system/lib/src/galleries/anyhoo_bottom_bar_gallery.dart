import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

/// Showcase of top and bottom bars.
class AnyhooBottomBarGallery extends StatelessWidget {
  const AnyhooBottomBarGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text('Hello').pad(l: 16)),
      bottomNavigationBar: AnyhooBottomBar(
        destinations: [
          AnyhooBottomBarButton(icon: Icons.home, label: 'Home', onTap: () {}),
          AnyhooBottomBarButton(icon: Icons.settings, label: 'Settings', onTap: () {}),
          AnyhooBottomBarButton(icon: Icons.logout, label: 'Log out', onTap: () {}),
        ],
        selectedIndex: 0,
      ),
    );
  }
}
