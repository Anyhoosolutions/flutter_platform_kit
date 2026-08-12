import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_design_system/src/widgets/buttons/anyhoo_button_content.dart';
import 'package:flutter/material.dart';

/// Text-only action button (Kinetic Logic).
///
/// Primary-colored label, no fill or border, 48px height, 8px radius hit target.
class AnyhooTextButton extends StatelessWidget {
  const AnyhooTextButton({
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
    final surface = context.surface;

    final button = TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: accent.primaryFixed,
        disabledForegroundColor: accent.primaryDisabled,
        minimumSize: Size(fullWidth ? double.infinity : _minWidth, _height),
        maximumSize: const Size(double.infinity, _height),
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingLg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusMd)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed) || states.contains(WidgetState.hovered)) {
            return surface.containerHighest.withValues(alpha: 0.6);
          }
          return null;
        }),
      ),
      child: AnyhooButtonContent(label: label, leadingIcon: leadingIcon, trailingIcon: trailingIcon),
    );

    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, height: _height, child: button);
  }
}
