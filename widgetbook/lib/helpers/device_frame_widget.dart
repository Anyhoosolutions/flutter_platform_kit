import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:flutter/material.dart';

class DeviceFrameWidget extends StatelessWidget {
  final Widget child;
  final bool showFrame;
  final DeviceInfo deviceType;
  final Orientation orientation;

  const DeviceFrameWidget({
    super.key,
    required this.child,
    required this.deviceType,
    required this.orientation,
    this.showFrame = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showFrame) {
      return child;
    }

    return Center(
      child: DeviceFrame(device: deviceType, orientation: orientation, screen: child),
    );
  }
}
