import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

enum SecondaryButtonSize { tiny, small, medium, large }

class AnyhooSecondaryButton extends StatelessWidget {
  const AnyhooSecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.size = SecondaryButtonSize.medium,
    this.fullWidth = false,
    this.roundedCorners = false,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final SecondaryButtonSize size;
  final bool fullWidth;
  final bool roundedCorners;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;

    final fontSize = switch (size) {
      SecondaryButtonSize.tiny => 12.0,
      SecondaryButtonSize.small => 16.0,
      SecondaryButtonSize.medium => 24.0,
      SecondaryButtonSize.large => 32.0,
    };
    final primaryColor = accent.primaryFixed;
    final bgColor = Colors.red;
    // context.surface.lowContractBackground;

    final button = FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(bgColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: roundedCorners ? BorderRadius.circular(DesignTokens.radiusMd) : BorderRadius.zero,
          ),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) Icon(leadingIcon, color: primaryColor).pad(r: DesignTokens.spacingXs),

            Text(
              label,
              style: AppFonts.oswald.copyWith(color: primaryColor, fontSize: fontSize, fontWeight: FontWeight.w700),
            ),
            if (trailingIcon != null) Icon(trailingIcon, color: primaryColor).pad(l: DesignTokens.spacingXs),
          ],
        ),
      ),
    );
    if (!fullWidth) {
      return button;
    }
    return SizedBox(height: 60, width: double.infinity, child: button).pad(l: 12, r: 12);
  }
}
