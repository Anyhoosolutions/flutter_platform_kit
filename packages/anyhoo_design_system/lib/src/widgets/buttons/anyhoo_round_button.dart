import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

class AnyhooRoundButton extends StatelessWidget {
  factory AnyhooRoundButton.add({required VoidCallback onPressed, Color? color}) {
    return AnyhooRoundButton(onPressed: onPressed, icon: Icons.add, color: color);
  }
  factory AnyhooRoundButton.minus({required VoidCallback onPressed, Color? color}) {
    return AnyhooRoundButton(onPressed: onPressed, icon: Icons.abc, color: color);
  }
  factory AnyhooRoundButton.remove({required VoidCallback onPressed, Color? color}) {
    return AnyhooRoundButton(onPressed: onPressed, icon: Icons.remove, color: color);
  }

  const AnyhooRoundButton({super.key, required this.onPressed, required this.icon, this.color});

  final VoidCallback? onPressed;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final controls = context.controls;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color ?? controls.cardColors.borderColor!),
          ),
          child: Icon(icon, color: color ?? surface.secondaryText),
        ),
      ),
    );
  }
}
