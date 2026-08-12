import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

enum PrimaryButtonSize { small, medium, large }

class AnyhooPrimaryButton extends StatelessWidget {
  const AnyhooPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isActive = true,
    this.leadingIcon,
    this.trailingIcon,
    this.size = PrimaryButtonSize.medium,
    this.fullWidth = false,
  });

  final VoidCallback onPressed;
  final String label;
  final bool isActive;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final PrimaryButtonSize size;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;

    final fontSize = switch (size) {
      PrimaryButtonSize.small => 16.0,
      PrimaryButtonSize.medium => 24.0,
      PrimaryButtonSize.large => 32.0,
    };

    final button = FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(isActive ? accent.primaryFixed : accent.primaryDisabled),
        shape: WidgetStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) Icon(leadingIcon, color: accent.onPrimaryFixed).pad(r: DesignTokens.spacingXs),

            Text(
              label,
              style: AppFonts.oswald.copyWith(
                color: isActive ? accent.onPrimaryFixed : accent.onPrimaryDisabled,
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (trailingIcon != null) Icon(trailingIcon, color: accent.onPrimaryFixed).pad(l: DesignTokens.spacingXs),
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
