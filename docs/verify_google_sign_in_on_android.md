# Android Build & Firebase App Distribution with Google Sign-In Test

## Prerequisites
- [ ]  Verify Firebase project is set up (flutterplatformkit) - ✓ Confirmed in .firebaserc
- [ ]  Verify Google Sign-In is enabled in Firebase Console (Authentication > Sign-in method > Google) - ✓ Enabled (screenshot confirmed)
- [ ]  Verify google-services.json exists in example_app/android/app/ - ✓ File exists and contains correct package name
- [ ]  Verify SHA-1 fingerprint is added to Firebase project (for Google Sign-In) - ✓ Found in google-services.json (certificate_hash: d543deeb96150ced4881c80e04ca4ec5c91fc2b4)
- [ ]  Install Firebase CLI and login: `npm install -g firebase-tools && firebase login` - ✓ Firebase CLI v15.0.0 installed
- [ ]  Install Firebase App Distribution plugin: `firebase init appdistribution` (if not already done) - ✓ Command available

## Step 1: Configure Android App for Release Build
- [ ]  Create release keystore (if not exists) or use existing signing config - ✓ Using debug keystore for now (release uses debug signing)
- [ ]  Update android/app/build.gradle.kts with proper release signing configuration - ✓ Currently using debug signing for release (needs production keystore later)
- [ ]  Verify applicationId matches Firebase app configuration (com.anyhoosolutions.flutterplatformkit) - ✓ Matches
- [ ]  Verify versionCode and versionName are set correctly in pubspec.yaml - ✓ Version: 1.0.0+1

## Step 2: Verify Google Sign-In Configuration
- [ ]  Check that google-services.json contains correct package name and SHA-1 - ✓ Package name matches, SHA-1 present
- [ ]  Verify Google Sign-In is properly configured in Firebase Console - ✓ Enabled and configured (screenshot confirmed)
- [ ]  **FIX REQUIRED**: Add debug keystore SHA-1 to Firebase Console - ✓ **COMPLETED** (SHA-1 added, google-services.json updated)
- [ ]  Download updated google-services.json after adding SHA-1 - ✓ **COMPLETED**
- [ ]  **ISSUE FOUND**: App is using Firebase emulator in debug mode, but device can't reach localhost - ✓ **FIXED**: Run with `--dart-define=USE_FIREBASE_EMULATOR=false`
- [ ]  **ISSUE FOUND**: Firestore permission denied for user enhancement - ✓ **FIXED**: Deployed Firestore rules
- [ ]  Test Google Sign-In locally first: `flutter run` on connected device - ✓ **COMPLETED**: Google Sign-In works!
- [ ]  Verify Google Sign-In button works and authentication flow completes - ✓ **COMPLETED**: Authentication successful, user logged in, Firestore data populated
- [ ]  Test Google Sign-In in release mode: `flutter run --release` - ✓ **COMPLETED**: Works perfectly!

## Step 3: Build Android Release APK/AAB
- [ ]  Clean build: `cd example_app && flutter clean` - ✓ **COMPLETED**
- [ ]  Get dependencies: `flutter pub get` - ✓ **COMPLETED**
- [ ]  Build release APK: `flutter build apk --release` - ✓ **COMPLETED** (56.1MB APK built successfully)
- [ ] OR build release AAB: `flutter build appbundle --release` (for Play Store)
- [ ]  Verify build succeeds without errors - ✓ **COMPLETED**
- [ ]  Locate built APK/AAB file (usually in build/app/outputs/) - ✓ **COMPLETED** (build/app/outputs/flutter-apk/app-release.apk)

## Step 4: Set Up Firebase App Distribution
- [ ]  Verify Firebase project: `firebase projects:list` - ✓ **COMPLETED** (flutterplatformkit confirmed)
- [ ]  Set Firebase project: `firebase use flutterplatformkit` - ✓ **COMPLETED**
- [ ]  Check if App Distribution is enabled in Firebase Console - ✓ **COMPLETED** (App Distribution is enabled)
- [ ]  Create testers group in Firebase Console (if needed) or use default - ✓ **COMPLETED** (Created "Testers" group with alias "testers")
- [ ]  Add device/testers to Firebase App Distribution - ✓ **COMPLETED** (Tester added)

## Step 5: Upload to Firebase App Distribution
- [ ]  Upload APK: `firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app 1:366512631366:android:b3c3da12d0c84726d22447 --groups "testers"` - ✓ **COMPLETED** (Upload successful! Release 1.0.0 (1))
- [ ] OR upload AAB: `flutter build appbundle --release` then distribute - **OPTIONAL** (for Play Store)
- [ ]  Verify upload succeeds and get distribution link - ✓ **COMPLETED** (Release available in Firebase Console)
- [ ]  Check Firebase Console > App Distribution to confirm upload - ✓ **COMPLETED** (View release: https://console.firebase.google.com/project/flutterplatformkit/appdistribution/app/android:com.anyhoosolutions.flutterplatformkit/releases/460mmcscori1g)
- [ ]  **NOTE**: Tester group "testers" created successfully - ✓ **COMPLETED**
- [ ]  **NEXT**: Add testers to the "testers" group via Firebase Console or distribute release to group - ✓ **COMPLETED**

## Step 6: Install on Device via Firebase App Distribution
- [ ]  Open distribution link/email on Android device - ✓ **COMPLETED**
- [ ]  Install Firebase App Tester app from Play Store (if not installed) - ✓ **COMPLETED**
- [ ]  Sign in to Firebase App Tester with test account - ✓ **COMPLETED**
- [ ]  Download and install the app from App Distribution - ✓ **COMPLETED**
- [ ]  Verify app installs successfully on device - ✓ **COMPLETED**

## Step 7: Test Google Sign-In on Installed App
- [ ]  Launch the installed app on device - ✓ **COMPLETED**
- [ ]  Navigate to login/auth screen - ✓ **COMPLETED**
- [ ]  Tap Google Sign-In button - ✓ **COMPLETED**
- [ ]  Complete Google Sign-In flow (select account, grant permissions) - ✓ **COMPLETED**
- [ ]  Verify authentication succeeds - ✓ **COMPLETED** (Login works!)
- [ ] Verify user data is retrieved correctly
- [ ] Verify user is logged in and can access authenticated features
- [ ] Test logout functionality
- [ ] Test sign-in again to verify persistence

## Step 8: Troubleshooting (if needed)
- [ ]  Check Firebase Console logs for authentication errors - ✓ Resolved
- [ ]  Verify SHA-1 fingerprint matches device/keystore - ✓ Fixed (SHA-1 added to Firebase)
- [ ]  Check app logs for any runtime errors - ✓ All issues resolved
- [ ]  Verify google-services.json is correct and up-to-date - ✓ Updated with correct SHA-1
- [ ]  Deploy Firestore rules - ✓ Rules deployed successfully
- [ ] Test with different Google accounts if needed
- [ ] Verify network connectivity on device

## Notes
- App ID for Firebase App Distribution: `1:366512631366:android:b3c3da12d0c84726d22447` (from `firebase apps:list` - this is the actual registered app ID)
- Package name: `com.anyhoosolutions.flutterplatformkit`
- Firebase project: `flutterplatformkit`
- **How to get APP_ID**: Run `firebase apps:list` in the example_app directory, or find it in Firebase Console > Project Settings > Your apps
- **Debug Keystore SHA-1**: `E0:9F:32:1B:FC:02:4F:17:A3:6C:D4:4F:90:9B:95:EB:B3:66:C4:95` (✓ Added to Firebase Console)
- **Command to run app without emulator**: `flutter run -d 47051FDAP00524 --dart-define=USE_FIREBASE_EMULATOR=false`
- **Release 1.0.0 (1) uploaded**: Release ID `460mmcscori1g`
- **Firebase Console link**: https://console.firebase.google.com/project/flutterplatformkit/appdistribution/app/android:com.anyhoosolutions.flutterplatformkit/releases/460mmcscori1g
- **Tester group created**: "Testers" (alias: "testers")
- **Next steps**: Add testers to the "testers" group via Firebase Console, then they can access the release

