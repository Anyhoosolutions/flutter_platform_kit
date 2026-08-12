import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Card-wrapped list with an optional header and dividers between [children].
class AnyhooList extends StatelessWidget {
  const AnyhooList({
    super.key,
    required this.children,
    this.title,
  });

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final dividerColor = surface.cardBorder.withValues(alpha: 0.3);

    return AnyhooCardShell(
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                child: Text(
                  title!,
                  style: AnyhooTypography.headline(HeadlineSize.small).copyWith(
                    color: surface.primaryText,
                  ),
                ),
              ),
              Divider(height: 1, thickness: 1, color: dividerColor),
            ],
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) Divider(height: 1, thickness: 1, color: dividerColor),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
