import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_design_system/src/widgets/cards/anyhoo_card.dart';
import 'package:flutter/material.dart';

/// Simple elevated card with title, body, and an optional text action.
class AnyhooEmptyCard extends AnyhooCard {
  const AnyhooEmptyCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnyhooCardShell(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [child]),
    );
  }
}
