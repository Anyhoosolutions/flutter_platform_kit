import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Rounded-full search field with optional trailing filter action.
class AnyhooSearchField extends StatelessWidget {
  const AnyhooSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hint = 'Search',
    this.onFilterTap,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hint;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface.containerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: DesignTokens.spacingMd),
            child: Icon(Icons.search, size: 20, color: surface.secondaryText),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AnyhooTypography.body(BodySize.large).copyWith(
                color: surface.primaryText,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AnyhooTypography.body(BodySize.large).copyWith(
                  color: surface.secondaryText,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingSm,
                  vertical: DesignTokens.spacingMd,
                ),
                isDense: true,
              ),
            ),
          ),
          if (onFilterTap != null)
            IconButton(
              onPressed: onFilterTap,
              icon: Icon(Icons.tune, size: 20, color: accent.primaryFixed),
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            ),
        ],
      ),
    );
  }
}
