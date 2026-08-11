# `anyhoo_design_system` Integration & Usage Guide

`anyhoo_design_system` provides core design tokens, customizable themes built on `ThemeTailor`, and reusable UI components for Anyhoo Flutter applications.

---

## 1. Installation & Setup

Add `anyhoo_design_system` as a local dependency in your application's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  anyhoo_design_system:
    path: ../../packages/anyhoo_design_system # Adjust path relative to your app
```

---

## 2. Option A: Using Default Themes & Components

If your application uses the standard Anyhoo color palette and styling, pass `AnyhooTheme.light()` and `AnyhooTheme.dark()` directly into your `MaterialApp`.

```dart
import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anyhoo App',
      theme: AnyhooTheme.light(),
      darkTheme: AnyhooTheme.dark(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access surface & accent colors cleanly using context extensions
    final surface = context.surface;
    final accent = context.accent;

    return Scaffold(
      appBar: AppBar(title: const Text('Design System Defaults')),
      body: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          children: [
            Text(
              'Hello World',
              style: TextStyle(color: surface.primaryText),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            
            // Reusable widget from anyhoo_design_system
            AnyhooRoundButton(
              icon: Icons.add,
              onPressed: () {},
            ),
            
            const SizedBox(height: DesignTokens.spacingMd),
            
            FilledButton(
              onPressed: () {},
              child: Text(
                'Primary Action',
                style: TextStyle(color: accent.onPrimaryFixed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 3. Option B: Overriding Theme Values (App-Specific Styling)

You can customize core tokens—such as scaffold backgrounds, card borders, primary colors, or statuses—by defining custom `AppColors` instances in your app and passing them into `AnyhooTheme.light()` or `AnyhooTheme.dark()`.

### Step 1: Define Custom `AppColors`

```dart
// lib/theme/app_colors_override.dart
import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

const myCustomLightColors = AppColors(
  surface: SurfaceColors(
    scaffoldBackground: Color(0xFFF8FAFC), // Custom slate background
    lowContrastBackground: Color(0xFFF1F5F9),
    primaryText: Color(0xFF0F172A),
    secondaryText: Color(0xFF475569),
    cardBackground: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE2E8F0),
    containerHigh: Color(0xFFE2E8F0),
    containerLow: Color(0xFFF1F5F9),
    containerHighest: Color(0xFFCBD5E1),
    containerLowest: Color(0xFFFFFFFF),
    outline: Color(0xFF94A3B8),
  ),
  accent: AccentColors(
    primaryFixed: Color(0xFF0284C7), // Custom sky-blue accent
    onPrimaryFixed: Color(0xFFFFFFFF),
    primaryDisabled: Color(0xFFBAE6FD),
    onPrimaryDisabled: Color(0xFF0369A1),
    primaryContainer: Color(0xFFE0F2FE),
    onPrimaryContainer: Color(0xFF0369A1),
    headline: Color(0xFF0F172A),
  ),
  status: StatusColors(
    error: Color(0xFFEF4444),
    warning: Color(0xFFF59E0B),
    success: Color(0xFF10B981),
  ),
  shimmer: ShimmerColors(
    baseColor: Color(0xFFE2E8F0),
    highlightColor: Color(0xFFF1F5F9),
  ),
);
```

### Step 2: Inject Custom Colors into `MaterialApp`

```dart
// lib/main.dart
import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'theme/app_colors_override.dart';

void main() {
  runApp(
    MaterialApp(
      // Pass custom AppColors overrides
      theme: AnyhooTheme.light(colors: myCustomLightColors),
      darkTheme: AnyhooTheme.dark(colors: myCustomLightColors),
      home: const CustomAppHomeScreen(),
    ),
  );
}
```

---

## 4. Extending with App-Specific Domain Tokens

When an app requires tokens specific to its domain (e.g., specialized status badges, chart colors, or feature themes) without modifying `anyhoo_design_system`, pass them via `extraExtensions`.

### Step 1: Create a Custom `ThemeExtension`

```dart
// lib/theme/domain_theme_extension.dart
import 'package:flutter/material.dart';

@immutable
class AppBadgeColors extends ThemeExtension<AppBadgeColors> {
  const AppBadgeColors({
    required this.pending,
    required this.completed,
  });

  final Color pending;
  final Color completed;

  @override
  AppBadgeColors copyWith({Color? pending, Color? completed}) {
    return AppBadgeColors(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
    );
  }

  @override
  AppBadgeColors lerp(ThemeExtension<AppBadgeColors>? other, double t) {
    if (other is! AppBadgeColors) return this;
    return AppBadgeColors(
      pending: Color.lerp(pending, other.pending, t)!,
      completed: Color.lerp(completed, other.completed, t)!,
    );
  }
}
```

### Step 2: Register in `extraExtensions`

```dart
// lib/main.dart
import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'theme/domain_theme_extension.dart';

void main() {
  runApp(
    MaterialApp(
      theme: AnyhooTheme.light(
        extraExtensions: const [
          AppBadgeColors(
            pending: Color(0xFFF59E0B),
            completed: Color(0xFF10B981),
          ),
        ],
      ),
      home: const DomainHomeScreen(),
    ),
  );
}

class DomainHomeScreen extends StatelessWidget {
  const DomainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve custom domain extension
    final badgeColors = Theme.of(context).extension<AppBadgeColors>();

    return Scaffold(
      body: Center(
        child: Container(
          color: badgeColors?.completed,
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: const Text('Completed Status Badge'),
        ),
      ),
    );
  }
}
```
