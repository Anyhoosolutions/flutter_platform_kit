import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Kinetic Logic toggle switch with an optional leading label.
class AnyhooAvatar extends StatelessWidget {
  const AnyhooAvatar({super.key, required this.text, required this.imageUrl, this.highlighted = false});

  final String? text;
  final String? imageUrl;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final avatar = context.controls.avatarColors;

    final buttonColor = highlighted ? avatar.regular.background : avatar.selected.background;
    final textColor = highlighted ? avatar.regular.foreground : avatar.selected.foreground;

    final child = imageUrl != null
        ? Container()
        : Text(
            text ?? '',
            style: AnyhooTypography.body(BodySize.medium).copyWith(color: textColor, fontWeight: FontWeight.w600),
          );

    return CircleAvatar(
      backgroundColor: buttonColor,
      foregroundColor: textColor,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: child,
    );
  }
}
