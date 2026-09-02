# widgetbook

Flutter Widgetbook for Anyhoo packages.

## Run locally

```bash
cd widgetbook
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

## Deploy to Firebase Hosting

Hosting lives on site `flutterplatformkit-widgetbook` in Firebase project `flutterplatformkit`. Config is in `example_app/firebase.json`. Deploy copies `widgetbook/build/web` into `example_app/widgetbook-hosting` (gitignored) because Firebase Hosting cannot serve files outside the `example_app` project directory.

```bash
cd widgetbook
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --release

cd ../example_app
firebase deploy --only hosting:widgetbook --project flutterplatformkit
```

Live URL: https://flutterplatformkit-widgetbook.web.app
