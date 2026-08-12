import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Single accordion panel with expand/collapse.
class AnyhooExpansionPanel extends StatefulWidget {
  const AnyhooExpansionPanel({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;

  @override
  State<AnyhooExpansionPanel> createState() => _AnyhooExpansionPanelState();
}

class _AnyhooExpansionPanelState extends State<AnyhooExpansionPanel> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingMd,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AnyhooTypography.label(LabelSize.large).copyWith(
                      color: surface.primaryText,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more,
                    color: surface.secondaryText,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(
              DesignTokens.spacingMd,
              0,
              DesignTokens.spacingMd,
              DesignTokens.spacingMd,
            ),
            child: DefaultTextStyle(
              style: AnyhooTypography.body(BodySize.medium).copyWith(
                color: surface.secondaryText,
              ),
              child: widget.child,
            ),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

/// FAQ-style accordion list with optional header and divide-y separators.
class AnyhooExpansionList extends StatelessWidget {
  const AnyhooExpansionList({
    super.key,
    required this.panels,
    this.headerTitle,
  });

  final String? headerTitle;
  final List<AnyhooExpansionPanel> panels;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return AnyhooCardShell(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (headerTitle != null) ...[
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingMd),
              child: Text(
                headerTitle!,
                style: AnyhooTypography.headline(HeadlineSize.tiny).copyWith(
                  color: surface.primaryText,
                ),
              ),
            ),
            Divider(height: 1, thickness: 1, color: surface.cardBorder.withValues(alpha: 0.3)),
          ],
          for (var i = 0; i < panels.length; i++) ...[
            panels[i],
            if (i < panels.length - 1)
              Divider(height: 1, thickness: 1, color: surface.cardBorder.withValues(alpha: 0.3)),
          ],
        ],
      ),
    );
  }
}
