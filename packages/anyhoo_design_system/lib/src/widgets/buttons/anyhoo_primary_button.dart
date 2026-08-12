import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_design_system/src/widgets/buttons/anyhoo_button_content.dart';
import 'package:flutter/material.dart';

/// Filled primary action button (Kinetic Logic).
///
/// Solid primary fill, on-primary label, 48px height, 8px radius.
class AnyhooPrimaryButton extends StatelessWidget {
  const AnyhooPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool fullWidth;

  static const double _height = 48;
  static const double _minWidth = 120;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final enabled = onPressed != null;

    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: enabled ? accent.primaryFixed : accent.primaryDisabled,
        foregroundColor: enabled ? accent.onPrimaryFixed : accent.onPrimaryDisabled,
        disabledBackgroundColor: accent.primaryDisabled,
        disabledForegroundColor: accent.onPrimaryDisabled,
        minimumSize: Size(fullWidth ? double.infinity : _minWidth, _height),
        maximumSize: const Size(double.infinity, _height),
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingLg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
        elevation: 0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: AnyhooButtonContent(label: label, leadingIcon: leadingIcon, trailingIcon: trailingIcon),
    );

    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, height: _height, child: button);
  }
}
