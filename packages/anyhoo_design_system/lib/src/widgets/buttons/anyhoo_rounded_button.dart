import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

class AnyhooRoundedButton extends StatelessWidget {
  const AnyhooRoundedButton({super.key, required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingSm, vertical: 2),
        decoration: BoxDecoration(
          color: accent.primaryFixed,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: accent.onPrimaryFixed,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
