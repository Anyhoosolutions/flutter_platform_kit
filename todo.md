# Android Build & Firebase App Distribution with Google Sign-In Test

## Prerequisites
- [x] Verify Firebase project is set up (flutterplatformkit) - ✓ Confirmed in .firebaserc
- [ ] Verify Google Sign-In is enabled in Firebase Console (Authentication > Sign-in method > Google) - **NEEDS MANUAL CHECK**
- [x] Verify google-services.json exists in example_app/android/app/ - ✓ File exists and contains correct package name
- [x] Verify SHA-1 fingerprint is added to Firebase project (for Google Sign-In) - ✓ Found in google-services.json (certificate_hash: d543deeb96150ced4881c80e04ca4ec5c91fc2b4)
- [x] Install Firebase CLI and login: `npm install -g firebase-tools && firebase login` - ✓ Firebase CLI v15.0.0 installed
- [x] Install Firebase App Distribution plugin: `firebase init appdistribution` (if not already done) - ✓ Command available

## Step 1: Configure Android App for Release Build
- [x] Create release keystore (if not exists) or use existing signing config - ✓ Using debug keystore for now (release uses debug signing)
- [x] Update android/app/build.gradle.kts with proper release signing configuration - ✓ Currently using debug signing for release (needs production keystore later)
- [x] Verify applicationId matches Firebase app configuration (com.anyhoosolutions.flutterplatformkit) - ✓ Matches
- [x] Verify versionCode and versionName are set correctly in pubspec.yaml - ✓ Version: 1.0.0+1

## Step 2: Verify Google Sign-In Configuration
- [x] Check that google-services.json contains correct package name and SHA-1 - ✓ Package name matches, SHA-1 present
- [ ] Verify Google Sign-In is properly configured in Firebase Console - **NEEDS MANUAL CHECK**
- [ ] Test Google Sign-In locally first: `flutter run --release` on connected device - **READY TO TEST**
- [ ] Verify Google Sign-In button works and authentication flow completes - **READY TO TEST**

## Step 3: Build Android Release APK/AAB
- [ ] Clean build: `cd example_app && flutter clean`
- [ ] Get dependencies: `flutter pub get`
- [ ] Build release APK: `flutter build apk --release`
- [ ] OR build release AAB: `flutter build appbundle --release` (for Play Store)
- [ ] Verify build succeeds without errors
- [ ] Locate built APK/AAB file (usually in build/app/outputs/)

## Step 4: Set Up Firebase App Distribution
- [ ] Verify Firebase project: `firebase projects:list`
- [ ] Set Firebase project: `firebase use flutterplatformkit`
- [ ] Check if App Distribution is enabled in Firebase Console
- [ ] Create testers group in Firebase Console (if needed) or use default
- [ ] Add device/testers to Firebase App Distribution

## Step 5: Upload to Firebase App Distribution
- [ ] Upload APK: `firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app <APP_ID> --groups "testers"`
- [ ] OR upload AAB: `firebase appdistribution:distribute build/app/outputs/bundle/release/app-release.aab --app <APP_ID> --groups "testers"`
- [ ] Verify upload succeeds and get distribution link
- [ ] Check Firebase Console > App Distribution to confirm upload

## Step 6: Install on Device via Firebase App Distribution
- [ ] Open distribution link/email on Android device
- [ ] Install Firebase App Tester app from Play Store (if not installed)
- [ ] Sign in to Firebase App Tester with test account
- [ ] Download and install the app from App Distribution
- [ ] Verify app installs successfully on device

## Step 7: Test Google Sign-In on Installed App
- [ ] Launch the installed app on device
- [ ] Navigate to login/auth screen
- [ ] Tap Google Sign-In button
- [ ] Complete Google Sign-In flow (select account, grant permissions)
- [ ] Verify authentication succeeds
- [ ] Verify user data is retrieved correctly
- [ ] Verify user is logged in and can access authenticated features
- [ ] Test logout functionality
- [ ] Test sign-in again to verify persistence

## Step 8: Troubleshooting (if needed)
- [ ] Check Firebase Console logs for authentication errors
- [ ] Verify SHA-1 fingerprint matches device/keystore
- [ ] Check app logs for any runtime errors
- [ ] Verify google-services.json is correct and up-to-date
- [ ] Test with different Google accounts if needed
- [ ] Verify network connectivity on device

## Notes
- App ID for Firebase App Distribution: `1:366512631366:android:dcce44f8481bea08d22447` (from firebase.json)
- Package name: `com.anyhoosolutions.flutterplatformkit`
- Firebase project: `flutterplatformkit`

