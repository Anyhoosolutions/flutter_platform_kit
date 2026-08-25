import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Showcase of top and bottom bars.
class AnyhooAppBarGallery extends StatelessWidget {
  const AnyhooAppBarGallery({super.key, this.useSubtitle = false});

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
            onSettingsTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings')));
            },
            onProfileTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile')));
            },
            onLogoutClick: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log out')));
            },
          ),
          AnyhooBottomBar.fromPath(''),
        ],
      ),
    );
  }
}
