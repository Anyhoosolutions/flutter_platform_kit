import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Shared Level-1 elevated surface used by Kinetic Logic cards.
class AnyhooCardShell extends StatelessWidget {
  const AnyhooCardShell({
    super.key,
    required this.child,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;
  final Color? backgroundColor;

  static const level1Shadow = [BoxShadow(color: Color(0x0D000000), offset: Offset(0, 2), blurRadius: 4)];

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? surface.cardBackground,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        border: Border.all(color: surface.cardBorder.withValues(alpha: 0.3)),
        boxShadow: level1Shadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        clipBehavior: clipBehavior,
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}
