import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Read-only date field that opens a picker via [onTap].
class AnyhooDateField extends StatelessWidget {
  const AnyhooDateField({
    super.key,
    required this.date,
    required this.onTap,
    this.hint = 'Select date',
    this.formatDate,
  });

  final DateTime? date;
  final VoidCallback onTap;
  final String hint;

  /// Optional custom formatter; defaults to `MMM d, yyyy`.
  final String Function(DateTime date)? formatDate;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;
    final controls = context.controls;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: surface.containerLow,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
            border: Border.all(color: controls.cardColors.borderColor!.withValues(alpha: 0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd, vertical: DesignTokens.spacingMd),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: accent.primaryFixed),
                const SizedBox(width: DesignTokens.spacingSm),
                Expanded(
                  child: Text(
                    date != null ? (formatDate ?? _defaultFormatDate)(date!) : hint,
                    style: AnyhooTypography.body(BodySize.large)
                        .copyWith(color: date != null ? surface.primaryText : surface.secondaryText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _defaultFormatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
