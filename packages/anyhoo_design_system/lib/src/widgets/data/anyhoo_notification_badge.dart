import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Wraps [child] and overlays either a red status dot or a count pill.
class AnyhooNotificationBadge extends StatelessWidget {
  const AnyhooNotificationBadge({
    super.key,
    required this.child,
    this.count,
    this.showDot = false,
  });

  final Widget child;

  /// When non-null and > 0, shows a primary count pill.
  final int? count;

  /// When true (and [count] is null/0), shows a small red status dot.
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final status = context.status;

    final showCount = count != null && count! > 0;
    final showIndicator = showCount || showDot;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showIndicator)
          Positioned(
            right: -4,
            top: -4,
            child: showCount
                ? Container(
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: accent.primaryFixed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      count! > 99 ? '99+' : '$count',
                      style: AnyhooTypography.label(LabelSize.medium).copyWith(
                        color: accent.onPrimaryFixed,
                        fontSize: 10,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: status.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
          ),
      ],
    );
  }
}
