import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

/// Simple elevated card with title, body, and an optional text action.
class AnyhooErrorCard extends StatelessWidget {
  const AnyhooErrorCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final status = context.status;

    return AnyhooCardShell(
      backgroundColor: status.errorContainer,
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: status.error).pad(r: 4),
              Text(
                title,
                style: AppFonts.inter.copyWith(
                  fontSize: 20,
                  height: 28 / 20,
                  fontWeight: FontWeight.w600,
                  color: status.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          DefaultTextStyle(
            style: AppFonts.inter.copyWith(
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w400,
              color: status.error,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
