import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

class AnyhooRemoveButton extends StatelessWidget {
  const AnyhooRemoveButton({super.key, required this.onPressed, this.color});

  final VoidCallback onPressed;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return AnyhooRoundButton(onPressed: onPressed, icon: Icons.delete, color: color);
  }
}
