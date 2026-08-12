import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooTopBar, path: 'anyhoo_design_system/appBar')
Widget buildAnyhooTopBar(BuildContext context) {
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(context, _AnyhooTopBarShowcase());
}

class _AnyhooTopBarShowcase extends StatelessWidget {
  const _AnyhooTopBarShowcase();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnyhooTopBar(
            topBarText: 'Anyhoo Top Bar',
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
