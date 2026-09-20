import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Named theme options available in design-system Widgetbook showcases.
enum ShowcaseThemeOption {
  defaults('Default');

  // slateSky('Slate + Sky'),
  // warmTerracotta('Warm Terracotta'),
  // emeraldGreen('Emerald Green'),
  // crazy('Crazy');

  const ShowcaseThemeOption(this.label);

  final String label;

  static ShowcaseThemeOption fromLabel(String label) {
    return ShowcaseThemeOption.values.firstWhere((option) => option.label == label);
  }

  ThemeData lightTheme() {
    return switch (this) {
      ShowcaseThemeOption.defaults => AnyhooTheme.light(),
      // ShowcaseThemeOption.slateSky => AnyhooTheme.light(colors: slateSkyColors),
      // ShowcaseThemeOption.warmTerracotta => AnyhooTheme.light(colors: warmTerracottaColors),
      // ShowcaseThemeOption.emeraldGreen => AnyhooTheme.light(colors: emeraldGreenColors),
      // ShowcaseThemeOption.crazy => AnyhooTheme.light(colors: crazyColors),
    };
  }

  ThemeData darkTheme() {
    return switch (this) {
      ShowcaseThemeOption.defaults => AnyhooTheme.dark(),
      // ShowcaseThemeOption.slateSky => AnyhooTheme.dark(colors: slateSkyDarkColors),
      // ShowcaseThemeOption.warmTerracotta => AnyhooTheme.dark(colors: warmTerracottaDarkColors),
      // ShowcaseThemeOption.emeraldGreen => AnyhooTheme.dark(colors: emeraldGreenDarkColors),
      // ShowcaseThemeOption.crazy => AnyhooTheme.dark(colors: crazyDarkColors),
    };
  }
}
