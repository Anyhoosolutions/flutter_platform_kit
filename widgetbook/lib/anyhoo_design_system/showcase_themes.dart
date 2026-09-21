import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Named theme options available in design-system Widgetbook showcases.
enum ShowcaseThemeOption {
  defaults('Default'),
  warmTerracotta('Warm Terracotta'),
  slateSky('Slate + Sky'),
  emeraldGreen('Emerald Green');

  const ShowcaseThemeOption(this.label);

  final String label;

  static ShowcaseThemeOption fromLabel(String label) {
    return ShowcaseThemeOption.values.firstWhere((option) => option.label == label);
  }

  ThemeData lightTheme() {
    return switch (this) {
      ShowcaseThemeOption.defaults => AnyhooTheme.light(),
      ShowcaseThemeOption.slateSky => AnyhooTheme.light(colors: lightSlateSkyAppColors),
      ShowcaseThemeOption.warmTerracotta => AnyhooTheme.light(colors: lightWarmTerracottaAppColors),
      ShowcaseThemeOption.emeraldGreen => AnyhooTheme.light(colors: lightEmeraldGreenAppColors),
    };
  }

  ThemeData darkTheme() {
    return switch (this) {
      ShowcaseThemeOption.defaults => AnyhooTheme.dark(),
      ShowcaseThemeOption.slateSky => AnyhooTheme.dark(colors: darkSlateSkyAppColors),
      ShowcaseThemeOption.warmTerracotta => AnyhooTheme.dark(colors: darkWarmTerracottaAppColors),
      ShowcaseThemeOption.emeraldGreen => AnyhooTheme.dark(colors: darkEmeraldGreenAppColors),
    };
  }
}

final lightWarmTerracottaAppColors = AppColors(
  // ---------------------------------------------------------------------------
  // Surface Colors (Warm Off-White & Cream Base)
  // ---------------------------------------------------------------------------
  surface: const SurfaceColors(
    scaffoldBackground: Color(0xFFFDFBF7), // Soft warm ivory canvas
    lowContrastBackground: Color(0xFFF7F2EA), // Warm linen/beige container background
    primaryText: Color(0xFF2C1810), // Deep espresso brown for high contrast
    secondaryText: Color(0xFF6E564C), // Warm taupe/earth grey text
    containerLowest: Color(0xFFFFFFFF), // Crisp white elevation base
    containerLow: Color(0xFFF7F2EA), // Soft cream card fill
    containerHigh: Color(0xFFEFE6D8), // Elevated warmth surface
    containerHighest: Color(0xFFE2D4C3), // Modals and popovers
    outline: Color(0xFFE8DACB), // Soft clay border line
    secondaryContainer: Color(0xFFFBECE3), // Very soft terracotta tint fill
    onSecondaryContainer: Color(0xFF8B3A22), // Deep terracotta text on secondary
    inverseSurface: Color(0xFF2C1810), // Dark espresso surface for inverse
    inverseOnSurface: Color(0xFFFDFBF7), // Soft cream text on dark surface
  ),

  // ---------------------------------------------------------------------------
  // Accent Colors (Primary Terracotta & Warm Rust Highlights)
  // ---------------------------------------------------------------------------
  accent: const AccentColors(
    primaryFixed: Color(0xFFC85A32), // Core terracotta brand color
    onPrimaryFixed: Color(0xFFFFFFFF), // Text on primary
    primaryDisabled: Color(0xFFEFE6D8), // Muted background for disabled state
    onPrimaryDisabled: Color(0xFFA69288), // Text on disabled state
    primaryContainer: Color(0xFFF9DCCF), // Soft terracotta wash
    onPrimaryContainer: Color(0xFF72230A), // Rich dark rust text on container
    headline: Color(0xFFB0431D), // Deep rust for emphasized headings
    inversePrimary: Color(0xFFE88A67), // Soft terracotta for dark overlay contexts
  ),

  // ---------------------------------------------------------------------------
  // Status Colors (Warm Palette Natural Feedback)
  // ---------------------------------------------------------------------------
  status: const StatusColors(
    error: Color(0xFFC0392B), // Crimson red
    errorContainer: Color(0xFFFADBD8), // Soft blush tint
    warning: Color(0xFFD35400), // Burnt amber
    success: Color(0xFF27AE60), // Warm olive green
  ),

  // ---------------------------------------------------------------------------
  // Shimmer Colors (Loading Visuals)
  // ---------------------------------------------------------------------------
  shimmer: const ShimmerColors(
    baseColor: Color(0xFFEFE6D8), // Warm sand base
    highlightColor: Color(0xFFFDFBF7), // Cream highlight sweep
  ),

  // ---------------------------------------------------------------------------
  // AppBar Colors (Top and Bottom Navigation)
  // ---------------------------------------------------------------------------
  appBar: const AppBarColors(
    topBarBackground: Color(0xFFFDFBF7), // Clean warm ivory bar
    topBarBorder: Color(0xFFE8DACB), // Divider line
    topBarText: Color(0xFF2C1810), // Dark espresso text
    backButtonColor: Color(0xFF6E564C), // Warm taupe icon color
    avatarColor: Color(0xFFC85A32), // Terracotta avatar background
    bottomBarBackground: Color(0xFFFDFBF7), // Bottom navigation bar
    bottomBarIconColors: Color(0xFF8C7369), // Unselected tab icons
    bottomBarIndicatorColor: Color(0xFFF9DCCF), // Active tab pill fill
    bottomBarBorderColor: Color(0xFFE8DACB), // Top border line
  ),

  // ---------------------------------------------------------------------------
  // Component Controls Colors
  // ---------------------------------------------------------------------------
  controls: const ControlsColors(
    switchColors: AnyhooSwitchColors(
      background: Color(0xFFE2D4C3), // Inactive track
      button: Color(0xFFC85A32), // Active thumb color
    ),
    cardColors: ColorSet(
      background: Color(0xFFFFFFFF), // White card surface
      foreground: Color(0xFF2C1810), // Card content text
      borderColor: Color(0xFFE8DACB), // Card border outline
    ),
    segmentColors: SegmentColors(
      regular: ColorSet(background: Color(0xFFF7F2EA), foreground: Color(0xFF8C7369), borderColor: Colors.transparent),
      selected: ColorSet(background: Color(0xFFC85A32), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFFB0431D)),
    ),
    avatarColors: AvatarColors(
      regular: ColorSet(background: Color(0xFFEFE6D8), foreground: Color(0xFF6E564C), borderColor: Color(0xFFE8DACB)),
      selected: ColorSet(background: Color(0xFFC85A32), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFFE88A67)),
    ),
    chipColors: ChipColors(
      primary: ColorSet(background: Color(0xFFF9DCCF), foreground: Color(0xFF72230A), borderColor: Color(0xFFE88A67)),
      secondary: ColorSet(background: Color(0xFFF7F2EA), foreground: Color(0xFF59433B), borderColor: Color(0xFFE2D4C3)),
      error: ColorSet(background: Color(0xFFFADBD8), foreground: Color(0xFF78281F), borderColor: Color(0xFFF5B7B1)),
      warning: ColorSet(background: Color(0xFFFDEBD0), foreground: Color(0xFF7E5109), borderColor: Color(0xFFF9E79F)),
      inactive: ColorSet(background: Color(0xFFFDFBF7), foreground: Color(0xFFA69288), borderColor: Color(0xFFE8DACB)),
    ),
  ),
);

final darkWarmTerracottaAppColors = AppColors(
  // ---------------------------------------------------------------------------
  // Surface Colors (Deep Charcoal Earth & Warm Espresso Base)
  // ---------------------------------------------------------------------------
  surface: const SurfaceColors(
    scaffoldBackground: Color(0xFF1B1412), // Dark espresso brown-black canvas
    lowContrastBackground: Color(0xFF251C1A), // Charcoal clay container background
    primaryText: Color(0xFFF5EBE6), // Warm off-white text
    secondaryText: Color(0xFFBFAEA5), // Muted warm grey text
    containerLowest: Color(0xFF201715), // Deeper elevation surface
    containerLow: Color(0xFF2C211E), // Standard card surface
    containerHigh: Color(0xFF382B27), // Elevated popovers and tiles
    containerHighest: Color(0xFF453631), // Dropdowns and dialogs
    outline: Color(0xFF4A3832), // Warm dark outline border
    secondaryContainer: Color(0xFF3D2721), // Muted terracotta container fill
    onSecondaryContainer: Color(0xFFF5C5B3), // Soft clay text on secondary
    inverseSurface: Color(0xFFF5EBE6), // Light surface for inverse elements
    inverseOnSurface: Color(0xFF1B1412), // Dark text on inverse surface
  ),

  // ---------------------------------------------------------------------------
  // Accent Colors (Vibrant Terracotta & Ember Highlights)
  // ---------------------------------------------------------------------------
  accent: const AccentColors(
    primaryFixed: Color(0xFFDD6B43), // Bright terracotta accent
    onPrimaryFixed: Color(0xFFFFFFFF), // Text on primary
    primaryDisabled: Color(0xFF382B27), // Disabled background
    onPrimaryDisabled: Color(0xFF7A655C), // Text on disabled
    primaryContainer: Color(0xFF5A2615), // Rich burnt terracotta container
    onPrimaryContainer: Color(0xFFFFDCD1), // Warm cream-clay text on container
    headline: Color(0xFFF07E56), // Bright coral-terracotta for headings
    inversePrimary: Color(0xFFB0431D), // Deep terracotta for light context overlay
  ),

  // ---------------------------------------------------------------------------
  // Status Colors (Warm Palette Feedback)
  // ---------------------------------------------------------------------------
  status: const StatusColors(
    error: Color(0xFFE74C3C), // Warm red
    errorContainer: Color(0xFF4A1510), // Dark crimson fill
    warning: Color(0xFFE67E22), // Burnt orange
    success: Color(0xFF2ECC71), // Vibrant natural green
  ),

  // ---------------------------------------------------------------------------
  // Shimmer Colors (Loading Visuals)
  // ---------------------------------------------------------------------------
  shimmer: const ShimmerColors(
    baseColor: Color(0xFF2C211E), // Dark clay shimmer base
    highlightColor: Color(0xFF382B27), // Shimmer sweep accent
  ),

  // ---------------------------------------------------------------------------
  // AppBar Colors (Top and Bottom Navigation)
  // ---------------------------------------------------------------------------
  appBar: const AppBarColors(
    topBarBackground: Color(0xFF251C1A), // Slate clay bar background
    topBarBorder: Color(0xFF382B27), // Bottom divider line
    topBarText: Color(0xFFF5EBE6), // Warm title text
    backButtonColor: Color(0xFFBFAEA5), // Muted icon color
    avatarColor: Color(0xFFDD6B43), // Terracotta avatar border/fill
    bottomBarBackground: Color(0xFF251C1A), // Bottom navigation bar
    bottomBarIconColors: Color(0xFFBFAEA5), // Unselected icons
    bottomBarIndicatorColor: Color(0xFF5A2615), // Active selection pill fill
    bottomBarBorderColor: Color(0xFF382B27), // Top divider line
  ),

  // ---------------------------------------------------------------------------
  // Component Controls Colors
  // ---------------------------------------------------------------------------
  controls: const ControlsColors(
    switchColors: AnyhooSwitchColors(
      background: Color(0xFF4A3832), // Inactive track
      button: Color(0xFFDD6B43), // Active thumb color
    ),
    cardColors: ColorSet(
      background: Color(0xFF2C211E), // Dark container fill
      foreground: Color(0xFFF5EBE6), // Card text
      borderColor: Color(0xFF382B27), // Card outline
    ),
    segmentColors: SegmentColors(
      regular: ColorSet(background: Color(0xFF201715), foreground: Color(0xFFBFAEA5), borderColor: Colors.transparent),
      selected: ColorSet(background: Color(0xFFDD6B43), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFFF07E56)),
    ),
    avatarColors: AvatarColors(
      regular: ColorSet(background: Color(0xFF382B27), foreground: Color(0xFFBFAEA5), borderColor: Color(0xFF4A3832)),
      selected: ColorSet(background: Color(0xFFDD6B43), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFFF07E56)),
    ),
    chipColors: ChipColors(
      primary: ColorSet(background: Color(0xFF5A2615), foreground: Color(0xFFFFDCD1), borderColor: Color(0xFFDD6B43)),
      secondary: ColorSet(background: Color(0xFF382B27), foreground: Color(0xFFE0D0C7), borderColor: Color(0xFF4A3832)),
      error: ColorSet(background: Color(0xFF4A1510), foreground: Color(0xFFFADBD8), borderColor: Color(0xFF78281F)),
      warning: ColorSet(background: Color(0xFF4A2800), foreground: Color(0xFFFDEBD0), borderColor: Color(0xFF7E5109)),
      inactive: ColorSet(background: Color(0xFF201715), foreground: Color(0xFF7A655C), borderColor: Color(0xFF382B27)),
    ),
  ),
);

final lightSlateSkyAppColors = AppColors(
  surface: const SurfaceColors(
    scaffoldBackground: Color(0xFFF1F5F9), // Cool slate white
    lowContrastBackground: Color(0xFFE2E8F0), // Light slate grey
    primaryText: Color(0xFF0F172A), // Deep slate black
    secondaryText: Color(0xFF475569), // Mid slate grey
    containerLowest: Color(0xFFFFFFFF), // Pure white
    containerLow: Color(0xFFF8FAFC), // Off-white container fill
    containerHigh: Color(0xFFE2E8F0), // Elevated surface
    containerHighest: Color(0xFFCBD5E1), // Dropdowns and overlays
    outline: Color(0xFFCBD5E1), // Cool grey border
    secondaryContainer: Color(0xFFE0F2FE), // Soft sky blue wash
    onSecondaryContainer: Color(0xFF0369A1), // Dark sky blue text
    inverseSurface: Color(0xFF0F172A),
    inverseOnSurface: Color(0xFFF8FAFC),
  ),
  accent: const AccentColors(
    primaryFixed: Color(0xFF0284C7), // Sky blue brand accent
    onPrimaryFixed: Color(0xFFFFFFFF),
    primaryDisabled: Color(0xFFE2E8F0),
    onPrimaryDisabled: Color(0xFF94A3B8),
    primaryContainer: Color(0xFFBAE6FD), // Light sky blue container fill
    onPrimaryContainer: Color(0xFF075985), // Deep sky text
    headline: Color(0xFF0369A1), // Vibrant sky blue headline
    inversePrimary: Color(0xFF38BDF8),
  ),
  status: const StatusColors(
    error: Color(0xFFE11D48),
    errorContainer: Color(0xFFFFE4E6),
    warning: Color(0xFFD97706),
    success: Color(0xFF0D9488),
  ),
  shimmer: const ShimmerColors(baseColor: Color(0xFFE2E8F0), highlightColor: Color(0xFFF8FAFC)),
  appBar: const AppBarColors(
    topBarBackground: Color(0xFFFFFFFF),
    topBarBorder: Color(0xFFE2E8F0),
    topBarText: Color(0xFF0F172A),
    backButtonColor: Color(0xFF475569),
    avatarColor: Color(0xFF0284C7),
    bottomBarBackground: Color(0xFFFFFFFF),
    bottomBarIconColors: Color(0xFF64748B),
    bottomBarIndicatorColor: Color(0xFFBAE6FD),
    bottomBarBorderColor: Color(0xFFE2E8F0),
  ),
  controls: const ControlsColors(
    switchColors: AnyhooSwitchColors(background: Color(0xFFCBD5E1), button: Color(0xFF0284C7)),
    cardColors: ColorSet(background: Color(0xFFFFFFFF), foreground: Color(0xFF0F172A), borderColor: Color(0xFFE2E8F0)),
    segmentColors: SegmentColors(
      regular: ColorSet(background: Color(0xFFF8FAFC), foreground: Color(0xFF64748B), borderColor: Colors.transparent),
      selected: ColorSet(background: Color(0xFF0284C7), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFF0369A1)),
    ),
    avatarColors: AvatarColors(
      regular: ColorSet(background: Color(0xFFE2E8F0), foreground: Color(0xFF475569), borderColor: Color(0xFFCBD5E1)),
      selected: ColorSet(background: Color(0xFF0284C7), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFF38BDF8)),
    ),
    chipColors: ChipColors(
      primary: ColorSet(background: Color(0xFFBAE6FD), foreground: Color(0xFF075985), borderColor: Color(0xFF7DD3FC)),
      secondary: ColorSet(background: Color(0xFFE2E8F0), foreground: Color(0xFF334155), borderColor: Color(0xFFCBD5E1)),
      error: ColorSet(background: Color(0xFFFFE4E6), foreground: Color(0xFF9F1239), borderColor: Color(0xFFFECDD3)),
      warning: ColorSet(background: Color(0xFFFEF3C7), foreground: Color(0xFF92400E), borderColor: Color(0xFFFDE68A)),
      inactive: ColorSet(background: Color(0xFFF8FAFC), foreground: Color(0xFF94A3B8), borderColor: Color(0xFFE2E8F0)),
    ),
  ),
);

final darkSlateSkyAppColors = AppColors(
  surface: const SurfaceColors(
    scaffoldBackground: Color(0xFF0F172A), // Dark slate backdrop
    lowContrastBackground: Color(0xFF1E293B), // Midnight slate fill
    primaryText: Color(0xFFF8FAFC), // Cool off-white
    secondaryText: Color(0xFF94A3B8), // Muted slate text
    containerLowest: Color(0xFF0B1120), // Deep backdrop surface
    containerLow: Color(0xFF1E293B), // Card surface
    containerHigh: Color(0xFF334155), // Elevated popover surface
    containerHighest: Color(0xFF475569), // Highest elevation surface
    outline: Color(0xFF334155), // Dark slate border
    secondaryContainer: Color(0xFF0C4A6E), // Dark sky blue wash
    onSecondaryContainer: Color(0xFFBAE6FD), // Soft sky blue text
    inverseSurface: Color(0xFFF8FAFC),
    inverseOnSurface: Color(0xFF0F172A),
  ),
  accent: const AccentColors(
    primaryFixed: Color(0xFF38BDF8), // Vibrant sky blue
    onPrimaryFixed: Color(0xFF0F172A),
    primaryDisabled: Color(0xFF334155),
    onPrimaryDisabled: Color(0xFF64748B),
    primaryContainer: Color(0xFF0369A1), // Deep sky blue accent container
    onPrimaryContainer: Color(0xFFE0F2FE), // Soft blue text
    headline: Color(0xFF7DD3FC), // Bright sky blue for text
    inversePrimary: Color(0xFF0284C7),
  ),
  status: const StatusColors(
    error: Color(0xFFF43F5E),
    errorContainer: Color(0xFF4C0519),
    warning: Color(0xFFF59E0B),
    success: Color(0xFF14B8A6),
  ),
  shimmer: const ShimmerColors(baseColor: Color(0xFF1E293B), highlightColor: Color(0xFF334155)),
  appBar: const AppBarColors(
    topBarBackground: Color(0xFF1E293B),
    topBarBorder: Color(0xFF334155),
    topBarText: Color(0xFFF8FAFC),
    backButtonColor: Color(0xFF94A3B8),
    avatarColor: Color(0xFF38BDF8),
    bottomBarBackground: Color(0xFF1E293B),
    bottomBarIconColors: Color(0xFF94A3B8),
    bottomBarIndicatorColor: Color(0xFF0369A1),
    bottomBarBorderColor: Color(0xFF334155),
  ),
  controls: const ControlsColors(
    switchColors: AnyhooSwitchColors(background: Color(0xFF475569), button: Color(0xFF38BDF8)),
    cardColors: ColorSet(background: Color(0xFF1E293B), foreground: Color(0xFFF8FAFC), borderColor: Color(0xFF334155)),
    segmentColors: SegmentColors(
      regular: ColorSet(background: Color(0xFF0B1120), foreground: Color(0xFF94A3B8), borderColor: Colors.transparent),
      selected: ColorSet(background: Color(0xFF38BDF8), foreground: Color(0xFF0F172A), borderColor: Color(0xFF7DD3FC)),
    ),
    avatarColors: AvatarColors(
      regular: ColorSet(background: Color(0xFF334155), foreground: Color(0xFF94A3B8), borderColor: Color(0xFF475569)),
      selected: ColorSet(background: Color(0xFF38BDF8), foreground: Color(0xFF0F172A), borderColor: Color(0xFF7DD3FC)),
    ),
    chipColors: ChipColors(
      primary: ColorSet(background: Color(0xFF0369A1), foreground: Color(0xFFE0F2FE), borderColor: Color(0xFF0284C7)),
      secondary: ColorSet(background: Color(0xFF334155), foreground: Color(0xFFCBD5E1), borderColor: Color(0xFF475569)),
      error: ColorSet(background: Color(0xFF4C0519), foreground: Color(0xFFFECDD3), borderColor: Color(0xFF881337)),
      warning: ColorSet(background: Color(0xFF451A03), foreground: Color(0xFFFDE68A), borderColor: Color(0xFF78350F)),
      inactive: ColorSet(background: Color(0xFF0B1120), foreground: Color(0xFF64748B), borderColor: Color(0xFF334155)),
    ),
  ),
);

final lightEmeraldGreenAppColors = AppColors(
  surface: const SurfaceColors(
    scaffoldBackground: Color(0xFFF4F7F5), // Fresh sage-tinted white
    lowContrastBackground: Color(0xFFE3EBE6), // Light sage background
    primaryText: Color(0xFF0B2017), // Deep forest black
    secondaryText: Color(0xFF40594D), // Mid moss grey
    containerLowest: Color(0xFFFFFFFF), // White base
    containerLow: Color(0xFFEDF2EE), // Soft green card fill
    containerHigh: Color(0xFFDCE6DF), // Elevated surface
    containerHighest: Color(0xFFC7D6CC), // Dropdowns and dialogs
    outline: Color(0xFFCCD9D0), // Light sage outline
    secondaryContainer: Color(0xFFD1E8DB), // Light emerald container
    onSecondaryContainer: Color(0xFF0F4D32), // Dark emerald text
    inverseSurface: Color(0xFF0B2017),
    inverseOnSurface: Color(0xFFF4F7F5),
  ),
  accent: const AccentColors(
    primaryFixed: Color(0xFF059669), // Rich emerald green
    onPrimaryFixed: Color(0xFFFFFFFF),
    primaryDisabled: Color(0xFFDCE6DF),
    onPrimaryDisabled: Color(0xFF879B90),
    primaryContainer: Color(0xFFA7F3D0), // Mint container fill
    onPrimaryContainer: Color(0xFF064E3B), // Deep emerald text
    headline: Color(0xFF047857), // Bold emerald text
    inversePrimary: Color(0xFF34D399),
  ),
  status: const StatusColors(
    error: Color(0xFFDC2626),
    errorContainer: Color(0xFFFEE2E2),
    warning: Color(0xFFD97706),
    success: Color(0xFF10B981),
  ),
  shimmer: const ShimmerColors(baseColor: Color(0xFFDCE6DF), highlightColor: Color(0xFFF4F7F5)),
  appBar: const AppBarColors(
    topBarBackground: Color(0xFFFFFFFF),
    topBarBorder: Color(0xFFCCD9D0),
    topBarText: Color(0xFF0B2017),
    backButtonColor: Color(0xFF40594D),
    avatarColor: Color(0xFF059669),
    bottomBarBackground: Color(0xFFFFFFFF),
    bottomBarIconColors: Color(0xFF5B7568),
    bottomBarIndicatorColor: Color(0xFFA7F3D0),
    bottomBarBorderColor: Color(0xFFCCD9D0),
  ),
  controls: const ControlsColors(
    switchColors: AnyhooSwitchColors(background: Color(0xFFC7D6CC), button: Color(0xFF059669)),
    cardColors: ColorSet(background: Color(0xFFFFFFFF), foreground: Color(0xFF0B2017), borderColor: Color(0xFFCCD9D0)),
    segmentColors: SegmentColors(
      regular: ColorSet(background: Color(0xFFEDF2EE), foreground: Color(0xFF5B7568), borderColor: Colors.transparent),
      selected: ColorSet(background: Color(0xFF059669), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFF047857)),
    ),
    avatarColors: AvatarColors(
      regular: ColorSet(background: Color(0xFFDCE6DF), foreground: Color(0xFF40594D), borderColor: Color(0xFFCCD9D0)),
      selected: ColorSet(background: Color(0xFF059669), foreground: Color(0xFFFFFFFF), borderColor: Color(0xFF34D399)),
    ),
    chipColors: ChipColors(
      primary: ColorSet(background: Color(0xFFA7F3D0), foreground: Color(0xFF064E3B), borderColor: Color(0xFF6EE7B7)),
      secondary: ColorSet(background: Color(0xFFEDF2EE), foreground: Color(0xFF233B2F), borderColor: Color(0xFFC7D6CC)),
      error: ColorSet(background: Color(0xFFFEE2E2), foreground: Color(0xFF991B1B), borderColor: Color(0xFFFCA5A5)),
      warning: ColorSet(background: Color(0xFFFEF3C7), foreground: Color(0xFF92400E), borderColor: Color(0xFFFDE68A)),
      inactive: ColorSet(background: Color(0xFFF4F7F5), foreground: Color(0xFF879B90), borderColor: Color(0xFFCCD9D0)),
    ),
  ),
);

final darkEmeraldGreenAppColors = AppColors(
  surface: const SurfaceColors(
    scaffoldBackground: Color(0xFF081C15), // Deep forest night
    lowContrastBackground: Color(0xFF112A20), // Deep pine fill
    primaryText: Color(0xFFECFDF5), // Soft minty white text
    secondaryText: Color(0xFFA7F3D0), // Muted mint text
    containerLowest: Color(0xFF05140E), // Base backdrop surface
    containerLow: Color(0xFF112A20), // Card surface
    containerHigh: Color(0xFF1B3B2F), // Elevated popovers and tiles
    containerHighest: Color(0xFF284E3F), // Highest elevation
    outline: Color(0xFF214536), // Dark forest border
    secondaryContainer: Color(0xFF064E3B), // Rich dark emerald fill
    onSecondaryContainer: Color(0xFFA7F3D0), // Mint text on secondary
    inverseSurface: Color(0xFFECFDF5),
    inverseOnSurface: Color(0xFF081C15),
  ),
  accent: const AccentColors(
    primaryFixed: Color(0xFF10B981), // Bright mint-emerald accent
    onPrimaryFixed: Color(0xFF064E3B),
    primaryDisabled: Color(0xFF1B3B2F),
    onPrimaryDisabled: Color(0xFF527867),
    primaryContainer: Color(0xFF047857), // Deep emerald container
    onPrimaryContainer: Color(0xFFD1FAE5), // Pale mint text
    headline: Color(0xFF34D399), // Luminous mint for text emphasis
    inversePrimary: Color(0xFF059669),
  ),
  status: const StatusColors(
    error: Color(0xFFEF4444),
    errorContainer: Color(0xFF450A0A),
    warning: Color(0xFFF59E0B),
    success: Color(0xFF10B981),
  ),
  shimmer: const ShimmerColors(baseColor: Color(0xFF112A20), highlightColor: Color(0xFF1B3B2F)),
  appBar: const AppBarColors(
    topBarBackground: Color(0xFF112A20),
    topBarBorder: Color(0xFF214536),
    topBarText: Color(0xFFECFDF5),
    backButtonColor: Color(0xFFA7F3D0),
    avatarColor: Color(0xFF10B981),
    bottomBarBackground: Color(0xFF112A20),
    bottomBarIconColors: Color(0xFF71A890),
    bottomBarIndicatorColor: Color(0xFF047857),
    bottomBarBorderColor: Color(0xFF214536),
  ),
  controls: const ControlsColors(
    switchColors: AnyhooSwitchColors(background: Color(0xFF284E3F), button: Color(0xFF10B981)),
    cardColors: ColorSet(background: Color(0xFF112A20), foreground: Color(0xFFECFDF5), borderColor: Color(0xFF214536)),
    segmentColors: SegmentColors(
      regular: ColorSet(background: Color(0xFF05140E), foreground: Color(0xFF71A890), borderColor: Colors.transparent),
      selected: ColorSet(background: Color(0xFF10B981), foreground: Color(0xFF064E3B), borderColor: Color(0xFF34D399)),
    ),
    avatarColors: AvatarColors(
      regular: ColorSet(background: Color(0xFF1B3B2F), foreground: Color(0xFFA7F3D0), borderColor: Color(0xFF284E3F)),
      selected: ColorSet(background: Color(0xFF10B981), foreground: Color(0xFF064E3B), borderColor: Color(0xFF6EE7B7)),
    ),
    chipColors: ChipColors(
      primary: ColorSet(background: Color(0xFF047857), foreground: Color(0xFFD1FAE5), borderColor: Color(0xFF10B981)),
      secondary: ColorSet(background: Color(0xFF1B3B2F), foreground: Color(0xFFA7F3D0), borderColor: Color(0xFF284E3F)),
      error: ColorSet(background: Color(0xFF450A0A), foreground: Color(0xFFFECACA), borderColor: Color(0xFF7F1D1D)),
      warning: ColorSet(background: Color(0xFF451A03), foreground: Color(0xFFFDE68A), borderColor: Color(0xFF78350F)),
      inactive: ColorSet(background: Color(0xFF05140E), foreground: Color(0xFF527867), borderColor: Color(0xFF1B3B2F)),
    ),
  ),
);
