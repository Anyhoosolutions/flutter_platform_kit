import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// A labeled value segment for [AnyhooSegmentedControl].
class AnyhooSegment<T> {
  const AnyhooSegment({required this.label, required this.value, this.key});

  final String label;
  final T value;
  final Key? key;
}

/// Pill-track segmented control with an elevated selected thumb.
class AnyhooSegmentedControl<T> extends StatelessWidget {
  const AnyhooSegmentedControl({super.key, required this.segments, required this.selected, required this.onChanged});

  final List<AnyhooSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface.containerHigh,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXs),
        child: Row(
          children: [
            for (final segment in segments)
              Expanded(
                child: _SegmentThumb(
                  key: segment.key,
                  label: segment.label,
                  selected: segment.value == selected,
                  onTap: () => onChanged(segment.value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SegmentThumb extends StatelessWidget {
  const _SegmentThumb({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm, vertical: DesignTokens.spacingSm),
        decoration: BoxDecoration(
          color: selected ? surface.cardBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          boxShadow: selected ? AnyhooCardShell.level1Shadow : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AnyhooTypography.label(LabelSize.medium).copyWith(
            color: selected ? surface.primaryText : surface.secondaryText,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
