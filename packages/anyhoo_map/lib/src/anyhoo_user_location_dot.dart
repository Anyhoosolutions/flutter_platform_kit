import 'package:flutter/material.dart';

/// The default "you are here" marker: a filled dot with a white ring and a
/// soft halo, in the style map apps use for the device's position.
class AnyhooUserLocationDot extends StatelessWidget {
  const AnyhooUserLocationDot({
    super.key,
    this.color = const Color(0xFF34A853),
    this.size = 18,
  });

  final Color color;

  /// Diameter of the dot including its white ring. The halo is twice as wide.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size * 2,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.2),
          ),
          child: Padding(
            padding: EdgeInsets.all(size / 2),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(color: Color(0x40000000), blurRadius: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
