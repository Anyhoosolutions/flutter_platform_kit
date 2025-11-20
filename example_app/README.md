# Example App

A unified example application demonstrating all Anyhoo packages working together.

## Purpose

This app serves multiple purposes:
- **Verification**: Tests that all packages integrate correctly
- **Documentation**: Shows real-world usage examples
- **Development**: Makes it easy to test package changes
- **Onboarding**: Helps new users understand how to use the packages

## Structure

The app is organized with isolated demo pages for each package:

```
lib/
  main.dart                    # App entry point with navigation
  pages/
    home_page.dart             # Navigation hub
    auth_demo_page.dart        # Auth package demo
    image_selector_demo_page.dart # Image selector demo
  models/
    example_user.dart          # Example user model for auth
    example_user_converter.dart # Example converter
  services/
    mock_auth_service.dart     # Mock auth service for demo
```

## Running the App

```bash
cd example_app
flutter pub get
flutter run
```

## Features Demonstrated

### Auth Demo
- Custom user model extending `AuthUser`
- User converter implementation
- Login/logout functionality
- User data refresh
- BLoC state management integration

### Image Selector Demo
- Image selection from gallery
- Image selection from camera
- Stock photo selection
- Different layout types

## Adding New Package Demos

To add a demo for a new package:

1. Add the package to `pubspec.yaml`:
   ```yaml
   dependencies:
     your_package:
       path: ../packages/your_package
   ```

2. Create a demo page in `lib/pages/your_package_demo_page.dart`

3. Add a card to `home_page.dart` that navigates to your demo page

4. Run `flutter pub get` to update dependencies

## Notes

- This is a **demo/example app**, not a production application
- Mock services are used for authentication (no real API calls)
- The app is kept simple and focused on demonstrating package usage
- All packages are referenced via path dependencies for local development
