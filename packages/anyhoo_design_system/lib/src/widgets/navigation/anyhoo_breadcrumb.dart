import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// A single breadcrumb trail entry.
class AnyhooBreadcrumbItem {
  const AnyhooBreadcrumbItem({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;
}

/// Horizontal breadcrumb trail. The last item is the current page.
class AnyhooBreadcrumb extends StatelessWidget {
  const AnyhooBreadcrumb({
    super.key,
    required this.items,
  });

  final List<AnyhooBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingXs),
              child: Icon(Icons.chevron_right, size: 16, color: surface.outline),
            ),
          _BreadcrumbLabel(
            item: items[i],
            isCurrent: i == items.length - 1,
          ),
        ],
      ],
    );
  }
}

class _BreadcrumbLabel extends StatelessWidget {
  const _BreadcrumbLabel({
    required this.item,
    required this.isCurrent,
  });

  final AnyhooBreadcrumbItem item;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final style = AnyhooTypography.label(LabelSize.medium).copyWith(
      color: isCurrent ? surface.primaryText : surface.secondaryText,
      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
    );

    if (isCurrent || item.onTap == null) {
      return Text(item.label, style: style);
    }

    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(item.label, style: style),
    );
  }
}
