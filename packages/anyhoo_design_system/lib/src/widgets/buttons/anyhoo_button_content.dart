import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Shared label + optional icons for Kinetic action buttons.
class AnyhooButtonContent extends StatelessWidget {
  const AnyhooButtonContent({
    super.key,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 20),
          const SizedBox(width: DesignTokens.spacingXs),
        ],
        Flexible(
          child: Text(
            label,
            style: AnyhooTypography.label(LabelSize.large),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: DesignTokens.spacingXs),
          Icon(trailingIcon, size: 20),
        ],
      ],
    );
  }
}
