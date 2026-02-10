# PRD Prompt for New Flutter Apps

Copy and paste the prompt below into an AI assistant to generate a complete PRD for a new app.

Replace `[DESCRIBE YOUR APP HERE]` with a description of what the app should do, who it's for, and any key features you already have in mind.

---

## Prompt


You are a senior product engineer helping me write a Product Requirements Document (PRD) for a new Flutter app. I have an established tech stack and shared platform kit that all my apps use. Your job is to ask me clarifying questions about this specific app, then produce a complete PRD.

## My Tech Stack (use this for every app)

### Framework & State Management
- Flutter (latest stable)
- Bloc / Cubit for state management (via flutter_bloc)
- Freezed + json_serializable for immutable models and JSON serialization
- Go Router for navigation (wrapped by anyhoo_router)

### Backend
- Firebase Auth (Google Sign-In, Apple Sign-In, email/password)
- Cloud Firestore for database
- Firebase Storage for file uploads
- Firebase Cloud Functions (TypeScript) for server-side logic
- Firebase Remote Config for feature flags and kill switches
- Firebase Analytics for event tracking

### Error Monitoring
- Sentry for error tracking and performance monitoring (via anyhoo_logging)
- Firebase Crashlytics as a secondary crash reporter (via anyhoo_firebase)

### Shared Platform Kit (anyhoo_* packages)

All apps depend on a monorepo called `flutter_platform_kit` which provides:

| Package | Purpose |
|---------|---------|
| `anyhoo_core` | Base models (`AnyhooUser`, `Arguments`), extensions, error widgets, timezone/time repos, `SimpleBlocObserver` |
| `anyhoo_logging` | Logging with optional Sentry integration. Uses `Logger` from the `logging` package. `SentryHelper` for packages to report errors. `LoggingCubit` for in-app log viewer. |
| `anyhoo_auth` | Auth with custom user models (generics). `AuthCubit<T>`, `AuthService`, Firebase Auth + Google/Apple sign-in, `EnhanceUserService` for Firestore user enrichment. |
| `anyhoo_router` | Go Router wrapper with auth redirects, refresh streams, route stack observer. |
| `anyhoo_firebase` | Firebase initialization (Firestore, Auth, Storage), emulator config, `AnyhooStorageService`, Analytics, Crashlytics setup. |
| `anyhoo_remote_config` | Remote Config Cubit wrapping Firebase Remote Config. |
| `anyhoo_app_bar` | Shared app bar and bottom navigation bar widgets. |
| `anyhoo_shimmer` | Shimmer loading placeholder widgets. |
| `anyhoo_form_builder_widgets` | Form builder widgets (e.g. multi-select dropdown). |
| `anyhoo_image_selector` | Image selection from camera/gallery with cropping. |
| `anyhoo_map` | Map widgets (Google Maps, flutter_map). |
| `anyhoo_search_bar` | Search bar widget. |

### Tooling
- `freezed_to_ts`: Converts Dart freezed models to TypeScript interfaces for Cloud Functions. Shared models live in a `sharedModels/` directory and are converted during CI.
- `sops_secrets`: Encrypts/decrypts secrets using SOPS + age. Used in CI to handle `firebase_options.dart`, service account keys, etc.
- `widgetbook_screenshots`: Captures screenshots from Widgetbook for visual documentation.

### CI/CD
- GitHub Actions for all CI/CD
- PR checks: `flutter analyze` + tests across all packages
- Deployment: Reusable workflow from `flutter_platform_kit` supporting parallel Android (Firebase App Distribution), iOS (Firebase App Distribution), and Web (Firebase Hosting) deploys
- Configuration via `.github/deploy-config.json` (flavor mapping, Firebase project IDs, hosting targets, functions config, SOPS config)
- Widgetbook deployed to its own Firebase Hosting target

### Environments & Flavors
- Apps typically have dev/staging/prod environments
- Multiple flavors supported (e.g. main app + admin dashboard)
- Each flavor has its own `target_file`, Firebase app IDs, hosting targets
- Secrets per environment encrypted with SOPS

### Testing Strategy
- Unit tests for Cubits, services, and models
- Widget tests for key UI components
- Widgetbook stories for all reusable widgets (visual testing + documentation)
- Integration tests for critical user flows

### Project Structure Convention

Each app flavor gets its own directory under `lib/`. Shared code lives in `lib/shared/`. Models that are converted to TypeScript for Cloud Functions live in `lib/sharedModels/`.

```
lib/
  firebase_options.dart        # Generated Firebase config (encrypted in repo)
  sharedModels/                # Models shared with Cloud Functions (→ TypeScript via freezed_to_ts)
    user.dart
    <entity>.dart
  shared/                      # Code shared across all flavors
    services/                  # App-level services (Sentry impl, etc.)
    models/                    # App-wide shared Dart models (not necessarily shared with TS)
    widgets/                   # Reusable widgets shared across flavors
    theme/                     # App theme, colors, text styles
  <flavor>/                    # e.g. main/, admin/ — one per flavor
    main.dart                  # Flavor entry point, Firebase init, Sentry init
    app.dart                   # MaterialApp with router, BlocProviders
    features/
      auth/                    # Login, signup, profile screens + cubits
      home/                    # Home/dashboard
      settings/                # Settings, about, release info
      <feature>/               # Each feature has its own folder
        cubit/                 # Feature-specific cubits
        models/                # Feature-specific freezed models
        screens/               # Screens/pages
        widgets/               # Feature-specific widgets
functions/                     # Firebase Cloud Functions (TypeScript)
  src/
    index.ts
widgetbook/                    # Widgetbook app
test/                          # Tests mirroring lib/ structure
```

For single-flavor apps, you can use `lib/app/` as the sole flavor directory alongside `lib/shared/` and `lib/sharedModels/`.

---

## Before generating the PRD, ask me about:

1. **App concept**: What is the app? Who is it for? What problem does it solve?
2. **Target platforms**: Which of iOS, Android, Web? All three?
3. **Auth methods**: Google, Apple, email/password? All? Guest access?
4. **Key user roles**: Are there different user types (e.g. regular user vs admin)? Do they need separate app flavors?
5. **Core features**: What are the 3-5 most important features? Walk through the main user journey.
6. **Data model**: What are the main entities? How do they relate? Which models are shared with Cloud Functions?
7. **Cloud Functions**: What server-side logic is needed? (triggers, scheduled jobs, callable functions, etc.)
8. **Firestore structure**: Top-level collections? Subcollections? Any denormalization?
9. **Media/files**: Does the app need image uploads, file storage, or media handling?
10. **Maps/location**: Does the app need maps or location features?
11. **Push notifications**: Are push notifications needed? What triggers them?
12. **Offline support**: How important is offline capability? Which data should be cached?
13. **Analytics events**: What key user actions should be tracked?
14. **Remote Config flags**: Any feature flags or kill switches needed from day one?
15. **Third-party integrations**: Any external APIs or services? (payments, AI, social, etc.)
16. **Localization**: Multi-language support? Which languages?
17. **Design direction**: Any design references, color schemes, or branding guidelines?

---

## PRD Output Format

After gathering answers, produce a PRD with these sections:

### 1. Overview
- App name, one-line description, target audience
- Problem statement and value proposition
- Target platforms

### 2. User Roles & Auth
- User types and their permissions
- Auth methods
- User model definition (as a freezed class)
- `EnhanceUserService` requirements (what Firestore data enriches the user)
- App flavors if multiple roles need separate UIs

### 3. Information Architecture
- Screen map / navigation tree (compatible with go_router + anyhoo_router)
- Bottom nav structure (if applicable, using anyhoo_app_bar)
- Auth redirect rules

### 4. Features
For each feature:
- User stories (As a [role], I want to [action], so that [benefit])
- Acceptance criteria
- Which anyhoo_* packages it uses
- Screen wireframe description
- Cubit/state description

### 5. Data Model
- All freezed model classes with fields and types
- Mark which models go in `sharedModels/` (shared with Cloud Functions)
- Firestore collection/document structure
- Security rules summary (who can read/write what)
- Indexes needed

### 6. Cloud Functions
- List of functions with trigger type (onCreate, onUpdate, callable, scheduled, etc.)
- Input/output types (referencing shared models)
- Business logic description

### 7. Remote Config & Feature Flags
- Config keys, types, default values, and purpose

### 8. Error Handling & Monitoring
- Sentry setup (DSN, environments, log level filter)
- Key breadcrumb events
- Custom tags/contexts
- Alert rules to set up

### 9. Analytics
- Key events with parameters
- Conversion funnels to track

### 10. Testing Plan
- Critical paths for integration tests
- Key cubits/services for unit tests
- Widgetbook stories to create

### 11. Deployment Plan
- Firebase project setup (project ID, apps per platform)
- Flavor configuration (for deploy-config.json)
- Environment setup (dev, staging, prod)
- SOPS secrets to encrypt
- Hosting targets

### 12. Milestones
- Phase 1 (MVP): Core features, timeline estimate
- Phase 2: Secondary features
- Phase 3: Polish and nice-to-haves

---

## App Description

[DESCRIBE YOUR APP HERE]

