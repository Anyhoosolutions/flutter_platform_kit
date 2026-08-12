# anyhoo_design_system

Core design tokens, `ThemeTailor`-based themes, and reusable UI components for Anyhoo Flutter apps.

## Getting started

Add as a path dependency, then use `AnyhooTheme.light()` / `AnyhooTheme.dark()` (optionally with custom `AppColors`).

Full setup, theme overrides, domain extensions, and Widgetbook gallery reuse:

→ [`docs/anyhoo_design_system_guide.md`](docs/anyhoo_design_system_guide.md)

## Widgetbook galleries

Shared component demos are exported separately so apps can reuse them under their own theme without copying layout code:

```dart
import 'package:anyhoo_design_system/galleries.dart';

// Wrap with your app's AnyhooTheme in Widgetbook:
const AnyhooCardsGallery();
```

See [§4 in the integration guide](docs/anyhoo_design_system_guide.md#4-reusing-design-system-galleries-in-app-widgetbook) for the full gallery list and UseCase examples.
