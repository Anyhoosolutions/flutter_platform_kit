import 'package:flutter/material.dart';

/// Standard font abstractions for the design system.
abstract final class AppFonts {
  static const familyOswald = 'Oswald';
  static const familyInter = 'Inter';

  static const oswald = TextStyle(fontFamily: familyOswald);
  static const inter = TextStyle(fontFamily: familyInter);
}
