import 'package:anyhoo_shimmer/src/shimmer.dart';
import 'package:flutter/material.dart';

class AnyhooShimmer extends StatelessWidget {
  final Widget? child;
  final bool enabled;

  final lightModeLinearGradient = LinearGradient(
    colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
    stops: const [0.1, 0.3, 0.4],
    begin: const Alignment(-1.0, -0.3),
    end: const Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  final darkModeLinearGradient = LinearGradient(
    colors: [Colors.grey[800]!, Colors.grey[600]!, Colors.grey[800]!],
    stops: const [0.1, 0.3, 0.4],
    begin: const Alignment(-1.0, -0.3),
    end: const Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  AnyhooShimmer({super.key, this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    // final settingsState = context.watch<UserSettingsBloc>().state;
    var linearGradient = lightModeLinearGradient;
    // if (settingsState is UserSettingsLoaded) {
    //   final themeType = settingsState.settings.themeType;
    //   if (themeType == ThemeType.system) {
    //     // _log.info(
    //     //     'MediaQuery.platformBrightnessOf(context): ${MediaQuery.platformBrightnessOf(context)}');
    //     final isDarkMode =
    //         MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    //     linearGradient = isDarkMode
    //         ? darkModeLinearGradient
    //         : lightModeLinearGradient;
    //   } else {
    //     linearGradient = themeType == ThemeType.dark
    //         ? darkModeLinearGradient
    //         : lightModeLinearGradient;
    //   }
    // }

    return Shimmer(linearGradient: linearGradient, enabled: enabled, child: child);
  }
}
